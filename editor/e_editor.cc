//------------------------------------------------------------------------
//  EDITOR : Editing widget
//------------------------------------------------------------------------
//
//  Tailor Lua Editor  Copyright (C) 2008  Andrew Apted
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
//  Based on the "editor.cxx" sample program from FLTK 1.1.6,
//  as described in Chapter 4 of the FLTK Programmer's Guide.
//  
//  Copyright 1998-2004 by Bill Spitzak, Mike Sweet and others.
//
//------------------------------------------------------------------------

#include "headers.h"


#define FLOWOVER_STYLE(ch)  ((ch) == 'S' || (ch) == 'T')

#define MY_FONT  FL_COURIER_BOLD
#define MY_SIZE  16


void style_unfinished_cb(int, void *);
void style_update_cb(int, int, int, int, const char *, void *);


W_Editor::W_Editor(int X, int Y, int W, int H, const char *label) :
    Fl_Text_Editor(X, Y, W, H, label),
    cur_dark(true), cur_font_h(MY_SIZE),
    cur_filename(NULL)
{
    textbuf  = new Fl_Text_Buffer;
    stylebuf = new Fl_Text_Buffer;

    buffer(textbuf);

    SetFont(MY_SIZE);
    SetDark(true);

    textbuf->add_modify_callback(style_update_cb, this);
}

W_Editor::~W_Editor()
{
    delete textbuf;
    delete stylebuf;
}


int W_Editor::handle(int event)
{
    if (event == FL_KEYDOWN || event == FL_PUSH)
        main_win->status->ClearError();

    if (event == FL_KEYDOWN)
    {
        int key = Fl::event_key();

        if (key == FL_Tab)
            return 1;
    }

    // pass it along to daddy...
    return Fl_Text_Editor::handle(event);
}


//---------------------------------------------------------------------------

void W_Editor::GetInsertPos(int *line, int *column)
{
    int i_pos = insert_position();

    *line = 1 + textbuf->count_lines(0, i_pos);

    *column = 1 + (i_pos - textbuf->line_start(i_pos));
}

bool W_Editor::GotoLine(int num)
{
    SYS_ASSERT(num >= 1);

    int pos = textbuf->skip_lines(0, num-1);

    insert_position(pos);
    show_insert_position();

    return textbuf->count_lines(0, pos) == (num-1);
}

//---------------------------------------------------------------------------

#define MY_FL_COLOR(R,G,B) \
          (Fl_Color) (((R) << 24) | ((G) << 16) | ((B) << 8))

#define COL_RED     MY_FL_COLOR(255,112,112)
#define COL_GREEN   MY_FL_COLOR(72,255,72)
#define COL_YELLOW  MY_FL_COLOR(255,255,128)
#define COL_BLUE    MY_FL_COLOR(128,128,255)
#define COL_CYAN    MY_FL_COLOR(0,255,255)
#define COL_BROWN   MY_FL_COLOR(200,144,112)
#define COL_GRAY    MY_FL_COLOR(200,200,200)


#define DRK_RED     MY_FL_COLOR(216,0,0)
#define DRK_GREEN   MY_FL_COLOR(0,176,0)
#define DRK_YELLOW  MY_FL_COLOR(192,0,192)
#define DRK_BLUE    MY_FL_COLOR(0,0,240)
#define DRK_CYAN    MY_FL_COLOR(0,176,224)
#define DRK_BROWN   MY_FL_COLOR(160,128,0)
#define DRK_GRAY    FL_BLACK


