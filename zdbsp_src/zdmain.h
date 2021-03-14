#include "zdbsp.h"

typedef struct zdbsp_options 
{
bool build_nodes;
bool build_gl_nodes;
ERejectMode	reject_mode; // = ERM_DontTouch;
bool check_polyobjs;
bool compress_nodes;
bool compress_gl_nodes;
bool force_compression;
};


int zdmain (const char *filename, zdbsp_options options);
