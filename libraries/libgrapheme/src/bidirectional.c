/* See LICENSE file for copyright and license details. */
#include <stdbool.h>
#include <stddef.h>

#include "bidirectional.h"
#include "../grapheme.h"
#include "util.h"

#define MAX_DEPTH 125

enum state_type {
	STATE_PROP,            /* in 0..23, bidi_property */
	STATE_PRESERVED_PROP,  /* in 0..23, preserved bidi_prop for L1-rule */
	STATE_BRACKET_OFF,     /* in 0..255, offset in bidi_bracket */
	STATE_LEVEL,           /* in 0..MAX_DEPTH+1=126, embedding level */
	STATE_PARAGRAPH_LEVEL, /* in 0..1, paragraph embedding level */
	STATE_VISITED,         /* in 0..1, visited within isolating run */
};

static struct {
	uint_least32_t filter_mask;
	size_t mask_shift;
	int_least16_t value_offset;
} state_lut[] = {
	[STATE_PROP] = {
		.filter_mask  = 0x000001F, /* 00000000 00000000 00000000 00011111 */
		.mask_shift   = 0,
		.value_offset = 0,
	},
	[STATE_PRESERVED_PROP] = {
		.filter_mask  = 0x00003E0, /* 00000000 00000000 00000011 11100000 */
		.mask_shift   = 5,
		.value_offset = 0,
	},
	[STATE_BRACKET_OFF] = {
		.filter_mask  = 0x003FC00, /* 00000000 00000011 11111100 00000000 */
		.mask_shift   = 10,
		.value_offset = 0,
	},
	[STATE_LEVEL] = {
		.filter_mask  = 0x1FC0000, /* 00000001 11111100 00000000 00000000 */
		.mask_shift   = 18,
		.value_offset = -1,
	},
	[STATE_PARAGRAPH_LEVEL] = {
		.filter_mask  = 0x2000000, /* 00000010 00000000 00000000 00000000 */
		.mask_shift   = 25,
		.value_offset = 0,
	},
	[STATE_VISITED] = {
		.filter_mask  = 0x4000000, /* 00000100 00000000 00000000 00000000 */
		.mask_shift   = 26,
		.value_offset = 0,
	},
};

static inline int_least16_t
get_state(enum state_type t, uint_least32_t input)
{
	return (int_least16_t)((input & state_lut[t].filter_mask) >>
	                       state_lut[t].mask_shift) +
	       state_lut[t].value_offset;
}

static inline void
set_state(enum state_type t, int_least16_t value, uint_least32_t *output)
{
	*output &= ~state_lut[t].filter_mask;
	*output |= ((uint_least32_t)(value - state_lut[t].value_offset)
	            << state_lut[t].mask_shift) &
	           state_lut[t].filter_mask;
}

struct isolate_runner {
	uint_least32_t *buf;
	size_t buflen;
	size_t start;

	struct {
		size_t off;
	} prev, cur, next;

	enum bidi_property sos, eos;

	uint_least8_t paragraph_level;
	int_least8_t isolating_run_level;
};

static inline enum bidi_property
ir_get_previous_prop(const struct isolate_runner *ir)
{
	return (ir->prev.off == SIZE_MAX) ?
	               ir->sos :
	               (uint_least8_t)get_state(STATE_PROP,
	                                        ir->buf[ir->prev.off]);
}

static inline enum bidi_property
ir_get_current_prop(const struct isolate_runner *ir)
{
	return (uint_least8_t)get_state(STATE_PROP, ir->buf[ir->cur.off]);
}

static inline enum bidi_property
ir_get_next_prop(const struct isolate_runner *ir)
{
	return (ir->next.off == SIZE_MAX) ?
	               ir->eos :
	               (uint_least8_t)get_state(STATE_PROP,
	                                        ir->buf[ir->next.off]);
}

static inline enum bidi_property
ir_get_current_preserved_prop(const struct isolate_runner *ir)
{
	return (uint_least8_t)get_state(STATE_PRESERVED_PROP,
	                                ir->buf[ir->cur.off]);
}

static inline int_least8_t
ir_get_current_level(const struct isolate_runner *ir)
{
	return (int_least8_t)get_state(STATE_LEVEL, ir->buf[ir->cur.off]);
}

static inline const struct bracket *
ir_get_current_bracket_prop(const struct isolate_runner *ir)
{
	return bidi_bracket +
	       (int_least8_t)get_state(STATE_BRACKET_OFF, ir->buf[ir->cur.off]);
}

static void
ir_set_current_prop(const struct isolate_runner *ir, enum bidi_property prop)
{
	set_state(STATE_PROP, (int_least16_t)prop, &(ir->buf[ir->cur.off]));
}

static void
ir_init(uint_least32_t *buf, size_t buflen, size_t off,
        uint_least8_t paragraph_level, bool within, struct isolate_runner *ir)
{
	size_t i;
	int_least8_t sos_level;

	/* initialize invariants */
	ir->buf = buf;
	ir->buflen = buflen;
	ir->paragraph_level = paragraph_level;
	ir->start = off;

	/* advance off until we are at a non-removed character */
	for (; off < buflen; off++) {
		if (get_state(STATE_LEVEL, buf[off]) != -1) {
			break;
		}
	}
	if (off == buflen) {
		/* we encountered no more non-removed character, terminate */
		ir->next.off = SIZE_MAX;
		return;
	}

	/* set the isolating run level to that of the current offset */
	ir->isolating_run_level =
		(int_least8_t)get_state(STATE_LEVEL, buf[off]);

	/* initialize sos and eos to dummy values */
	ir->sos = ir->eos = NUM_BIDI_PROPS;

	/*
	 * we write the information of the "current" state into next,
	 * so that the shift-in at the first advancement moves it in
	 * cur, as desired.
	 */
	ir->next.off = off;

	/*
	 * determine the previous state but store its offset in cur.off,
	 * given it's shifted in on the first advancement
	 */
	ir->cur.off = SIZE_MAX;
	for (i = off, sos_level = -1; i >= 1; i--) {
		if (get_state(STATE_LEVEL, buf[i - 1]) != -1) {
			/*
			 * we found a character that has not been
			 * removed in X9
			 */
			sos_level = (int_least8_t)get_state(STATE_LEVEL,
			                                    buf[i - 1]);

			if (within) {
				/* we just take it */
				ir->cur.off = i;
			}

			break;
		}
	}
	if (sos_level == -1) {
		/*
		 * there were no preceding non-removed characters, set
		 * sos-level to paragraph embedding level
		 */
		sos_level = (int_least8_t)paragraph_level;
	}

	if (!within || ir->cur.off == SIZE_MAX) {
		/*
		 * we are at the beginning of the sequence; initialize
		 * it faithfully according to the algorithm by looking
		 * at the sos-level
		 */
		if (MAX(sos_level, ir->isolating_run_level) % 2 == 0) {
			/* the higher level is even, set sos to L */
			ir->sos = BIDI_PROP_L;
		} else {
			/* the higher level is odd, set sos to R */
			ir->sos = BIDI_PROP_R;
		}
	}
}

