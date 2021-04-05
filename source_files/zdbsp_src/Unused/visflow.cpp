// An adaptation of the Quake vis utility.

#include <string.h>
#include <stdio.h>

#include "zdbsp.h"
#include "nodebuild.h"
#include "rejectbuilder.h"
#include "templates.h"

enum { SIDE_FRONT, SIDE_BACK, SIDE_ON };

/*

  each portal will have a list of all possible to see from first portal

  if (!thread->portalmightsee[portalnum])

  portal mightsee

  for p2 = all other portals in leaf
	get sperating planes
	for all portals that might be seen by p2
		mark as unseen if not present in seperating plane
	flood fill a new mightsee
	save as passagemightsee


  void CalcMightSee (leaf_t *leaf, 
*/

int FRejectBuilder::CountBits (BYTE *bits, int numbits)
{
	int		i;
	int		c;

	c = 0;
	for (i=0 ; i<numbits ; i++)
		if (bits[i>>3] & (1<<(i&7)) )
			c++;

	return c;
}

int		c_fullskip;
int		c_portalskip, c_leafskip;
int		c_vistest, c_mighttest;

int		c_chop, c_nochop;

int		active;

void FRejectBuilder::CheckStack (FLeaf *leaf, FThreadData *thread)
{
	PStack *p, *p2;

	for (p = thread->pstack_head.next; p != NULL; p = p->next)
	{
//		_printf ("=");
		if (p->leaf == leaf)
			throw exception("CheckStack: leaf recursion");
		for (p2 = thread->pstack_head.next; p2 != p; p2 = p2->next)
			if (p2->leaf == p->leaf)
				throw exception("CheckStack: late leaf recursion");
	}
//	_printf ("\n");
}


FRejectBuilder::FWinding *FRejectBuilder::AllocStackWinding (PStack *stack) const
{
	for (int i = 0; i < 3; i++)
	{
		if (stack->freewindings[i])
		{
			stack->freewindings[i] = false;
			return &stack->windings[i];
		}
	}

	throw exception("AllocStackWinding: failed");
}

void FRejectBuilder::FreeStackWinding (FWinding *w, PStack *stack) const
{
	int i;

	i = w - stack->windings;

	if (i < 0 || i > 2)
		return;		// not from local

	if (stack->freewindings[i])
		throw exception("FreeStackWinding: already free");
	stack->freewindings[i] = true;
}

/*
==============
VisChopWinding

==============
*/
FRejectBuilder::FWinding *FRejectBuilder::VisChopWinding (FWinding *in, PStack *stack, FLine *split)
{
	int			side1, side2;
	FPoint		mid;
	FWinding	*neww;

	// determine sides for each point
	side1 = PointOnSide (in->points[0], *split);
	side2 = PointOnSide (in->points[1], *split);

	if (side1 <= 0 && side2 <= 0)
	{ // completely on front side
		return in;
	}

	if (side1 >= 0 && side2 >= 0)
	{ // completely on back side
		FreeStackWinding (in, stack);
		return NULL;
	}

	neww = AllocStackWinding (stack);

	// generate a split point
	double v2x = (double)in->points[0].x;
	double v2y = (double)in->points[0].y;
	double v2dx = (double)in->points[1].x - v2x;
	double v2dy = (double)in->points[1].y - v2y;
	double v1dx = (double)split->dx;
	double v1dy = (double)split->dy;

	double den = v1dy*v2dx - v1dx*v2dy;

	if (den == 0.0)
	{ // parallel
		return in;
	}

	double v1x = (double)split->x;
	double v1y = (double)split->y;

	double num = (v1x - v2x)*v1dy + (v2y - v1y)*v1dx;
	double frac = num / den;

	mid.x = in->points[0].x + fixed_t(v2dx * frac);
	mid.y = in->points[0].y + fixed_t(v2dy * frac);

	if (side1 <= 0)
	{
		neww->points[0] = in->points[0];
		neww->points[1] = mid;
	}
	else
	{
		neww->points[0] = mid;
		neww->points[1] = in->points[1];
	}
	
	// free the original winding
	FreeStackWinding (in, stack);
	
	return neww;
}

