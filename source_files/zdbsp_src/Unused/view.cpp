/*
    A really crappy viewer module.
    Copyright (C) 2002-2006 Randy Heit

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

*/
#ifndef NO_MAP_VIEWER

#define WIN32_LEAN_AND_MEAN
#define _WIN32_WINNT 0x0400
#include <windows.h>
#include "resource.h"
#include "zdbsp.h"
#include "doomdata.h"
#include "templates.h"
#include "tarray.h"

static int MapWidthDiff, MapHeightDiff;
static int ButtonsLeftOffset, ButtonsTopOffset;
static int StaticNumberLeft, StaticComboLeft;
static FLevel *Level;
static RECT MapBounds;
static POINT MapSize;
static int Divisor;

enum ViewMode
{
	ViewNodes,
	ViewGLNodes,
	ViewSubsectors,
	ViewGLSubsectors,
	ViewReject,
	ViewPVS
};

ViewMode Viewing;

void ResetViews ();
void SetStaticText ();

void ResizeDialog (HWND hDlg)
{
	RECT client;
	HWND control;

	GetClientRect (hDlg, &client);
	control = GetDlgItem (hDlg, IDC_MAPVIEW);
	SetWindowPos (control, 0, 0, 0, client.right - MapWidthDiff, client.bottom - MapHeightDiff,
		SWP_NOMOVE|SWP_NOREPOSITION|SWP_NOZORDER);

	control = GetDlgItem (hDlg, IDOK);
	SetWindowPos (control, 0, ButtonsLeftOffset, client.bottom - ButtonsTopOffset, 0, 0,
		SWP_NOSIZE|SWP_NOREPOSITION|SWP_NOZORDER);

	control = GetDlgItem (hDlg, IDC_STATICNUMBER);
	SetWindowPos (control, 0, StaticNumberLeft, client.bottom - ButtonsTopOffset, 0, 0,
		SWP_NOSIZE|SWP_NOREPOSITION|SWP_NOZORDER);

	control = GetDlgItem (hDlg, IDC_COMBO1);
	SetWindowPos (control, 0, StaticComboLeft, client.bottom - ButtonsTopOffset, 0, 0,
		SWP_NOSIZE|SWP_NOREPOSITION|SWP_NOZORDER);
}

void AddToCombo (HWND control, const char *name, ViewMode mode)
{
	LRESULT lResult = SendMessage (control, CB_ADDSTRING, 0, (LPARAM)name);
	if (lResult != CB_ERR && lResult != CB_ERRSPACE)
	{
		SendMessage (control, CB_SETITEMDATA, lResult, (LPARAM)mode);
		if (Viewing == mode)
		{
			SendMessage (control, CB_SETCURSEL, (WPARAM)lResult, 0);
		}
	}
}

INT_PTR CALLBACK ViewDialogFunc (HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	HWND control;
	RECT rect1, rect2;

	switch (uMsg)
	{
	case WM_INITDIALOG:
		if (GetClientRect (hDlg, &rect1))
		{
			control = GetDlgItem (hDlg, IDC_MAPVIEW);
			if (GetWindowRect (control, &rect2))
			{
				MapWidthDiff = rect1.right - rect2.right + rect2.left;
				MapHeightDiff = rect1.bottom - rect2.bottom + rect2.top;
			}
			control = GetDlgItem (hDlg, IDOK);
			if (GetWindowRect (control, &rect2))
			{
				POINT pt = { 0, rect1.bottom };
				ClientToScreen (hDlg, &pt);
				ButtonsTopOffset = pt.y - rect2.top;
				ButtonsLeftOffset = rect2.left - pt.x;
				control = GetDlgItem (hDlg, IDC_STATICNUMBER);
				if (GetWindowRect (control, &rect2))
				{
					StaticNumberLeft = rect2.left - pt.x;
				}
				control = GetDlgItem (hDlg, IDC_COMBO1);
				if (GetWindowRect (control, &rect2))
				{
					StaticComboLeft = rect2.left - pt.x;
				}
			}
		}

		control = GetDlgItem (hDlg, IDC_COMBO1);
		if (Level->Nodes)
		{
			AddToCombo (control, "Nodes", ViewNodes);
		}
		if (Level->Subsectors)
		{
			AddToCombo (control, "Subsectors", ViewSubsectors);
		}
		if (Level->Reject)
		{
			AddToCombo (control, "Reject", ViewReject);
		}
		if (Level->GLNodes)
		{
			AddToCombo (control, "GL Nodes", ViewGLNodes);
		}
		if (Level->GLSubsectors)
		{
			AddToCombo (control, "GL Subsectors", ViewGLSubsectors);
		}
		if (Level->GLPVS)
		{
			AddToCombo (control, "PVS", ViewPVS);
		}
		return TRUE;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
		case IDCANCEL:
			EndDialog (hDlg, 1);
			break;

		case IDC_COMBO1:
			if (HIWORD(wParam) == CBN_SELENDOK)
			{
				ViewMode newmode;

				newmode = (ViewMode)SendMessage (HWND(lParam), CB_GETITEMDATA,
					SendMessage (HWND(lParam), CB_GETCURSEL, 0, 0), 0);

				if (newmode != Viewing)
				{
					Viewing = newmode;
					ResetViews ();
					InvalidateRect (GetDlgItem (hDlg, IDC_MAPVIEW), NULL, TRUE);
				}
			}
			break;
		}
		return TRUE;

	case WM_GETMINMAXINFO:
		((MINMAXINFO *)lParam)->ptMinTrackSize.x = 480;
		((MINMAXINFO *)lParam)->ptMinTrackSize.y = 200;
		return TRUE;

	case WM_SIZE:
		if (wParam != SIZE_MAXHIDE && wParam != SIZE_MAXSHOW && wParam != SIZE_MINIMIZED)
		{
			ResizeDialog (hDlg);
		}
		return TRUE;

	case WM_MOUSEWHEEL:
		control = GetDlgItem (hDlg, IDC_MAPVIEW);
		PostMessage (control, WM_MOUSEWHEEL, wParam, lParam);
		return 0;

	case WM_APP:
		control = GetDlgItem (hDlg, IDC_STATICNUMBER);
		char foo[16];
		wsprintf (foo, "%d", wParam);
		SendMessage (control, WM_SETTEXT, 0, (LPARAM)foo);
		return 0;
	}
	return FALSE;
}