static int
ir_advance(struct isolate_runner *ir)
{
	enum bidi_property prop;
	int_least8_t level, isolate_level, last_isolate_level;
	size_t i;

	if (ir->next.off == SIZE_MAX) {
		/* the sequence is over */
		return 1;
	}

	/* shift in */
	ir->prev.off = ir->cur.off;
	ir->cur.off = ir->next.off;

	/* mark as visited */
	set_state(STATE_VISITED, 1, &(ir->buf[ir->cur.off]));

	/* initialize next state by going to the next character in the sequence
	 */
	ir->next.off = SIZE_MAX;

	last_isolate_level = -1;
	for (i = ir->cur.off, isolate_level = 0; i < ir->buflen; i++) {
		level = (int_least8_t)get_state(STATE_LEVEL, ir->buf[i]);
		prop = (uint_least8_t)get_state(STATE_PROP, ir->buf[i]);

		if (level == -1) {
			/* this is one of the ignored characters, skip */
			continue;
		} else if (level == ir->isolating_run_level) {
			last_isolate_level = level;
		}

		/* follow BD8/BD9 and P2 to traverse the current sequence */
		if (prop == BIDI_PROP_LRI || prop == BIDI_PROP_RLI ||
		    prop == BIDI_PROP_FSI) {
			/*
			 * we encountered an isolate initiator, increment
			 * counter, but go into processing when we
			 * were not isolated before
			 */
			if (isolate_level < MAX_DEPTH) {
				isolate_level++;
			}
			if (isolate_level != 1) {
				continue;
			}
		} else if (prop == BIDI_PROP_PDI && isolate_level > 0) {
			isolate_level--;

			/*
			 * if the current PDI dropped the isolate-level
			 * to zero, it is itself part of the isolating
			 * run sequence; otherwise we simply continue.
			 */
			if (isolate_level > 0) {
				continue;
			}
		} else if (isolate_level > 0) {
			/* we are in an isolating sequence */
			continue;
		}

		/*
		 * now we either still are in our sequence or we hit
		 * the eos-case as we left the sequence and hit the
		 * first non-isolating-sequence character.
		 */
		if (i == ir->cur.off) {
			/* we were in the first initializing round */
			continue;
		} else if (level == ir->isolating_run_level) {
			/* isolate_level-skips have been handled before, we're
			 * good */
			/* still in the sequence */
			ir->next.off = i;
		} else {
			/* out of sequence or isolated, compare levels via eos
			 */
			ir->next.off = SIZE_MAX;
			if (MAX(last_isolate_level, level) % 2 == 0) {
				ir->eos = BIDI_PROP_L;
			} else {
				ir->eos = BIDI_PROP_R;
			}
		}
		break;
	}
	if (i == ir->buflen) {
		/*
		 * the sequence ended before we could grab an offset.
		 * we need to determine the eos-prop by comparing the
		 * level of the last element in the isolating run sequence
		 * with the paragraph level.
		 */
		ir->next.off = SIZE_MAX;
		if (MAX(last_isolate_level, ir->paragraph_level) % 2 == 0) {
			/* the higher level is even, set eos to L */
			ir->eos = BIDI_PROP_L;
		} else {
			/* the higher level is odd, set eos to R */
			ir->eos = BIDI_PROP_R;
		}
	}

	return 0;
}

static enum bidi_property
ir_get_last_strong_prop(const struct isolate_runner *ir)
{
	struct isolate_runner tmp;
	enum bidi_property last_strong_prop = ir->sos, prop;

	ir_init(ir->buf, ir->buflen, ir->start, ir->paragraph_level, false,
	        &tmp);
	for (; !ir_advance(&tmp) && tmp.cur.off < ir->cur.off;) {
		prop = ir_get_current_prop(&tmp);

		if (prop == BIDI_PROP_R || prop == BIDI_PROP_L ||
		    prop == BIDI_PROP_AL) {
			last_strong_prop = prop;
		}
	}

	return last_strong_prop;
}

static enum bidi_property
ir_get_last_strong_or_number_prop(const struct isolate_runner *ir)
{
	struct isolate_runner tmp;
	enum bidi_property last_strong_or_number_prop = ir->sos, prop;

	ir_init(ir->buf, ir->buflen, ir->start, ir->paragraph_level, false,
	        &tmp);
	for (; !ir_advance(&tmp) && tmp.cur.off < ir->cur.off;) {
		prop = ir_get_current_prop(&tmp);

		if (prop == BIDI_PROP_R || prop == BIDI_PROP_L ||
		    prop == BIDI_PROP_AL || prop == BIDI_PROP_EN ||
		    prop == BIDI_PROP_AN) {
			last_strong_or_number_prop = prop;
		}
	}

	return last_strong_or_number_prop;
}

static void
preprocess_bracket_pair(const struct isolate_runner *start,
                        const struct isolate_runner *end)
{
	enum bidi_property prop, bracket_prop, last_strong_or_number_prop;
	struct isolate_runner ir;
	size_t strong_type_off;

	/*
	 * check if the bracket contains a strong type (L or R|EN|AN)
	 */
	for (ir = *start, strong_type_off = SIZE_MAX,
	    bracket_prop = NUM_BIDI_PROPS;
	     !ir_advance(&ir) && ir.cur.off < end->cur.off;) {
		prop = ir_get_current_prop(&ir);

		if (prop == BIDI_PROP_L) {
			strong_type_off = ir.cur.off;
			if (ir.isolating_run_level % 2 == 0) {
				/*
				 * set the type for both brackets to L (so they
				 * match the strong type they contain)
				 */
				bracket_prop = BIDI_PROP_L;
			}
		} else if (prop == BIDI_PROP_R || prop == BIDI_PROP_EN ||
		           prop == BIDI_PROP_AN) {
			strong_type_off = ir.cur.off;
			if (ir.isolating_run_level % 2 != 0) {
				/*
				 * set the type for both brackets to R (so they
				 * match the strong type they contain)
				 */
				bracket_prop = BIDI_PROP_R;
			}
		}
	}
	if (strong_type_off == SIZE_MAX) {
		/*
		 * there are no strong types within the brackets and we just
		 * leave the brackets as is
		 */
		return;
	}

	if (bracket_prop == NUM_BIDI_PROPS) {
		/*
		 * We encountered a strong type, but it was opposite
		 * to the embedding direction.
		 * Check the previous strong type before the opening
		 * bracket
		 */
		last_strong_or_number_prop =
			ir_get_last_strong_or_number_prop(start);
		if (last_strong_or_number_prop == BIDI_PROP_L &&
		    ir.isolating_run_level % 2 != 0) {
			/*
			 * the previous strong type is also opposite
			 * to the embedding direction, so the context
			 * was established and we set the brackets
			 * accordingly.
			 */
			bracket_prop = BIDI_PROP_L;
		} else if ((last_strong_or_number_prop == BIDI_PROP_R ||
		            last_strong_or_number_prop == BIDI_PROP_EN ||
		            last_strong_or_number_prop == BIDI_PROP_AN) &&
		           ir.isolating_run_level % 2 == 0) {
			/*
			 * the previous strong type is also opposite
			 * to the embedding direction, so the context
			 * was established and we set the brackets
			 * accordingly.
			 */
			bracket_prop = BIDI_PROP_R;
		} else {
			/* set brackets to the embedding direction */
			if (ir.isolating_run_level % 2 == 0) {
				bracket_prop = BIDI_PROP_L;
			} else {
				bracket_prop = BIDI_PROP_R;
			}
		}
	}

	ir_set_current_prop(start, bracket_prop);
	ir_set_current_prop(end, bracket_prop);

	/*
	 * any sequence of NSMs after opening or closing brackets get
	 * the same property as the one we set on the brackets
	 */
	for (ir = *start; !ir_advance(&ir) && ir_get_current_preserved_prop(
						      &ir) == BIDI_PROP_NSM;) {
		ir_set_current_prop(&ir, bracket_prop);
	}
	for (ir = *end; !ir_advance(&ir) &&
	                ir_get_current_preserved_prop(&ir) == BIDI_PROP_NSM;) {
		ir_set_current_prop(&ir, bracket_prop);
	}
}

