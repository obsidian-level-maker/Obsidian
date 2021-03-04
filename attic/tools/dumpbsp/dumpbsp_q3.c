/*
 * Q3 DUMPBSP tool by Andrew Apted
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "cmdlib.h"
#include "mathlib.h"
#include "bspfile.h"


static int verbose_mode = 2;


static const char *VectorStr(float *vec)
{
	static char buffer[256];

	buffer[0] = 0;

	char *pos = buffer;

	int i;
	for (i = 0 ; i < 3 ; i++)
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
	for (i = 0 ; i < 3 ; i++)
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


static const char *IntBBoxStr(int *vec)
{
	static char buffer[256];

	buffer[0] = 0;

	char *pos = buffer;

	int i;
	for (i = 0 ; i < 3 ; i++)
	{
		if (i > 0)
			strcat(buffer, " ");

		pos = buffer + strlen(buffer);

		sprintf(pos, "%+5d", vec[i]);
	}

	return buffer;
}


static const char *ShaderInfo(int shader, int force_verbose)
{
	static char buffer[100];

	if (shader < 0 || shader >= numShaders)
	{
		sprintf(buffer, "%d [BAD SHADER]", shader);
	}
	else if (force_verbose)
	{
		snprintf(buffer, sizeof(buffer), "%d \"%s\"", shader, dshaders[shader].shader);
	}
	else
	{
		sprintf(buffer, "%d", shader);
	}

	return buffer;
}



static void DumpPlanes(void)
{
	int i;

	printf("PLANE COUNT: %d\n\n", numplanes);

	for (i = 0 ; i < numplanes ; i++)
	{
		dplane_t *P = &dplanes[i];

		printf("Plane #%04d : (%s) dist:%+8.1f\n",
				i, NormalStr(P->normal), P->dist);
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

	for (i = 0 ; i < nummodels ; i++)
	{
		dmodel_t *M = &dmodels[i];

		printf("Model #%04d : surfs:%d(@%d) brushes:%d(@%d)\n",
				i, M->numSurfaces, M->firstSurface,
				M->numBrushes, M->firstBrush);

		{
			printf("              mins (%s)\n", VectorStr(M->mins));
			printf("              maxs (%s)\n", VectorStr(M->maxs));
			printf("\n");
		}
	}

	printf("\n------------------------------------------------------------\n\n");
}


static void DumpDrawVerts(void)
{
	int i;

	printf("DRAWVERT COUNT: %d\n\n", numDrawVerts);

	for (i = 0 ; i < numDrawVerts ; i++)
	{
		drawVert_t *V = &drawVerts[i];

		printf("DrawVert #%05d : xyz:(%s)\n", i, VectorStr(V->xyz));

		if (verbose_mode)
		{
			printf("                  st:(%+9.6f %+9.6f)\n", V->st[0], V->st[1]);
			printf("                  lm:(%+9.6f %+9.6f)\n", V->lightmap[0], V->lightmap[1]);
			printf("                  normal:(%s)\n", NormalStr(V->normal));
			printf("                  rgb:(%3d %3d %3d)\n", V->color[0], V->color[1], V->color[2]);

			printf("\n");
		}
	}

	printf("\n------------------------------------------------------------\n\n");
}


static const char * GetSurfaceType(int val)
{
	switch (val)
	{
		case MST_PLANAR:
			return "POLYGON";

		case MST_PATCH:
			return "_PATCH_";

		case MST_TRIANGLE_SOUP:
			return "__SOUP_";

		case MST_FLARE:
			return "__FLARE";

		default:
			return "???????";
	}
}


static const char * GetTriangleList(dsurface_t *F)
{
	static char buffer[65536];

	char triple[200];

	int i;

	buffer[0] = 0;

	// iterate over the triangles in the surface

	for (i = 0 ; i < F->numIndexes / 3 ; i++)
	{
		int k = F->firstIndex + i*3;

		if (i > 0)
			strcat(buffer, " ");

		if (k < 0 || k+2 >= numDrawIndexes)
		{
			strcat(buffer, "[BAD INDEX]");
			continue;
		}

		sprintf(triple, "(%d %d %d)",
			drawIndexes[k+0], drawIndexes[k+1], drawIndexes[k+2]);

		strcat(buffer, triple);
	}

	return buffer;
}


static void DumpSurfaces(void)
{
	int i;

	printf("SURFACE COUNT: %d\n\n", numDrawSurfaces);

	for (i = 0 ; i < numDrawSurfaces ; i++)
	{
		dsurface_t *F = &drawSurfaces[i];

		printf("Surf #%04d : type:%s shader:%s\n",
				i, GetSurfaceType(F->surfaceType),
				ShaderInfo(F->shaderNum, 1));

		if (verbose_mode)
		{
			if (F->fogNum >= 0)
				printf("             fog: %d\n", F->fogNum);

			printf("             verts:%d(@%d) indexes:%d(@%d)\n",
					F->numVerts, F->firstVert,
					F->numIndexes, F->firstIndex);

			printf("             lightmap:#%d (%d %d) %d x %d\n",
					F->lightmapNum,
					F->lightmapX, F->lightmapY,
					F->lightmapWidth, F->lightmapHeight);

			printf("             lm origin:(%s)\n", VectorStr(F->lightmapOrigin));

			if (verbose_mode >= 2)
			{
				int k;

				printf("             lm S vec: (%s)\n", NormalStr(F->lightmapVecs[0]));
				printf("             lm T vec: (%s)\n", NormalStr(F->lightmapVecs[1]));
				printf("             lm N vec: (%s)\n", NormalStr(F->lightmapVecs[2]));

				for (k = 0 ; k < F->numVerts ; k++)
				{
					int k2 = F->firstVert + k;

					if (k2 < 0 || k2 >= numDrawVerts)
						printf("             vert[%04d] : [BAD REF]\n", k2);
					else
						printf("             vert[%04d] : (%s)\n", k2, VectorStr(drawVerts[k2].xyz));
				}

				if (F->numIndexes >= 3)
				{
					printf("             triangles: %s\n", GetTriangleList(F));
				}

#if 0
				for (k = 0 ; k < F->numIndexes ; k++)
				{
					int k2 = F->firstIndex + k;

					if (k2 < 0 || k2 >= numDrawIndexes)
						printf("             index[%02d] : [BAD REF]\n", k2);
					else
						printf("             index[%02d] : %04d \n", k2, drawIndexes[k2]);
				}
#endif

				printf("             patch size:%d x %d\n",
						F->patchWidth, F->patchHeight);
			}

			printf("\n");
		}
	}

	printf("\n------------------------------------------------------------\n\n");
}


static void DumpShaders(void)
{
	int i;

	printf("SHADER COUNT : %d\n\n", numShaders);

	for (i = 0 ; i < numShaders ; i++)
	{
		dshader_t *T = &dshaders[i];

		printf("Shader #%04d : flag:0x%06x cont:0x%08x %s\n",
				i, T->surfaceFlags, T->contentFlags, T->shader);
	}

	printf("\n------------------------------------------------------------\n\n");
}


static void DumpBrushes(void)
{
	int i, k;

	printf("BRUSH COUNT : %d\n\n", numbrushes);

	for (i = 0 ; i < numbrushes ; i++)
	{
		dbrush_t *B = &dbrushes[i];

		printf("Brush #%04d : shader:%s\n", i, ShaderInfo(B->shaderNum, 1));

		if (B->numSides == 0)
		{
			printf("BAD BRUSH (no sides)\n\n");
			continue;
		}

		for (k = 0 ; k < B->numSides ; k++)
		{
			int k2 = B->firstSide + k;
			dbrushside_t *S;

			if (k2 < 0 || k2 >= numbrushsides)
			{
				printf("BAD BRUSHSIDE REF! (%d >= %d)\n", k2, numbrushsides);
				continue;
			}

			S = &dbrushsides[k2];

			printf("              side[%04d] : ", k2);

			printf("plane:%04d shader:%s\n", S->planeNum, ShaderInfo(S->shaderNum, 0));
		}

		printf("\n");
	}

	printf("\n------------------------------------------------------------\n\n");
}


static void DumpLeafSurfaces(dleaf_t *L)
{
	int k;

	for (k = 0 ; k < L->numLeafSurfaces ; k++)
	{
		int k2 = L->firstLeafSurface + k;
		int surf_idx;

		printf("             leafsurf");

		if (k2 < 0 || k2 >= numleafsurfaces)
		{
			printf(": BAD LEAFSURF REF! (%d >= %d)\n", k2, numleafsurfaces);
			continue;
		}

		surf_idx = dleafsurfaces[k2];

		if (surf_idx >= numDrawSurfaces)
		{
			printf(": BAD SURFACE REF! (%d >= %d)\n", surf_idx, numDrawSurfaces);
			continue;
		}
		else
		{
			dsurface_t *F = &drawSurfaces[surf_idx];

			printf("[%04d] = surf:%04d ", k2, surf_idx);

			printf("shader:%s\n", ShaderInfo(F->shaderNum, verbose_mode >= 2));
		}
	}
}


static void DumpLeafBrushes(dleaf_t *L)
{
	int k;

	for (k = 0 ; k < L->numLeafBrushes ; k++)
	{
		int k2 = L->firstLeafBrush + k;
		int brush_idx;

		if (k2 < 0 || k2 >= numleafbrushes)
		{
			printf("BAD LEAFBRUSH REF! (%d >= %d)\n", k2, numleafbrushes);
			continue;
		}

		brush_idx = dleafbrushes[k2];

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

	for (i = 0 ; i < numleafs ; i++)
	{
		dleaf_t *L = &dleafs[i];

		printf("Leaf #%04d : cluster:%d area:%d surfs:%d(@%d) brushes:%d(@%d)\n",
				i, L->cluster, L->area,
				L->numLeafSurfaces, L->firstLeafSurface,
				L->numLeafBrushes,  L->firstLeafBrush);

		if (verbose_mode)
		{
			printf("             mins (%s)\n", IntBBoxStr(L->mins));
			printf("             maxs (%s)\n", IntBBoxStr(L->maxs));

			DumpLeafSurfaces(L);
			DumpLeafBrushes(L);

			printf("\n");
		}
	}

	printf("\n------------------------------------------------------------\n\n");
}


static const char *ChildName(int child)
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

	for (i = 0 ; i < numnodes ; i++)
	{
		dnode_t *N = &dnodes[i];

		printf("Node #%04d : splitter %04d  ", i, N->planeNum);
		printf("front(%s)  ", ChildName(N->children[0]));
		printf("back(%s)\n",  ChildName(N->children[1]));

		if (verbose_mode)
		{
			printf("             mins (%s)\n", IntBBoxStr(N->mins));
			printf("             maxs (%s)\n", IntBBoxStr(N->maxs));

			printf("\n");
		}
	}

	printf("\n------------------------------------------------------------\n\n");
}


int main(int argc, char **argv)
{
	char source[1024];

	while (strcmp(argv[1], "-v") == 0)
	{
		verbose_mode++;

		argv++;
		argc--;
	}

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
	DumpShaders();

	DumpDrawVerts();
	DumpSurfaces();

	DumpLeafs();
	DumpNodes();

	DumpBrushes();
	DumpModels();

	DumpEntities();

	return 0;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
