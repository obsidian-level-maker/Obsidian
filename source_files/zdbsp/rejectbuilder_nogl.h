#include "doomdata.h"
#include "tarray.h"
#include "zdbsp.h"

class FRejectBuilderNoGL {
    struct FPoint {
        int x, y;
    };

    struct BBox {
        int Bounds[4];

        const int &operator[](int index) const { return Bounds[index]; }
        int &operator()(int index) { return Bounds[index]; }
        void AddPt(int x, int y) {
            if (x < Bounds[LEFT]) Bounds[LEFT] = x;
            if (x > Bounds[RIGHT]) Bounds[RIGHT] = x;
            if (y < Bounds[BOTTOM]) Bounds[BOTTOM] = y;
            if (y > Bounds[TOP]) Bounds[TOP] = y;
        }
        void AddPt(WideVertex vert) {
            AddPt(vert.x >> FRACBITS, vert.y >> FRACBITS);
        }
        void AddPt(FPoint pt) { AddPt(pt.x, pt.y); }
    };

    struct FBlockChain {
        FBlockChain() : Points(0) {}
        ~FBlockChain() {
            if (Points) delete[] Points;
        }

        BBox Bounds;
        FPoint *Points;
        int NumPoints;
        FBlockChain *Next;
    };

    enum { LEFT, TOP, RIGHT, BOTTOM };
    friend struct BBox;

   public:
    FRejectBuilderNoGL(FLevel &level);
    ~FRejectBuilderNoGL();

    BYTE *GetReject();

   private:
    void FindSectorBounds();
    void FindBlockChains();
    void HullSides(const BBox &box1, const BBox &box2, FPoint sides[4]);
    bool ChainBlocks(const FBlockChain *chain, const BBox *hullBounds,
                     const FPoint *hullPts);
    void BuildReject();

    inline int PointOnSide(const FPoint *pt, const FPoint &lpt1,
                           const FPoint &lpt2);

    BBox *SectorBounds;
    BYTE *Reject;

    FLevel &Level;
    int RejectSize;

    FBlockChain *BlockChains;
};