static void
preprocess_bracket_pairs(uint_least32_t *buf, size_t buflen, size_t off,
                         uint_least8_t paragraph_level)
{
	/*
	 * The N0-rule deals with bracket pairs that shall be determined
	 * with the rule BD16. This is specified as an algorithm with a
	 * stack of 63 bracket openings that are used to resolve into a
	 * separate list of pairs, which is then to be sorted by opening
	 * position. Thus, even though the bracketing-depth is limited
	 * by 63, the algorithm, as is, requires dynamic memory
	 * management.
	 *
	 * A naive approach (used by Fribidi) would be to screw the
	 * stack-approach and simply directly determine the
	 * corresponding closing bracket offset for a given opening
	 * bracket, leading to O(n²) time complexity in the worst case
	 * with a lot of brackets. While many brackets are not common,
	 * it is still possible to find a middle ground where you obtain
	 * strongly linear time complexity in most common cases:
	 *
	 * Instead of a stack, we use a FIFO data structure which is
	 * filled with bracket openings in the order of appearance (thus
	 * yielding an implicit sorting!) at the top. If the
	 * corresponding closing bracket is encountered, it is added to
	 * the respective entry, making it ready to "move out" at the
	 * bottom (i.e. passed to the bracket processing). Due to the
	 * nature of the specified pair detection algorithm, which only
	 * cares about the bracket type and nothing else (bidi class,
	 * level, etc.), we can mix processing and bracket detection.
	 *
	 * Obviously, if you, for instance, have one big bracket pair at
	 * the bottom that has not been closed yet, it will block the
	 * bracket processing and the FIFO might hit its capacity limit.
	 * At this point, the blockage is manually resolved using the
	 * naive quadratic approach.
	 *
	 * To remain within the specified standard behaviour, which
	 * mandates that processing of brackets should stop when the
	 * bracketing-depth is at 63, we simply check in an "overflow"
	 * scenario if all 63 elements in the LIFO are unfinished, which
	 * corresponds with such a bracketing depth.
	 */
	enum bidi_property prop;

	struct {
		bool complete;
		size_t bracket_class;
		struct isolate_runner start;
		struct isolate_runner end;
	} fifo[63];
	const struct bracket *bracket_prop, *tmp_bracket_prop;
	struct isolate_runner ir, tmp_ir;
	size_t fifo_len = 0, i, blevel, j, k;

	ir_init(buf, buflen, off, paragraph_level, false, &ir);
	while (!ir_advance(&ir)) {
		prop = ir_get_current_prop(&ir);
		bracket_prop = ir_get_current_bracket_prop(&ir);
		if (prop == BIDI_PROP_ON &&
		    bracket_prop->type == BIDI_BRACKET_OPEN) {
			if (fifo_len == LEN(fifo)) {
				/*
				 * The FIFO is full, check first if it's
				 * completely blocked (i.e. no finished
				 * bracket pairs, triggering the standard
				 * that mandates to abort in such a case
				 */
				for (i = 0; i < fifo_len; i++) {
					if (fifo[i].complete) {
						break;
					}
				}
				if (i == fifo_len) {
					/* abort processing */
					return;
				}

				/*
				 * by construction, the bottom entry
				 * in the FIFO is guaranteed to be
				 * unfinished (given we "consume" all
				 * finished bottom entries after each
				 * iteration).
				 *
				 * iterate, starting after the opening
				 * bracket, and find the corresponding
				 * closing bracket.
				 *
				 * if we find none, just drop the FIFO
				 * entry silently
				 */
				for (tmp_ir = fifo[0].start, blevel = 0;
				     !ir_advance(&tmp_ir);) {
					tmp_bracket_prop =
						ir_get_current_bracket_prop(
							&tmp_ir);

					if (tmp_bracket_prop->type ==
					            BIDI_BRACKET_OPEN &&
					    tmp_bracket_prop->class ==
					            bracket_prop->class) {
						/* we encountered another
						 * opening bracket of the
						 * same class */
						blevel++;

					} else if (tmp_bracket_prop->type ==
					                   BIDI_BRACKET_CLOSE &&
					           tmp_bracket_prop->class ==
					                   bracket_prop
					                           ->class) {
						/* we encountered a closing
						 * bracket of the same class
						 */
						if (blevel == 0) {
							/* this is the
							 * corresponding
							 * closing bracket
							 */
							fifo[0].complete = true;
							fifo[0].end = ir;
						} else {
							blevel--;
						}
					}
				}
				if (fifo[0].complete) {
					/* we found the matching bracket */
					preprocess_bracket_pair(
						&(fifo[i].start),
						&(fifo[i].end));
				}

				/* shift FIFO one to the left */
				for (i = 1; i < fifo_len; i++) {
					fifo[i - 1] = fifo[i];
				}
				fifo_len--;
			}

			/* add element to the FIFO */
			fifo_len++;
			fifo[fifo_len - 1].complete = false;
			fifo[fifo_len - 1].bracket_class = bracket_prop->class;
			fifo[fifo_len - 1].start = ir;
		} else if (prop == BIDI_PROP_ON &&
		           bracket_prop->type == BIDI_BRACKET_CLOSE) {
			/*
			 * go backwards in the FIFO, skip finished entries
			 * and simply ignore (do nothing) the closing
			 * bracket if we do not match anything
			 */
			for (i = fifo_len; i > 0; i--) {
				if (bracket_prop->class ==
				            fifo[i - 1].bracket_class &&
				    !fifo[i - 1].complete) {
					/* we have found a pair */
					fifo[i - 1].complete = true;
					fifo[i - 1].end = ir;

					/* remove all uncompleted FIFO elements
					 * above i - 1 */
					for (j = i; j < fifo_len;) {
						if (fifo[j].complete) {
							j++;
							continue;
						}

						/* shift FIFO one to the left */
						for (k = j + 1; k < fifo_len;
						     k++) {
							fifo[k - 1] = fifo[k];
						}
						fifo_len--;
					}
					break;
				}
			}
		}

		/* process all ready bracket pairs from the FIFO bottom */
		while (fifo_len > 0 && fifo[0].complete) {
			preprocess_bracket_pair(&(fifo[0].start),
			                        &(fifo[0].end));

			/* shift FIFO one to the left */
			for (j = 0; j + 1 < fifo_len; j++) {
				fifo[j] = fifo[j + 1];
			}
			fifo_len--;
		}
	}

	/*
	 * afterwards, we still might have unfinished bracket pairs
	 * that will remain as such, but the subsequent finished pairs
	 * also need to be taken into account, so we go through the
	 * FIFO once more and process all finished pairs
	 */
	for (i = 0; i < fifo_len; i++) {
		if (fifo[i].complete) {
			preprocess_bracket_pair(&(fifo[i].start),
			                        &(fifo[i].end));
		}
	}
}