/*
==============
ClipToSeperators

Source, pass, and target are an ordering of portals.

Generates seperating planes canidates by taking two points from source and one
point from pass, and clips target by them.

If target is totally clipped away, that portal can not be seen through.

Normal clip keeps target on the same side as pass, which is correct if the
order goes source, pass, target.  If the order goes pass, source, target then
flipclip should be set.
==============
*/
FRejectBuilder::FWinding *FRejectBuilder::ClipToSeperators
	(FWinding *source, FWinding *pass, FWinding *target, bool flipclip, PStack *stack)
{
	int			i, j;
	FLine		line;
	int			d;
	bool		fliptest;

	// check all combinations	
	for (i = 0; i < 2; i++)
	{
		// find a vertex of pass that makes a line that puts all of the
		// vertexes of pass on the front side and all of the vertexes of
		// source on the back side
		for (j = 0; j < 2; j++)
		{
			line.x = source->points[i].x;
			line.y = source->points[i].y;
			line.dx = pass->points[j].x - line.x;
			line.dy = pass->points[j].y - line.y;

			//
			// find out which side of the generated seperating line has the
			// source portal
			//
			fliptest = false;
			d = PointOnSide (source->points[!i], line);
			if (d > 0)
			{ // source is on the back side, so we want all
			  // pass and target on the front side
				fliptest = false;
			}
			else if (d < 0)
			{ // source in on the front side, so we want all
			  // pass and target on the back side
				fliptest = true;
			}
			else
			{ // colinear with source portal
				continue;
			}

			//
			// flip the line if the source portal is backwards
			//
			if (fliptest)
			{
				line.Flip ();
			}

			//
			// if all of the pass portal points are now on the front side,
			// this is the seperating line
			//
			d = PointOnSide (pass->points[!j], line);
			if (d >= 0)
			{ // == 0: colinear with seperating plane
			  //  > 0: points on back side; not a seperating plane
				continue;
			}

			//
			// flip the line if we want the back side
			//
			if (flipclip)
			{
				line.Flip ();
			}

#ifdef SEPERATORCACHE
			stack->seperators[flipclip][stack->numseperators[flipclip]] = line;
			if (++stack->numseperators[flipclip] >= MAX_SEPERATORS)
				throw exception("MAX_SEPERATORS");
#endif

			//
			// clip target by the seperating plane
			//
			target = VisChopWinding (target, stack, &line);
			if (!target)
			{ // target is not visible
				return NULL;
			}

			break;		// optimization by Antony Suter
		}
	}
	
	return target;
}

