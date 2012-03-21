/*
 * To generate test coverage files with LLVM compliers
 *
 * http://stackoverflow.com/questions/8732393/code-coverage-with-xcode-4-2-missing-files
 */

#include <stdio.h>

FILE *fopen$UNIX2003(const char *filename, const char *mode);
size_t fwrite$UNIX2003(const void *ptr, size_t size, size_t nitems, FILE *stream);

FILE *fopen$UNIX2003(const char *filename, const char *mode)
{
    return fopen(filename, mode);
}

size_t fwrite$UNIX2003(const void *ptr, size_t size, size_t nitems, FILE *stream)
{
    return fwrite(ptr, size, nitems, stream);
}