Fl_Text_Display::Style_Table_Entry W_Editor::table_dark[W_Editor::TABLE_SIZE] =
{
    { COL_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'A' - All else
    { COL_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'B'
    { COL_BLUE,    MY_FONT,  MY_SIZE, 0 },  // 'C' - Comments --
    { COL_BLUE,    MY_FONT,  MY_SIZE, 0 },  // 'D' - Comments --[[ ]]
    { COL_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'E'
    { COL_GREEN,   MY_FONT,  MY_SIZE, 0 },  // 'F' - Function
    { COL_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'G'
    { COL_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'H'
    { COL_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'I'
    { COL_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'J'
    { COL_BROWN,   MY_FONT,  MY_SIZE, 0 },  // 'K' - Keyword
    { COL_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'L'
    { COL_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'M'
    { COL_YELLOW,  MY_FONT,  MY_SIZE, 0 },  // 'N' - Numbers
    { COL_CYAN,    MY_FONT,  MY_SIZE, 0 },  // 'O' - Oblige Stuff
    { COL_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'P'
    { COL_RED,     MY_FONT,  MY_SIZE, 0 },  // 'Q' - Strings ''
    { COL_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'R'
    { COL_RED,     MY_FONT,  MY_SIZE, 0 },  // 'S' - Strings ""
    { COL_GREEN,   MY_FONT,  MY_SIZE, 0 },  // 'T' - Table {}
};


Fl_Text_Display::Style_Table_Entry W_Editor::table_light[W_Editor::TABLE_SIZE] =
{
    { DRK_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'A' - All else
    { DRK_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'B'
    { DRK_BLUE,    MY_FONT,  MY_SIZE, 0 },  // 'C' - Comments --
    { DRK_BLUE,    MY_FONT,  MY_SIZE, 0 },  // 'D' - Comments --[[ ]]
    { DRK_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'E'
    { DRK_GREEN,   MY_FONT,  MY_SIZE, 0 },  // 'F' - Function
    { DRK_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'G'
    { DRK_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'H'
    { DRK_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'I'
    { DRK_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'J'
    { DRK_BROWN,   MY_FONT,  MY_SIZE, 0 },  // 'K' - Keyword
    { DRK_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'L'
    { DRK_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'M'
    { DRK_YELLOW,  MY_FONT,  MY_SIZE, 0 },  // 'N' - Numbers
    { DRK_CYAN,    MY_FONT,  MY_SIZE, 0 },  // 'O' - Oblige Stuff
    { DRK_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'P'
    { DRK_RED ,    MY_FONT,  MY_SIZE, 0 },  // 'Q' - Strings ''
    { DRK_GRAY,    MY_FONT,  MY_SIZE, 0 },  // 'R'
    { DRK_RED ,    MY_FONT,  MY_SIZE, 0 },  // 'S' - Strings ""
    { DRK_GREEN,   MY_FONT,  MY_SIZE, 0 },  // 'T' - Table {}
};


void W_Editor::SetDark(bool dark)
{
    cur_dark = dark;

    if (cur_dark)
    {
        color(FL_BLACK /* background */, FL_WHITE /* selection */);
        cursor_color(FL_WHITE);
    }
    else
    {
        color(FL_WHITE /* background */, FL_BLACK /* selection */);
        cursor_color(FL_BLACK);
    }

    highlight_data(stylebuf, cur_dark ? table_dark : table_light,
        TABLE_SIZE, 'A', style_unfinished_cb, this);

    show_insert_position();
}

void W_Editor::SetFont(int font_h)
{
    cur_font_h = font_h;

    textfont(FL_COURIER);

    for (int i = 0; i < TABLE_SIZE; i++)
    {
        table_dark [i].size = font_h;
        table_light[i].size = font_h;
    }

    highlight_data(stylebuf, cur_dark ? table_dark : table_light,
        TABLE_SIZE, 'A', style_unfinished_cb, this);

    show_insert_position();
}


//
// 'style_unfinished_cb()' - Update unfinished styles.
//

void style_unfinished_cb(int, void*)
{
}


//
// 'style_update()' - Update the style buffer...
//

void style_update_cb(int pos,       // Position of update
                     int nInserted, // Number of inserted chars
                     int nDeleted,  // Number of deleted chars
                     int nRestyled, // Number of restyled chars
                     const char * deletedText,// Text that was deleted
                     void *cbArg)   // Callback data
{
    (void)nRestyled;
    (void)deletedText;

    W_Editor *WE = (W_Editor*) cbArg;

    // If this is just a selection change, just unselect the style buffer...
    if (nInserted == 0 && nDeleted == 0)
    {
        WE->stylebuf->unselect();
        return;
    }

    // Track changes in the text buffer...
    if (nInserted > 0)
    {
        // Insert characters into the style buffer...
        char *style = new char[nInserted + 1];
        memset(style, 'A', nInserted);
        style[nInserted] = '\0';

        WE->stylebuf->replace(pos, pos + nDeleted, style);
        delete[] style;
    }
    else
    {
        // Just delete characters in the style buffer...
        WE->stylebuf->remove(pos, pos + nDeleted);
    }

    // Select the area that was just updated to avoid unnecessary
    // callbacks...
    WE->stylebuf->select(pos, pos + nInserted - nDeleted);

    // Re-parse the changed region; we do this by parsing from the
    // beginning of the line of the changed region to the end of
    // the line of the changed region...  Then we check the last
    // style character and keep updating if necessary.

    int start = WE->textbuf->line_start(pos);
    int end   = WE->textbuf->line_end(pos + nInserted);

    if (end < WE->textbuf->length())
        end++;

    if (start >= WE->textbuf->length())
        return;

    for (;;)
    {
        // NOTE: 'end-1' could be invalid if last line has no trailing NUL.
        //       The character() method returns NUL in this case.
        char last_before = WE->stylebuf->character(end-1);

        WE->UpdateStyleRange(start, end);

        char last_after = WE->stylebuf->character(end-1);

        if (last_before == last_after)
            break;

        // The newline ('\n') on the end line changed styles, so
        // reparse another chunk.

        if (end >= WE->textbuf->length())
            break;

        start = end;
        end   = WE->textbuf->skip_lines(start, 5);

        SYS_ASSERT(start < end);
    }
}

void W_Editor::UpdateStyleRange(int start, int end)
{
    // get style of previous line (from the '\n' character)
    char context = 'A';

    if (start > 0)
        context = stylebuf->character(start - 1);

    char *text  = textbuf->text_range(start, end);
    char *style = stylebuf->text_range(start, end);
    {
        Parse(text, text + (end - start), style, context);

        stylebuf->replace(start, end, style);
    }
    free(text);
    free(style);

    redisplay_range(start, end);
}

bool W_Editor::Load(const char *filename)
{
    FILE *fp = fopen(filename, "r");

    if (! fp)
    {
        fl_alert("Loading file %s failed\n", filename);
        return false;
    }

    SetFilename(filename);

    char buffer[1024];

    while (! feof(fp))
    {
        int len = fread(buffer, 1, sizeof(buffer)-4, fp);

        if (len <= 0)
            break;
        
        len = SanitizeInput(buffer, len);

        buffer[len] = 0;
        textbuf->append(buffer);
    }

    fclose(fp);
    return true;
}

bool W_Editor::Save()
{
    SYS_ASSERT(cur_filename);

    FILE *fp = fopen(cur_filename, "w");

    if (! fp)
    {
        fl_alert("Saving file %s failed\n", cur_filename);
        return false;
    }

    int pos = 0;
    int total_len = textbuf->length();

    if (total_len == 0)
        fprintf(fp, "\n");

    while (pos < total_len)
    {
        char *line = textbuf->line_text(pos);

        pos = textbuf->skip_lines(pos, 1);

        fwrite(line, strlen(line), 1, fp);
        fprintf(fp, "\n");

        free(line);
    }

    fclose(fp);
    return true;
}

bool W_Editor::HasFilename() const
{
    return (cur_filename != NULL);
}

void W_Editor::SetFilename(const char *filename)
{
    if (cur_filename)
        StringFree(cur_filename);

    cur_filename = StringDup(filename);
}

int W_Editor::SanitizeInput(char *buffer, int len)
{
    char *src  = buffer;
    char *dest = buffer;

    while (src < buffer + len) 
    {
        if (*src == 0 || *src == '\r')
        {
            src++;
            continue;
        }

        *dest++ = *src++;
    }

    return (int)(dest - buffer);
}


//===============================================================
//  STYLE PARSING CODE
//===============================================================

void W_Editor::Parse(const char *text, const char *t_end, char *style, char context)
{
    SYS_ASSERT(text < t_end);

    while (text < t_end)
    {
        if (context == 'S' || context == 'R')
        {
            int len = ParseString(text, t_end, style, context);
            text  += len;
            style += len;
            continue;
        }

        if (context == 'D')
        {
            int len = ParseCommentBig(text, t_end, style, context);
            text  += len;
            style += len;
            continue;
        }
 
        if (*text == '"' || *text == '\'')
        {
            context = (*text == '"') ? 'S' : 'R';

            text++, *style++ = context;
            continue;
        }

        if ((t_end - text) >= 4 && strncmp(text, "--[[", 4) == 0)
        {
            context = 'D';

            memset(style, context, 4);

            text += 4; 
            style += 4;
            continue;
        }

        if (isdigit(*text))
        {
            int len = ParseNumber(text, t_end, style);
            text  += len;
            style += len;
            continue;
        }

        if (isalpha(*text) || (*text == '_'))
        {
            int len = ParseKeyword(text, t_end, style);
            text  += len;
            style += len;
            continue;
        }

        if (text < t_end-1 && text[0] == '-' && text[1] == '-')
        {
                int len = ParseComment(text, t_end, style);
                text  += len;
                style += len;
                continue;
        }

        if (*text == '{' || *text == '}')
        {
          text++, *style++ = 'T';
          continue;
        }

        text++, *style++ = 'A';
    }
}

int W_Editor::ParseNumber(const char *text, const char *t_end, char *style)
{
    const char *t_orig = text;

    if (*text == '-')
    {
        text++, *style++ = 'N';
    }

    while (text < t_end)
    {
        if (! (isdigit(*text) || *text == '.' || tolower(*text) == 'e'))
            break;

        text++, *style++ = 'N';
    }

    return (text - t_orig);
}

const char * W_Editor::keywords[] =
{
    // --- special values ---
    "N:nil",
    "N:true",
    "N:false",
    "N:_G",
    "N:_VERSION",

    // --- Lua keywords ---
    "K:and",
    "K:break",
    "K:do",
    "K:else",
    "K:elseif",
    "K:end",
    "K:for",
    "K:function",

    "K:if",
    "K:in",
    "K:local",
    "K:nil",
    "K:not",
    "K:or",
    "K:repeat",
    "K:return",
    "K:then",
    "K:until",
    "K:while",

    // --- Lua Libraries ---

    // basic library
    "F:next",
    "F:pairs",
    "F:ipairs",

    "F:assert",
    "F:collectgarbage",
    "F:dofile",
    "F:error",
    "F:getfenv",
    "F:getmetatable",
    "F:setfenv",
    "F:setmetatable",

    "F:load",
    "F:loadfile",
    "F:loadstring",
    "F:pcall",
    "F:print",
    "F:rawequal",
    "F:rawget",
    "F:rawset",
    "F:select",
    "F:tonumber",
    "F:tostring",
    "F:type",
    "F:unpack",
    "F:xpcall",
 
    // co-routines
    "F:coroutine.create",
    "F:coroutine.resume",
    "F:coroutine.running",
    "F:coroutine.status",
    "F:coroutine.wrap",
    "F:coroutine.yield",
        
    // package library
    "K:require",
    "K:module",

    "N:package.cpath",
    "N:package.loaded",
    "N:package.path",

    "F:package.loadlib",
    "F:package.preload",
    "F:package.seeall",

    // string library
    "F:string.byte",
    "F:string.char",
    "F:string.dump",
    "F:string.find",
    "F:string.format",
    "F:string.gmatch",
    "F:string.gsub",
    "F:string.len",
    "F:string.lower",
    "F:string.upper",
    "F:string.match",
    "F:string.rep",
    "F:string.reverse",
    "F:string.sub",
 
    // table library
    "F:table.insert",
    "F:table.remove",
    "F:table.concat",
    "F:table.maxn",
    "F:table.sort",

    // math library
    "N:math.pi",
    "N:math.huge",

    "F:math.abs",
    "F:math.acos",
    "F:math.asin",
    "F:math.atan",
    "F:math.atan2",
    "F:math.ceil",
    "F:math.cos",
    "F:math.cosh",
    "F:math.deg",
    "F:math.exp",
    "F:math.floor",
    "F:math.fmod",
    "F:math.frexp",
    "F:math.ldexp",
    "F:math.log",
    "F:math.log10",
    "F:math.max",
    "F:math.min",
    "F:math.modf",
    "F:math.pow",
    "F:math.rad",
    "F:math.random",
    "F:math.randomseed",
    "F:math.sin",
    "F:math.sinh",
    "F:math.sqrt",
    "F:math.tan",
    "F:math.tanh",
    
    // I/O library
    "F:io.close",
    "F:io.flush",
    "F:io.input",
    "F:io.lines",
    "F:io.open",
    "F:io.output",
    "F:io.popen",
    "F:io.read",
    "F:io.tmpfile",
    "F:io.type",
    "F:io.write",

    // operating system
    "F:os.clock",
    "F:os.date",
    "F:os.difftime",
    "F:os.execute",
    "F:os.exit",
    "F:os.getenv",
    "F:os.remove",
    "F:os.rename",
    "F:os.setlocale",
    "F:os.time",
    "F:os.tmpname",

    // debugging
    "F:debug.debug",
    "F:debug.getfenv",
    "F:debug.gethook",
    "F:debug.getinfo",
    "F:debug.getlocal",
    "F:debug.getmetatable",
    "F:debug.getregistry",
    "F:debug.getupvalue",
    "F:debug.setfenv",
    "F:debug.sethook",
    "F:debug.setlocal",
    "F:debug.setmetatable",
    "F:debug.setupvalue",
    "F:debug.traceback",

    // --- Oblige specific stuff ---

    "O:int",
    "O:sel",

    "O:gui.printf",
    "O:gui.debugf",
    "O:gui.raw_log_print",
    "O:gui.raw_debug_print",
    "O:gui.add_button",
    "O:gui.show_button",
    "O:gui.change_button",

    "O:gui.rand_seed",
    "O:gui.random",
    "O:gui.at_level",
    "O:gui.progress",
    "O:gui.ticker",
    "O:gui.abort",

    "O:gui.begin_level",
    "O:gui.end_level",
    "O:gui.property",
    "O:gui.add_brush",
    "O:gui.add_entity",

    NULL // end of list
};


int W_Editor::ParseKeyword(const char *text, const char *t_end, char *style)
{
    for (int i = 0; keywords[i]; i++)
    {
        const char *K = keywords[i];

        if ((int)strlen(K+2) > (int)(t_end - text))
            continue;

        int len = strlen(K+2);

        if (text+len < t_end && (isalnum(text[len]) || text[len] == '_'))
            continue;

        if (memcmp(K+2, text, strlen(K+2)) == 0)
        {
            // matches!
            memset(style, K[0], len);
            return len;
        }
    }

    const char *t_orig = text;

    while (text < t_end)
    {
        if (! (isalnum(*text) || *text == '_'))
            break;

        text++, *style++ = 'A';
    }

    return (text - t_orig);
}

int W_Editor::ParseComment(const char *text, const char *t_end, char *style)
{
    const char *t_orig = text;

    text++, *style++ = 'C';
    text++, *style++ = 'C';

    while (text < t_end)
    {
        if (*text == '\n')
            break;

        text++, *style++ = 'C';
    }

    return (text - t_orig);
}


int W_Editor::ParseString(const char *text, const char *t_end, char *style, char& context)
{
    const char *t_orig = text;

    while (text < t_end)
    {
        if (*text == ((context == 'S') ? '"' : '\''))
        {
            *text++, *style++ = context;
            context = 'A';
            break;
        }

        *text++, *style++ = context;
    }

/// fprintf(stderr, "STRING LEN %d\n", text - t_orig);
    return (text - t_orig);
}


int W_Editor::ParseCommentBig(const char *text, const char *t_end, char *style, char& context)
{
    const char *t_orig = text;

    while (text < t_end)
    {
        if (text < t_end-1 && text[0] == ']' && text[1] == ']')
        {
            *text++, *style++ = context;
            *text++, *style++ = context;

            context = 'A';
            break;
        }

        *text++, *style++ = context;
    }

    return (text - t_orig);
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