/*
==================
RecursiveLeafFlow

Flood fill through the leafs
If src_portal is NULL, this is the originating leaf
==================
*/
void FRejectBuilder::RecursiveLeafFlow (int leafnum, FThreadData *thread, PStack *prevstack)
{
	PStack		stack;
	VPortal		*p;
	FLine		backline;
	FLeaf		*leaf;
	int			i, j;
	long		*test, *might, *prevmight, *vis, more;
	int			pnum;

	thread->c_chains++;

	leaf = &leafs[leafnum];
//	CheckStack (leaf, thread);

	prevstack->next = &stack;

	stack.next = NULL;
	stack.leaf = leaf;
	stack.portal = NULL;
	stack.depth = prevstack->depth + 1;

#ifdef SEPERATORCACHE
	stack.numseperators[0] = 0;
	stack.numseperators[1] = 0;
#endif

	might = (long *)stack.mightsee;
	vis = (long *)thread->base->portalvis;
	
	// check all portals for flowing into other leafs	
	for (i = 0; i < leaf->numportals; i++)
	{
		p = leaf->portals[i];
		if (p->removed)
			continue;
		pnum = p - portals;

		/* MrE: portal trace debug code
		{
			int portaltrace[] = {13, 16, 17, 37};
			pstack_t *s;

			s = &thread->pstack_head;
			for (j = 0; s->next && j < sizeof(portaltrace)/sizeof(int) - 1; j++, s = s->next)
			{
				if (s->portal->num != portaltrace[j])
					break;
			}
			if (j >= sizeof(portaltrace)/sizeof(int) - 1)
			{
				if (p->num == portaltrace[j])
					n = 0; //traced through all the portals
			}
		}
		*/

		if ( ! (prevstack->mightsee[pnum >> 3] & (1<<(pnum&7)) ) )
		{
			continue;	// can't possibly see it
		}

		// if the portal can't see anything we haven't already seen, skip it
		if (p->status == STAT_Done)
		{
			test = (long *)p->portalvis;
		}
		else
		{
			test = (long *)p->portalflood;
		}

		more = 0;
		prevmight = (long *)prevstack->mightsee;
		for (j = 0; j < portallongs; j++)
		{
			might[j] = prevmight[j] & test[j];
			more |= (might[j] & ~vis[j]);
		}
		
		if (!more && 
			(thread->base->portalvis[pnum>>3] & (1<<(pnum&7))) )
		{	// can't see anything new
			continue;
		}

		// get line of portal and point into the neighbor leaf
		backline = stack.portalline = p->line;
		backline.Flip ();
		
//		c_portalcheck++;
		
		stack.portal = p;
		stack.next = NULL;
		stack.freewindings[0] = true;
		stack.freewindings[1] = true;
		stack.freewindings[2] = true;

		stack.pass = VisChopWinding (&p->winding, &stack, &thread->pstack_head.portalline);
		if (!stack.pass)
		{
			continue;
		}

		stack.source = VisChopWinding (prevstack->source, &stack, &backline);
		if (!stack.source)
		{
			continue;
		}

		if (!prevstack->pass)
		{	// the second leaf can only be blocked if coplanar

			// mark the portal as visible
			thread->base->portalvis[pnum>>3] |= (1<<(pnum&7));

			RecursiveLeafFlow (p->leaf, thread, &stack);
			continue;
		}

#ifdef SEPERATORCACHE
		if (stack.numseperators[0])
		{
			for (n = 0; n < stack.numseperators[0]; n++)
			{
				stack.pass = VisChopWinding (stack.pass, &stack, &stack.seperators[0][n]);
				if (!stack.pass)
					break;		// target is not visible
			}
			if (n < stack.numseperators[0])
				continue;
		}
		else
		{
			stack.pass = ClipToSeperators (prevstack->source, prevstack->pass, stack.pass, false, &stack);
		}
#else
		stack.pass = ClipToSeperators (stack.source, prevstack->pass, stack.pass, false, &stack);
#endif
		if (!stack.pass)
			continue;

#ifdef SEPERATORCACHE
		if (stack.numseperators[1])
		{
			for (n = 0; n < stack.numseperators[1]; n++)
			{
				stack.pass = VisChopWinding (stack.pass, &stack, &stack.seperators[1][n]);
				if (!stack.pass)
					break;		// target is not visible
			}
		}
		else
		{
			stack.pass = ClipToSeperators (prevstack->pass, prevstack->source, stack.pass, true, &stack);
		}
#else
		stack.pass = ClipToSeperators (prevstack->pass, stack.source, stack.pass, true, &stack);
#endif
		if (!stack.pass)
			continue;

		// mark the portal as visible
		thread->base->portalvis[pnum>>3] |= (1<<(pnum&7));

		// flow through it for real
		RecursiveLeafFlow (p->leaf, thread, &stack);
		//
		stack.next = NULL;
	}	
}

/*
===============
PortalFlow

generates the portalvis bit vector
===============
*/
void FRejectBuilder::PortalFlow (int portalnum)
{
	FThreadData		data;
	int				i;
	VPortal			*p;
	int				c_might, c_can;

#ifdef MREDEBUG
	printf("\r%6d", portalnum);
#endif

	p = sorted_portals[portalnum];

	if (p->removed)
	{
		p->status = STAT_Done;
		return;
	}

	if (p->nummightsee == 0)
	{
		p->status = STAT_Done;
		return;
	}

	p->status = STAT_Working;

	c_might = p->nummightsee;//CountBits (p->portalflood, numportals);

	memset (&data, 0, sizeof(data));
	data.base = p;
	
	data.pstack_head.portal = p;
	data.pstack_head.source = &p->winding;
	data.pstack_head.portalline = p->line;
	data.pstack_head.depth = 0;
	for (i = 0; i < portallongs; i++)
	{
		((long *)data.pstack_head.mightsee)[i] = ((long *)p->portalflood)[i];
	}

	RecursiveLeafFlow (p->leaf, &data, &data.pstack_head);

	p->status = STAT_Done;

	c_can = CountBits (p->portalvis, numportals);

	//printf ("portal:%4i  mightsee:%4i  cansee:%4i (%i chains)\n", 
	//	(int)(p - portals),	c_might, c_can, data.c_chains);
}

