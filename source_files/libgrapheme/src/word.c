/* See LICENSE file for copyright and license details. */
#include <stdbool.h>
#include <stddef.h>

#include "word.h"
#include "../grapheme.h"
#include "util.h"

struct word_break_state {
	bool ri_even;
};

static inline uint_least8_t
get_word_break_prop(uint_least32_t cp)
{
	if (likely(cp <= UINT32_C(0x10FFFF))) {
		return (uint_least8_t)
			word_break_minor[word_break_major[cp >> 8] +
		                         (cp & 0xff)];
	} else {
		return WORD_BREAK_PROP_OTHER;
	}
}

static bool
is_skippable_word_prop(uint_least8_t prop)
{
	return prop == WORD_BREAK_PROP_EXTEND ||
	       prop == WORD_BREAK_PROP_FORMAT || prop == WORD_BREAK_PROP_ZWJ;
}

static void
word_skip_shift_callback(uint_least8_t prop, void *s)
{
	struct word_break_state *state = (struct word_break_state *)s;

	if (prop == WORD_BREAK_PROP_REGIONAL_INDICATOR) {
		/*
		 * The property we just shifted in is
		 * a regional indicator, increasing the
		 * number of consecutive RIs on the left
		 * side of the breakpoint by one, changing
		 * the oddness.
		 *
		 */
		state->ri_even = !(state->ri_even);
	} else {
		/*
		 * We saw no regional indicator, so the
		 * number of consecutive RIs on the left
		 * side of the breakpoint is zero, which
		 * is an even number.
		 *
		 */
		state->ri_even = true;
	}
}

