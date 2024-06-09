/* See LICENSE file for copyright and license details. */
#include <limits.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "types.h"
#include "../grapheme.h"
#include "util.h"

void
herodotus_reader_init(HERODOTUS_READER *r, enum herodotus_type type,
                      const void *src, size_t srclen)
{
	size_t i;

	r->type = type;
	r->src = src;
	r->srclen = srclen;
	r->off = 0;
	r->terminated_by_null = false;

	for (i = 0; i < LEN(r->soft_limit); i++) {
		r->soft_limit[i] = SIZE_MAX;
	}
}

void
herodotus_reader_copy(const HERODOTUS_READER *src, HERODOTUS_READER *dest)
{
	size_t i;

	/*
	 * we copy such that we have a "fresh" start and build on the
	 * fact that src->soft_limit[i] for any i and src->srclen are
	 * always larger or equal to src->off
	 */
	dest->type = src->type;
	if (src->type == HERODOTUS_TYPE_CODEPOINT) {
		dest->src =
			(src->src == NULL) ?
				NULL :
				((const uint_least32_t *)(src->src)) + src->off;
	} else { /* src->type == HERODOTUS_TYPE_UTF8 */
		dest->src = (src->src == NULL) ?
		                    NULL :
		                    ((const char *)(src->src)) + src->off;
	}
	if (src->srclen == SIZE_MAX) {
		dest->srclen = SIZE_MAX;
	} else {
		dest->srclen =
			(src->off < src->srclen) ? src->srclen - src->off : 0;
	}
	dest->off = 0;
	dest->terminated_by_null = src->terminated_by_null;

	for (i = 0; i < LEN(src->soft_limit); i++) {
		if (src->soft_limit[i] == SIZE_MAX) {
			dest->soft_limit[i] = SIZE_MAX;
		} else {
			/*
			 * if we have a degenerate case where the offset is
			 * higher than the soft-limit, we simply clamp the
			 * soft-limit to zero given we can't decide here
			 * to release the limit and, instead, we just
			 * prevent any more reads
			 */
			dest->soft_limit[i] =
				(src->off < src->soft_limit[i]) ?
					src->soft_limit[i] - src->off :
					0;
		}
	}
}

void
herodotus_reader_push_advance_limit(HERODOTUS_READER *r, size_t count)
{
	size_t i;

	for (i = LEN(r->soft_limit) - 1; i >= 1; i--) {
		r->soft_limit[i] = r->soft_limit[i - 1];
	}
	r->soft_limit[0] = r->off + count;
}

void
herodotus_reader_pop_limit(HERODOTUS_READER *r)
{
	size_t i;

	for (i = 0; i < LEN(r->soft_limit) - 1; i++) {
		r->soft_limit[i] = r->soft_limit[i + 1];
	}
	r->soft_limit[LEN(r->soft_limit) - 1] = SIZE_MAX;
}

size_t
herodotus_reader_next_word_break(const HERODOTUS_READER *r)
{
	if (r->type == HERODOTUS_TYPE_CODEPOINT) {
		return grapheme_next_word_break(
			(const uint_least32_t *)(r->src) + r->off,
			MIN(r->srclen, r->soft_limit[0]) - r->off);
	} else { /* r->type == HERODOTUS_TYPE_UTF8 */
		return grapheme_next_word_break_utf8(
			(const char *)(r->src) + r->off,
			MIN(r->srclen, r->soft_limit[0]) - r->off);
	}
}

size_t
herodotus_reader_next_codepoint_break(const HERODOTUS_READER *r)
{
	if (r->type == HERODOTUS_TYPE_CODEPOINT) {
		return (r->off < MIN(r->srclen, r->soft_limit[0])) ? 1 : 0;
	} else { /* r->type == HERODOTUS_TYPE_UTF8 */
		return grapheme_decode_utf8(
			(const char *)(r->src) + r->off,
			MIN(r->srclen, r->soft_limit[0]) - r->off, NULL);
	}
}

size_t
herodotus_reader_number_read(const HERODOTUS_READER *r)
{
	return r->off;
}

