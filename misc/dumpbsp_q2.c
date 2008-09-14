/*
 * DUMPBSP3 by Andrew Apted
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "cmdlib.h"
#include "mathlib.h"
#include "bspfile.h"


static int me_verbose = 1;


static const char *VectorStr(float *vec)
{
  static char buffer[256];

  buffer[0] = 0;

  char *pos = buffer;

  int i;
  for (i = 0; i < 3; i++)
  {
    if (i > 0)
      strcat(buffer, " ");

    pos = buffer + strlen(buffer);

    sprintf(pos, "%+7.1f", vec[i]);
  }

  return buffer;
}

static const char *NormalStr(float *vec)
{
  static char buffer[256];

  buffer[0] = 0;

  char *pos = buffer;

  int i;
  for (i = 0; i < 3; i++)
  {
    if (i > 0)
      strcat(buffer, " ");

    pos = buffer + strlen(buffer);

    if (fabs(vec[i]) < 0.0001)
      strcat(pos, " 0    ");
    else if (fabs(fabs(vec[i]) - 1.0) < 0.0001)
      sprintf(pos, "%c1    ", (vec[i] < 0) ? '-' : '+');
    else
      sprintf(pos, "%+2.3f", vec[i]);
  }

  return buffer;
}

static const char *ShortBBoxStr(signed short *vec)
{
  static char buffer[256];

  buffer[0] = 0;

  char *pos = buffer;

  int i;
  for (i = 0; i < 3; i++)
  {
    if (i > 0)
      strcat(buffer, " ");

    pos = buffer + strlen(buffer);

    sprintf(pos, "%+5d", (int)vec[i]);
  }

  return buffer;
}


static const char *PlaneTypeName(int type)
{
  switch (type)
  {
    case PLANE_X: return "PLANE_X";
    case PLANE_Y: return "PLANE_Y";
    case PLANE_Z: return "PLANE_Z";

    case PLANE_ANYX: return "PLANE_ANYX";
    case PLANE_ANYY: return "PLANE_ANYY";
    case PLANE_ANYZ: return "PLANE_ANYZ";

    default: return "????";
  }
}

static const char *PaddedString(const char *name, int max_len)
{
  static char buffer[1024];
  char *pos;

  if (max_len > 1000)
      max_len = 1000;

  pos = buffer;

  *pos++ = '"';

  for (; max_len > 0 && *name; max_len--)
  {
    *pos++ = *name++;
  }

  *pos++ = '"';

  for (; max_len > 0; max_len--)
    *pos++ = ' ';


  *pos = 0;

  return buffer;
}


static void DumpPlanes(void)
{
  int i;

  printf("PLANE COUNT: %d\n\n", numplanes);

  for (i = 0; i < numplanes; i++)
  {
    dplane_t *P = &dplanes[i];

    printf("Plane #%04d : (%s) dist:%+8.1f  %s\n",
           i, NormalStr(P->normal), P->dist, PlaneTypeName(P->type));
  }

  printf("\n------------------------------------------------------------\n\n");
}


static void DumpEntities(void)
{
  dentdata[entdatasize] = 0;

  printf("ENTITY DATA SIZE: %d\n\n", entdatasize);

  printf("%s", dentdata);

  printf("\n------------------------------------------------------------\n\n");
}


static void DumpModels(void)
{
  int i;

  printf("MODEL COUNT: %d\n\n", nummodels);

  for (i = 0; i < nummodels; i++)
  {
    dmodel_t *M = &dmodels[i];

    printf("Model #%04d : firstface:%5d  numfaces: %d\n",
           i, M->firstface, M->numfaces);

    if (me_verbose)
    {
      printf("              mins (%s)\n", VectorStr(M->mins));
      printf("              maxs (%s)\n", VectorStr(M->maxs));
      printf("              orig (%s)\n", VectorStr(M->origin));

      printf("              root node: %d\n", M->headnode);
      printf("\n");
    }
  }

  printf("\n------------------------------------------------------------\n\n");
}


static void DumpVertices(void)
{
  int i;

  printf("VERTEX COUNT: %d\n\n", numvertexes);

  for (i = 0; i < numvertexes; i++)
  {
    dvertex_t *V = &dvertexes[i];

    printf("Vertex #%04d : (%s)\n", i, VectorStr(V->point));
  }

  printf("\n------------------------------------------------------------\n\n");
}


static void DumpEdges(void)
{
  int i;

  printf("EDGE COUNT: %d\n\n", numedges);

  for (i = 0; i < numedges; i++)
  {
    dedge_t *E = &dedges[i];

    dvertex_t *v1 = (E->v[0] < numvertexes) ? &dvertexes[E->v[0]] : NULL;
    dvertex_t *v2 = (E->v[1] < numvertexes) ? &dvertexes[E->v[1]] : NULL;

    printf("Edge #%04d : %04d..%04d ", i, (int)E->v[0], (int)E->v[1]);
    printf("(%s) ",  v1 ? VectorStr(v1->point) : "INVALID!");
    printf("(%s)\n", v2 ? VectorStr(v2->point) : "INVALID!");
  }

  printf("\n------------------------------------------------------------\n\n");
}


static void DumpFaceEdges(dface_t *F)
{
  int k;

  for (k = 0; k < F->numedges; k++)
  {
    int k2 = F->firstedge + k;
    int edge_idx;

    printf("             edge[%d] : ", k);

    if (k2 < 0 || k2 >= numsurfedges)
    {
      printf("BAD SURFEDGE REF! (%d >= %d)\n", k2, numsurfedges);
      continue;
    }

    edge_idx = dsurfedges[k2];

    if (edge_idx == 0 || abs(edge_idx) >= numedges)
    {
      printf("BAD EDGE REF! (%d >= %d)\n", edge_idx, numedges);
      continue;
    }
    else
    {
      dedge_t *edge = &dedges[abs(edge_idx)];

      int v_idx = (edge_idx < 0) ? edge->v[1] : edge->v[0];

      printf("%04d>> %+05d ", k2, edge_idx);

      if (v_idx >= numvertexes)
      {
        printf("BAD VERTEX REF! (%d)\n", v_idx);
        continue;
      }

      printf("from (%s)\n", VectorStr(dvertexes[v_idx].point));
    }
  }
}


static void DumpFaces(void)
{
  int i;

  printf("FACE COUNT: %d\n\n", numfaces);

  for (i = 0; i < numfaces; i++)
  {
    dface_t *F = &dfaces[i];

    printf("Face #%04d : on %s %04d  edges:%2d  tex:%2d  lightofs:%d\n",
           i, F->side ? "back " : "front", F->planenum,
           F->numedges, F->texinfo, F->lightofs);

    if (me_verbose)
    {
      printf("             styles: %02x %02x %02x %02x\n",
             F->styles[0], F->styles[1], F->styles[2], F->styles[3]);

      DumpFaceEdges(F);

      printf("\n");
    }
  }

  printf("\n------------------------------------------------------------\n\n");
}


static void DumpTexInfo(void)
{
  int i;

  printf("TEXINFO COUNT : %d\n\n", numtexinfo);

  for (i = 0; i < numtexinfo; i++)
  {
    texinfo_t *T = &texinfo[i];

    printf("Tex-Info #%04d : flags:0x%04x value:0x%04x %s\n",
           i, T->flags, T->value, T->texture);

    if (me_verbose)
    {
      printf("                 s = (%s) offset:%+1.5f\n",
             NormalStr(T->vecs[0]), T->vecs[0][3]);

      printf("                 t = (%s) offset:%+1.5f\n",
             NormalStr(T->vecs[1]), T->vecs[1][3]);

      printf("\n");
    }
  }

  printf("\n------------------------------------------------------------\n\n");
}


static const char *ContentsName(signed short contents)
{
  static char buffer[64];

  switch (contents)
  {
    case 0: return "EMPTY";
    case CONTENTS_SOLID: return "SOLID";
    case CONTENTS_WATER: return "WATER";
    case CONTENTS_SLIME: return "SLIME";
    case CONTENTS_LAVA:  return "LAVA ";

    default:
      sprintf(buffer, "[%5d]", contents);
      return buffer;
  }
}

static void DumpBrushes(void)
{
  int i, k;

  printf("BRUSH COUNT : %d\n\n", numbrushes);

  for (i = 0; i < numbrushes; i++)
  {
    dbrush_t *B = &dbrushes[i];

    printf("Brush #%04d : contents:%s\n",
           i, ContentsName(B->contents));

    if (B->numsides == 0)
    {
      printf("BAD BRUSH (no sides)\n\n");
      continue;
    }

    for (k = 0; k < B->numsides; k++)
    {
      int k2 = B->firstside + k;
      dbrushside_t *S;

      if (k2 < 0 || k2 >= numbrushsides)
      {
        printf("BAD BRUSHSIDE REF! (%d >= %d)\n", k2, numbrushsides);
        continue;
      }

      S = &dbrushsides[k2];

      printf("             side[%04d] : ", k2);
      
      printf("plane:%04d tex:%d\n", S->planenum, S->texinfo);
    }

    printf("\n");
  }

  printf("\n------------------------------------------------------------\n\n");
}


static void DumpLeafFaces(dleaf_t *L)
{
  int k;

  for (k = 0; k < L->numleaffaces; k++)
  {
    int k2 = L->firstleafface + k;
    int face_idx;

    printf("             face[%d] : ", k);

    if (k2 < 0 || k2 >= numleaffaces)
    {
      printf("BAD MARKSURF REF! (%d >= %d)\n", k2, numleaffaces);
      continue;
    }

    face_idx = (int)dleaffaces[k2];

    if (face_idx >= numfaces)
    {
      printf("BAD FACE REF! (%d >= %d)\n", face_idx, numfaces);
      continue;
    }
    else
    {
      dface_t *F = &dfaces[face_idx];

      printf("%04d>> %04d ", k2, face_idx);

      printf("plane:%04d side:%d\n", F->planenum, F->side);
    }
  }
}

static void DumpLeafBrushes(dleaf_t *L)
{
  int k;

  for (k = 0; k < L->numleafbrushes; k++)
  {
    int k2 = L->firstleafbrush + k;
    int brush_idx;

    if (k2 < 0 || k2 >= numleafbrushes)
    {
      printf("BAD LEAFBRUSH REF! (%d >= %d)\n", k2, numleafbrushes);
      continue;
    }

    brush_idx = (int)dleafbrushes[k2];

    if (brush_idx < 0 || brush_idx >= numbrushes)
    {
      printf("BAD BRUSH REF! (%d >= %d)\n", brush_idx, numbrushes);
      continue;
    }

    printf("             brush %04d [leafbrush:%d]\n", brush_idx, k2);
  }
}

static void DumpLeafs(void)
{
  int i;

  printf("LEAF COUNT: %d\n\n", numleafs);

  for (i = 0; i < numleafs; i++)
  {
    dleaf_t *L = &dleafs[i];

    printf("Leaf #%04d : contents:%s faces:%d cluster:%d area:%d\n",
           i, ContentsName(L->contents), L->numleaffaces,
           L->cluster, L->area);

    if (me_verbose)
    {
      printf("             mins (%s)\n", ShortBBoxStr(L->mins));
      printf("             maxs (%s)\n", ShortBBoxStr(L->maxs));

      DumpLeafFaces(L);

      DumpLeafBrushes(L);

      printf("\n");
    }
  }

  printf("\n------------------------------------------------------------\n\n");
}


static const char *ChildName(signed short child)
{
  static char buffer[64];

  if (child == -1)
    return "__SOLID__";

  if (child < 0)
    sprintf(buffer, "Leaf:%04d", -child - 1);
  else
    sprintf(buffer, "Node:%04d", child);
 
  return buffer;
}

static void DumpNodes(void)
{
  int i;

  printf("NODE COUNT: %d\n\n", numnodes);

  for (i = 0; i < numnodes; i++)
  {
    dnode_t *N = &dnodes[i];

    printf("Node #%04d : splitter %04d  ", i, N->planenum);
    printf("front(%s)  ", ChildName(N->children[0]));
    printf("back(%s)\n",  ChildName(N->children[1]));

    if (me_verbose)
    {
      printf("             mins (%s)\n", ShortBBoxStr(N->mins));
      printf("             maxs (%s)\n", ShortBBoxStr(N->maxs));

      printf("             firstface:%d numfaces:%d\n", N->firstface, N->numfaces);

      printf("\n");
    }
  }

  printf("\n------------------------------------------------------------\n\n");
}


int main(int argc, char **argv)
{
  char source[1024];

  if (argc != 2)
  {
    Error ("uSAGE: dumpbsp3 file.bsp");
    return 9;
  }
    
  strcpy (source, argv[1]);
  DefaultExtension (source, ".bsp");

  printf ("LOADING FILE: %s\n\n", source);
  
  LoadBSPFile (source);   
    
  DumpPlanes();
  DumpVertices();
  DumpEdges();
  DumpFaces();

  DumpBrushes();
  DumpLeafs();
  DumpNodes();
  DumpModels();

  DumpTexInfo();
  DumpEntities();

  // FIXME: areas, areaportals, visibility

  return 0;
}