/*
==================
RecursivePassageFlow
==================
*/
void FRejectBuilder::RecursivePassageFlow (VPortal *portal, FThreadData *thread, PStack *prevstack)
{
	PStack		stack;
	VPortal		*p;
	FLeaf 		*leaf;
	FPassage	*passage, *nextpassage;
	int			i, j;
	long		*might, *vis, *prevmight, *cansee, *portalvis, more;
	int			pnum;

//	thread->c_chains++;

	leaf = &leafs[portal->leaf];
//	CheckStack (leaf, thread);

	prevstack->next = &stack;

	stack.next = NULL;
//	stack.leaf = leaf;
//	stack.portal = NULL;
	stack.depth = prevstack->depth + 1;

	vis = (long *)thread->base->portalvis;

	passage = portal->passages;
	nextpassage = passage;
	// check all portals for flowing into other leafs	
	for (i = 0; i < leaf->numportals; i++, passage = nextpassage)
	{
		p = leaf->portals[i];
		if (p->removed)
			continue;
		nextpassage = passage->next;
		pnum = p - portals;

		if ( ! (prevstack->mightsee[pnum >> 3] & (1<<(pnum&7)) ) )
			continue;	// can't possibly see it

		prevmight = (long *)prevstack->mightsee;
		cansee = (long *)passage->cansee;
		might = (long *)stack.mightsee;
		memcpy(might, prevmight, portalbytes);
		portalvis = (p->status == STAT_Done) ? (long *)p->portalvis : (long *)p->portalflood;
		more = 0;
		for (j = 0; j < portallongs; j++)
		{
			if (*might)
			{
				*might &= *cansee++ & *portalvis++;
				more |= (*might & ~vis[j]);
			}
			else
			{
				cansee++;
				portalvis++;
			}
			might++;
		}

		if (!more &&
			(thread->base->portalvis[pnum>>3] & (1<<(pnum&7))) )
		{	// can't see anything new
			continue;
		}

//		stack.portal = p;
		// mark the portal as visible
		thread->base->portalvis[pnum>>3] |= (1<<(pnum&7));
		// flow through it for real
		RecursivePassageFlow(p, thread, &stack);
		//
		stack.next = NULL;
	}
}

/*
===============
PassageFlow
===============
*/
void FRejectBuilder::PassageFlow (int portalnum)
{
	FThreadData		data;
	int				i;
	VPortal			*p;
//	int				c_might, c_can;

#ifdef MREDEBUG
	printf("\r%6d", portalnum);
#endif

	p = sorted_portals[portalnum];

	if (p->removed)
	{
		p->status = STAT_Done;
		return;
	}

	p->status = STAT_Working;

//	c_might = CountBits (p->portalflood, numportals);

	memset (&data, 0, sizeof(data));
	data.base = p;
	
	data.pstack_head.portal = p;
	data.pstack_head.source = &p->winding;
	data.pstack_head.portalline = p->line;
	data.pstack_head.depth = 0;
	for (i = 0; i < portallongs; i++)
	{
		((long *)data.pstack_head.mightsee)[i] = ((long *)p->portalflood)[i];
	}

	RecursivePassageFlow (p, &data, &data.pstack_head);

	p->status = STAT_Done;

	/*
	c_can = CountBits (p->portalvis, numportals);

	qprintf ("portal:%4i  mightsee:%4i  cansee:%4i (%i chains)\n", 
		(int)(p - portals),	c_might, c_can, data.c_chains);
	*/
}

