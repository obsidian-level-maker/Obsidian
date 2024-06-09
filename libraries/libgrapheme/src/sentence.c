/* See LICENSE file for copyright and license details. */
#include <stdbool.h>
#include <stddef.h>

#include "sentence.h"
#include "../grapheme.h"
#include "util.h"

struct sentence_break_state {
	uint_least8_t aterm_close_sp_level;
	uint_least8_t saterm_close_sp_parasep_level;
};

static inline uint_least8_t
get_sentence_break_prop(uint_least32_t cp)
{
	if (likely(cp <= UINT32_C(0x10FFFF))) {
		return (uint_least8_t)
			sentence_break_minor[sentence_break_major[cp >> 8] +
		                             (cp & 0xff)];
	} else {
		return SENTENCE_BREAK_PROP_OTHER;
	}
}

static bool
is_skippable_sentence_prop(uint_least8_t prop)
{
	return prop == SENTENCE_BREAK_PROP_EXTEND ||
	       prop == SENTENCE_BREAK_PROP_FORMAT;
}

static void
sentence_skip_shift_callback(uint_least8_t prop, void *s)
{
	struct sentence_break_state *state = (struct sentence_break_state *)s;

	/*
	 * Here comes a bit of magic. The rules
	 * SB8, SB8a, SB9 and SB10 have very complicated
	 * left-hand-side-rules of the form
	 *
	 *  ATerm Close* Sp*
	 *  SATerm Close*
	 *  SATerm Close* Sp*
	 *  SATerm Close* Sp* ParaSep?
	 *
	 * but instead of backtracking, we keep the
	 * state as some kind of "power level" in
	 * two state-variables
	 *
	 *  aterm_close_sp_level
	 *  saterm_close_sp_parasep_level
	 *
	 * that go from 0 to 3/4:
	 *
	 *  0: we are not in the sequence
	 *  1: we have one ATerm/SATerm to the left of
	 *     the middle spot
	 *  2: we have one ATerm/SATerm and one or more
	 *     Close to the left of the middle spot
	 *  3: we have one ATerm/SATerm, zero or more
	 *     Close and one or more Sp to the left of
	 *     the middle spot.
	 *  4: we have one SATerm, zero or more Close,
	 *     zero or more Sp and one ParaSep to the
	 *     left of the middle spot.
	 *
	 */
	if ((state->aterm_close_sp_level == 0 ||
	     state->aterm_close_sp_level == 1) &&
	    prop == SENTENCE_BREAK_PROP_ATERM) {
		/* sequence has begun */
		state->aterm_close_sp_level = 1;
	} else if ((state->aterm_close_sp_level == 1 ||
	            state->aterm_close_sp_level == 2) &&
	           prop == SENTENCE_BREAK_PROP_CLOSE) {
		/* close-sequence begins or continued */
		state->aterm_close_sp_level = 2;
	} else if ((state->aterm_close_sp_level == 1 ||
	            state->aterm_close_sp_level == 2 ||
	            state->aterm_close_sp_level == 3) &&
	           prop == SENTENCE_BREAK_PROP_SP) {
		/* sp-sequence begins or continued */
		state->aterm_close_sp_level = 3;
	} else {
		/* sequence broke */
		state->aterm_close_sp_level = 0;
	}

	if ((state->saterm_close_sp_parasep_level == 0 ||
	     state->saterm_close_sp_parasep_level == 1) &&
	    (prop == SENTENCE_BREAK_PROP_STERM ||
	     prop == SENTENCE_BREAK_PROP_ATERM)) {
		/* sequence has begun */
		state->saterm_close_sp_parasep_level = 1;
	} else if ((state->saterm_close_sp_parasep_level == 1 ||
	            state->saterm_close_sp_parasep_level == 2) &&
	           prop == SENTENCE_BREAK_PROP_CLOSE) {
		/* close-sequence begins or continued */
		state->saterm_close_sp_parasep_level = 2;
	} else if ((state->saterm_close_sp_parasep_level == 1 ||
	            state->saterm_close_sp_parasep_level == 2 ||
	            state->saterm_close_sp_parasep_level == 3) &&
	           prop == SENTENCE_BREAK_PROP_SP) {
		/* sp-sequence begins or continued */
		state->saterm_close_sp_parasep_level = 3;
	} else if ((state->saterm_close_sp_parasep_level == 1 ||
	            state->saterm_close_sp_parasep_level == 2 ||
	            state->saterm_close_sp_parasep_level == 3) &&
	           (prop == SENTENCE_BREAK_PROP_SEP ||
	            prop == SENTENCE_BREAK_PROP_CR ||
	            prop == SENTENCE_BREAK_PROP_LF)) {
		/* ParaSep at the end of the sequence */
		state->saterm_close_sp_parasep_level = 4;
	} else {
		/* sequence broke */
		state->saterm_close_sp_parasep_level = 0;
	}
}