static size_t
preprocess_isolating_run_sequence(uint_least32_t *buf, size_t buflen,
                                  size_t off, uint_least8_t paragraph_level)
{
	enum bidi_property sequence_prop, prop;
	struct isolate_runner ir, tmp;
	size_t runsince, sequence_end;

	/* W1 */
	ir_init(buf, buflen, off, paragraph_level, false, &ir);
	while (!ir_advance(&ir)) {
		if (ir_get_current_prop(&ir) == BIDI_PROP_NSM) {
			prop = ir_get_previous_prop(&ir);

			if (prop == BIDI_PROP_LRI || prop == BIDI_PROP_RLI ||
			    prop == BIDI_PROP_FSI || prop == BIDI_PROP_PDI) {
				ir_set_current_prop(&ir, BIDI_PROP_ON);
			} else {
				ir_set_current_prop(&ir, prop);
			}
		}
	}

	/* W2 */
	ir_init(buf, buflen, off, paragraph_level, false, &ir);
	while (!ir_advance(&ir)) {
		if (ir_get_current_prop(&ir) == BIDI_PROP_EN &&
		    ir_get_last_strong_prop(&ir) == BIDI_PROP_AL) {
			ir_set_current_prop(&ir, BIDI_PROP_AN);
		}
	}

	/* W3 */
	ir_init(buf, buflen, off, paragraph_level, false, &ir);
	while (!ir_advance(&ir)) {
		if (ir_get_current_prop(&ir) == BIDI_PROP_AL) {
			ir_set_current_prop(&ir, BIDI_PROP_R);
		}
	}

	/* W4 */
	ir_init(buf, buflen, off, paragraph_level, false, &ir);
	while (!ir_advance(&ir)) {
		if (ir_get_previous_prop(&ir) == BIDI_PROP_EN &&
		    (ir_get_current_prop(&ir) == BIDI_PROP_ES ||
		     ir_get_current_prop(&ir) == BIDI_PROP_CS) &&
		    ir_get_next_prop(&ir) == BIDI_PROP_EN) {
			ir_set_current_prop(&ir, BIDI_PROP_EN);
		}

		if (ir_get_previous_prop(&ir) == BIDI_PROP_AN &&
		    ir_get_current_prop(&ir) == BIDI_PROP_CS &&
		    ir_get_next_prop(&ir) == BIDI_PROP_AN) {
			ir_set_current_prop(&ir, BIDI_PROP_AN);
		}
	}

	/* W5 */
	runsince = SIZE_MAX;
	ir_init(buf, buflen, off, paragraph_level, false, &ir);
	while (!ir_advance(&ir)) {
		if (ir_get_current_prop(&ir) == BIDI_PROP_ET) {
			if (runsince == SIZE_MAX) {
				/* a new run has begun */
				runsince = ir.cur.off;
			}
		} else if (ir_get_current_prop(&ir) == BIDI_PROP_EN) {
			/* set the preceding sequence */
			if (runsince != SIZE_MAX) {
				ir_init(buf, buflen, runsince, paragraph_level,
				        (runsince > off), &tmp);
				while (!ir_advance(&tmp) &&
				       tmp.cur.off < ir.cur.off) {
					ir_set_current_prop(&tmp, BIDI_PROP_EN);
				}
				runsince = SIZE_MAX;
			} else {
				ir_init(buf, buflen, ir.cur.off,
				        paragraph_level, (ir.cur.off > off),
				        &tmp);
				ir_advance(&tmp);
			}
			/* follow the succeeding sequence */
			while (!ir_advance(&tmp)) {
				if (ir_get_current_prop(&tmp) != BIDI_PROP_ET) {
					break;
				}
				ir_set_current_prop(&tmp, BIDI_PROP_EN);
			}
		} else {
			/* sequence ended */
			runsince = SIZE_MAX;
		}
	}

	/* W6 */
	ir_init(buf, buflen, off, paragraph_level, false, &ir);
	while (!ir_advance(&ir)) {
		prop = ir_get_current_prop(&ir);

		if (prop == BIDI_PROP_ES || prop == BIDI_PROP_ET ||
		    prop == BIDI_PROP_CS) {
			ir_set_current_prop(&ir, BIDI_PROP_ON);
		}
	}

	/* W7 */
	ir_init(buf, buflen, off, paragraph_level, false, &ir);
	while (!ir_advance(&ir)) {
		if (ir_get_current_prop(&ir) == BIDI_PROP_EN &&
		    ir_get_last_strong_prop(&ir) == BIDI_PROP_L) {
			ir_set_current_prop(&ir, BIDI_PROP_L);
		}
	}

	/* N0 */
	preprocess_bracket_pairs(buf, buflen, off, paragraph_level);

	/* N1 */
	sequence_end = SIZE_MAX;
	sequence_prop = NUM_BIDI_PROPS;
	ir_init(buf, buflen, off, paragraph_level, false, &ir);
	while (!ir_advance(&ir)) {
		if (sequence_end == SIZE_MAX) {
			prop = ir_get_current_prop(&ir);

			if (prop == BIDI_PROP_B || prop == BIDI_PROP_S ||
			    prop == BIDI_PROP_WS || prop == BIDI_PROP_ON ||
			    prop == BIDI_PROP_FSI || prop == BIDI_PROP_LRI ||
			    prop == BIDI_PROP_RLI || prop == BIDI_PROP_PDI) {
				/* the current character is an NI (neutral
				 * or isolate) */

				/* scan ahead to the end of the NI-sequence
				 */
				ir_init(buf, buflen, ir.cur.off,
				        paragraph_level, (ir.cur.off > off),
				        &tmp);
				while (!ir_advance(&tmp)) {
					prop = ir_get_next_prop(&tmp);

					if (prop != BIDI_PROP_B &&
					    prop != BIDI_PROP_S &&
					    prop != BIDI_PROP_WS &&
					    prop != BIDI_PROP_ON &&
					    prop != BIDI_PROP_FSI &&
					    prop != BIDI_PROP_LRI &&
					    prop != BIDI_PROP_RLI &&
					    prop != BIDI_PROP_PDI) {
						break;
					}
				}

				/*
				 * check what follows and see if the text
				 * has the same direction on both sides
				 */
				if (ir_get_previous_prop(&ir) == BIDI_PROP_L &&
				    ir_get_next_prop(&tmp) == BIDI_PROP_L) {
					sequence_end = tmp.cur.off;
					sequence_prop = BIDI_PROP_L;
				} else if ((ir_get_previous_prop(&ir) ==
				                    BIDI_PROP_R ||
				            ir_get_previous_prop(&ir) ==
				                    BIDI_PROP_EN ||
				            ir_get_previous_prop(&ir) ==
				                    BIDI_PROP_AN) &&
				           (ir_get_next_prop(&tmp) ==
				                    BIDI_PROP_R ||
				            ir_get_next_prop(&tmp) ==
				                    BIDI_PROP_EN ||
				            ir_get_next_prop(&tmp) ==
				                    BIDI_PROP_AN)) {
					sequence_end = tmp.cur.off;
					sequence_prop = BIDI_PROP_R;
				}
			}
		}

		if (sequence_end != SIZE_MAX) {
			if (ir.cur.off <= sequence_end) {
				ir_set_current_prop(&ir, sequence_prop);
			} else {
				/* end of sequence, reset */
				sequence_end = SIZE_MAX;
				sequence_prop = NUM_BIDI_PROPS;
			}
		}
	}

	/* N2 */
	ir_init(buf, buflen, off, paragraph_level, false, &ir);
	while (!ir_advance(&ir)) {
		prop = ir_get_current_prop(&ir);

		if (prop == BIDI_PROP_B || prop == BIDI_PROP_S ||
		    prop == BIDI_PROP_WS || prop == BIDI_PROP_ON ||
		    prop == BIDI_PROP_FSI || prop == BIDI_PROP_LRI ||
		    prop == BIDI_PROP_RLI || prop == BIDI_PROP_PDI) {
			/* N2 */
			if (ir_get_current_level(&ir) % 2 == 0) {
				/* even embedding level */
				ir_set_current_prop(&ir, BIDI_PROP_L);
			} else {
				/* odd embedding level */
				ir_set_current_prop(&ir, BIDI_PROP_R);
			}
		}
	}

	return 0;
}

