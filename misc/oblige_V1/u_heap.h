//----------------------------------------------------------------------------
//  Priority HEAP
//----------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2005 Andrew Apted
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

#ifndef __OBLIGE_HEAP_H__
#define __OBLIGE_HEAP_H__


class priority_heap_c
{
public:
	priority_heap_c(int _size);
	~priority_heap_c();

private:
	int total_size;

	int *heap;
	int heap_size;

	int *score;  // score for each node (indexed by node number)
	int *map;    // maps node index --> (heap index + 1), zero => not present

public:
	void Clear();

	inline bool IsEmpty() { return (heap_size == 0); }

	bool IsMapped(int node);

	void Insert(int node, int nd_score);
	// insert a node into the heap.  The node must not be present
	// already.

	void Change(int node, int nd_score);
	// change the score for a node.  Causes heap to be re-adjusted.

	int RemoveHead(int *nd_score = NULL);
	// removes the top-most node and returns it.  Must not be called
	// on an empty heap.

	void DebugDump(int h_idx = 0, int level = 0);

private:
	inline int Par(int h_idx) const
	{
		return (h_idx+1) / 2 - 1;
	}

	inline int Left(int h_idx) const
	{
		return (h_idx+1) * 2 - 1;
	}

	inline int Right(int h_idx) const
	{
		return (h_idx+1) * 2;
	}

	inline bool HasLeft(int h_idx) const
	{
		return Left(h_idx) < heap_size;
	}

	inline bool HasRight(int h_idx) const
	{
		return Right(h_idx) < heap_size;
	}

	void Adjust(int h_idx);
	// handles trickle up and down.

	void Validate(int h_idx);
	// debugging support -- check if heap is valid.

	inline void Swap(int i, int j)
	{
		int tmp = heap[i];
		heap[i] = heap[j];
		heap[j] = tmp;

		map[heap[i]] = i+1;
		map[heap[j]] = j+1;
	}

	inline int ScoreAt(int h_idx) { return score[heap[h_idx]]; }
};

#endif  /* __OBLIGE_HEAP_H__ */