enum herodotus_status
herodotus_read_codepoint(HERODOTUS_READER *r, bool advance, uint_least32_t *cp)
{
	size_t ret;

	if (r->terminated_by_null || r->off >= r->srclen || r->src == NULL) {
		*cp = GRAPHEME_INVALID_CODEPOINT;
		return HERODOTUS_STATUS_END_OF_BUFFER;
	}

	if (r->off >= r->soft_limit[0]) {
		*cp = GRAPHEME_INVALID_CODEPOINT;
		return HERODOTUS_STATUS_SOFT_LIMIT_REACHED;
	}

	if (r->type == HERODOTUS_TYPE_CODEPOINT) {
		*cp = ((const uint_least32_t *)(r->src))[r->off];
		ret = 1;
	} else { /* r->type == HERODOTUS_TYPE_UTF8 */
		ret = grapheme_decode_utf8(
			(const char *)r->src + r->off,
			MIN(r->srclen, r->soft_limit[0]) - r->off, cp);
	}

	if (unlikely(r->srclen == SIZE_MAX && *cp == 0)) {
		/*
		 * We encountered a null-codepoint. Don't increment
		 * offset and return as if the buffer had ended here all
		 * along
		 */
		r->terminated_by_null = true;
		return HERODOTUS_STATUS_END_OF_BUFFER;
	}

	if (r->off + ret > MIN(r->srclen, r->soft_limit[0])) {
		/*
		 * we want more than we have; instead of returning
		 * garbage we terminate here.
		 */
		return HERODOTUS_STATUS_END_OF_BUFFER;
	}

	/*
	 * Increase offset which we now know won't surpass the limits,
	 * unless we got told otherwise
	 */
	if (advance) {
		r->off += ret;
	}

	return HERODOTUS_STATUS_SUCCESS;
}

void
herodotus_writer_init(HERODOTUS_WRITER *w, enum herodotus_type type, void *dest,
                      size_t destlen)
{
	w->type = type;
	w->dest = dest;
	w->destlen = destlen;
	w->off = 0;
	w->first_unwritable_offset = SIZE_MAX;
}

void
herodotus_writer_nul_terminate(HERODOTUS_WRITER *w)
{
	if (w->dest == NULL) {
		return;
	}

	if (w->off < w->destlen) {
		/* We still have space in the buffer. Simply use it */
		if (w->type == HERODOTUS_TYPE_CODEPOINT) {
			((uint_least32_t *)(w->dest))[w->off] = 0;
		} else { /* w->type == HERODOTUS_TYPE_UTF8 */
			((char *)(w->dest))[w->off] = '\0';
		}
	} else if (w->first_unwritable_offset < w->destlen) {
		/*
		 * There is no more space in the buffer. However,
		 * we have noted down the first offset we couldn't
		 * use to write into the buffer and it's smaller than
		 * destlen. Thus we bailed writing into the
		 * destination when a multibyte-codepoint couldn't be
		 * written. So the last "real" byte might be at
		 * destlen-4, destlen-3, destlen-2 or destlen-1
		 * (the last case meaning truncation).
		 */
		if (w->type == HERODOTUS_TYPE_CODEPOINT) {
			((uint_least32_t
			          *)(w->dest))[w->first_unwritable_offset] = 0;
		} else { /* w->type == HERODOTUS_TYPE_UTF8 */
			((char *)(w->dest))[w->first_unwritable_offset] = '\0';
		}
	} else if (w->destlen > 0) {
		/*
		 * In this case, there is no more space in the buffer and
		 * the last unwritable offset is larger than
		 * or equal to the destination buffer length. This means
		 * that we are forced to simply write into the last
		 * byte.
		 */
		if (w->type == HERODOTUS_TYPE_CODEPOINT) {
			((uint_least32_t *)(w->dest))[w->destlen - 1] = 0;
		} else { /* w->type == HERODOTUS_TYPE_UTF8 */
			((char *)(w->dest))[w->destlen - 1] = '\0';
		}
	}

	/* w->off is not incremented in any case */
}

size_t
herodotus_writer_number_written(const HERODOTUS_WRITER *w)
{
	return w->off;
}

void
herodotus_write_codepoint(HERODOTUS_WRITER *w, uint_least32_t cp)
{
	size_t ret;

	/*
	 * This function will always faithfully say how many codepoints
	 * were written, even if the buffer ends. This is used to enable
	 * truncation detection.
	 */
	if (w->type == HERODOTUS_TYPE_CODEPOINT) {
		if (w->dest != NULL && w->off < w->destlen) {
			((uint_least32_t *)(w->dest))[w->off] = cp;
		}

		w->off += 1;
	} else { /* w->type == HERODOTUS_TYPE_UTF8 */
		/*
		 * First determine how many bytes we need to encode the
		 * codepoint
		 */
		ret = grapheme_encode_utf8(cp, NULL, 0);

		if (w->dest != NULL && w->off + ret < w->destlen) {
			/* we still have enough room in the buffer */
			grapheme_encode_utf8(cp, (char *)(w->dest) + w->off,
			                     w->destlen - w->off);
		} else if (w->first_unwritable_offset == SIZE_MAX) {
			/*
			 * the first unwritable offset has not been
			 * noted down, so this is the first time we can't
			 * write (completely) to an offset
			 */
			w->first_unwritable_offset = w->off;
		}

		w->off += ret;
	}
}