static uint_least8_t
get_isolated_paragraph_level(const uint_least32_t *state, size_t statelen)
{
	enum bidi_property prop;
	int_least8_t isolate_level;
	size_t stateoff;

	/* determine paragraph level (rules P1-P3) and terminate on PDI */
	for (stateoff = 0, isolate_level = 0; stateoff < statelen; stateoff++) {
		prop = (uint_least8_t)get_state(STATE_PROP, state[stateoff]);

		if (prop == BIDI_PROP_PDI && isolate_level == 0) {
			/*
			 * we are in a FSI-subsection of a paragraph and
			 * matched with the terminating PDI
			 */
			break;
		}

		/* BD8/BD9 */
		if ((prop == BIDI_PROP_LRI || prop == BIDI_PROP_RLI ||
		     prop == BIDI_PROP_FSI) &&
		    isolate_level < MAX_DEPTH) {
			/* we hit an isolate initiator, increment counter */
			isolate_level++;
		} else if (prop == BIDI_PROP_PDI && isolate_level > 0) {
			isolate_level--;
		}

		/* P2 */
		if (isolate_level > 0) {
			continue;
		}

		/* P3 */
		if (prop == BIDI_PROP_L) {
			return 0;
		} else if (prop == BIDI_PROP_AL || prop == BIDI_PROP_R) {
			return 1;
		}
	}

	return 0;
}

static inline uint_least8_t
get_bidi_property(uint_least32_t cp)
{
	if (likely(cp <= 0x10FFFF)) {
		return (bidi_minor[bidi_major[cp >> 8] + (cp & 0xff)]) &
		       0x1F /* 00011111 */;
	} else {
		return BIDI_PROP_L;
	}
}

static uint_least8_t
get_paragraph_level(enum grapheme_bidirectional_direction override,
                    const HERODOTUS_READER *r)
{
	HERODOTUS_READER tmp;
	enum bidi_property prop;
	int_least8_t isolate_level;
	uint_least32_t cp;

	/* check overrides first according to rule HL1 */
	if (override == GRAPHEME_BIDIRECTIONAL_DIRECTION_LTR) {
		return 0;
	} else if (override == GRAPHEME_BIDIRECTIONAL_DIRECTION_RTL) {
		return 1;
	}

	/* copy reader into temporary reader */
	herodotus_reader_copy(r, &tmp);

	/* determine paragraph level (rules P1-P3) */
	for (isolate_level = 0; herodotus_read_codepoint(&tmp, true, &cp) ==
	                        HERODOTUS_STATUS_SUCCESS;) {
		prop = get_bidi_property(cp);

		/* BD8/BD9 */
		if ((prop == BIDI_PROP_LRI || prop == BIDI_PROP_RLI ||
		     prop == BIDI_PROP_FSI) &&
		    isolate_level < MAX_DEPTH) {
			/* we hit an isolate initiator, increment counter */
			isolate_level++;
		} else if (prop == BIDI_PROP_PDI && isolate_level > 0) {
			isolate_level--;
		}

		/* P2 */
		if (isolate_level > 0) {
			continue;
		}

		/* P3 */
		if (prop == BIDI_PROP_L) {
			return 0;
		} else if (prop == BIDI_PROP_AL || prop == BIDI_PROP_R) {
			return 1;
		}
	}

	return 0;
}

