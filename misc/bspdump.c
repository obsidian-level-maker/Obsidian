/*
 * BSP DUMP by Andrew Apted
 */

#include "cmdlib.h"
#include "mathlib.h"
#include "bspfile.h"


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

    printf("Model #%04d : visleafs:%5d  firstface:%5d  numfaces: %d\n",
           i, M->visleafs, M->firstface, M->numfaces);

    if (true)
    {
      printf("              mins (%s)\n", VectorStr(M->mins));
      printf("              maxs (%s)\n", VectorStr(M->maxs));
      printf("              orig (%s)\n", VectorStr(M->origin));

      printf("              root node: %d  clip nodes: %d %d %d\n",
             M->headnode[0], M->headnode[1], M->headnode[2], M->headnode[3]);

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

  printf("             styles: %02x %02x %02x %02x\n",
         F->styles[0], F->styles[1], F->styles[2], F->styles[3]);

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

    if (true)
    {
      DumpFaceEdges(F);

      printf("\n");
    }
  }

  printf("\n------------------------------------------------------------\n\n");
}


int main (int argc, char **argv)
{
  char source[1024];

  if (argc != 2)
  {
    Error ("uSAGE: bspdump file.bsp");
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

  DumpModels();
  DumpEntities();

  return 0;
}