/*
==================
RecursivePassagePortalFlow
==================
*/
void FRejectBuilder::RecursivePassagePortalFlow (VPortal *portal, FThreadData *thread, PStack *prevstack)
{
	PStack		stack;
	VPortal		*p;
	FLeaf 		*leaf;
	FLine		backline;
	FPassage	*passage, *nextpassage;
	int			i, j;
	long		*might, *vis, *prevmight, *cansee, *portalvis, more;
	int			pnum;

//	thread->c_chains++;

	leaf = &leafs[portal->leaf];
//	CheckStack (leaf, thread);

	prevstack->next = &stack;

	stack.next = NULL;
	stack.leaf = leaf;
	stack.portal = NULL;
	stack.depth = prevstack->depth + 1;

#ifdef SEPERATORCACHE
	stack.numseperators[0] = 0;
	stack.numseperators[1] = 0;
#endif

	vis = (long *)thread->base->portalvis;

	passage = portal->passages;
	nextpassage = passage;
	// check all portals for flowing into other leafs	
	for (i = 0; i < leaf->numportals; i++, passage = nextpassage)
	{
		p = leaf->portals[i];
		if (p->removed)
			continue;
		nextpassage = passage->next;
		pnum = p - portals;

		if ( ! (prevstack->mightsee[pnum >> 3] & (1<<(pnum&7)) ) )
			continue;	// can't possibly see it

		prevmight = (long *)prevstack->mightsee;
		cansee = (long *)passage->cansee;
		might = (long *)stack.mightsee;
		memcpy(might, prevmight, portalbytes);
		portalvis = (p->status == STAT_Done) ? (long *) p->portalvis : (long *) p->portalflood;
		more = 0;
		for (j = 0; j < portallongs; j++)
		{
			if (*might)
			{
				*might &= *cansee++ & *portalvis++;
				more |= (*might & ~vis[j]);
			}
			else
			{
				cansee++;
				portalvis++;
			}
			might++;
		}

		if (!more &&
			(thread->base->portalvis[pnum>>3] & (1<<(pnum&7))) )
		{	// can't see anything new
			continue;
		}

		// get line of portal, point front into the neighbor leaf
		backline = stack.portalline = p->line;
		backline.Flip ();
		
//		c_portalcheck++;
		
		stack.portal = p;
		stack.next = NULL;
		stack.freewindings[0] = true;
		stack.freewindings[1] = true;
		stack.freewindings[2] = true;

		stack.pass = VisChopWinding (&p->winding, &stack, &thread->pstack_head.portalline);
		if (!stack.pass)
			continue;

		stack.source = VisChopWinding (prevstack->source, &stack, &backline);
		if (!stack.source)
			continue;

		if (!prevstack->pass)
		{	// the second leaf can only be blocked if colinear

			// mark the portal as visible
			thread->base->portalvis[pnum>>3] |= (1<<(pnum&7));

			RecursivePassagePortalFlow (p, thread, &stack);
			continue;
		}

#ifdef SEPERATORCACHE
		if (stack.numseperators[0])
		{
			for (n = 0; n < stack.numseperators[0]; n++)
			{
				stack.pass = VisChopWinding (stack.pass, &stack, &stack.seperators[0][n]);
				if (!stack.pass)
					break;		// target is not visible
			}
			if (n < stack.numseperators[0])
				continue;
		}
		else
		{
			stack.pass = ClipToSeperators (prevstack->source, prevstack->pass, stack.pass, false, &stack);
		}
#else
		stack.pass = ClipToSeperators (stack.source, prevstack->pass, stack.pass, false, &stack);
#endif
		if (!stack.pass)
			continue;

#ifdef SEPERATORCACHE
		if (stack.numseperators[1])
		{
			for (n = 0; n < stack.numseperators[1]; n++)
			{
				stack.pass = VisChopWinding (stack.pass, &stack, &stack.seperators[1][n]);
				if (!stack.pass)
					break;		// target is not visible
			}
		}
		else
		{
			stack.pass = ClipToSeperators (prevstack->pass, prevstack->source, stack.pass, true, &stack);
		}
#else
		stack.pass = ClipToSeperators (prevstack->pass, stack.source, stack.pass, true, &stack);
#endif
		if (!stack.pass)
			continue;

		// mark the portal as visible
		thread->base->portalvis[pnum>>3] |= (1<<(pnum&7));
		// flow through it for real
		RecursivePassagePortalFlow(p, thread, &stack);
		//
		stack.next = NULL;
	}
}

