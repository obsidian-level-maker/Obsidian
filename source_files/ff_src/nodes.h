#ifndef DPARSE_NONSENSE_NODES_H
#define DPARSE_NONSENSE_NODES_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdbool.h>

enum token {
    tokLiteral,
    tokYear,
    tokMonth,
    tokDay,
    tokHour,
    tokMinute,
    tokSecond,
    tokGame,
    tokVersion,
    tokTheme,
    tokCount,
    tokEof,
};

typedef struct {
    enum token t;
    bool isLeaf;
} My_ParseNode;

#define D_ParseNode_User My_ParseNode

extern void year(void);
extern void month(void);
extern void day(void);
extern void hour(void);
extern void minute(void);
extern void second(void);
extern void game(void);
extern void theme(void);
extern void version(void);
extern void count(void);

#ifdef __cplusplus
}
#endif

#endif  // DPARSE_NONSENSE_NODES_H
