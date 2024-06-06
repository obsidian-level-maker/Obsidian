/* See LICENSE file for copyright and license details. */
#include <stdbool.h>
#include <stddef.h>

#include "line.h"
#include "../grapheme.h"
#include "util.h"

static inline enum line_break_property
get_break_prop(uint_least32_t cp)
{
	if (likely(cp <= UINT32_C(0x10FFFF))) {
		return (enum line_break_property)
			line_break_minor[line_break_major[cp >> 8] +
		                         (cp & 0xff)];
	} else {
		return LINE_BREAK_PROP_AL;
	}
}

static size_t
next_line_break(HERODOTUS_READER *r)
{
	HERODOTUS_READER tmp;
	enum line_break_property cp0_prop, cp1_prop, last_non_cm_or_zwj_prop,
		last_non_sp_prop, last_non_sp_cm_or_zwj_prop;
	uint_least32_t cp;
	uint_least8_t lb25_level = 0;
	bool lb21a_flag = false, ri_even = true;

	/*
	 * Apply line breaking algorithm (UAX #14), see
	 * https://unicode.org/reports/tr14/#Algorithm and tailoring
	 * https://unicode.org/reports/tr14/#Examples (example 7),
	 * given the automatic test-cases implement this example for
	 * better number handling.
	 *
	 */

	/*
	 * Initialize the different properties such that we have
	 * a good state after the state-update in the loop
	 */
	last_non_cm_or_zwj_prop = LINE_BREAK_PROP_AL; /* according to LB10 */
	last_non_sp_prop = last_non_sp_cm_or_zwj_prop = NUM_LINE_BREAK_PROPS;

	for (herodotus_read_codepoint(r, true, &cp),
	     cp0_prop = get_break_prop(cp);
	     herodotus_read_codepoint(r, false, &cp) ==
	     HERODOTUS_STATUS_SUCCESS;
	     herodotus_read_codepoint(r, true, &cp), cp0_prop = cp1_prop) {
		/* get property of the right codepoint */
		cp1_prop = get_break_prop(cp);

		/* update retention-states */

		/*
		 * store the last observed non-CM-or-ZWJ-property for
		 * LB9 and following.
		 */
		if (cp0_prop != LINE_BREAK_PROP_CM &&
		    cp0_prop != LINE_BREAK_PROP_ZWJ) {
			/*
			 * check if the property we are overwriting now is an
			 * HL. If so, we set the LB21a-flag which depends on
			 * this knowledge.
			 */
			lb21a_flag =
				(last_non_cm_or_zwj_prop == LINE_BREAK_PROP_HL);

			/* check regional indicator state */
			if (cp0_prop == LINE_BREAK_PROP_RI) {
				/*
				 * The property we just shifted in is
				 * a regional indicator, increasing the
				 * number of consecutive RIs on the left
				 * side of the breakpoint by one, changing
				 * the oddness.
				 *
				 */
				ri_even = !ri_even;
			} else {
				/*
				 * We saw no regional indicator, so the
				 * number of consecutive RIs on the left
				 * side of the breakpoint is zero, which
				 * is an even number.
				 *
				 */
				ri_even = true;
			}

			/*
			 * Here comes a bit of magic. The tailored rule
			 * LB25 (using example 7) has a very complicated
			 * left-hand-side-rule of the form
			 *
			 *  NU (NU | SY | IS)* (CL | CP)?
			 *
			 * but instead of backtracking, we keep the state
			 * as some kind of "power level" in the variable
			 *
			 *  lb25_level
			 *
			 * that goes from 0 to 3
			 *
			 *  0: we are not in the sequence
			 *  1: we have one NU to the left of the middle
			 *     spot
			 *  2: we have one NU and one or more (NU | SY | IS)
			 *     to the left of the middle spot
			 *  3: we have one NU, zero or more (NU | SY | IS)
			 *     and one (CL | CP) to the left of the middle
			 *     spot
			 */
			if ((lb25_level == 0 || lb25_level == 1) &&
			    cp0_prop == LINE_BREAK_PROP_NU) {
				/* sequence has begun */
				lb25_level = 1;
			} else if ((lb25_level == 1 || lb25_level == 2) &&
			           (cp0_prop == LINE_BREAK_PROP_NU ||
			            cp0_prop == LINE_BREAK_PROP_SY ||
			            cp0_prop == LINE_BREAK_PROP_IS)) {
				/* (NU | SY | IS) sequence begins or continued
				 */
				lb25_level = 2;
			} else if (
				(lb25_level == 1 || lb25_level == 2) &&
				(cp0_prop == LINE_BREAK_PROP_CL ||
			         cp0_prop ==
			                 LINE_BREAK_PROP_CP_WITHOUT_EAW_HWF ||
			         cp0_prop == LINE_BREAK_PROP_CP_WITH_EAW_HWF)) {
				/* CL or CP at the end of the sequence */
				lb25_level = 3;
			} else {
				/* sequence broke */
				lb25_level = 0;
			}

			last_non_cm_or_zwj_prop = cp0_prop;
		}

		/*
		 * store the last observed non-SP-property for LB8, LB14,
		 * LB15, LB16 and LB17. LB8 gets its own unskipped property,
		 * whereas the others build on top of the CM-ZWJ-skipped
		 * properties as they come after LB9
		 */
		if (cp0_prop != LINE_BREAK_PROP_SP) {
			last_non_sp_prop = cp0_prop;
		}
		if (last_non_cm_or_zwj_prop != LINE_BREAK_PROP_SP) {
			last_non_sp_cm_or_zwj_prop = last_non_cm_or_zwj_prop;
		}

		/* apply the algorithm */

		/* LB4 */
		if (cp0_prop == LINE_BREAK_PROP_BK) {
			break;
		}

		/* LB5 */
		if (cp0_prop == LINE_BREAK_PROP_CR &&
		    cp1_prop == LINE_BREAK_PROP_LF) {
			continue;
		}
		if (cp0_prop == LINE_BREAK_PROP_CR ||
		    cp0_prop == LINE_BREAK_PROP_LF ||
		    cp0_prop == LINE_BREAK_PROP_NL) {
			break;
		}

		/* LB6 */
		if (cp1_prop == LINE_BREAK_PROP_BK ||
		    cp1_prop == LINE_BREAK_PROP_CR ||
		    cp1_prop == LINE_BREAK_PROP_LF ||
		    cp1_prop == LINE_BREAK_PROP_NL) {
			continue;
		}

		/* LB7 */
		if (cp1_prop == LINE_BREAK_PROP_SP ||
		    cp1_prop == LINE_BREAK_PROP_ZW) {
			continue;
		}

		/* LB8 */
		if (last_non_sp_prop == LINE_BREAK_PROP_ZW) {
			break;
		}

		/* LB8a */
		if (cp0_prop == LINE_BREAK_PROP_ZWJ) {
			continue;
		}

		/* LB9 */
		if ((cp0_prop != LINE_BREAK_PROP_BK &&
		     cp0_prop != LINE_BREAK_PROP_CR &&
		     cp0_prop != LINE_BREAK_PROP_LF &&
		     cp0_prop != LINE_BREAK_PROP_NL &&
		     cp0_prop != LINE_BREAK_PROP_SP &&
		     cp0_prop != LINE_BREAK_PROP_ZW) &&
		    (cp1_prop == LINE_BREAK_PROP_CM ||
		     cp1_prop == LINE_BREAK_PROP_ZWJ)) {
			/*
			 * given we skip them, we don't break in such
			 * a sequence
			 */
			continue;
		}

		/* LB10 is baked into the following rules */

		/* LB11 */
		if (last_non_cm_or_zwj_prop == LINE_BREAK_PROP_WJ ||
		    cp1_prop == LINE_BREAK_PROP_WJ) {
			continue;
		}

		/* LB12 */
		if (last_non_cm_or_zwj_prop == LINE_BREAK_PROP_GL) {
			continue;
		}

		/* LB12a */
		if ((last_non_cm_or_zwj_prop != LINE_BREAK_PROP_SP &&
		     last_non_cm_or_zwj_prop != LINE_BREAK_PROP_BA &&
		     last_non_cm_or_zwj_prop != LINE_BREAK_PROP_HY) &&
		    cp1_prop == LINE_BREAK_PROP_GL) {
			continue;
		}

		/* LB13 (affected by tailoring for LB25, see example 7) */
		if (cp1_prop == LINE_BREAK_PROP_EX ||
		    (last_non_cm_or_zwj_prop != LINE_BREAK_PROP_NU &&
		     (cp1_prop == LINE_BREAK_PROP_CL ||
		      cp1_prop == LINE_BREAK_PROP_CP_WITHOUT_EAW_HWF ||
		      cp1_prop == LINE_BREAK_PROP_CP_WITH_EAW_HWF ||
		      cp1_prop == LINE_BREAK_PROP_IS ||
		      cp1_prop == LINE_BREAK_PROP_SY))) {
			continue;
		}

		/* LB14 */
		if (last_non_sp_cm_or_zwj_prop ==
		            LINE_BREAK_PROP_OP_WITHOUT_EAW_HWF ||
		    last_non_sp_cm_or_zwj_prop ==
		            LINE_BREAK_PROP_OP_WITH_EAW_HWF) {
			continue;
		}

		/* LB15 */
		if (last_non_sp_cm_or_zwj_prop == LINE_BREAK_PROP_QU &&
		    (cp1_prop == LINE_BREAK_PROP_OP_WITHOUT_EAW_HWF ||
		     cp1_prop == LINE_BREAK_PROP_OP_WITH_EAW_HWF)) {
			continue;
		}

		/* LB16 */
		if ((last_non_sp_cm_or_zwj_prop == LINE_BREAK_PROP_CL ||
		     last_non_sp_cm_or_zwj_prop ==
		             LINE_BREAK_PROP_CP_WITHOUT_EAW_HWF ||
		     last_non_sp_cm_or_zwj_prop ==
		             LINE_BREAK_PROP_CP_WITH_EAW_HWF) &&
		    cp1_prop == LINE_BREAK_PROP_NS) {
			continue;
		}

		/* LB17 */
		if (last_non_sp_cm_or_zwj_prop == LINE_BREAK_PROP_B2 &&
		    cp1_prop == LINE_BREAK_PROP_B2) {
			continue;
		}

		/* LB18 */
		if (last_non_cm_or_zwj_prop == LINE_BREAK_PROP_SP) {
			break;
		}

		/* LB19 */
		if (last_non_cm_or_zwj_prop == LINE_BREAK_PROP_QU ||
		    cp1_prop == LINE_BREAK_PROP_QU) {
			continue;
		}

		/* LB20 */
		if (last_non_cm_or_zwj_prop == LINE_BREAK_PROP_CB ||
		    cp1_prop == LINE_BREAK_PROP_CB) {
			break;
		}

		/* LB21 */
		if (cp1_prop == LINE_BREAK_PROP_BA ||
		    cp1_prop == LINE_BREAK_PROP_HY ||
		    cp1_prop == LINE_BREAK_PROP_NS ||
		    last_non_cm_or_zwj_prop == LINE_BREAK_PROP_BB) {
			continue;
		}

		/* LB21a */
		if (lb21a_flag &&
		    (last_non_cm_or_zwj_prop == LINE_BREAK_PROP_HY ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_BA)) {
			continue;
		}

		/* LB21b */
		if (last_non_cm_or_zwj_prop == LINE_BREAK_PROP_SY &&
		    cp1_prop == LINE_BREAK_PROP_HL) {
			continue;
		}

		/* LB22 */
		if (cp1_prop == LINE_BREAK_PROP_IN) {
			continue;
		}

		/* LB23 */
		if ((last_non_cm_or_zwj_prop == LINE_BREAK_PROP_AL ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_HL) &&
		    cp1_prop == LINE_BREAK_PROP_NU) {
			continue;
		}
		if (last_non_cm_or_zwj_prop == LINE_BREAK_PROP_NU &&
		    (cp1_prop == LINE_BREAK_PROP_AL ||
		     cp1_prop == LINE_BREAK_PROP_HL)) {
			continue;
		}

		/* LB23a */
		if (last_non_cm_or_zwj_prop == LINE_BREAK_PROP_PR &&
		    (cp1_prop == LINE_BREAK_PROP_ID ||
		     cp1_prop == LINE_BREAK_PROP_EB ||
		     cp1_prop == LINE_BREAK_PROP_EM)) {
			continue;
		}
		if ((last_non_cm_or_zwj_prop == LINE_BREAK_PROP_ID ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_EB ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_EM) &&
		    cp1_prop == LINE_BREAK_PROP_PO) {
			continue;
		}

		/* LB24 */
		if ((last_non_cm_or_zwj_prop == LINE_BREAK_PROP_PR ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_PO) &&
		    (cp1_prop == LINE_BREAK_PROP_AL ||
		     cp1_prop == LINE_BREAK_PROP_HL)) {
			continue;
		}
		if ((last_non_cm_or_zwj_prop == LINE_BREAK_PROP_AL ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_HL) &&
		    (cp1_prop == LINE_BREAK_PROP_PR ||
		     cp1_prop == LINE_BREAK_PROP_PO)) {
			continue;
		}

		/* LB25 (tailored with example 7) */
		if ((last_non_cm_or_zwj_prop == LINE_BREAK_PROP_PR ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_PO)) {
			if (cp1_prop == LINE_BREAK_PROP_NU) {
				continue;
			}

			/* this stupid rule is the reason why we cannot
			 * simply have a stateful break-detection between
			 * two adjacent codepoints as we have it with
			 * characters.
			 */
			herodotus_reader_copy(r, &tmp);
			herodotus_read_codepoint(&tmp, true, &cp);
			if (herodotus_read_codepoint(&tmp, true, &cp) ==
			            HERODOTUS_STATUS_SUCCESS &&
			    (cp1_prop == LINE_BREAK_PROP_OP_WITHOUT_EAW_HWF ||
			     cp1_prop == LINE_BREAK_PROP_OP_WITH_EAW_HWF ||
			     cp1_prop == LINE_BREAK_PROP_HY)) {
				if (get_break_prop(cp) == LINE_BREAK_PROP_NU) {
					continue;
				}
			}
		}
		if ((last_non_cm_or_zwj_prop ==
		             LINE_BREAK_PROP_OP_WITHOUT_EAW_HWF ||
		     last_non_cm_or_zwj_prop ==
		             LINE_BREAK_PROP_OP_WITH_EAW_HWF ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_HY) &&
		    cp1_prop == LINE_BREAK_PROP_NU) {
			continue;
		}
		if (lb25_level == 1 && (cp1_prop == LINE_BREAK_PROP_NU ||
		                        cp1_prop == LINE_BREAK_PROP_SY ||
		                        cp1_prop == LINE_BREAK_PROP_IS)) {
			continue;
		}
		if ((lb25_level == 1 || lb25_level == 2) &&
		    (cp1_prop == LINE_BREAK_PROP_NU ||
		     cp1_prop == LINE_BREAK_PROP_SY ||
		     cp1_prop == LINE_BREAK_PROP_IS ||
		     cp1_prop == LINE_BREAK_PROP_CL ||
		     cp1_prop == LINE_BREAK_PROP_CP_WITHOUT_EAW_HWF ||
		     cp1_prop == LINE_BREAK_PROP_CP_WITH_EAW_HWF)) {
			continue;
		}
		if ((lb25_level == 1 || lb25_level == 2 || lb25_level == 3) &&
		    (cp1_prop == LINE_BREAK_PROP_PO ||
		     cp1_prop == LINE_BREAK_PROP_PR)) {
			continue;
		}

		/* LB26 */
		if (last_non_cm_or_zwj_prop == LINE_BREAK_PROP_JL &&
		    (cp1_prop == LINE_BREAK_PROP_JL ||
		     cp1_prop == LINE_BREAK_PROP_JV ||
		     cp1_prop == LINE_BREAK_PROP_H2 ||
		     cp1_prop == LINE_BREAK_PROP_H3)) {
			continue;
		}
		if ((last_non_cm_or_zwj_prop == LINE_BREAK_PROP_JV ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_H2) &&
		    (cp1_prop == LINE_BREAK_PROP_JV ||
		     cp1_prop == LINE_BREAK_PROP_JT)) {
			continue;
		}
		if ((last_non_cm_or_zwj_prop == LINE_BREAK_PROP_JT ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_H3) &&
		    cp1_prop == LINE_BREAK_PROP_JT) {
			continue;
		}

		/* LB27 */
		if ((last_non_cm_or_zwj_prop == LINE_BREAK_PROP_JL ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_JV ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_JT ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_H2 ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_H3) &&
		    cp1_prop == LINE_BREAK_PROP_PO) {
			continue;
		}
		if (last_non_cm_or_zwj_prop == LINE_BREAK_PROP_PR &&
		    (cp1_prop == LINE_BREAK_PROP_JL ||
		     cp1_prop == LINE_BREAK_PROP_JV ||
		     cp1_prop == LINE_BREAK_PROP_JT ||
		     cp1_prop == LINE_BREAK_PROP_H2 ||
		     cp1_prop == LINE_BREAK_PROP_H3)) {
			continue;
		}

		/* LB28 */
		if ((last_non_cm_or_zwj_prop == LINE_BREAK_PROP_AL ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_HL) &&
		    (cp1_prop == LINE_BREAK_PROP_AL ||
		     cp1_prop == LINE_BREAK_PROP_HL)) {
			continue;
		}

		/* LB29 */
		if (last_non_cm_or_zwj_prop == LINE_BREAK_PROP_IS &&
		    (cp1_prop == LINE_BREAK_PROP_AL ||
		     cp1_prop == LINE_BREAK_PROP_HL)) {
			continue;
		}

		/* LB30 */
		if ((last_non_cm_or_zwj_prop == LINE_BREAK_PROP_AL ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_HL ||
		     last_non_cm_or_zwj_prop == LINE_BREAK_PROP_NU) &&
		    cp1_prop == LINE_BREAK_PROP_OP_WITHOUT_EAW_HWF) {
			continue;
		}
		if (last_non_cm_or_zwj_prop ==
		            LINE_BREAK_PROP_CP_WITHOUT_EAW_HWF &&
		    (cp1_prop == LINE_BREAK_PROP_AL ||
		     cp1_prop == LINE_BREAK_PROP_HL ||
		     cp1_prop == LINE_BREAK_PROP_NU)) {
			continue;
		}

		/* LB30a */
		if (!ri_even && last_non_cm_or_zwj_prop == LINE_BREAK_PROP_RI &&
		    cp1_prop == LINE_BREAK_PROP_RI) {
			continue;
		}

		/* LB30b */
		if (last_non_cm_or_zwj_prop == LINE_BREAK_PROP_EB &&
		    cp1_prop == LINE_BREAK_PROP_EM) {
			continue;
		}
		if (last_non_cm_or_zwj_prop ==
		            LINE_BREAK_PROP_BOTH_CN_EXTPICT &&
		    cp1_prop == LINE_BREAK_PROP_EM) {
			continue;
		}

		/* LB31 */
		break;
	}

	return herodotus_reader_number_read(r);
}

size_t
grapheme_next_line_break(const uint_least32_t *str, size_t len)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_CODEPOINT, str, len);

	return next_line_break(&r);
}

size_t
grapheme_next_line_break_utf8(const char *str, size_t len)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_UTF8, str, len);

	return next_line_break(&r);
}
