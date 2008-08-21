//------------------------------------------------------------------------
//  2.5D CSG : Quake .MAP format
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"

#include <algorithm>

#include "lib_util.h"
#include "main.h"

#include "csg_main.h"
#include "csg_qkmap.h"


static FILE *map_fp;

static void Q_WriteField(const char *field, const char *val_str, ...)
{
  fprintf(map_fp, "  \"%s\"  \"", field);

  va_list args;

  va_start(args, val_str);
  vfprintf(map_fp, val_str, args);
  va_end(args);

  fprintf(map_fp, "\"\n");
}

static void Q_WriteBrush(area_poly_c *P)
{
  fprintf(map_fp, "  {\n");

  // TODO: slopes

  // TODO: x/y offsets

  // Top
  fprintf(map_fp, "    ( %1.1f %1.1f %1.1f ) ( %1.1f %1.1f %1.1f ) ( %1.1f %1.1f %1.1f ) %s 0 0 0 1 1\n",
      0.0, 0.0, P->info->z2,
      0.0, 1.0, P->info->z2,
      1.0, 0.0, P->info->z2,
      P->info->t_face->tex.c_str());

  // Bottom
  fprintf(map_fp, "    ( %1.1f %1.1f %1.1f ) ( %1.1f %1.1f %1.1f ) ( %1.1f %1.1f %1.1f ) %s 0 0 0 1 1\n",
      0.0, 0.0, P->info->z1,
      1.0, 0.0, P->info->z1,
      0.0, 1.0, P->info->z1,
      P->info->b_face->tex.c_str());

  // Sides
  for (int j1 = 0; j1 < (int)P->verts.size(); j1++)
  {
    int j2 = (j1 + 1) % (int)P->verts.size();

    area_vert_c *v1 = P->verts[j1];
    area_vert_c *v2 = P->verts[j2];

    SYS_ASSERT(v1 && v2);

    const char *tex = v1->face ? v1->face->tex.c_str() : P->info->side->tex.c_str();

    SYS_ASSERT(tex);
    SYS_ASSERT(strlen(tex) > 0);

    fprintf(map_fp, "    ( %1.1f %1.1f %1.1f ) ( %1.1f %1.1f %1.1f ) ( %1.1f %1.1f %1.1f ) %s 0 0 0 1 1\n",
        v1->x, v1->y, P->info->z1,
        v2->x, v2->y, P->info->z1,
        v1->x, v1->y, P->info->z2, tex);
  }

  fprintf(map_fp, "  }\n");
}

void CSG2_TestMapOut(void)
{
  // converts the area_poly list into a QUAKE ".map" file.

  map_fp = fopen("TEST.map", "w");
  SYS_ASSERT(map_fp);

  fprintf(map_fp, "{\n");

  Q_WriteField("classname", "worldspawn");
  Q_WriteField("worldtype", "0");
  Q_WriteField("wad", "textures.wad");

  fprintf(map_fp, "\n");

  for (int i = 0; i < (int)all_polys.size(); i++)
  {
    area_poly_c *P = all_polys[i];
    SYS_ASSERT(P);

    Q_WriteBrush(P);
  }

  fprintf(map_fp, "}\n\n");

  // FIXME: entities !!!!

  fclose(map_fp);
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
