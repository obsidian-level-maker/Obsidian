/* See LICENSE file for copyright and license details. */
#include <stddef.h>
#include <stdint.h>

#include "case.h"
#include "../grapheme.h"
#include "util.h"

static inline enum case_property
get_case_property(uint_least32_t cp)
{
	if (likely(cp <= UINT32_C(0x10FFFF))) {
		return (enum case_property)
			case_minor[case_major[cp >> 8] + (cp & 0xFF)];
	} else {
		return CASE_PROP_OTHER;
	}
}

static inline int_least32_t
get_case_offset(uint_least32_t cp, const uint_least16_t *major,
                const int_least32_t *minor)
{
	if (likely(cp <= UINT32_C(0x10FFFF))) {
		/*
		 * this value might be larger than or equal to 0x110000
		 * for the special-case-mapping. This needs to be handled
		 * separately
		 */
		return minor[major[cp >> 8] + (cp & 0xFF)];
	} else {
		return 0;
	}
}

static inline size_t
to_case(HERODOTUS_READER *r, HERODOTUS_WRITER *w,
        uint_least8_t final_sigma_level, const uint_least16_t *major,
        const int_least32_t *minor, const struct special_case *sc)
{
	HERODOTUS_READER tmp;
	enum case_property prop;
	enum herodotus_status s;
	size_t off, i;
	uint_least32_t cp, tmp_cp;
	int_least32_t map;

	for (; herodotus_read_codepoint(r, true, &cp) ==
	       HERODOTUS_STATUS_SUCCESS;) {
		if (sc == lower_special) {
			/*
			 * For the special Final_Sigma-rule (see
			 * SpecialCasing.txt), which is the only non-localized
			 * case-dependent rule, we apply a different mapping
			 * when a sigma is at the end of a word.
			 *
			 * Before: cased case-ignorable*
			 * After: not(case-ignorable* cased)
			 *
			 * We check the after-condition on demand, but the
			 * before- condition is best checked using the
			 * "level"-heuristic also used in the sentence and line
			 * breaking-implementations.
			 */
			if (cp == UINT32_C(0x03A3) && /* GREEK CAPITAL LETTER
			                                 SIGMA */
			    (final_sigma_level == 1 ||
			     final_sigma_level == 2)) {
				/*
				 * check succeeding characters by first skipping
				 * all case-ignorable characters and then
				 * checking if the succeeding character is
				 * cased, invalidating the after-condition
				 */
				herodotus_reader_copy(r, &tmp);
				for (prop = NUM_CASE_PROPS;
				     (s = herodotus_read_codepoint(&tmp, true,
				                                   &tmp_cp)) ==
				     HERODOTUS_STATUS_SUCCESS;) {
					prop = get_case_property(tmp_cp);

					if (prop != CASE_PROP_CASE_IGNORABLE &&
					    prop != CASE_PROP_BOTH_CASED_CASE_IGNORABLE) {
						break;
					}
				}

				/*
				 * Now prop is something other than
				 * case-ignorable or the source-string ended. If
				 * it is something other than cased, we know
				 * that the after-condition holds
				 */
				if (s != HERODOTUS_STATUS_SUCCESS ||
				    (prop != CASE_PROP_CASED &&
				     prop != CASE_PROP_BOTH_CASED_CASE_IGNORABLE)) {
					/*
					 * write GREEK SMALL LETTER FINAL SIGMA
					 * to destination
					 */
					herodotus_write_codepoint(
						w, UINT32_C(0x03C2));

					/* reset Final_Sigma-state and continue
					 */
					final_sigma_level = 0;
					continue;
				}
			}

			/* update state */
			prop = get_case_property(cp);
			if ((final_sigma_level == 0 ||
			     final_sigma_level == 1) &&
			    (prop == CASE_PROP_CASED ||
			     prop == CASE_PROP_BOTH_CASED_CASE_IGNORABLE)) {
				/* sequence has begun */
				final_sigma_level = 1;
			} else if (
				(final_sigma_level == 1 ||
			         final_sigma_level == 2) &&
				(prop == CASE_PROP_CASE_IGNORABLE ||
			         prop == CASE_PROP_BOTH_CASED_CASE_IGNORABLE)) {
				/* case-ignorable sequence begins or continued
				 */
				final_sigma_level = 2;
			} else {
				/* sequence broke */
				final_sigma_level = 0;
			}
		}

		/* get and handle case mapping */
		if (unlikely((map = get_case_offset(cp, major, minor)) >=
		             INT32_C(0x110000))) {
			/* we have a special case and the offset in the sc-array
			 * is the difference to 0x110000*/
			off = (uint_least32_t)map - UINT32_C(0x110000);

			for (i = 0; i < sc[off].cplen; i++) {
				herodotus_write_codepoint(w, sc[off].cp[i]);
			}
		} else {
			/* we have a simple mapping */
			herodotus_write_codepoint(
				w, (uint_least32_t)((int_least32_t)cp + map));
		}
	}

	herodotus_writer_nul_terminate(w);

	return herodotus_writer_number_written(w);
}

