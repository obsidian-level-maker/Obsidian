/* See LICENSE file for copyright and license details. */
#include <limits.h>
#include <stdbool.h>
#include <stddef.h>

#include "character.h"
#include "../grapheme.h"
#include "util.h"

struct character_break_state {
	uint_least8_t prop;
	bool prop_set;
	bool gb11_flag;
	bool gb12_13_flag;
};

static const uint_least16_t dont_break[NUM_CHAR_BREAK_PROPS] = {
	[CHAR_BREAK_PROP_OTHER] =
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND |           /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |              /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_SPACINGMARK,       /* GB9a */
	[CHAR_BREAK_PROP_CR] = UINT16_C(1) << CHAR_BREAK_PROP_LF, /* GB3  */
	[CHAR_BREAK_PROP_EXTEND] =
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND |     /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |        /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_SPACINGMARK, /* GB9a */
	[CHAR_BREAK_PROP_EXTENDED_PICTOGRAPHIC] =
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND |     /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |        /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_SPACINGMARK, /* GB9a */
	[CHAR_BREAK_PROP_HANGUL_L] =
		UINT16_C(1) << CHAR_BREAK_PROP_HANGUL_L |   /* GB6  */
		UINT16_C(1) << CHAR_BREAK_PROP_HANGUL_V |   /* GB6  */
		UINT16_C(1) << CHAR_BREAK_PROP_HANGUL_LV |  /* GB6  */
		UINT16_C(1) << CHAR_BREAK_PROP_HANGUL_LVT | /* GB6  */
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND |     /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |        /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_SPACINGMARK, /* GB9a */
	[CHAR_BREAK_PROP_HANGUL_V] =
		UINT16_C(1) << CHAR_BREAK_PROP_HANGUL_V |   /* GB7  */
		UINT16_C(1) << CHAR_BREAK_PROP_HANGUL_T |   /* GB7  */
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND |     /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |        /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_SPACINGMARK, /* GB9a */
	[CHAR_BREAK_PROP_HANGUL_T] =
		UINT16_C(1) << CHAR_BREAK_PROP_HANGUL_T |   /* GB8  */
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND |     /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |        /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_SPACINGMARK, /* GB9a */
	[CHAR_BREAK_PROP_HANGUL_LV] =
		UINT16_C(1) << CHAR_BREAK_PROP_HANGUL_V |   /* GB7  */
		UINT16_C(1) << CHAR_BREAK_PROP_HANGUL_T |   /* GB7  */
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND |     /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |        /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_SPACINGMARK, /* GB9a */
	[CHAR_BREAK_PROP_HANGUL_LVT] =
		UINT16_C(1) << CHAR_BREAK_PROP_HANGUL_T |   /* GB8  */
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND |     /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |        /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_SPACINGMARK, /* GB9a */
	[CHAR_BREAK_PROP_PREPEND] =
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND |      /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |         /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_SPACINGMARK | /* GB9a */
		(UINT16_C(0xFFFF) &
	         ~(UINT16_C(1) << CHAR_BREAK_PROP_CR |
	           UINT16_C(1) << CHAR_BREAK_PROP_LF |
	           UINT16_C(1) << CHAR_BREAK_PROP_CONTROL)), /* GB9b */
	[CHAR_BREAK_PROP_REGIONAL_INDICATOR] =
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND |     /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |        /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_SPACINGMARK, /* GB9a */
	[CHAR_BREAK_PROP_SPACINGMARK] =
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND |     /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |        /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_SPACINGMARK, /* GB9a */
	[CHAR_BREAK_PROP_ZWJ] =
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND |     /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |        /* GB9  */
		UINT16_C(1) << CHAR_BREAK_PROP_SPACINGMARK, /* GB9a */
};
static const uint_least16_t flag_update_gb11[2 * NUM_CHAR_BREAK_PROPS] = {
	[CHAR_BREAK_PROP_EXTENDED_PICTOGRAPHIC] =
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND,
	[CHAR_BREAK_PROP_ZWJ + NUM_CHAR_BREAK_PROPS] =
		UINT16_C(1) << CHAR_BREAK_PROP_EXTENDED_PICTOGRAPHIC,
	[CHAR_BREAK_PROP_EXTEND + NUM_CHAR_BREAK_PROPS] =
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND |
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ,
	[CHAR_BREAK_PROP_EXTENDED_PICTOGRAPHIC + NUM_CHAR_BREAK_PROPS] =
		UINT16_C(1) << CHAR_BREAK_PROP_ZWJ |
		UINT16_C(1) << CHAR_BREAK_PROP_EXTEND,
};
static const uint_least16_t dont_break_gb11[2 * NUM_CHAR_BREAK_PROPS] = {
	[CHAR_BREAK_PROP_ZWJ + NUM_CHAR_BREAK_PROPS] =
		UINT16_C(1) << CHAR_BREAK_PROP_EXTENDED_PICTOGRAPHIC,
};
static const uint_least16_t flag_update_gb12_13[2 * NUM_CHAR_BREAK_PROPS] = {
	[CHAR_BREAK_PROP_REGIONAL_INDICATOR] =
		UINT16_C(1) << CHAR_BREAK_PROP_REGIONAL_INDICATOR,
};
static const uint_least16_t dont_break_gb12_13[2 * NUM_CHAR_BREAK_PROPS] = {
	[CHAR_BREAK_PROP_REGIONAL_INDICATOR + NUM_CHAR_BREAK_PROPS] =
		UINT16_C(1) << CHAR_BREAK_PROP_REGIONAL_INDICATOR,
};