/*
===============
PassagePortalFlow
===============
*/
void FRejectBuilder::PassagePortalFlow (int portalnum)
{
	FThreadData		data;
	int				i;
	VPortal			*p;
//	int				c_might, c_can;

#ifdef MREDEBUG
	printf("\r%6d", portalnum);
#endif

	p = sorted_portals[portalnum];

	if (p->removed)
	{
		p->status = STAT_Done;
		return;
	}

	p->status = STAT_Working;

//	c_might = CountBits (p->portalflood, numportals);

	memset (&data, 0, sizeof(data));
	data.base = p;
	
	data.pstack_head.portal = p;
	data.pstack_head.source = &p->winding;
	data.pstack_head.portalline = p->line;
	data.pstack_head.depth = 0;
	for (i = 0; i < portallongs; i++)
	{
		((long *)data.pstack_head.mightsee)[i] = ((long *)p->portalflood)[i];
	}

	RecursivePassagePortalFlow (p, &data, &data.pstack_head);

	p->status = STAT_Done;

	/*
	c_can = CountBits (p->portalvis, numportals);

	qprintf ("portal:%4i  mightsee:%4i  cansee:%4i (%i chains)\n", 
		(int)(p - portals),	c_might, c_can, data.c_chains);
	*/
}

FRejectBuilder::FWinding *FRejectBuilder::PassageChopWinding (FWinding *in, FWinding *out, FLine *split)
{
	int		side1, side2;
	FPoint	mid;
	FWinding	*neww;

	// determine sides for each point
	side1 = PointOnSide (in->points[0], *split);
	side2 = PointOnSide (in->points[1], *split);

	if (side1 <= 0 && side2 <= 0)
	{ // completely on front side
		return in;
	}

	if (side1 >= 0 && side2 >= 0)
	{ // completely on back side
		return NULL;
	}

	neww = out;

	// generate a split point
	double v2x = (double)in->points[0].x;
	double v2y = (double)in->points[0].y;
	double v2dx = (double)in->points[1].x - v2x;
	double v2dy = (double)in->points[1].y - v2y;
	double v1dx = (double)split->dx;
	double v1dy = (double)split->dy;

	double den = v1dy*v2dx - v1dx*v2dy;

	if (den == 0.0)
	{ // parallel
		return in;
	}

	double v1x = (double)split->x;
	double v1y = (double)split->y;

	double num = (v1x - v2x)*v1dy + (v2y - v1y)*v1dx;
	double frac = num / den;

	mid.x = in->points[0].x + fixed_t(v2dx * frac);
	mid.y = in->points[0].y + fixed_t(v2dy * frac);

	if (side1 <= 0)
	{
		neww->points[0] = in->points[0];
		neww->points[1] = mid;
	}
	else
	{
		neww->points[0] = mid;
		neww->points[1] = in->points[1];
	}
	
	return neww;
}

/*
===============
AddSeperators
===============
*/
int FRejectBuilder::AddSeperators (FWinding *source, FWinding *pass, bool flipclip,
								   FLine *seperators, int maxseperators)
{
	int			i, j;
	FLine		line;
	int			d;
	int			numseperators;
	bool		fliptest;

	numseperators = 0;
	// check all combinations	
	for (i = 0; i < 2; i++)
	{
		// find a vertex of pass that makes a plane that puts all of the
		// vertexes of pass on the front side and all of the vertexes of
		// source on the back side
		for (j = 0; j < 2; j++)
		{
			line.x = source->points[i].x;
			line.y = source->points[i].y;
			line.dx = pass->points[j].x - line.x;
			line.dy = pass->points[j].y - line.y;

			//
			// find out which side of the generated seperating plane has the
			// source portal
			//
			fliptest = false;
			d = PointOnSide (source->points[!i], line);
			if (d > 0)
			{ // source is on the back side, so we want all
			  // pass and target on the front side
				fliptest = false;
			}
			else if (d < 0)
			{ // source in on the front side, so we want all
			  // pass and target on the back side
				fliptest = true;
			}
			else
			{ // colinear with source portal
				continue;
			}

			//
			// flip the line if the source portal is backwards
			//
			if (fliptest)
			{
				line.Flip ();
			}

			//
			// if all of the pass portal points are now on the positive side,
			// this is the seperating plane
			//
			d = PointOnSide (pass->points[!j], line);
			if (d >= 0)
			{ // == 0: colinear with seperating plane
			  //  > 0: points on back side; not a seperating plane
				continue;
			}

			//
			// flip the line if we want the back side
			//
			if (flipclip)
			{
				line.Flip ();
			}

			if (numseperators >= maxseperators)
				throw exception("max seperators");
			seperators[numseperators] = line;
			numseperators++;
			break;
		}
	}
	return numseperators;
}