static size_t
herodotus_next_word_break(const HERODOTUS_READER *r)
{
	HERODOTUS_READER tmp;

	herodotus_reader_copy(r, &tmp);

	if (r->type == HERODOTUS_TYPE_CODEPOINT) {
		return grapheme_next_word_break(tmp.src, tmp.srclen);
	} else { /* r->type == HERODOTUS_TYPE_UTF8 */
		return grapheme_next_word_break_utf8(tmp.src, tmp.srclen);
	}
}

static inline size_t
to_titlecase(HERODOTUS_READER *r, HERODOTUS_WRITER *w)
{
	enum case_property prop;
	enum herodotus_status s;
	uint_least32_t cp;
	size_t nwb;

	for (; (nwb = herodotus_next_word_break(r)) > 0;) {
		herodotus_reader_push_advance_limit(r, nwb);
		for (; (s = herodotus_read_codepoint(r, false, &cp)) ==
		       HERODOTUS_STATUS_SUCCESS;) {
			/* check if we have a cased character */
			prop = get_case_property(cp);
			if (prop == CASE_PROP_CASED ||
			    prop == CASE_PROP_BOTH_CASED_CASE_IGNORABLE) {
				break;
			} else {
				/* write the data to the output verbatim, it if
				 * permits */
				herodotus_write_codepoint(w, cp);

				/* increment reader */
				herodotus_read_codepoint(r, true, &cp);
			}
		}

		if (s == HERODOTUS_STATUS_END_OF_BUFFER) {
			/* we are done */
			herodotus_reader_pop_limit(r);
			break;
		} else if (s == HERODOTUS_STATUS_SOFT_LIMIT_REACHED) {
			/*
			 * we did not encounter any cased character
			 * up to the word break
			 */
			herodotus_reader_pop_limit(r);
			continue;
		} else {
			/*
			 * we encountered a cased character before the word
			 * break, convert it to titlecase
			 */
			herodotus_reader_push_advance_limit(
				r, herodotus_reader_next_codepoint_break(r));
			to_case(r, w, 0, title_major, title_minor,
			        title_special);
			herodotus_reader_pop_limit(r);
		}

		/* cast the rest of the codepoints in the word to lowercase */
		to_case(r, w, 1, lower_major, lower_minor, lower_special);

		/* remove the limit on the word before the next iteration */
		herodotus_reader_pop_limit(r);
	}

	herodotus_writer_nul_terminate(w);

	return herodotus_writer_number_written(w);
}

size_t
grapheme_to_uppercase(const uint_least32_t *src, size_t srclen,
                      uint_least32_t *dest, size_t destlen)
{
	HERODOTUS_READER r;
	HERODOTUS_WRITER w;

	herodotus_reader_init(&r, HERODOTUS_TYPE_CODEPOINT, src, srclen);
	herodotus_writer_init(&w, HERODOTUS_TYPE_CODEPOINT, dest, destlen);

	return to_case(&r, &w, 0, upper_major, upper_minor, upper_special);
}

size_t
grapheme_to_lowercase(const uint_least32_t *src, size_t srclen,
                      uint_least32_t *dest, size_t destlen)
{
	HERODOTUS_READER r;
	HERODOTUS_WRITER w;

	herodotus_reader_init(&r, HERODOTUS_TYPE_CODEPOINT, src, srclen);
	herodotus_writer_init(&w, HERODOTUS_TYPE_CODEPOINT, dest, destlen);

	return to_case(&r, &w, 0, lower_major, lower_minor, lower_special);
}

size_t
grapheme_to_titlecase(const uint_least32_t *src, size_t srclen,
                      uint_least32_t *dest, size_t destlen)
{
	HERODOTUS_READER r;
	HERODOTUS_WRITER w;

	herodotus_reader_init(&r, HERODOTUS_TYPE_CODEPOINT, src, srclen);
	herodotus_writer_init(&w, HERODOTUS_TYPE_CODEPOINT, dest, destlen);

	return to_titlecase(&r, &w);
}

size_t
grapheme_to_uppercase_utf8(const char *src, size_t srclen, char *dest,
                           size_t destlen)
{
	HERODOTUS_READER r;
	HERODOTUS_WRITER w;

	herodotus_reader_init(&r, HERODOTUS_TYPE_UTF8, src, srclen);
	herodotus_writer_init(&w, HERODOTUS_TYPE_UTF8, dest, destlen);

	return to_case(&r, &w, 0, upper_major, upper_minor, upper_special);
}

size_t
grapheme_to_lowercase_utf8(const char *src, size_t srclen, char *dest,
                           size_t destlen)
{
	HERODOTUS_READER r;
	HERODOTUS_WRITER w;

	herodotus_reader_init(&r, HERODOTUS_TYPE_UTF8, src, srclen);
	herodotus_writer_init(&w, HERODOTUS_TYPE_UTF8, dest, destlen);

	return to_case(&r, &w, 0, lower_major, lower_minor, lower_special);
}