static void
preprocess_paragraph(uint_least8_t paragraph_level, uint_least32_t *buf,
                     size_t buflen)
{
	enum bidi_property prop;
	int_least8_t level;

	struct {
		int_least8_t level;
		enum grapheme_bidirectional_direction override;
		bool directional_isolate;
	} directional_status[MAX_DEPTH + 2], *dirstat = directional_status;

	size_t overflow_isolate_count, overflow_embedding_count,
		valid_isolate_count, bufoff, i, runsince;

	/* X1 */
	dirstat->level = (int_least8_t)paragraph_level;
	dirstat->override = GRAPHEME_BIDIRECTIONAL_DIRECTION_NEUTRAL;
	dirstat->directional_isolate = false;
	overflow_isolate_count = overflow_embedding_count =
		valid_isolate_count = 0;

	for (bufoff = 0; bufoff < buflen; bufoff++) {
		prop = (uint_least8_t)get_state(STATE_PROP, buf[bufoff]);

		/* set paragraph level we need for line-level-processing */
		set_state(STATE_PARAGRAPH_LEVEL, paragraph_level,
		          &(buf[bufoff]));
again:
		if (prop == BIDI_PROP_RLE) {
			/* X2 */
			if (dirstat->level + (dirstat->level % 2 != 0) + 1 <=
			            MAX_DEPTH &&
			    overflow_isolate_count == 0 &&
			    overflow_embedding_count == 0) {
				/* valid RLE */
				dirstat++;
				dirstat->level =
					(dirstat - 1)->level +
					((dirstat - 1)->level % 2 != 0) + 1;
				dirstat->override =
					GRAPHEME_BIDIRECTIONAL_DIRECTION_NEUTRAL;
				dirstat->directional_isolate = false;
			} else {
				/* overflow RLE */
				overflow_embedding_count +=
					(overflow_isolate_count == 0);
			}
		} else if (prop == BIDI_PROP_LRE) {
			/* X3 */
			if (dirstat->level + (dirstat->level % 2 == 0) + 1 <=
			            MAX_DEPTH &&
			    overflow_isolate_count == 0 &&
			    overflow_embedding_count == 0) {
				/* valid LRE */
				dirstat++;
				dirstat->level =
					(dirstat - 1)->level +
					((dirstat - 1)->level % 2 == 0) + 1;
				dirstat->override =
					GRAPHEME_BIDIRECTIONAL_DIRECTION_NEUTRAL;
				dirstat->directional_isolate = false;
			} else {
				/* overflow LRE */
				overflow_embedding_count +=
					(overflow_isolate_count == 0);
			}
		} else if (prop == BIDI_PROP_RLO) {
			/* X4 */
			if (dirstat->level + (dirstat->level % 2 != 0) + 1 <=
			            MAX_DEPTH &&
			    overflow_isolate_count == 0 &&
			    overflow_embedding_count == 0) {
				/* valid RLO */
				dirstat++;
				dirstat->level =
					(dirstat - 1)->level +
					((dirstat - 1)->level % 2 != 0) + 1;
				dirstat->override =
					GRAPHEME_BIDIRECTIONAL_DIRECTION_RTL;
				dirstat->directional_isolate = false;
			} else {
				/* overflow RLO */
				overflow_embedding_count +=
					(overflow_isolate_count == 0);
			}
		} else if (prop == BIDI_PROP_LRO) {
			/* X5 */
			if (dirstat->level + (dirstat->level % 2 == 0) + 1 <=
			            MAX_DEPTH &&
			    overflow_isolate_count == 0 &&
			    overflow_embedding_count == 0) {
				/* valid LRE */
				dirstat++;
				dirstat->level =
					(dirstat - 1)->level +
					((dirstat - 1)->level % 2 == 0) + 1;
				dirstat->override =
					GRAPHEME_BIDIRECTIONAL_DIRECTION_LTR;
				dirstat->directional_isolate = false;
			} else {
				/* overflow LRO */
				overflow_embedding_count +=
					(overflow_isolate_count == 0);
			}
		} else if (prop == BIDI_PROP_RLI) {
			/* X5a */
			set_state(STATE_LEVEL, dirstat->level, &(buf[bufoff]));
			if (dirstat->override ==
			    GRAPHEME_BIDIRECTIONAL_DIRECTION_LTR) {
				set_state(STATE_PROP, BIDI_PROP_L,
				          &(buf[bufoff]));
			} else if (dirstat->override ==
			           GRAPHEME_BIDIRECTIONAL_DIRECTION_RTL) {
				set_state(STATE_PROP, BIDI_PROP_R,
				          &(buf[bufoff]));
			}

			if (dirstat->level + (dirstat->level % 2 != 0) + 1 <=
			            MAX_DEPTH &&
			    overflow_isolate_count == 0 &&
			    overflow_embedding_count == 0) {
				/* valid RLI */
				valid_isolate_count++;

				dirstat++;
				dirstat->level =
					(dirstat - 1)->level +
					((dirstat - 1)->level % 2 != 0) + 1;
				dirstat->override =
					GRAPHEME_BIDIRECTIONAL_DIRECTION_NEUTRAL;
				dirstat->directional_isolate = true;
			} else {
				/* overflow RLI */
				overflow_isolate_count++;
			}
		} else if (prop == BIDI_PROP_LRI) {
			/* X5b */
			set_state(STATE_LEVEL, dirstat->level, &(buf[bufoff]));
			if (dirstat->override ==
			    GRAPHEME_BIDIRECTIONAL_DIRECTION_LTR) {
				set_state(STATE_PROP, BIDI_PROP_L,
				          &(buf[bufoff]));
			} else if (dirstat->override ==
			           GRAPHEME_BIDIRECTIONAL_DIRECTION_RTL) {
				set_state(STATE_PROP, BIDI_PROP_R,
				          &(buf[bufoff]));
			}

			if (dirstat->level + (dirstat->level % 2 == 0) + 1 <=
			            MAX_DEPTH &&
			    overflow_isolate_count == 0 &&
			    overflow_embedding_count == 0) {
				/* valid LRI */
				valid_isolate_count++;

				dirstat++;
				dirstat->level =
					(dirstat - 1)->level +
					((dirstat - 1)->level % 2 == 0) + 1;
				dirstat->override =
					GRAPHEME_BIDIRECTIONAL_DIRECTION_NEUTRAL;
				dirstat->directional_isolate = true;
			} else {
				/* overflow LRI */
				overflow_isolate_count++;
			}
		} else if (prop == BIDI_PROP_FSI) {
			/* X5c */
			if (get_isolated_paragraph_level(
				    buf + (bufoff + 1),
				    buflen - (bufoff + 1)) == 1) {
				prop = BIDI_PROP_RLI;
				goto again;
			} else { /* ... == 0 */
				prop = BIDI_PROP_LRI;
				goto again;
			}
		} else if (prop != BIDI_PROP_B && prop != BIDI_PROP_BN &&
		           prop != BIDI_PROP_PDF && prop != BIDI_PROP_PDI) {
			/* X6 */
			set_state(STATE_LEVEL, dirstat->level, &(buf[bufoff]));
			if (dirstat->override ==
			    GRAPHEME_BIDIRECTIONAL_DIRECTION_LTR) {
				set_state(STATE_PROP, BIDI_PROP_L,
				          &(buf[bufoff]));
			} else if (dirstat->override ==
			           GRAPHEME_BIDIRECTIONAL_DIRECTION_RTL) {
				set_state(STATE_PROP, BIDI_PROP_R,
				          &(buf[bufoff]));
			}
		} else if (prop == BIDI_PROP_PDI) {
			/* X6a */
			if (overflow_isolate_count > 0) {
				/* PDI matches an overflow isolate initiator
				 */
				overflow_isolate_count--;
			} else if (valid_isolate_count > 0) {
				/* PDI matches a normal isolate initiator */
				overflow_embedding_count = 0;
				while (dirstat->directional_isolate == false &&
				       dirstat > directional_status) {
					/*
					 * we are safe here as given the
					 * valid isolate count is positive
					 * there must be a stack-entry
					 * with positive directional
					 * isolate status, but we take
					 * no chances and include an
					 * explicit check
					 *
					 * POSSIBLE OPTIMIZATION: Whenever
					 * we push on the stack, check if it
					 * has the directional isolate
					 * status true and store a pointer
					 * to it so we can jump to it very
					 * quickly.
					 */
					dirstat--;
				}

				/*
				 * as above, the following check is not
				 * necessary, given we are guaranteed to
				 * have at least one stack entry left,
				 * but it's better to be safe
				 */
				if (dirstat > directional_status) {
					dirstat--;
				}
				valid_isolate_count--;
			}

			set_state(STATE_LEVEL, dirstat->level, &(buf[bufoff]));
			if (dirstat->override ==
			    GRAPHEME_BIDIRECTIONAL_DIRECTION_LTR) {
				set_state(STATE_PROP, BIDI_PROP_L,
				          &(buf[bufoff]));
			} else if (dirstat->override ==
			           GRAPHEME_BIDIRECTIONAL_DIRECTION_RTL) {
				set_state(STATE_PROP, BIDI_PROP_R,
				          &(buf[bufoff]));
			}
		} else if (prop == BIDI_PROP_PDF) {
			/* X7 */
			if (overflow_isolate_count > 0) {
				/* do nothing */
			} else if (overflow_embedding_count > 0) {
				overflow_embedding_count--;
			} else if (dirstat->directional_isolate == false &&
			           dirstat > directional_status) {
				dirstat--;
			}
		} else if (prop == BIDI_PROP_B) {
			/* X8 */
			set_state(STATE_LEVEL, paragraph_level, &(buf[bufoff]));
		}

		/* X9 */
		if (prop == BIDI_PROP_RLE || prop == BIDI_PROP_LRE ||
		    prop == BIDI_PROP_RLO || prop == BIDI_PROP_LRO ||
		    prop == BIDI_PROP_PDF || prop == BIDI_PROP_BN) {
			set_state(STATE_LEVEL, -1, &(buf[bufoff]));
		}
	}

	/* X10 (W1-W7, N0-N2) */
	for (bufoff = 0; bufoff < buflen; bufoff++) {
		if (get_state(STATE_VISITED, buf[bufoff]) == 0 &&
		    get_state(STATE_LEVEL, buf[bufoff]) != -1) {
			bufoff += preprocess_isolating_run_sequence(
				buf, buflen, bufoff, paragraph_level);
		}
	}

	/*
	 * I1-I2 (given our sequential approach to processing the
	 * isolating run sequences, we apply this rule separately)
	 */
	for (bufoff = 0; bufoff < buflen; bufoff++) {
		level = (int_least8_t)get_state(STATE_LEVEL, buf[bufoff]);
		prop = (uint_least8_t)get_state(STATE_PROP, buf[bufoff]);

		if (level % 2 == 0) {
			/* even level */
			if (prop == BIDI_PROP_R) {
				set_state(STATE_LEVEL, level + 1,
				          &(buf[bufoff]));
			} else if (prop == BIDI_PROP_AN ||
			           prop == BIDI_PROP_EN) {
				set_state(STATE_LEVEL, level + 2,
				          &(buf[bufoff]));
			}
		} else {
			/* odd level */
			if (prop == BIDI_PROP_L || prop == BIDI_PROP_EN ||
			    prop == BIDI_PROP_AN) {
				set_state(STATE_LEVEL, level + 1,
				          &(buf[bufoff]));
			}
		}
	}

	/* L1 (rules 1-3) */
	runsince = SIZE_MAX;
	for (bufoff = 0; bufoff < buflen; bufoff++) {
		level = (int_least8_t)get_state(STATE_LEVEL, buf[bufoff]);
		prop = (uint_least8_t)get_state(STATE_PRESERVED_PROP,
		                                buf[bufoff]);

		if (level == -1) {
			/* ignored character */
			continue;
		}

		/* rules 1 and 2 */
		if (prop == BIDI_PROP_S || prop == BIDI_PROP_B) {
			set_state(STATE_LEVEL, paragraph_level, &(buf[bufoff]));
		}

		/* rule 3 */
		if (prop == BIDI_PROP_WS || prop == BIDI_PROP_FSI ||
		    prop == BIDI_PROP_LRI || prop == BIDI_PROP_RLI ||
		    prop == BIDI_PROP_PDI) {
			if (runsince == SIZE_MAX) {
				/* a new run has begun */
				runsince = bufoff;
			}
		} else if ((prop == BIDI_PROP_S || prop == BIDI_PROP_B) &&
		           runsince != SIZE_MAX) {
			/*
			 * we hit a segment or paragraph separator in a
			 * sequence, reset sequence-levels
			 */
			for (i = runsince; i < bufoff; i++) {
				if (get_state(STATE_LEVEL, buf[i]) != -1) {
					set_state(STATE_LEVEL, paragraph_level,
					          &(buf[i]));
				}
			}
			runsince = SIZE_MAX;
		} else {
			/* sequence ended */
			runsince = SIZE_MAX;
		}
	}
	if (runsince != SIZE_MAX) {
		/*
		 * this is the end of the paragraph and we
		 * are in a run
		 */
		for (i = runsince; i < buflen; i++) {
			if (get_state(STATE_LEVEL, buf[i]) != -1) {
				set_state(STATE_LEVEL, paragraph_level,
				          &(buf[i]));
			}
		}
		runsince = SIZE_MAX;
	}
}