static inline int VERTX (int i)
{
	return Level->Vertices[i].x >> FRACBITS;
}

static inline int VERTY (int i)
{
	return Level->Vertices[i].y >> FRACBITS;
}

static inline int GLVERTX (int i)
{
	return Level->GLVertices[i].x >> FRACBITS;
}

static inline int GLVERTY (int i)
{
	return Level->GLVertices[i].y >> FRACBITS;
}

static HPEN NotInNode;
static HPEN LeftOfSplitter, LeftPen1, LeftPen2;
static HPEN RightOfSplitter, RightPen1, RightPen2;
static HPEN OutPen1;
static HPEN Splitter;
static short DesiredNode;
static TArray<short> DesiredHistory;

static void DrawSubsector (HDC dc, int ssec)
{
	for (DWORD i = 0; i < Level->Subsectors[ssec].numlines; ++i)
	{
		int seg = Level->Subsectors[ssec].firstline + i;
		if (Level->Segs[seg].side == 0)
		{
			MoveToEx (dc, VERTX(Level->Segs[seg].v1), VERTY(Level->Segs[seg].v1), NULL);
			LineTo (dc, VERTX(Level->Segs[seg].v2), VERTY(Level->Segs[seg].v2));
		}
		else
		{
			MoveToEx (dc, VERTX(Level->Segs[seg].v2), VERTY(Level->Segs[seg].v2), NULL);
			LineTo (dc, VERTX(Level->Segs[seg].v1), VERTY(Level->Segs[seg].v1));
		}
	}
}

static void DrawSubsectorGL (HDC dc, int ssec, HPEN miniPen, HPEN badPen)
{
	int seg;

	seg = Level->GLSubsectors[ssec].firstline;
	MoveToEx (dc, GLVERTX(Level->GLSegs[seg].v1), GLVERTY(Level->GLSegs[seg].v1), NULL);
	for (DWORD i = 0; i < Level->GLSubsectors[ssec].numlines; ++i)
	{
		HPEN oldPen = NULL;
		seg = Level->GLSubsectors[ssec].firstline + i;
		if (Level->GLSegs[seg].linedef == NO_INDEX)
		{
			if (Level->GLSegs[seg].partner == NO_INDEX)
			{
				oldPen = (HPEN)SelectObject (dc, badPen);
			}
			else
			{
				oldPen = (HPEN)SelectObject (dc, miniPen);
			}
		}
		if (Level->GLSegs[seg].side == 0 || 1)
		{
			//MoveToEx (dc, GLVERTX(Level->GLSegs[seg].v1), GLVERTY(Level->GLSegs[seg].v1), NULL);
			LineTo (dc, GLVERTX(Level->GLSegs[seg].v2), GLVERTY(Level->GLSegs[seg].v2));
		}
		else
		{
			//MoveToEx (dc, GLVERTX(Level->GLSegs[seg].v2), GLVERTY(Level->GLSegs[seg].v2), NULL);
			LineTo (dc, GLVERTX(Level->GLSegs[seg].v1), GLVERTY(Level->GLSegs[seg].v1));
		}
		if (oldPen != NULL)
		{
			SelectObject (dc, oldPen);
		}
	}
}