void
proper_init(const HERODOTUS_READER *r, void *state, uint_least8_t no_prop,
            uint_least8_t (*get_break_prop)(uint_least32_t),
            bool (*is_skippable_prop)(uint_least8_t),
            void (*skip_shift_callback)(uint_least8_t, void *),
            struct proper *p)
{
	uint_least8_t prop;
	uint_least32_t cp;
	size_t i;

	/* set internal variables */
	p->state = state;
	p->no_prop = no_prop;
	p->get_break_prop = get_break_prop;
	p->is_skippable_prop = is_skippable_prop;
	p->skip_shift_callback = skip_shift_callback;

	/*
	 * Initialize mid-reader, which is basically just there
	 * to reflect the current position of the viewing-line
	 */
	herodotus_reader_copy(r, &(p->mid_reader));

	/*
	 * In the initialization, we simply (try to) fill in next_prop.
	 * If we cannot read in more (due to the buffer ending), we
	 * fill in the prop as invalid
	 */

	/*
	 * initialize the previous properties to have no property
	 * (given we are at the start of the buffer)
	 */
	p->raw.prev_prop[1] = p->raw.prev_prop[0] = p->no_prop;
	p->skip.prev_prop[1] = p->skip.prev_prop[0] = p->no_prop;

	/*
	 * initialize the next properties
	 */

	/* initialize the raw reader */
	herodotus_reader_copy(r, &(p->raw_reader));

	/* fill in the two next raw properties (after no-initialization) */
	p->raw.next_prop[0] = p->raw.next_prop[1] = p->no_prop;
	for (i = 0;
	     i < 2 && herodotus_read_codepoint(&(p->raw_reader), true, &cp) ==
	                      HERODOTUS_STATUS_SUCCESS;) {
		p->raw.next_prop[i++] = p->get_break_prop(cp);
	}

	/* initialize the skip reader */
	herodotus_reader_copy(r, &(p->skip_reader));

	/* fill in the two next skip properties (after no-initialization) */
	p->skip.next_prop[0] = p->skip.next_prop[1] = p->no_prop;
	for (i = 0;
	     i < 2 && herodotus_read_codepoint(&(p->skip_reader), true, &cp) ==
	                      HERODOTUS_STATUS_SUCCESS;) {
		prop = p->get_break_prop(cp);
		if (!p->is_skippable_prop(prop)) {
			p->skip.next_prop[i++] = prop;
		}
	}
}

int
proper_advance(struct proper *p)
{
	uint_least8_t prop;
	uint_least32_t cp;

	/* read in next "raw" property */
	if (herodotus_read_codepoint(&(p->raw_reader), true, &cp) ==
	    HERODOTUS_STATUS_SUCCESS) {
		prop = p->get_break_prop(cp);
	} else {
		prop = p->no_prop;
	}

	/*
	 * do a shift-in, unless we find that the property that is to
	 * be moved past the "raw-viewing-line" (this property is stored
	 * in p->raw.next_prop[0]) is a no_prop, indicating that
	 * we are at the end of the buffer.
	 */
	if (p->raw.next_prop[0] == p->no_prop) {
		return 1;
	}

	/* shift in the properties */
	p->raw.prev_prop[1] = p->raw.prev_prop[0];
	p->raw.prev_prop[0] = p->raw.next_prop[0];
	p->raw.next_prop[0] = p->raw.next_prop[1];
	p->raw.next_prop[1] = prop;

	/* advance the middle reader viewing-line */
	(void)herodotus_read_codepoint(&(p->mid_reader), true, &cp);

	/* check skippability-property */
	if (!p->is_skippable_prop(p->raw.prev_prop[0])) {
		/*
		 * the property that has moved past the "raw-viewing-line"
		 * (this property is now (after the raw-shift) stored in
		 * p->raw.prev_prop[0] and guaranteed not to be a no-prop,
		 * guaranteeing that we won't shift a no-prop past the
		 * "viewing-line" in the skip-properties) is not a skippable
		 * property, thus we need to shift the skip property as well.
		 */
		p->skip.prev_prop[1] = p->skip.prev_prop[0];
		p->skip.prev_prop[0] = p->skip.next_prop[0];
		p->skip.next_prop[0] = p->skip.next_prop[1];

		/*
		 * call the skip-shift-callback on the property that
		 * passed the skip-viewing-line (this property is now
		 * stored in p->skip.prev_prop[0]).
		 */
		p->skip_shift_callback(p->skip.prev_prop[0], p->state);

		/* determine the next shift property */
		p->skip.next_prop[1] = p->no_prop;
		while (herodotus_read_codepoint(&(p->skip_reader), true, &cp) ==
		       HERODOTUS_STATUS_SUCCESS) {
			prop = p->get_break_prop(cp);
			if (!p->is_skippable_prop(prop)) {
				p->skip.next_prop[1] = prop;
				break;
			}
		}
	}

	return 0;
}