/*
===============
CreatePassages

MrE: create passages from one portal to all the portals in the leaf the portal leads to
	 every passage has a cansee bit string with all the portals that can be
	 seen through the passage
===============
*/
void FRejectBuilder::CreatePassages (int portalnum)
{
	int i, j, k, numseperators, numsee;
	VPortal *portal, *p, *target;
	FLeaf *leaf;
	FPassage	*passage, *lastpassage;
	FLine seperators[MAX_SEPERATORS*2];
	FWinding in, out, *res;

#ifdef MREDEBUG
	printf("\r%6d", portalnum);
#endif

	portal = sorted_portals[portalnum];

	if (portal->removed)
	{
		portal->status = STAT_Done;
		return;
	}

	lastpassage = NULL;
	leaf = &leafs[portal->leaf];
	for (i = 0; i < leaf->numportals; i++)
	{
		target = leaf->portals[i];
		if (target->removed)
			continue;

		passage = (FPassage *) malloc(sizeof(FPassage) + portalbytes);
		memset(passage, 0, sizeof(FPassage) + portalbytes);
		numseperators = AddSeperators(&portal->winding, &target->winding, false, seperators, MAX_SEPERATORS*2);
		numseperators += AddSeperators(&target->winding, &portal->winding, true, &seperators[numseperators], MAX_SEPERATORS*2-numseperators);

		passage->next = NULL;
		if (lastpassage)
			lastpassage->next = passage;
		else
			portal->passages = passage;
		lastpassage = passage;

		numsee = 0;
		//create the passage->cansee
		for (j = 0; j < numportals; j++)
		{
			p = &portals[j];
			if (p->removed)
				continue;
			if ( ! (target->portalflood[j >> 3] & (1<<(j&7)) ) )
				continue;
			if ( ! (portal->portalflood[j >> 3] & (1<<(j&7)) ) )
				continue;
			for (k = 0; k < numseperators; k++)
			{
				//check if completely on the back of the seperator line
				if (PointOnSide (p->line, seperators[k]) > 0)
				{
					FPoint pt2 = p->line;
					pt2.x += p->line.dx;
					pt2.y += p->line.dy;
					if (PointOnSide (pt2, seperators[k]) > 0)
					{
						break;
					}
				}
			}
			if (k < numseperators)
			{
				continue;
			}
			memcpy(&in, &p->winding, sizeof(FWinding));
			for (k = 0; k < numseperators; k++)
			{
				res = PassageChopWinding(&in, &out, &seperators[k]);
				if (res == &out)
					memcpy(&in, &out, sizeof(FWinding));
				if (res == NULL)
					break;
			}
			if (k < numseperators)
				continue;
			passage->cansee[j >> 3] |= (1<<(j&7));
			numsee++;
		}
	}
}

void FRejectBuilder::PassageMemory ()
{
	int i, j, totalmem, totalportals;
	VPortal *portal, *target;
	FLeaf *leaf;

	totalmem = 0;
	totalportals = 0;
	for (i = 0; i < numportals; i++)
	{
		portal = sorted_portals[i];
		if (portal->removed)
			continue;
		leaf = &leafs[portal->leaf];
		for (j = 0; j < leaf->numportals; j++)
		{
			target = leaf->portals[j];
			if (target->removed)
				continue;
			totalmem += sizeof(FPassage) + portalbytes;
			totalportals++;
		}
	}
	printf("\n%7i average number of passages per leaf\n", totalportals / numportals);
	printf("%7i MB required passage memory\n", totalmem >> 10 >> 10);
}

/*
===============================================================================

This is a rough first-order aproximation that is used to trivially reject some
of the final calculations.


Calculates portalfront and portalflood bit vectors

thinking about:

typedef struct passage_s
{
	struct passage_s	*next;
	struct portal_s		*to;
	struct sep_s		*seperators;
	byte				*mightsee;
} passage_t;

typedef struct portal_s
{
	struct passage_s	*passages;
	int					leaf;		// leaf portal faces into
} portal_s;

leaf = portal->leaf
clear 
for all portals


calc portal visibility
	clear bit vector
	for all passages
		passage visibility


for a portal to be visible to a passage, it must be on the front of
all seperating planes, and both portals must be behind the new portal

===============================================================================
*/

int		c_flood, c_vis;