static void RealDrawNode (HDC dc, int node, HPEN miniPen, HPEN badPen)
{
	if (Viewing == ViewNodes)
	{
		if (node & NFX_SUBSECTOR)
		{
			DrawSubsector (dc, node & ~NFX_SUBSECTOR);
		}
		else
		{
			RealDrawNode (dc, Level->Nodes[node].children[0], miniPen, badPen);
			RealDrawNode (dc, Level->Nodes[node].children[1], miniPen, badPen);
		}
	}
	else
	{
		if (node & NFX_SUBSECTOR)
		{
			DrawSubsectorGL (dc, node & ~NFX_SUBSECTOR, miniPen, badPen);
		}
		else
		{
			RealDrawNode (dc, Level->GLNodes[node].children[0], miniPen, badPen);
			RealDrawNode (dc, Level->GLNodes[node].children[1], miniPen, badPen);
		}
	}
}

static void DrawNode (HDC dc, int node)
{
	if (node & NFX_SUBSECTOR)
	{
		return;
	}
	else
	{
		if (Viewing == ViewNodes)
		{
			if (node == DesiredNode)
			{
				SelectObject (dc, LeftOfSplitter);
				RealDrawNode (dc, Level->Nodes[node].children[1], LeftPen1, LeftPen2);
				SelectObject (dc, RightOfSplitter);
				RealDrawNode (dc, Level->Nodes[node].children[0], RightPen1, RightPen2);
				return;
			}
			else
			{
				DrawNode (dc, Level->Nodes[node].children[0]);
				DrawNode (dc, Level->Nodes[node].children[1]);
			}
		}
		else
		{
			if (node == DesiredNode)
			{
				SelectObject (dc, LeftOfSplitter);
				RealDrawNode (dc, Level->GLNodes[node].children[1], LeftPen1, LeftPen2);
				SelectObject (dc, RightOfSplitter);
				RealDrawNode (dc, Level->GLNodes[node].children[0], RightPen1, RightPen2);
				return;
			}
			else
			{
				DrawNode (dc, Level->GLNodes[node].children[0]);
				DrawNode (dc, Level->GLNodes[node].children[1]);
			}
		}
	}
}

static void DrawOutsideNode (HDC dc, int node)
{
	if (node == DesiredNode)
	{
		return;
	}
	else if (node & NFX_SUBSECTOR)
	{
		if (Viewing == ViewNodes)
		{
			DrawSubsector (dc, node & ~NFX_SUBSECTOR);
		}
		else
		{
			DrawSubsectorGL (dc, node & ~NFX_SUBSECTOR, OutPen1, OutPen1);
		}
	}
	else
	{
		if (Viewing == ViewNodes)
		{
			DrawOutsideNode (dc, Level->Nodes[node].children[0]);
			DrawOutsideNode (dc, Level->Nodes[node].children[1]);
		}
		else
		{
			DrawOutsideNode (dc, Level->GLNodes[node].children[0]);
			DrawOutsideNode (dc, Level->GLNodes[node].children[1]);
		}
	}
}

static void DrawSplitter (HDC dc, MapNodeEx *node)
{
	int dx = node->dx, dy = node->dy;
	// If the splitter is particularly short, make it longer to stand out
	while (abs(dx) < (20 << 16) && abs(dy) < (20 << 16))
	{
		dx <<= 1;
		dy <<= 1;
	}
	SelectObject (dc, Splitter);
	MoveToEx (dc, (node->x - dx) >> 16, (node->y - dy) >> 16, NULL);
	LineTo (dc, (node->x + 2*dx) >> 16, (node->y + 2*dy) >> 16);
}