size_t
grapheme_to_titlecase_utf8(const char *src, size_t srclen, char *dest,
                           size_t destlen)
{
	HERODOTUS_READER r;
	HERODOTUS_WRITER w;

	herodotus_reader_init(&r, HERODOTUS_TYPE_UTF8, src, srclen);
	herodotus_writer_init(&w, HERODOTUS_TYPE_UTF8, dest, destlen);

	return to_titlecase(&r, &w);
}

static inline bool
is_case(HERODOTUS_READER *r, const uint_least16_t *major,
        const int_least32_t *minor, const struct special_case *sc,
        size_t *output)
{
	size_t off, i;
	bool ret = true;
	uint_least32_t cp;
	int_least32_t map;

	for (; herodotus_read_codepoint(r, false, &cp) ==
	       HERODOTUS_STATUS_SUCCESS;) {
		/* get and handle case mapping */
		if (unlikely((map = get_case_offset(cp, major, minor)) >=
		             INT32_C(0x110000))) {
			/* we have a special case and the offset in the sc-array
			 * is the difference to 0x110000*/
			off = (uint_least32_t)map - UINT32_C(0x110000);

			for (i = 0; i < sc[off].cplen; i++) {
				if (herodotus_read_codepoint(r, false, &cp) ==
				    HERODOTUS_STATUS_SUCCESS) {
					if (cp != sc[off].cp[i]) {
						ret = false;
						goto done;
					} else {
						/* move forward */
						herodotus_read_codepoint(
							r, true, &cp);
					}
				} else {
					/*
					 * input ended and we didn't see
					 * any difference so far, so this
					 * string is in fact okay
					 */
					ret = true;
					goto done;
				}
			}
		} else {
			/* we have a simple mapping */
			if (cp != (uint_least32_t)((int_least32_t)cp + map)) {
				/* we have a difference */
				ret = false;
				goto done;
			} else {
				/* move forward */
				herodotus_read_codepoint(r, true, &cp);
			}
		}
	}
done:
	if (output) {
		*output = herodotus_reader_number_read(r);
	}
	return ret;
}

static inline bool
is_titlecase(HERODOTUS_READER *r, size_t *output)
{
	enum case_property prop;
	enum herodotus_status s;
	bool ret = true;
	uint_least32_t cp;
	size_t nwb;

	for (; (nwb = herodotus_next_word_break(r)) > 0;) {
		herodotus_reader_push_advance_limit(r, nwb);
		for (; (s = herodotus_read_codepoint(r, false, &cp)) ==
		       HERODOTUS_STATUS_SUCCESS;) {
			/* check if we have a cased character */
			prop = get_case_property(cp);
			if (prop == CASE_PROP_CASED ||
			    prop == CASE_PROP_BOTH_CASED_CASE_IGNORABLE) {
				break;
			} else {
				/* increment reader */
				herodotus_read_codepoint(r, true, &cp);
			}
		}

		if (s == HERODOTUS_STATUS_END_OF_BUFFER) {
			/* we are done */
			break;
		} else if (s == HERODOTUS_STATUS_SOFT_LIMIT_REACHED) {
			/*
			 * we did not encounter any cased character
			 * up to the word break
			 */
			herodotus_reader_pop_limit(r);
			continue;
		} else {
			/*
			 * we encountered a cased character before the word
			 * break, check if it's titlecase
			 */
			herodotus_reader_push_advance_limit(
				r, herodotus_reader_next_codepoint_break(r));
			if (!is_case(r, title_major, title_minor, title_special,
			             NULL)) {
				ret = false;
				goto done;
			}
			herodotus_reader_pop_limit(r);
		}

		/* check if the rest of the codepoints in the word are lowercase
		 */
		if (!is_case(r, lower_major, lower_minor, lower_special,
		             NULL)) {
			ret = false;
			goto done;
		}

		/* remove the limit on the word before the next iteration */
		herodotus_reader_pop_limit(r);
	}
done:
	if (output) {
		*output = herodotus_reader_number_read(r);
	}
	return ret;
}

bool
grapheme_is_uppercase(const uint_least32_t *src, size_t srclen, size_t *caselen)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_CODEPOINT, src, srclen);

	return is_case(&r, upper_major, upper_minor, upper_special, caselen);
}

bool
grapheme_is_lowercase(const uint_least32_t *src, size_t srclen, size_t *caselen)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_CODEPOINT, src, srclen);

	return is_case(&r, lower_major, lower_minor, lower_special, caselen);
}

bool
grapheme_is_titlecase(const uint_least32_t *src, size_t srclen, size_t *caselen)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_CODEPOINT, src, srclen);

	return is_titlecase(&r, caselen);
}

bool
grapheme_is_uppercase_utf8(const char *src, size_t srclen, size_t *caselen)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_UTF8, src, srclen);

	return is_case(&r, upper_major, upper_minor, upper_special, caselen);
}

bool
grapheme_is_lowercase_utf8(const char *src, size_t srclen, size_t *caselen)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_UTF8, src, srclen);

	return is_case(&r, lower_major, lower_minor, lower_special, caselen);
}

bool
grapheme_is_titlecase_utf8(const char *src, size_t srclen, size_t *caselen)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_UTF8, src, srclen);

	return is_titlecase(&r, caselen);
}