static inline uint_least8_t
get_bidi_bracket_off(uint_least32_t cp)
{
	if (likely(cp <= 0x10FFFF)) {
		return (uint_least8_t)((bidi_minor[bidi_major[cp >> 8] +
		                                   (cp & 0xff)]) >>
		                       5);
	} else {
		return 0;
	}
}

static size_t
preprocess(HERODOTUS_READER *r, enum grapheme_bidirectional_direction override,
           uint_least32_t *buf, size_t buflen,
           enum grapheme_bidirectional_direction *resolved)
{
	HERODOTUS_READER tmp;
	size_t bufoff, bufsize, paragraph_len;
	uint_least32_t cp;
	uint_least8_t paragraph_level;

	/* determine length and level of the paragraph */
	herodotus_reader_copy(r, &tmp);
	for (; herodotus_read_codepoint(&tmp, true, &cp) ==
	       HERODOTUS_STATUS_SUCCESS;) {
		/* break on paragraph separator */
		if (get_bidi_property(cp) == BIDI_PROP_B) {
			break;
		}
	}
	paragraph_len = herodotus_reader_number_read(&tmp);
	paragraph_level = get_paragraph_level(override, r);

	if (resolved != NULL) {
		/* store resolved paragraph level in output variable */
		/* TODO use enum-type */
		*resolved = (paragraph_level == 0) ?
		                    GRAPHEME_BIDIRECTIONAL_DIRECTION_LTR :
		                    GRAPHEME_BIDIRECTIONAL_DIRECTION_RTL;
	}

	if (buf == NULL) {
		/* see below for return value reasoning */
		return paragraph_len;
	}

	/*
	 * the first step is to determine the bidirectional properties
	 * and store them in the buffer
	 */
	for (bufoff = 0;
	     bufoff < paragraph_len &&
	     herodotus_read_codepoint(r, true, &cp) == HERODOTUS_STATUS_SUCCESS;
	     bufoff++) {
		if (bufoff < buflen) {
			/*
			 * actually only do something when we have
			 * space in the level-buffer. We continue
			 * the iteration to be able to give a good
			 * return value
			 */
			set_state(STATE_PROP,
			          (uint_least8_t)get_bidi_property(cp),
			          &(buf[bufoff]));
			set_state(STATE_BRACKET_OFF, get_bidi_bracket_off(cp),
			          &(buf[bufoff]));
			set_state(STATE_LEVEL, 0, &(buf[bufoff]));
			set_state(STATE_PARAGRAPH_LEVEL, 0, &(buf[bufoff]));
			set_state(STATE_VISITED, 0, &(buf[bufoff]));
			set_state(STATE_PRESERVED_PROP,
			          (uint_least8_t)get_bidi_property(cp),
			          &(buf[bufoff]));
		}
	}
	bufsize = herodotus_reader_number_read(r);

	for (bufoff = 0; bufoff < bufsize; bufoff++) {
		if (get_state(STATE_PROP, buf[bufoff]) != BIDI_PROP_B &&
		    bufoff != bufsize - 1) {
			continue;
		}

		/*
		 * we either encountered a paragraph terminator or this
		 * is the last character in the string.
		 * Call the paragraph handler on the paragraph, including
		 * the terminating character or last character of the
		 * string respectively
		 */
		preprocess_paragraph(paragraph_level, buf, bufoff + 1);
		break;
	}

	/*
	 * we return the number of total bytes read, as the function
	 * should indicate if the given level-buffer is too small
	 */
	return herodotus_reader_number_read(r);
}

size_t
grapheme_bidirectional_preprocess_paragraph(
	const uint_least32_t *src, size_t srclen,
	enum grapheme_bidirectional_direction override, uint_least32_t *dest,
	size_t destlen, enum grapheme_bidirectional_direction *resolved)
{
	HERODOTUS_READER r;

	herodotus_reader_init(&r, HERODOTUS_TYPE_CODEPOINT, src, srclen);

	return preprocess(&r, override, dest, destlen, resolved);
}