static inline enum char_break_property
get_break_prop(uint_least32_t cp)
{
	if (likely(cp <= UINT32_C(0x10FFFF))) {
		return (enum char_break_property)
			char_break_minor[char_break_major[cp >> 8] +
		                         (cp & 0xFF)];
	} else {
		return CHAR_BREAK_PROP_OTHER;
	}
}

static inline void
state_serialize(const struct character_break_state *in, uint_least16_t *out)
{
	*out = (uint_least16_t)(in->prop & UINT8_C(0xFF)) | /* first 8 bits */
	       (uint_least16_t)(((uint_least16_t)(in->prop_set))
	                        << 8) | /* 9th bit */
	       (uint_least16_t)(((uint_least16_t)(in->gb11_flag))
	                        << 9) | /* 10th bit */
	       (uint_least16_t)(((uint_least16_t)(in->gb12_13_flag))
	                        << 10); /* 11th bit */
}

static inline void
state_deserialize(uint_least16_t in, struct character_break_state *out)
{
	out->prop = in & UINT8_C(0xFF);
	out->prop_set = in & (UINT16_C(1) << 8);
	out->gb11_flag = in & (UINT16_C(1) << 9);
	out->gb12_13_flag = in & (UINT16_C(1) << 10);
}

bool
grapheme_is_character_break(uint_least32_t cp0, uint_least32_t cp1,
                            uint_least16_t *s)
{
	struct character_break_state state;
	enum char_break_property cp0_prop, cp1_prop;
	bool notbreak = false;

	if (likely(s)) {
		state_deserialize(*s, &state);

		if (likely(state.prop_set)) {
			cp0_prop = state.prop;
		} else {
			cp0_prop = get_break_prop(cp0);
		}
		cp1_prop = get_break_prop(cp1);

		/* preserve prop of right codepoint for next iteration */
		state.prop = (uint_least8_t)cp1_prop;
		state.prop_set = true;

		/* update flags */
		state.gb11_flag =
			flag_update_gb11[cp0_prop + NUM_CHAR_BREAK_PROPS *
		                                            state.gb11_flag] &
			UINT16_C(1) << cp1_prop;
		state.gb12_13_flag =
			flag_update_gb12_13[cp0_prop +
		                            NUM_CHAR_BREAK_PROPS *
		                                    state.gb12_13_flag] &
			UINT16_C(1) << cp1_prop;

		/*
		 * Apply grapheme cluster breaking algorithm (UAX #29), see
		 * http://unicode.org/reports/tr29/#Grapheme_Cluster_Boundary_Rules
		 */
		notbreak = (dont_break[cp0_prop] & (UINT16_C(1) << cp1_prop)) ||
		           (dont_break_gb11[cp0_prop +
		                            state.gb11_flag *
		                                    NUM_CHAR_BREAK_PROPS] &
		            (UINT16_C(1) << cp1_prop)) ||
		           (dont_break_gb12_13[cp0_prop +
		                               state.gb12_13_flag *
		                                       NUM_CHAR_BREAK_PROPS] &
		            (UINT16_C(1) << cp1_prop));

		/* update or reset flags (when we have a break) */
		if (likely(!notbreak)) {
			state.gb11_flag = state.gb12_13_flag = false;
		}

		state_serialize(&state, s);
	} else {
		cp0_prop = get_break_prop(cp0);
		cp1_prop = get_break_prop(cp1);

		/*
		 * Apply grapheme cluster breaking algorithm (UAX #29), see
		 * http://unicode.org/reports/tr29/#Grapheme_Cluster_Boundary_Rules
		 *
		 * Given we have no state, this behaves as if the state-booleans
		 * were all set to false
		 */
		notbreak = (dont_break[cp0_prop] & (UINT16_C(1) << cp1_prop)) ||
		           (dont_break_gb11[cp0_prop] &
		            (UINT16_C(1) << cp1_prop)) ||
		           (dont_break_gb12_13[cp0_prop] &
		            (UINT16_C(1) << cp1_prop));
	}

	return !notbreak;
}

static size_t
next_character_break(HERODOTUS_READER *r)
{
	uint_least16_t state = 0;
	uint_least32_t cp0 = 0, cp1 = 0;

	for (herodotus_read_codepoint(r, true, &cp0);
	     herodotus_read_codepoint(r, false, &cp1) ==
	     HERODOTUS_STATUS_SUCCESS;
	     herodotus_read_codepoint(r, true, &cp0)) {
		if (grapheme_is_character_break(cp0, cp1, &state)) {
			break;
		}
	}

	return herodotus_reader_number_read(r);
}

size_t
grapheme_next_character_break(const uint_least32_t *str, size_t len)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_CODEPOINT, str, len);

	return next_character_break(&r);
}

size_t
grapheme_next_character_break_utf8(const char *str, size_t len)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_UTF8, str, len);

	return next_character_break(&r);
}
