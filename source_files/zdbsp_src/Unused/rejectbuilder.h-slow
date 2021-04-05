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
	struct Portal
	{
		const MapSubsector *Subsector;
		const WideVertex *Left;
		const WideVertex *Right;
	};
	enum ESegSeeStatus
	{
		MIGHT_SEE,
		CAN_SEE,
		CANNOT_SEE
	};

	void BuildReject ();
	void TracePath (int subsector, const MapSegGL *window);
	void TracePathDeep (const MapSegGL *window);
	inline const WideVertex *GetVertex (WORD vertnum);

	BYTE *SubSeeMatrix;
	WORD *SegSubsectors;
	TArray<Portal> PortalStack;

	FLevel &Level;

	int SourceRow;
	int SourceSeg, SegRow;
};