static void DrawLevelNodes (HDC dc)
{
	HPEN oldPen;

	NotInNode = CreatePen (PS_SOLID, 1, RGB(200,200,200));
	OutPen1 = CreatePen (PS_SOLID, 1, RGB(238,238,238));
	LeftOfSplitter = CreatePen (PS_SOLID, 1, RGB(255,0,0));
	LeftPen1 = CreatePen (PS_SOLID, 1, RGB(255,200,200));
	LeftPen2 = CreatePen (PS_SOLID, 1, RGB(128,0,0));
	RightOfSplitter = CreatePen (PS_SOLID, 1, RGB(0,255,0));
	RightPen1 = CreatePen (PS_SOLID, 1, RGB(200,255,200));
	RightPen2 = CreatePen (PS_SOLID, 1, RGB(0,128,0));
	Splitter = CreatePen (PS_DOT, 1, RGB(70,0,255));

	oldPen = (HPEN)SelectObject (dc, NotInNode);

	if (Viewing == ViewNodes)
	{
		DrawOutsideNode (dc, Level->NumNodes - 1);
		DrawNode (dc, Level->NumNodes - 1);
		DrawSplitter (dc, &Level->Nodes[DesiredNode]);
	}
	else
	{
		DrawOutsideNode (dc, Level->NumGLNodes - 1);
		DrawNode (dc, Level->NumGLNodes - 1);
		DrawSplitter (dc, &Level->GLNodes[DesiredNode]);
	}


	SelectObject (dc, oldPen);

	DeleteObject (NotInNode);
	DeleteObject (LeftOfSplitter);
	DeleteObject (LeftPen1);
	DeleteObject (LeftPen2);
	DeleteObject (RightOfSplitter);
	DeleteObject (RightPen1);
	DeleteObject (RightPen2);
	DeleteObject (Splitter);
}

static int DesiredSubsector;

static void DrawLevelSubsectors (HDC dc)
{
	HPEN oldPen, pen, mini, bad;
	int i;

	pen = CreatePen (PS_SOLID, 1, RGB(200,200,200));
	mini = CreatePen (PS_SOLID, 1, RGB(100,200,255));
	bad = CreatePen (PS_SOLID, 1, RGB(255,128,128));

	oldPen = (HPEN)SelectObject (dc, pen);

	if (Viewing == ViewGLSubsectors)
	{
		for (i = 0; i < Level->NumGLSubsectors; ++i)
		{
			if (i != DesiredSubsector)
			{
				DrawSubsectorGL (dc, i, mini, bad);
			}
		}
	}
	else
	{
		for (i = 0; i < Level->NumSubsectors; ++i)
		{
			if (i != DesiredSubsector)
			{
				DrawSubsector (dc, i);
			}
		}
	}
	SelectObject (dc, oldPen);
	DeleteObject (pen);
	DeleteObject (mini);
	DeleteObject (bad);

	pen = CreatePen (PS_SOLID, 1, RGB(0,0,0));
	mini = CreatePen (PS_SOLID, 1, RGB(0,0,255));
	bad = CreatePen (PS_SOLID, 1, RGB(255,0,0));
	SelectObject (dc, pen);
	if (Viewing == ViewGLSubsectors)
	{
		DrawSubsectorGL (dc, DesiredSubsector, mini, bad);
	}
	else
	{
		DrawSubsector (dc, DesiredSubsector);
	}
	SelectObject (dc, oldPen);
	DeleteObject (pen);
	DeleteObject (mini);
	DeleteObject (bad);
}

static inline int PointOnSide (int x, int y, const MapNodeEx &nd)
{
	int foo = DMulScale32 ((y<<16)-nd.y, nd.dx, nd.x-(x<<16), nd.dy);
	return foo >= 0;
}

static void SetDesiredSubsector (int x, int y)
{
	if (Viewing == ViewSubsectors)
	{
		int node = Level->NumNodes - 1;

		while (!(node & NFX_SUBSECTOR))
		{
			node = Level->Nodes[node].children[PointOnSide (x, y, Level->Nodes[node])];
		}
		DesiredSubsector = node & ~NFX_SUBSECTOR;
	}
	else
	{
		int node = Level->NumGLNodes - 1;

		while (!(node & NFX_SUBSECTOR))
		{
			node = Level->GLNodes[node].children[PointOnSide (x, y, Level->GLNodes[node])];
		}
		DesiredSubsector = node & ~NFX_SUBSECTOR;
	}
}

static void SetDesiredNode (int x, int y)
{
	int node, parent;
	unsigned int depth = 0;

	// Traverse the tree until we find a node that is not on the
	// path to the previous desired node.
	if (Viewing == ViewNodes)
	{
		node = Level->NumNodes - 1, parent = node;
		while (depth < DesiredHistory.Size() && node == DesiredHistory[depth])
		{
			parent = node;
			node = Level->Nodes[node].children[PointOnSide (x, y, Level->Nodes[node])];
			depth++;
		}
	}
	else
	{
		node = Level->NumGLNodes - 1, parent = node;
		while (depth < DesiredHistory.Size() && node == DesiredHistory[depth])
		{
			parent = node;
			node = Level->GLNodes[node].children[PointOnSide (x, y, Level->GLNodes[node])];
			depth++;
		}
	}

	// If we traversed all the way through the history, the new desired
	// node is a child of the old one.
	if (depth == DesiredHistory.Size())
	{
		if (!(node & NFX_SUBSECTOR))
		{
			DesiredNode = node;
			DesiredHistory.Push (DesiredNode);
		}
	}
	// If we didn't make it all the way through the history, set the
	// desired node to this node's parent, so that the new desired node
	// will include both the old node and the one just clicked.
	else
	{
		DesiredHistory.Resize (depth);
		DesiredNode = DesiredHistory[depth-1];;
	}
}

