#ifndef FILENAME_FORMATTER_NODES_H
#define FILENAME_FORMATTER_NODES_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdbool.h>

#define TOK_EOF 1

extern void year(void);
extern void month(void);
extern void day(void);
extern void hour(void);
extern void minute(void);
extern void second(void);
extern void game(void);
extern void engine(void);
extern void theme(void);
extern void version(void);
extern void count(void);
extern void raw_append(const char *string);

#ifdef __cplusplus
}
#endif

#endif  // FILENAME_FORMATTER_NODES_H