static size_t
next_word_break(HERODOTUS_READER *r)
{
	struct proper p;
	struct word_break_state state = { .ri_even = true };

	/*
	 * Apply word breaking algorithm (UAX #29), see
	 * https://unicode.org/reports/tr29/#Word_Boundary_Rules
	 */
	proper_init(r, &state, NUM_WORD_BREAK_PROPS, get_word_break_prop,
	            is_skippable_word_prop, word_skip_shift_callback, &p);

	while (!proper_advance(&p)) {
		/* WB3 */
		if (p.raw.prev_prop[0] == WORD_BREAK_PROP_CR &&
		    p.raw.next_prop[0] == WORD_BREAK_PROP_LF) {
			continue;
		}

		/* WB3a */
		if (p.raw.prev_prop[0] == WORD_BREAK_PROP_NEWLINE ||
		    p.raw.prev_prop[0] == WORD_BREAK_PROP_CR ||
		    p.raw.prev_prop[0] == WORD_BREAK_PROP_LF) {
			break;
		}

		/* WB3b */
		if (p.raw.next_prop[0] == WORD_BREAK_PROP_NEWLINE ||
		    p.raw.next_prop[0] == WORD_BREAK_PROP_CR ||
		    p.raw.next_prop[0] == WORD_BREAK_PROP_LF) {
			break;
		}

		/* WB3c */
		if (p.raw.prev_prop[0] == WORD_BREAK_PROP_ZWJ &&
		    (p.raw.next_prop[0] ==
		             WORD_BREAK_PROP_EXTENDED_PICTOGRAPHIC ||
		     p.raw.next_prop[0] ==
		             WORD_BREAK_PROP_BOTH_ALETTER_EXTPICT)) {
			continue;
		}

		/* WB3d */
		if (p.raw.prev_prop[0] == WORD_BREAK_PROP_WSEGSPACE &&
		    p.raw.next_prop[0] == WORD_BREAK_PROP_WSEGSPACE) {
			continue;
		}

		/* WB4 */
		if (p.raw.next_prop[0] == WORD_BREAK_PROP_EXTEND ||
		    p.raw.next_prop[0] == WORD_BREAK_PROP_FORMAT ||
		    p.raw.next_prop[0] == WORD_BREAK_PROP_ZWJ) {
			continue;
		}

		/* WB5 */
		if ((p.skip.prev_prop[0] == WORD_BREAK_PROP_ALETTER ||
		     p.skip.prev_prop[0] ==
		             WORD_BREAK_PROP_BOTH_ALETTER_EXTPICT ||
		     p.skip.prev_prop[0] == WORD_BREAK_PROP_HEBREW_LETTER) &&
		    (p.skip.next_prop[0] == WORD_BREAK_PROP_ALETTER ||
		     p.skip.next_prop[0] ==
		             WORD_BREAK_PROP_BOTH_ALETTER_EXTPICT ||
		     p.skip.next_prop[0] == WORD_BREAK_PROP_HEBREW_LETTER)) {
			continue;
		}

		/* WB6 */
		if ((p.skip.prev_prop[0] == WORD_BREAK_PROP_ALETTER ||
		     p.skip.prev_prop[0] ==
		             WORD_BREAK_PROP_BOTH_ALETTER_EXTPICT ||
		     p.skip.prev_prop[0] == WORD_BREAK_PROP_HEBREW_LETTER) &&
		    (p.skip.next_prop[0] == WORD_BREAK_PROP_MIDLETTER ||
		     p.skip.next_prop[0] == WORD_BREAK_PROP_MIDNUMLET ||
		     p.skip.next_prop[0] == WORD_BREAK_PROP_SINGLE_QUOTE) &&
		    (p.skip.next_prop[1] == WORD_BREAK_PROP_ALETTER ||
		     p.skip.next_prop[1] ==
		             WORD_BREAK_PROP_BOTH_ALETTER_EXTPICT ||
		     p.skip.next_prop[1] == WORD_BREAK_PROP_HEBREW_LETTER)) {
			continue;
		}

		/* WB7 */
		if ((p.skip.prev_prop[0] == WORD_BREAK_PROP_MIDLETTER ||
		     p.skip.prev_prop[0] == WORD_BREAK_PROP_MIDNUMLET ||
		     p.skip.prev_prop[0] == WORD_BREAK_PROP_SINGLE_QUOTE) &&
		    (p.skip.next_prop[0] == WORD_BREAK_PROP_ALETTER ||
		     p.skip.next_prop[0] ==
		             WORD_BREAK_PROP_BOTH_ALETTER_EXTPICT ||
		     p.skip.next_prop[0] == WORD_BREAK_PROP_HEBREW_LETTER) &&
		    (p.skip.prev_prop[1] == WORD_BREAK_PROP_ALETTER ||
		     p.skip.prev_prop[1] ==
		             WORD_BREAK_PROP_BOTH_ALETTER_EXTPICT ||
		     p.skip.prev_prop[1] == WORD_BREAK_PROP_HEBREW_LETTER)) {
			continue;
		}

		/* WB7a */
		if (p.skip.prev_prop[0] == WORD_BREAK_PROP_HEBREW_LETTER &&
		    p.skip.next_prop[0] == WORD_BREAK_PROP_SINGLE_QUOTE) {
			continue;
		}

		/* WB7b */
		if (p.skip.prev_prop[0] == WORD_BREAK_PROP_HEBREW_LETTER &&
		    p.skip.next_prop[0] == WORD_BREAK_PROP_DOUBLE_QUOTE &&
		    p.skip.next_prop[1] == WORD_BREAK_PROP_HEBREW_LETTER) {
			continue;
		}

		/* WB7c */
		if (p.skip.prev_prop[0] == WORD_BREAK_PROP_DOUBLE_QUOTE &&
		    p.skip.next_prop[0] == WORD_BREAK_PROP_HEBREW_LETTER &&
		    p.skip.prev_prop[1] == WORD_BREAK_PROP_HEBREW_LETTER) {
			continue;
		}

		/* WB8 */
		if (p.skip.prev_prop[0] == WORD_BREAK_PROP_NUMERIC &&
		    p.skip.next_prop[0] == WORD_BREAK_PROP_NUMERIC) {
			continue;
		}

		/* WB9 */
		if ((p.skip.prev_prop[0] == WORD_BREAK_PROP_ALETTER ||
		     p.skip.prev_prop[0] ==
		             WORD_BREAK_PROP_BOTH_ALETTER_EXTPICT ||
		     p.skip.prev_prop[0] == WORD_BREAK_PROP_HEBREW_LETTER) &&
		    p.skip.next_prop[0] == WORD_BREAK_PROP_NUMERIC) {
			continue;
		}

		/* WB10 */
		if (p.skip.prev_prop[0] == WORD_BREAK_PROP_NUMERIC &&
		    (p.skip.next_prop[0] == WORD_BREAK_PROP_ALETTER ||
		     p.skip.next_prop[0] ==
		             WORD_BREAK_PROP_BOTH_ALETTER_EXTPICT ||
		     p.skip.next_prop[0] == WORD_BREAK_PROP_HEBREW_LETTER)) {
			continue;
		}

		/* WB11 */
		if ((p.skip.prev_prop[0] == WORD_BREAK_PROP_MIDNUM ||
		     p.skip.prev_prop[0] == WORD_BREAK_PROP_MIDNUMLET ||
		     p.skip.prev_prop[0] == WORD_BREAK_PROP_SINGLE_QUOTE) &&
		    p.skip.next_prop[0] == WORD_BREAK_PROP_NUMERIC &&
		    p.skip.prev_prop[1] == WORD_BREAK_PROP_NUMERIC) {
			continue;
		}

		/* WB12 */
		if (p.skip.prev_prop[0] == WORD_BREAK_PROP_NUMERIC &&
		    (p.skip.next_prop[0] == WORD_BREAK_PROP_MIDNUM ||
		     p.skip.next_prop[0] == WORD_BREAK_PROP_MIDNUMLET ||
		     p.skip.next_prop[0] == WORD_BREAK_PROP_SINGLE_QUOTE) &&
		    p.skip.next_prop[1] == WORD_BREAK_PROP_NUMERIC) {
			continue;
		}

		/* WB13 */
		if (p.skip.prev_prop[0] == WORD_BREAK_PROP_KATAKANA &&
		    p.skip.next_prop[0] == WORD_BREAK_PROP_KATAKANA) {
			continue;
		}

		/* WB13a */
		if ((p.skip.prev_prop[0] == WORD_BREAK_PROP_ALETTER ||
		     p.skip.prev_prop[0] ==
		             WORD_BREAK_PROP_BOTH_ALETTER_EXTPICT ||
		     p.skip.prev_prop[0] == WORD_BREAK_PROP_HEBREW_LETTER ||
		     p.skip.prev_prop[0] == WORD_BREAK_PROP_NUMERIC ||
		     p.skip.prev_prop[0] == WORD_BREAK_PROP_KATAKANA ||
		     p.skip.prev_prop[0] == WORD_BREAK_PROP_EXTENDNUMLET) &&
		    p.skip.next_prop[0] == WORD_BREAK_PROP_EXTENDNUMLET) {
			continue;
		}

		/* WB13b */
		if (p.skip.prev_prop[0] == WORD_BREAK_PROP_EXTENDNUMLET &&
		    (p.skip.next_prop[0] == WORD_BREAK_PROP_ALETTER ||
		     p.skip.next_prop[0] ==
		             WORD_BREAK_PROP_BOTH_ALETTER_EXTPICT ||
		     p.skip.next_prop[0] == WORD_BREAK_PROP_HEBREW_LETTER ||
		     p.skip.next_prop[0] == WORD_BREAK_PROP_NUMERIC ||
		     p.skip.next_prop[0] == WORD_BREAK_PROP_KATAKANA)) {
			continue;
		}

		/* WB15 and WB16 */
		if (!state.ri_even &&
		    p.skip.next_prop[0] == WORD_BREAK_PROP_REGIONAL_INDICATOR) {
			continue;
		}

		/* WB999 */
		break;
	}

	return herodotus_reader_number_read(&(p.mid_reader));
}

size_t
grapheme_next_word_break(const uint_least32_t *str, size_t len)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_CODEPOINT, str, len);

	return next_word_break(&r);
}

size_t
grapheme_next_word_break_utf8(const char *str, size_t len)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_UTF8, str, len);

	return next_word_break(&r);
}