static int DesiredSector;

static void DrawLevelReject (HDC dc)
{
	int seeFromRow = DesiredSector * Level->NumSectors();
	HPEN oldPen;
	HPEN cantSee;
	HPEN canSee;
	HPEN seeFrom;

	cantSee = CreatePen (PS_SOLID, 1, RGB(200,200,200));
	canSee = CreatePen (PS_SOLID, 1, RGB(200,0,200));
	seeFrom = CreatePen (PS_SOLID, 1, RGB(255,128,0));

	oldPen = (HPEN)SelectObject (dc, canSee);
	enum { UNDECIDED, CANT_SEE, CAN_SEE, SEE_FROM } choice, prevchoice = CAN_SEE;

	for (int i = 0; i < Level->NumLines(); ++i)
	{
		choice = UNDECIDED;

		if (Level->Lines[i].sidenum[0] != NO_INDEX)
		{
			if (Level->Sides[Level->Lines[i].sidenum[0]].sector == DesiredSector)
			{
				choice = SEE_FROM;
			}
			else if (Level->Reject != NULL)
			{
				int pnum = seeFromRow + Level->Sides[Level->Lines[i].sidenum[0]].sector;
				if (Level->Reject[pnum>>3] & (1<<(pnum&7)))
				{
					choice = CANT_SEE;
				}
				else
				{
					choice = CAN_SEE;
				}
			}
			else
			{
				choice = CAN_SEE;
			}
		}
		if (Level->Lines[i].sidenum[1] != NO_INDEX && choice < SEE_FROM)
		{
			if (Level->Sides[Level->Lines[i].sidenum[1]].sector == DesiredSector)
			{
				choice = SEE_FROM;
			}
			else if (Level->Reject != NULL && choice < CAN_SEE)
			{
				int pnum = seeFromRow + Level->Sides[Level->Lines[i].sidenum[1]].sector;
				if (Level->Reject[pnum>>3] & (1<<(pnum&7)))
				{
					choice = CANT_SEE;
				}
				else
				{
					choice = CAN_SEE;
				}
			}
			else
			{
				choice = CAN_SEE;
			}
		}
		if (choice != UNDECIDED)
		{
			if (choice != prevchoice)
			{
				prevchoice = choice;
				switch (choice)
				{
				case CANT_SEE:	SelectObject (dc, cantSee);	break;
				case CAN_SEE:	SelectObject (dc, canSee); break;
				case SEE_FROM:	SelectObject (dc, seeFrom); break;
				default: break;
				}
			}
			MoveToEx (dc, VERTX(Level->Lines[i].v1), VERTY(Level->Lines[i].v1), NULL);
			LineTo (dc, VERTX(Level->Lines[i].v2), VERTY(Level->Lines[i].v2));
		}
	}
	SelectObject (dc, oldPen);
	DeleteObject (cantSee);
	DeleteObject (canSee);
	DeleteObject (seeFrom);
}

static void DrawLevelPVS (HDC dc)
{
	HPEN oldPen;
	HPEN pen;
	HPEN mini;

	pen = CreatePen (PS_SOLID, 1, RGB(200,200,200));
	mini = CreatePen (PS_SOLID, 1, RGB(100,200,255));

	oldPen = (HPEN)SelectObject (dc, pen);

	int i, row = DesiredSubsector * Level->NumGLSubsectors;

	for (i = 0; i < Level->NumGLSubsectors; ++i)
	{
		int l = (row + i) >> 3;
		int r = (row + i) & 7;

		if (!(Level->GLPVS[l] & (1 << r)))
		{
			DrawSubsectorGL (dc, i, mini, mini);
		}
	}

	SelectObject (dc, oldPen);
	DeleteObject (pen);
	DeleteObject (mini);

	pen = CreatePen (PS_SOLID, 1, RGB(200,0,200));
	mini = CreatePen (PS_SOLID, 1, RGB(200,100,200));
	SelectObject (dc, pen);

	for (i = 0; i < Level->NumGLSubsectors; ++i)
	{
		int l = (row + i) >> 3;
		int r = (row + i) & 7;

		if (Level->GLPVS[l] & (1 << r))
		{
			DrawSubsectorGL (dc, i, mini, mini);
		}
	}

	SelectObject (dc, oldPen);
	DeleteObject (pen);
	DeleteObject (mini);

	pen = CreatePen (PS_SOLID, 1, RGB(255,128,0));
	mini = CreatePen (PS_SOLID, 1, RGB(255,150,100));
	SelectObject (dc, pen);

	DrawSubsectorGL (dc, DesiredSubsector, mini, mini);

	SelectObject (dc, oldPen);
	DeleteObject (pen);
	DeleteObject (mini);
}

