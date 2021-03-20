// A slight adaptation of Quake's vis utility.

#include "zdbsp.h"
#include "tarray.h"
#include "doomdata.h"

class FRejectBuilder
{
public:
	FRejectBuilder (FLevel &level);
	~FRejectBuilder ();

	BYTE *GetReject ();

private:
	void BuildReject ();
	void LoadPortals ();
	inline const WideVertex *GetVertex (WORD vertnum);
	FLevel &Level;

/* Looky! Stuff from vis.h: */

// seperator caching helps a bit
//#define SEPERATORCACHE

// can't have more seperators than the max number of points on a winding
	static const int MAX_SEPERATORS = 2;
	static const int MAX_PORTALS = 65536*2/3;
	static const int MAX_MAP_LEAFS = 32768;
	static const int MAX_PORTALS_ON_LEAF = MAX_PORTALS;

	struct FPoint
	{
		fixed_t x, y;

		const FPoint &operator= (const WideVertex *other)
		{
			x = other->x;
			y = other->y;
			return *this;
		}
	};

	struct FLine : public FPoint
	{
		fixed_t dx, dy;

		void Flip ()
		{
			x += dx;
			y += dy;
			dx = -dx;
			dy = -dy;
		}
	};

	struct FWinding
	{
		FPoint	points[2];
	};

	struct FPassage
	{
		FPassage	*next;
		BYTE		cansee[1];	//all portals that can be seen through this passage
	};

	enum VStatus
	{
		STAT_None,
		STAT_Working,
		STAT_Done
	};

	struct VPortal
	{
		bool		removed;
		bool		hint;
		FLine		line;	// neighbor is on front/right side
		int			leaf;	// neighbor

		FWinding	winding;
		VStatus		status;
		BYTE		*portalfront;	// [portals], preliminary
		BYTE		*portalflood;	// [portals], intermediate
		BYTE		*portalvis;		// [portals], final

		int			nummightsee;	// bit count on portalflood for sort
		FPassage	*passages;		// there are just as many passages as there
									// are portals in the leaf this portal leads to
	};

	struct FLeaf
	{
		FLeaf ();
		~FLeaf ();

		int			numportals;
		int			merged;
		VPortal		**portals;
	};

	struct PStack
	{
		BYTE		mightsee[MAX_PORTALS/8];		// bit string
		PStack		*next;
		FLeaf		*leaf;
		VPortal		*portal;	// portal exiting
		FWinding	*source;
		FWinding	*pass;

		FWinding	windings[3];	// source, pass, temp in any order
		bool		freewindings[3];

		FLine		portalline;
		int			depth;
	#ifdef SEPERATORCACHE
		FLine		seperators[2][MAX_SEPERATORS];
		int			numseperators[2];
	#endif
	};

	struct FThreadData
	{
		VPortal		*base;
		int			c_chains;
		PStack		pstack_head;
	};

	int			numportals;
	int			portalclusters;

	VPortal		*portals;
	FLeaf		*leafs;

	int			c_portaltest, c_portalpass, c_portalcheck;
	int			c_portalskip, c_leafskip;
	int			c_vistest, c_mighttest;
	int			c_chains;

	int			testlevel;

	BYTE		*uncompressed;

	int		leafbytes, leaflongs;
	int		portalbytes, portallongs;

	int		numVisBytes;
	BYTE	*visBytes;

	int		totalvis;

	void LeafFlow (int leafnum);

	void BasePortalVis (int portalnum);
	void BetterPortalVis (int portalnum);
	void PortalFlow (int portalnum);
	void PassagePortalFlow (int portalnum);
	void CreatePassages (int portalnum);
	void PassageFlow (int portalnum);

	VPortal	*sorted_portals[65536];

	static int CountBits (BYTE *bits, int numbits);

	void SortPortals ();
	static int PComp (const void *a, const void *b);
	int LeafVectorFromPortalVector (BYTE *portalbits, BYTE *leafbits);
	void ClusterMerge (int leafnum);

	void PassageMemory ();
	void CalcFastVis ();
	void CalcVis ();
	void CalcPortalVis ();
	void CalcPassagePortalVis ();

	int CountActivePortals ();

	bool pacifier;
	int workcount;
	int dispatch;
	int oldf;
	int oldcount;

	void RunThreadsOnIndividual (int workcnt, bool showpacifire, void (FRejectBuilder::*func)(int));
	int GetThreadWork ();

	void CheckStack (FLeaf *leaf, FThreadData *thread);

	FWinding *AllocStackWinding (PStack *stack) const;
	void FreeStackWinding (FWinding *w, PStack *stack) const;

	FWinding *VisChopWinding (FWinding *in, PStack *stack, FLine *split);
	FWinding *ClipToSeperators (FWinding *source, FWinding *pass, FWinding *target, bool flipclip, PStack *stack);
	void RecursiveLeafFlow (int leafnum, FThreadData *thread, PStack *prevstack);
	void RecursivePassageFlow (VPortal *portal, FThreadData *thread, PStack *prevstack);
	void RecursivePassagePortalFlow (VPortal *portal, FThreadData *thread, PStack *prevstack);
	FWinding *PassageChopWinding (FWinding *in, FWinding *out, FLine *split);
	int AddSeperators (FWinding *source, FWinding *pass, bool flipclip, FLine *seperators, int maxseperators);
	void SimpleFlood (VPortal *srcportal, int leafnum);
	void RecursiveLeafBitFlow (int leafnum, BYTE *mightsee, BYTE *cansee);

	int PointOnSide (const FPoint &point, const FLine &line);

	bool TryMergeLeaves (int l1num, int l2num);
	void UpdatePortals ();
	void MergeLeaves ();
	FWinding *TryMergeWinding (FWinding *f1, FWinding *f2, const FLine &line);
	void MergeLeafPortals ();
	bool Winding_PlanesConcave (const FWinding *w1, const FWinding *w2, const FLine &line1, const FLine &line2);
};