static inline size_t
get_line_embedding_levels(const uint_least32_t *linedata, size_t linelen,
                          int_least8_t (*get_level)(const void *, size_t),
                          void (*set_level)(void *, size_t, int_least8_t),
                          void *lev, size_t levsize, bool skipignored)
{
	enum bidi_property prop;
	size_t i, levlen, runsince;
	int_least8_t level, runlevel;

	/* rule L1.4 */
	runsince = SIZE_MAX;
	runlevel = -1;
	for (i = 0, levlen = 0; i < linelen; i++) {
		level = (int_least8_t)get_state(STATE_LEVEL, linedata[i]);
		prop = (uint_least8_t)get_state(STATE_PRESERVED_PROP,
		                                linedata[i]);

		/* write level into level array if we still have space */
		if (level != -1 || skipignored == false) {
			if (levlen <= levsize) {
				set_level(lev, levlen, level);
			}
			levlen++;
		}

		if (level == -1) {
			/* ignored character */
			continue;
		}

		if (prop == BIDI_PROP_WS || prop == BIDI_PROP_FSI ||
		    prop == BIDI_PROP_LRI || prop == BIDI_PROP_RLI ||
		    prop == BIDI_PROP_PDI) {
			if (runsince == SIZE_MAX) {
				/* a new run has begun */
				runsince = levlen - 1; /* levlen > 0 */
				runlevel = (int_least8_t)get_state(
					STATE_PARAGRAPH_LEVEL, linedata[i]);
			}
		} else {
			/* sequence ended */
			runsince = SIZE_MAX;
			runlevel = -1;
		}
	}
	if (runsince != SIZE_MAX) {
		/*
		 * we hit the end of the line but were in a run;
		 * reset the line levels to the paragraph level
		 */
		for (i = runsince; i < MIN(linelen, levlen); i++) {
			if (get_level(lev, i) != -1) {
				set_level(lev, i, runlevel);
			}
		}
	}

	return levlen;
}

static inline int_least8_t
get_level_int8(const void *lev, size_t off)
{
	return ((const int_least8_t *)lev)[off];
}

static inline void
set_level_int8(void *lev, size_t off, int_least8_t value)
{
	((int_least8_t *)lev)[off] = value;
}

size_t
grapheme_bidirectional_get_line_embedding_levels(const uint_least32_t *linedata,
                                                 size_t linelen,
                                                 int_least8_t *lev,
                                                 size_t levlen)
{
	return get_line_embedding_levels(linedata, linelen, get_level_int8,
	                                 set_level_int8, lev, levlen, false);
}

static inline int_least8_t
get_level_uint32(const void *lev, size_t off)
{
	return (int_least8_t)((((const uint_least32_t *)lev)[off] &
	                       UINT32_C(0x1FE00000)) >>
	                      21) -
	       1;
}

static inline void
set_level_uint32(void *lev, size_t off, int_least8_t value)
{
	((uint_least32_t *)lev)[off] ^=
		((uint_least32_t *)lev)[off] & UINT32_C(0x1FE00000);
	((uint_least32_t *)lev)[off] |= ((uint_least32_t)(value + 1)) << 21;
}

static inline int_least16_t
get_mirror_offset(uint_least32_t cp)
{
	if (cp <= UINT32_C(0x10FFFF)) {
		return mirror_minor[mirror_major[cp >> 8] + (cp & 0xFF)];
	} else {
		return 0;
	}
}

size_t
grapheme_bidirectional_reorder_line(const uint_least32_t *line,
                                    const uint_least32_t *linedata,
                                    size_t linelen, uint_least32_t *output,
                                    size_t outputsize)
{
	size_t i, outputlen, first, last, j, k, l /*, laststart*/;
	int_least8_t level, min_odd_level = MAX_DEPTH + 2, max_level = 0;
	uint_least32_t tmp;

	/* write output characters (and apply possible mirroring) */
	for (i = 0, outputlen = 0; i < linelen; i++) {
		if (get_state(STATE_LEVEL, linedata[i]) != -1) {
			if (outputlen < outputsize) {
				output[outputlen] =
					(uint_least32_t)((int_least32_t)
				                                 line[i] +
				                         get_mirror_offset(
								 line[i]));
			}
			outputlen++;
		}
	}
	if (outputlen >= outputsize) {
		/* clear output buffer */
		for (i = 0; i < outputsize; i++) {
			output[i] = GRAPHEME_INVALID_CODEPOINT;
		}

		/* return required size */
		return outputlen;
	}

	/*
	 * write line embedding levels as metadata and codepoints into the
	 * output
	 */
	get_line_embedding_levels(linedata, linelen, get_level_uint32,
	                          set_level_uint32, output, outputsize, true);

	/* determine level range */
	for (i = 0; i < outputlen; i++) {
		level = get_level_uint32(output, i);

		if (level == -1) {
			/* ignored character */
			continue;
		}

		if (level % 2 == 1 && level < min_odd_level) {
			min_odd_level = level;
		}
		if (level > max_level) {
			max_level = level;
		}
	}

	for (level = max_level; level >= min_odd_level /* > 0 */; level--) {
		for (i = 0; i < outputlen; i++) {
			if (get_level_uint32(output, i) >= level) {
				/*
				 * the current character has the desired level
				 */
				first = last = i;

				/* find the end of the level-sequence */
				for (i++; i < outputlen; i++) {
					if (get_level_uint32(output, i) >=
					    level) {
						/* the sequence continues */
						last = i;
					} else {
						break;
					}
				}

				/* invert the sequence first..last respecting
				 * grapheme clusters
				 *
				 * The standard only speaks of combining marks
				 * inversion, but we should in the perfect case
				 * respect _all_ grapheme clusters, which we do
				 * here!
				 */

				/* mark grapheme cluster breaks */
				for (j = first; j <= last;
				     j += grapheme_next_character_break(
					     line + j, outputlen - j)) {
					/*
					 * we use a special trick here: The
					 * first 21 bits of the state are filled
					 * with the codepoint, the next 8 bits
					 * are used for the level, so we can use
					 * the 30th bit to mark the grapheme
					 * cluster breaks. This allows us to
					 * reinvert the grapheme clusters into
					 * the proper direction later.
					 */
					output[j] |= UINT32_C(1) << 29;
				}

				/* global inversion */
				for (k = first, l = last; k < l; k++, l--) {
					/* swap */
					tmp = output[k];
					output[k] = output[l];
					output[l] = tmp;
				}

				/* grapheme cluster reinversion */
#if 0
				for (j = first, laststart = first; j <= last;
				     j++) {
					if (output[j] & (UINT32_C(1) << 29)) {
						/* we hit a mark! given the
						 * grapheme cluster is inverted,
						 * this means that the cluster
						 * ended and we now reinvert it
						 * again
						 */
						for (k = laststart, l = j;
						     k < l; k++, l--) {
							/* swap */
							tmp = output[k];
							output[k] = output[l];
							output[l] = tmp;
						}
						laststart = j + 1;
					}
				}
#endif

				/* unmark grapheme cluster breaks */
				for (j = first; j <= last; j++) {
					output[j] ^= output[j] &
					             UINT32_C(0x20000000);
				}
			}
		}
	}

	/* remove embedding level metadata */
	for (i = 0; i < outputlen; i++) {
		output[i] ^= output[i] & UINT32_C(0x1FE00000);
	}

	return outputlen;
}