static void SetDesiredSector (int x, int y)
{
	int node = Level->NumNodes - 1;
	const MapSegEx *seg;

	while (!(node & NFX_SUBSECTOR))
	{
		node = Level->Nodes[node].children[PointOnSide (x, y, Level->Nodes[node])];
	}
	node &= ~NFX_SUBSECTOR;
	seg = &Level->Segs[Level->Subsectors[node].firstline];
	DesiredSector = Level->Sides[Level->Lines[seg->linedef].sidenum[seg->side]].sector;
}

static void DrawLevel (HDC dc)
{
	switch (Viewing)
	{
	case ViewNodes:
	case ViewGLNodes:
		DrawLevelNodes (dc);
		break;
	case ViewSubsectors:
	case ViewGLSubsectors:
		DrawLevelSubsectors (dc);
		break;
	case ViewReject:
		DrawLevelReject (dc);
		break;
	case ViewPVS:
		DrawLevelPVS (dc);
		break;
	}
	/*
	int i;

	for (i = 0; i < Level->NumSegs; ++i)
	{
		MoveToEx (dc, VERTX(Level->Segs[i].v1), VERTY(Level->Segs[i].v1), NULL);
		LineTo (dc, VERTX(Level->Segs[i].v2), VERTY(Level->Segs[i].v2));
	}
	*/
}

void SizeView (HWND wnd, bool firstTime)
{
	RECT rect;
	SCROLLINFO sinfo = { sizeof(SCROLLINFO) };

	GetClientRect (wnd, &rect);
	sinfo.fMask = SIF_PAGE|SIF_RANGE|SIF_POS;

	GetScrollInfo (wnd, SB_VERT, &sinfo);
	sinfo.nMin = 0;
	sinfo.nMax = MapBounds.bottom - MapBounds.top;
	sinfo.nPage = rect.bottom;
	if (firstTime)
	{
		sinfo.nPos = 0;
	}
	else if (sinfo.nPos > sinfo.nMax - (int)sinfo.nPage)
	{
		int delta = sinfo.nPos - sinfo.nMax + (int)sinfo.nPage;
		ScrollWindowEx (wnd, 0, (delta + Divisor-1) / Divisor, NULL, NULL, NULL, NULL, SW_INVALIDATE|SW_ERASE);
		sinfo.nPos = sinfo.nMax - sinfo.nPage;
	}
	SetScrollInfo (wnd, SB_VERT, &sinfo, TRUE);

	GetScrollInfo (wnd, SB_HORZ, &sinfo);
	sinfo.nMin = 0;
	sinfo.nMax = MapBounds.right - MapBounds.left;
	sinfo.nPage = rect.right;
	if (firstTime)
	{
		sinfo.nPos = 0;
	}
	else if (sinfo.nPos > sinfo.nMax - (int)sinfo.nPage)
	{
		int delta = sinfo.nPos - sinfo.nMax + (int)sinfo.nPage;
		ScrollWindowEx (wnd, (delta + Divisor-1) / Divisor, 0, NULL, NULL, NULL, NULL, SW_INVALIDATE|SW_ERASE);
		sinfo.nPos = sinfo.nMax - sinfo.nPage;
	}
	SetScrollInfo (wnd, SB_HORZ, &sinfo, TRUE);
}