static size_t
next_sentence_break(HERODOTUS_READER *r)
{
	HERODOTUS_READER tmp;
	enum sentence_break_property prop;
	struct proper p;
	struct sentence_break_state state = { 0 };
	uint_least32_t cp;

	/*
	 * Apply sentence breaking algorithm (UAX #29), see
	 * https://unicode.org/reports/tr29/#Sentence_Boundary_Rules
	 */
	proper_init(r, &state, NUM_SENTENCE_BREAK_PROPS,
	            get_sentence_break_prop, is_skippable_sentence_prop,
	            sentence_skip_shift_callback, &p);

	while (!proper_advance(&p)) {
		/* SB3 */
		if (p.raw.prev_prop[0] == SENTENCE_BREAK_PROP_CR &&
		    p.raw.next_prop[0] == SENTENCE_BREAK_PROP_LF) {
			continue;
		}

		/* SB4 */
		if (p.raw.prev_prop[0] == SENTENCE_BREAK_PROP_SEP ||
		    p.raw.prev_prop[0] == SENTENCE_BREAK_PROP_CR ||
		    p.raw.prev_prop[0] == SENTENCE_BREAK_PROP_LF) {
			break;
		}

		/* SB5 */
		if (p.raw.next_prop[0] == SENTENCE_BREAK_PROP_EXTEND ||
		    p.raw.next_prop[0] == SENTENCE_BREAK_PROP_FORMAT) {
			continue;
		}

		/* SB6 */
		if (p.skip.prev_prop[0] == SENTENCE_BREAK_PROP_ATERM &&
		    p.skip.next_prop[0] == SENTENCE_BREAK_PROP_NUMERIC) {
			continue;
		}

		/* SB7 */
		if ((p.skip.prev_prop[1] == SENTENCE_BREAK_PROP_UPPER ||
		     p.skip.prev_prop[1] == SENTENCE_BREAK_PROP_LOWER) &&
		    p.skip.prev_prop[0] == SENTENCE_BREAK_PROP_ATERM &&
		    p.skip.next_prop[0] == SENTENCE_BREAK_PROP_UPPER) {
			continue;
		}

		/* SB8 */
		if (state.aterm_close_sp_level == 1 ||
		    state.aterm_close_sp_level == 2 ||
		    state.aterm_close_sp_level == 3) {
			/*
			 * This is the most complicated rule, requiring
			 * the right-hand-side to satisfy the regular expression
			 *
			 *  ( ¬(OLetter | Upper | Lower | ParaSep | SATerm) )*
			 * Lower
			 *
			 * which we simply check "manually" given LUT-lookups
			 * are very cheap by starting at the mid_reader.
			 *
			 */
			herodotus_reader_copy(&(p.mid_reader), &tmp);

			prop = NUM_SENTENCE_BREAK_PROPS;
			while (herodotus_read_codepoint(&tmp, true, &cp) ==
			       HERODOTUS_STATUS_SUCCESS) {
				prop = get_sentence_break_prop(cp);

				/*
				 * the skippable properties are ignored
				 * automatically here given they do not
				 * match the following condition
				 */
				if (prop == SENTENCE_BREAK_PROP_OLETTER ||
				    prop == SENTENCE_BREAK_PROP_UPPER ||
				    prop == SENTENCE_BREAK_PROP_LOWER ||
				    prop == SENTENCE_BREAK_PROP_SEP ||
				    prop == SENTENCE_BREAK_PROP_CR ||
				    prop == SENTENCE_BREAK_PROP_LF ||
				    prop == SENTENCE_BREAK_PROP_STERM ||
				    prop == SENTENCE_BREAK_PROP_ATERM) {
					break;
				}
			}

			if (prop == SENTENCE_BREAK_PROP_LOWER) {
				continue;
			}
		}

		/* SB8a */
		if ((state.saterm_close_sp_parasep_level == 1 ||
		     state.saterm_close_sp_parasep_level == 2 ||
		     state.saterm_close_sp_parasep_level == 3) &&
		    (p.skip.next_prop[0] == SENTENCE_BREAK_PROP_SCONTINUE ||
		     p.skip.next_prop[0] == SENTENCE_BREAK_PROP_STERM ||
		     p.skip.next_prop[0] == SENTENCE_BREAK_PROP_ATERM)) {
			continue;
		}

		/* SB9 */
		if ((state.saterm_close_sp_parasep_level == 1 ||
		     state.saterm_close_sp_parasep_level == 2) &&
		    (p.skip.next_prop[0] == SENTENCE_BREAK_PROP_CLOSE ||
		     p.skip.next_prop[0] == SENTENCE_BREAK_PROP_SP ||
		     p.skip.next_prop[0] == SENTENCE_BREAK_PROP_SEP ||
		     p.skip.next_prop[0] == SENTENCE_BREAK_PROP_CR ||
		     p.skip.next_prop[0] == SENTENCE_BREAK_PROP_LF)) {
			continue;
		}

		/* SB10 */
		if ((state.saterm_close_sp_parasep_level == 1 ||
		     state.saterm_close_sp_parasep_level == 2 ||
		     state.saterm_close_sp_parasep_level == 3) &&
		    (p.skip.next_prop[0] == SENTENCE_BREAK_PROP_SP ||
		     p.skip.next_prop[0] == SENTENCE_BREAK_PROP_SEP ||
		     p.skip.next_prop[0] == SENTENCE_BREAK_PROP_CR ||
		     p.skip.next_prop[0] == SENTENCE_BREAK_PROP_LF)) {
			continue;
		}

		/* SB11 */
		if (state.saterm_close_sp_parasep_level == 1 ||
		    state.saterm_close_sp_parasep_level == 2 ||
		    state.saterm_close_sp_parasep_level == 3 ||
		    state.saterm_close_sp_parasep_level == 4) {
			break;
		}

		/* SB998 */
		continue;
	}

	return herodotus_reader_number_read(&(p.mid_reader));
}

size_t
grapheme_next_sentence_break(const uint_least32_t *str, size_t len)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_CODEPOINT, str, len);

	return next_sentence_break(&r);
}

size_t
grapheme_next_sentence_break_utf8(const char *str, size_t len)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_UTF8, str, len);

	return next_sentence_break(&r);
}