/*
==================
SimpleFlood

==================
*/
void FRejectBuilder::SimpleFlood (VPortal *srcportal, int leafnum)
{
	int		i;
	FLeaf	*leaf;
	VPortal	*p;
	int		pnum;

	leaf = &leafs[leafnum];
	
	for (i = 0; i < leaf->numportals; i++)
	{
		p = leaf->portals[i];
		if (p->removed)
			continue;
		pnum = p - portals;
		if ((srcportal->portalfront[pnum>>3] & (1<<(pnum&7))) &&
			!(srcportal->portalflood[pnum>>3] & (1<<(pnum&7))) )
		{
			srcportal->portalflood[pnum>>3] |= (1<<(pnum&7));
			SimpleFlood (srcportal, p->leaf);
		}
	}
}

/*
==============
BasePortalVis
==============
*/
void FRejectBuilder::BasePortalVis (int portalnum)
{
	int			j, p1, p2;
	VPortal		*tp, *p;

	p = portals+portalnum;

	if (p->removed)
		return;

	p->portalfront = new BYTE[portalbytes];
	memset (p->portalfront, 0, portalbytes);

	p->portalflood = new BYTE[portalbytes];
	memset (p->portalflood, 0, portalbytes);
	
	p->portalvis = new BYTE[portalbytes];
	memset (p->portalvis, 0, portalbytes);
	
	for (j = 0, tp = portals; j < numportals; j++, tp++)
	{
		if (j == portalnum)
			continue;
		if (tp->removed)
			continue;

		//p->portalfront[j>>3] |= (1<<(j&7));
		//continue;

		// The target portal must be in front of this one
		if ((p1 = PointOnSide (tp->winding.points[0], p->line)) > 0 ||
			(p2 = PointOnSide (tp->winding.points[1], p->line)) > 0)
		{
			continue;
		}

		// Portals must not be colinear
		if ((p1 | p2) == 0)
		{
			continue;
		}

		// This portal must be behind the target portal
		if (PointOnSide (p->winding.points[0], tp->line) < 0 ||
			PointOnSide (p->winding.points[1], tp->line) < 0)
		{
			continue;
		}

		p->portalfront[j>>3] |= (1<<(j&7));
	}
	
	SimpleFlood (p,  p->leaf);

	p->nummightsee = CountBits (p->portalflood, numportals);
//	_printf ("portal %i: %i mightsee\n", portalnum, p->nummightsee);
	c_flood += p->nummightsee;
}





/*
===============================================================================

This is a second order aproximation 

Calculates portalvis bit vector

WAAAAAAY too slow.

===============================================================================
*/

/*
==================
RecursiveLeafBitFlow

==================
*/
void FRejectBuilder::RecursiveLeafBitFlow (int leafnum, BYTE *mightsee, BYTE *cansee)
{
	VPortal		*p;
	FLeaf 		*leaf;
	int			i, j;
	long		more;
	int			pnum;
	BYTE		newmight[MAX_PORTALS/8];

	leaf = &leafs[leafnum];
	
	// check all portals for flowing into other leafs
	for (i = 0; i < leaf->numportals; i++)
	{
		p = leaf->portals[i];
		if (p->removed)
			continue;
		pnum = p - portals;

		// if some previous portal can't see it, skip
		if (! (mightsee[pnum>>3] & (1<<(pnum&7)) ) )
			continue;

		// if this portal can see some portals we mightsee, recurse
		more = 0;
		for (j = 0; j < portallongs; j++)
		{
			((long *)newmight)[j] = ((long *)mightsee)[j] & ((long *)p->portalflood)[j];
			more |= ((long *)newmight)[j] & ~((long *)cansee)[j];
		}

		if (!more)
			continue;	// can't see anything new

		cansee[pnum>>3] |= (1<<(pnum&7));

		RecursiveLeafBitFlow (p->leaf, newmight, cansee);
	}	
}

/*
==============
BetterPortalVis
==============
*/
void FRejectBuilder::BetterPortalVis (int portalnum)
{
	VPortal *p;

	p = portals+portalnum;

	if (p->removed)
		return;

	RecursiveLeafBitFlow (p->leaf, p->portalflood, p->portalvis);

	// build leaf vis information
	p->nummightsee = CountBits (p->portalvis, numportals);
	c_vis += p->nummightsee;
}