LRESULT CALLBACK MapViewFunc (HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	static bool dragging = false;
	static union { POINTS dragpos; LPARAM dragpos_lp; };
	static int hitx, hity;
	SCROLLINFO sinfo = { sizeof(SCROLLINFO), };
	int pos;

	switch (uMsg)
	{
	case WM_CREATE:
		SizeView (hWnd, true);
		break;

	case WM_SIZE:
		SizeView (hWnd, false);
		//InvalidateRect (hWnd, NULL, TRUE);
		break;

	case WM_PAINT:
		if (GetUpdateRect (hWnd, NULL, FALSE))
		{
			PAINTSTRUCT paint;
			HDC dc = BeginPaint (hWnd, &paint);

			if (dc != NULL)
			{
				sinfo.fMask = SIF_POS;
				GetScrollInfo (hWnd, SB_HORZ, &sinfo);
				pos = sinfo.nPos;
				GetScrollInfo (hWnd, SB_VERT, &sinfo);
				SetMapMode (dc, MM_ANISOTROPIC);
				ScaleWindowExtEx (dc, Divisor, 1, Divisor, -1, NULL);
				SetWindowOrgEx (dc, pos + MapBounds.left, MapBounds.bottom - sinfo.nPos, NULL);
				DrawLevel (dc);
				EndPaint (hWnd, &paint);
			}
		}
		return 0;

	case WM_LBUTTONDOWN:
		sinfo.fMask = SIF_POS;
		GetScrollInfo (hWnd, SB_HORZ, &sinfo);
		pos = sinfo.nPos;
		GetScrollInfo (hWnd, SB_VERT, &sinfo);
		hitx = LOWORD(lParam)*Divisor + pos + MapBounds.left;
		hity = MapBounds.bottom - sinfo.nPos - HIWORD(lParam)*Divisor;
		switch (Viewing)
		{
		case ViewNodes:
		case ViewGLNodes:
			SetDesiredNode (hitx, hity);
			PostMessage (GetParent (hWnd), WM_APP, DesiredNode, 0);
			break;
		case ViewSubsectors:
		case ViewGLSubsectors:
		case ViewPVS:
			SetDesiredSubsector (hitx, hity);
			PostMessage (GetParent (hWnd), WM_APP, DesiredSubsector, 0);
			break;
		case ViewReject:
			SetDesiredSector (hitx, hity);
			PostMessage (GetParent (hWnd), WM_APP, DesiredSector, 0);
			break;
		}
		InvalidateRect (hWnd, NULL, TRUE);
		return 0;

	case WM_HSCROLL:
		sinfo.fMask = SIF_POS|SIF_TRACKPOS|SIF_RANGE|SIF_PAGE;
		GetScrollInfo (hWnd, SB_HORZ, &sinfo);
		switch (LOWORD(wParam))
		{
		case SB_PAGEUP:			pos = sinfo.nPos - sinfo.nPage;		break;
		case SB_PAGEDOWN:		pos = sinfo.nPos + sinfo.nPage;		break;
		case SB_LINEUP:			pos = sinfo.nPos - 10;				break;
		case SB_LINEDOWN:		pos = sinfo.nPos + 10;				break;
		case SB_THUMBTRACK:		pos = sinfo.nTrackPos;				break;
		default:				pos = sinfo.nPos;
		};

		pos = clamp<int> (pos, 0, sinfo.nMax - sinfo.nPage);
		if (pos != sinfo.nPos)
		{
			SetScrollPos (hWnd, SB_HORZ, pos, TRUE);
			int oldx = sinfo.nPos / Divisor;
			int newx = pos / Divisor;
			ScrollWindowEx (hWnd, oldx - newx, 0, NULL, NULL, NULL, NULL, SW_INVALIDATE|SW_ERASE);
			UpdateWindow (hWnd);
		}
		return 0;

	case WM_VSCROLL:
		sinfo.fMask = SIF_POS|SIF_TRACKPOS|SIF_RANGE|SIF_PAGE;
		GetScrollInfo (hWnd, SB_VERT, &sinfo);
		switch (LOWORD(wParam))
		{
		case SB_PAGEUP:			pos = sinfo.nPos - sinfo.nPage;		break;
		case SB_PAGEDOWN:		pos = sinfo.nPos + sinfo.nPage;		break;
		case SB_LINEUP:			pos = sinfo.nPos - 10;				break;
		case SB_LINEDOWN:		pos = sinfo.nPos + 10;				break;
		case SB_THUMBTRACK:		pos = sinfo.nTrackPos;				break;
		default:				pos = sinfo.nPos;
		};

		pos = clamp<int> (pos, 0, sinfo.nMax - sinfo.nPage);
		if (pos != sinfo.nPos)
		{
			SetScrollPos (hWnd, SB_VERT, pos, TRUE);
			ScrollWindowEx (hWnd, 0, (sinfo.nPos - pos) / Divisor, NULL, NULL, NULL, NULL, SW_INVALIDATE|SW_ERASE);
			UpdateWindow (hWnd);
		}
		return 0;

	case WM_MOUSEWHEEL:
		sinfo.fMask = SIF_POS|SIF_RANGE|SIF_PAGE;
		GetScrollInfo (hWnd, SB_VERT, &sinfo);
		pos = sinfo.nPos - short(HIWORD(wParam))*64/WHEEL_DELTA;

		pos = clamp<int> (pos, 0, sinfo.nMax - sinfo.nPage);
		if (pos != sinfo.nPos)
		{
			SetScrollPos (hWnd, SB_VERT, pos, TRUE);
			ScrollWindowEx (hWnd, 0, (sinfo.nPos - pos) / Divisor, NULL, NULL, NULL, NULL, SW_INVALIDATE|SW_ERASE);
			UpdateWindow (hWnd);
		}
		return 0;

	case WM_RBUTTONDOWN:
		dragging = true;
		dragpos_lp = lParam;	// also sets dragpos; avoids type-punned dereference warning from GCC
		//dragpos = MAKEPOINTS(lParam);
		return 0;

	case WM_RBUTTONUP:
		dragging = false;
		return 0;

	case WM_MOUSEMOVE:
		if (!(wParam & MK_RBUTTON))
		{
			dragging = false;
		}
		else if (dragging)
		{
			union { POINTS newpos; LPARAM newpos_lp; };
			int delta;

			newpos_lp = lParam;
			delta = (newpos.x - dragpos.x) * 8;
			if (delta)
			{
				sinfo.fMask = SIF_POS|SIF_RANGE|SIF_PAGE;
				GetScrollInfo (hWnd, SB_HORZ, &sinfo);
				pos = sinfo.nPos - delta;

				pos = clamp<int> (pos, 0, sinfo.nMax - sinfo.nPage);
				if (pos != sinfo.nPos)
				{
					SetScrollPos (hWnd, SB_HORZ, pos, TRUE);
					ScrollWindowEx (hWnd, (sinfo.nPos - pos) / Divisor, 0, NULL, NULL, NULL, NULL, SW_INVALIDATE|SW_ERASE);
					UpdateWindow (hWnd);
				}
			}
			delta = (newpos.y - dragpos.y) * 8;
			if (delta)
			{
				sinfo.fMask = SIF_POS|SIF_RANGE|SIF_PAGE;
				GetScrollInfo (hWnd, SB_VERT, &sinfo);
				pos = sinfo.nPos - delta;

				pos = clamp<int> (pos, 0, sinfo.nMax - sinfo.nPage);
				if (pos != sinfo.nPos)
				{
					SetScrollPos (hWnd, SB_VERT, pos, TRUE);
					ScrollWindowEx (hWnd, 0, (sinfo.nPos - pos) / Divisor, NULL, NULL, NULL, NULL, SW_INVALIDATE|SW_ERASE);
					UpdateWindow (hWnd);
				}
			}
			dragpos = newpos;
			return 0;
		}
	}
	return DefWindowProc (hWnd, uMsg, wParam, lParam);
}

