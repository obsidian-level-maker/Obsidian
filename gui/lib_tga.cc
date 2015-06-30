//------------------------------------------------------------------------
//  TGA (Targa) IMAGE LOADING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2013-2015 Andrew Apted
//  Copyright (C) 1997-2001 Id Software, Inc.
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
//
//  NOTE: this is based on the TGA loading code from Quake 2.
//
//------------------------------------------------------------------------

#include "headers.h"
#include "main.h"

#include "lib_tga.h"
#include "lib_file.h"


typedef struct
{
	u8_t	id_length, colormap_type, image_type;
	u16_t	colormap_index, colormap_length;
	u8_t	colormap_size;
	u16_t	x_origin, y_origin, width, height;
	u8_t	pixel_size, attributes;

} targa_header_t;


static bool LoadTGA (image_t * img, const char *name, imagetype_e type)
{
// load the file

	byte  * buffer;
	byte  * buf_p;
	byte  * buf_end;

	int length = FS_LoadFile (name, (void **)&buffer);

	if (! buffer)
		return false;

	buf_p   = buffer;
	buf_end = buffer + length;


// decode the TGA header

	targa_header_t	targa_header;

	targa_header.id_length = *buf_p++;
	targa_header.colormap_type = *buf_p++;
	targa_header.image_type = *buf_p++;
	
	targa_header.colormap_index = LittleShort ( *((short *)buf_p) );
	buf_p+=2;
	targa_header.colormap_length = LittleShort ( *((short *)buf_p) );
	buf_p+=2;
	targa_header.colormap_size = *buf_p++;
	targa_header.x_origin = LittleShort ( *((short *)buf_p) );
	buf_p+=2;
	targa_header.y_origin = LittleShort ( *((short *)buf_p) );
	buf_p+=2;
	targa_header.width = LittleShort ( *((short *)buf_p) );
	buf_p+=2;
	targa_header.height = LittleShort ( *((short *)buf_p) );
	buf_p+=2;
	targa_header.pixel_size = *buf_p++;
	targa_header.attributes = *buf_p++;

	if (targa_header.image_type != 2 &&
		targa_header.image_type != 10) 
		Sys_Error ("Bad tga file: Only type 2 and 10 images supported\n");

	if (targa_header.colormap_type !=0 ||
	    (targa_header.pixel_size != 24 && targa_header.pixel_size != 32))
		Sys_Error ("Bad tga file: only 24 or 32 bit images supported (no colormaps)\n");


	int width  = targa_header.width;
	int height = targa_header.height;

	img->width  = width;
	img->height = height;

	img->rgb[0] = new rgb32_t [img->width * img->height];

	bool is_masked  = false;  // opacity testing
	bool is_complex = false;  // 


// decode the pixel stream

	rgb32_t	*dest = img->rgb[0];
	rgb32_t	*p;

	if (targa_header.id_length != 0)
		buf_p += targa_header.id_length;  // skip TARGA image comment

	if (targa_header.image_type == 2)   // Uncompressed, RGB images
	{
		for (int y = height-1 ; y >= 0 ; y--)
		{
			p = dest + y*width;

			for (int x=0 ; x < width ; x++)
			{
				byte red, green, blue, alphabyte;

				switch (targa_header.pixel_size)
				{
					case 24:
							blue = *buf_p++;
							green = *buf_p++;
							red = *buf_p++;

							*p++ = MAKE_RGB(red, green, blue);
							break;

					case 32:
							blue = *buf_p++;
							green = *buf_p++;
							red = *buf_p++;
							alphabyte = *buf_p++;

							*p++ = MAKE_RGBA(red, green, blue, alphabyte);

							if (alphabyte != 255)
							{
								if (alphabyte == 0)
									is_masked = true;
								else
									is_complex = true;
							}
							break;
				}
			}
		}
	}
	else if (targa_header.image_type == 10)   // Runlength encoded RGB images
	{
		byte red, green, blue, alphabyte;
		byte packetHeader, packetSize;

		for (int y=height-1 ; y >= 0 ; y--)
		{
			p = dest + y*width;

			for (int x=0 ; x < width ; )
			{
				packetHeader= *buf_p++;
				packetSize = 1 + (packetHeader & 0x7f);

				if (packetHeader & 0x80)    // run-length packet
				{
					switch (targa_header.pixel_size)
					{
						case 24:
								blue = *buf_p++;
								green = *buf_p++;
								red = *buf_p++;
								alphabyte = 255;
								break;
						case 32:
								blue = *buf_p++;
								green = *buf_p++;
								red = *buf_p++;
								alphabyte = *buf_p++;

								if (alphabyte != 255)
								{
									if (alphabyte == 0)
										is_masked = true;
									else
										is_complex = true;
								}
								break;
					}
	
					for (int j=0 ; j < packetSize ; j++)
					{
						*p++ = MAKE_RGBA(red, green, blue, alphabyte);

						x++;

						if (x == width)  // run spans across edge
						{
							x = 0;
							if (y > 0)
								y--;
							else
								goto breakOut;

							p = dest + y*width;
						}
					}
				}
				else        // not a run-length packet
				{
					for(int j=0 ; j < packetSize; j++)
					{
						switch (targa_header.pixel_size)
						{
							case 24:
									blue = *buf_p++;
									green = *buf_p++;
									red = *buf_p++;

									*p++ = MAKE_RGB(red, green, blue);
									break;

							case 32:
									blue = *buf_p++;
									green = *buf_p++;
									red = *buf_p++;
									alphabyte = *buf_p++;

									*p++ = MAKE_RGBA(red, green, blue, alphabyte);

									if (alphabyte != 255)
									{
										if (alphabyte == 0)
											is_masked = true;
										else
											is_complex = true;
									}
									break;
						}

						x++;

						if (x == width)  // pixel packet run spans across edge
						{
							x = 0;
							if (y > 0)
								y--;
							else
								goto breakOut;

							p = dest + y*width;
						}						
					}
				}
			}
			breakOut: ;
		}
	}

	FS_FreeFile (buffer);

	img->opacity =	is_complex ? OPAC_Complex :
					is_masked  ? OPAC_Masked  : OPAC_Solid;

	return true;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
