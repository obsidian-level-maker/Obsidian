//------------------------------------------------------------------------
//  LIST library
//------------------------------------------------------------------------
//
//  GL-Node Viewer (C) 2004-2007 Andrew Apted
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

#ifndef __NODEVIEW_LIST_H__
#define __NODEVIEW_LIST_H__

// (Yes, I'm probably nuts for not using std::list)

class listnode_c
{
friend class list_c;

private:
  listnode_c *nd_next;
  listnode_c *nd_prev;

public:
  listnode_c() : nd_next(NULL), nd_prev(NULL) { }
  listnode_c(const listnode_c& other) : nd_next(other.nd_next),
    nd_prev(other.nd_prev) { }
  ~listnode_c() { }

  inline listnode_c& operator= (const listnode_c& rhs)
  {
    if (this != &rhs)
    {
      nd_next = rhs.nd_next;
      nd_prev = rhs.nd_prev;
    }
    return *this;
  }

  inline listnode_c *NodeNext() const { return nd_next; }
  inline listnode_c *NodePrev() const { return nd_prev; }
};

class list_c
{
private:
  listnode_c *head;
  listnode_c *tail;

public:
  list_c() : head(NULL), tail(NULL) { }
  list_c(const list_c& other) : head(other.head), tail(other.tail) { }
  ~list_c() { }

  inline list_c& operator= (const list_c& rhs)
  {
    if (this != &rhs)
    {
      head = rhs.head;
      tail = rhs.tail;
    }
    return *this;
  }

  void clear()
  {
    head = NULL;
    tail = NULL;
  }

  inline listnode_c *begin() const { return head; }
  inline listnode_c *end()   const { return tail; }

  // insert_before
  // insert_after

  void remove(listnode_c *cur)
  {
    SYS_NULL_CHECK(cur);

    if (cur->nd_next)
      cur->nd_next->nd_prev = cur->nd_prev;
    else
      tail = cur->nd_prev;

    if (cur->nd_prev)
      cur->nd_prev->nd_next = cur->nd_next;
    else
      head = cur->nd_next;
  }

  void push_back(listnode_c *cur)
  {
    cur->nd_next = NULL;
    cur->nd_prev = tail;

    if (tail)
      tail->nd_next = cur;
    else
      head = cur;

    tail = cur;
  }

  void push_front(listnode_c *cur)
  {
    cur->nd_next = head;
    cur->nd_prev = NULL;

    if (head)
      head->nd_prev = cur;
    else
      tail = cur;

    head = cur;
  }

  inline listnode_c *pop_back()
  {
    listnode_c *cur = tail;

    if (cur)
      remove(cur);

    return cur;
  }

  inline listnode_c *pop_front()
  {
    listnode_c *cur = head;

    if (cur)
      remove(cur);

    return cur;
  }
};

#endif /* __NODEVIEW_LIST_H__ */