void ShowView (FLevel *level)
{
	LOGBRUSH WhiteBrush = { BS_SOLID, RGB(255,255,255), 0 };
	WNDCLASS MapViewerClass =
	{
		0,
		MapViewFunc,
		0,
		0,
		GetModuleHandle(0),
		0,
		LoadCursor (0, IDC_ARROW),
		CreateBrushIndirect (&WhiteBrush),
		0,
		"MapViewer"
	};

	if (RegisterClass (&MapViewerClass))
	{
		Level = level;

		if (level->Blockmap != NULL)
		{
			MapBounds.left = short(level->Blockmap[0]) - 8;
			MapBounds.right = short(level->Blockmap[0]) + (level->Blockmap[2] << BLOCKBITS) + 8;
			MapBounds.top = short(level->Blockmap[1]) - 8;
			MapBounds.bottom = short(level->Blockmap[1]) + (level->Blockmap[3] << BLOCKBITS) + 8;
		}
		else
		{
			MapBounds.left = level->MinX >> FRACBITS;
			MapBounds.right = level->MaxX >> FRACBITS;
			MapBounds.top = level->MinY >> FRACBITS;
			MapBounds.bottom = level->MaxY >> FRACBITS;
		}
		MapSize.x = MapBounds.right - MapBounds.left;
		MapSize.y = MapBounds.bottom - MapBounds.top;
		Divisor = 1;

		if (Level->Subsectors == NULL)
		{
			Viewing = ViewGLSubsectors;
		}
		else
		{
			Viewing = ViewSubsectors;
		}

		ResetViews ();
		DialogBox (GetModuleHandle(0), MAKEINTRESOURCE(IDD_MAPVIEW), NULL, ViewDialogFunc);
		UnregisterClass ("MapViewer", GetModuleHandle(0));
	}
}

void ResetViews ()
{
	DesiredHistory.Clear ();
	if (Viewing == ViewNodes)
	{
		DesiredNode = Level->NumNodes - 1;
	}
	else
	{
		DesiredNode = Level->NumGLNodes - 1;
	}
	DesiredHistory.Push (DesiredNode);
	DesiredSubsector = 0;
	DesiredSector = 0;
}

#endif /* !NO_MAP_VIEWER */
