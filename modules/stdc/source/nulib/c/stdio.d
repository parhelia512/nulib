/**
    Bindings to C standard library I/O functions.

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.c.stdio;
import numem.compiler;

static if (!NU_COMPILER_STRICT_TYPES) {
    
    /**
        Opaque File Handle
    */
    struct FILE;
} else {
    
    // Fallback for compilers with strict types.
    import drt = core.stdc.stdio;
    alias FILE = drt.FILE;
}

extern(C) nothrow @nogc:

enum {
    /**
        Offset is relative to the beginning.
    */
    SEEK_SET,

    /**
        Offset is relative to the current position.
    */
    SEEK_CUR,
    
    /**
        Offset is relative to the end.
    */
    SEEK_END
}

enum {

    /**
        End-of-file
    */
    EOF = -1
}

/**
    Prints a formatted string.

    Params:
        format = The format string.
        ...    = Arguments following `format`.

    Returns:
        On success, the total number of characters written is returned.
*/
pragma(printf)
extern int printf(const(char)* format, ...) @trusted pure;

/**
    Prints a formatted string to a sized buffer.

    Params:
        buffer =    The buffer to write to.
        size   =    The size of the buffer.
        format =    The format string.
        ...    =    Arguments following `format`.

    Returns:
        On success, the total number of characters written is returned.
        A terminating $(D '\0') is automatically written to the buffer after
        the content.
*/
pragma(printf)
extern int snprintf(char* buffer, size_t size, const(char)* format, ...) @trusted pure;

/**
    Prints a formatted string to a buffer.

    Params:
        buffer =    The buffer to write to.
        format =    The format string.
        ...    =    Arguments following `format`.

    Returns:
        On success, the total number of characters written is returned.
        A terminating $(D '\0') is automatically written to the buffer after
        the content.
*/
pragma(printf)
extern int sprintf(char* buffer, const(char)* format, ...) @system pure;

/**
    Reads a data from stdin with a given format.

    Params:
        format = The format string.
        ...    = Arguments following `format`.

    Returns:
        The amount of items successfully filled.
*/
pragma(scanf)
extern int scanf(const(char)* format, ...) @trusted pure;

/**
    Reads a data from a string with a given format.

    Params:
        s       = The input string.
        format  = The format string.
        ...     = Arguments following `format`.

    Returns:
        The amount of items successfully filled.
*/
pragma(scanf)
extern int sscanf(const(char)* s, const(char)* format, ...) @trusted pure;

/**
    Writes the last reported error to stderr.

    Params:
        str = Optional string to preprend to the error.
*/
extern void perror(const(char)* str = null) @trusted pure;

/**
    Opens the file with the given file name and mode.

    Params:
        filename =  The name and path of the file to open, in system encoding.
        mode =      The mode to open the file in.

    Returns:
        A file handle on success, $(D null) on failure.
*/
extern FILE* fopen(const(char)* filename, const(char)* mode);

/**
    Opens the file with the given file name and mode.

    Params:
        filename =  The name and path of the file to open, in UTF-16.
        mode =      The mode to open the file in.

    Returns:
        A file handle on success, $(D null) on failure.
*/
version (CRuntime_Microsoft)
extern FILE* _wfopen(const(wchar)* filename, const(wchar)* mode);

/**
    Flushes the stream.

    If the stream provided is $(D null), all streams are flushed.
    The stream remains open after this call.

    Params:
        stream =    Pointer to a $(D FILE)

    Returns:
        0 on success, $(D EOF) on failure.
*/
extern int fflush(FILE* stream) @trusted;

/**
    Closes the stream. 

    Params:
        stream =    Pointer to a $(D FILE)

    Returns:
        0 on success, $(D EOF) on failure.
*/
extern int fclose(FILE* stream);

/**
    Gets the current position in the stream.

    Params:
        stream =    Pointer to a $(D FILE)

    Returns:
        0 on success.
*/
extern ptrdiff_t ftell(FILE* stream);

/**
    Sets the position of the stream.

    Params:
        stream =    Pointer to a $(D FILE)
        offset =    Offset into the stream.
        origin =    The origin to seek from.

    Returns:
        0 on success.
*/
extern int fseek(FILE* stream, ptrdiff_t offset, int origin);

/**
    Sets the position of the stream to its beginning.

    Params:
        stream =    Pointer to a $(D FILE)
*/
extern void rewind(FILE* stream);

/**
    Reads data from the stream.

    Params:
        ptr =       Buffer to write to.
        size =      Size of a single unit of data in bytes
        count =     The amount of units to write to the buffer.
        stream =    The stream to read from.
    
    Returns:
        The amount of elements read.
*/
extern size_t fread(void* ptr, size_t size, size_t count, FILE* stream);

/**
    Writes data to the stream.

    Params:
        ptr =       The buffer to write to.
        size =      Size of a single unit of data in bytes
        count =     The amount of units to write to the file.
        stream =    The stream to write to.
    
    Returns:
        The amount of elements written.
*/
extern size_t fwrite(const(void)* ptr, size_t size, size_t count, FILE* stream);

/**
    Creates a temporary file handle.

    This handle is not backed by a real file.

    Returns:
        A file handle on success, $(D null) on failure.
*/
extern FILE* tmpfile();

/**
    Generates a temporary file name.

    Params:
        str = The buffer that should store the name, or $(D null).

    Returns:
        The buffer containing the name.
*/
extern char* tmpnam(char* str);

/**
    Removes the given file.

    Params:
        path = Path to the file to remove, in system encoding.
    
    Returns:
        0 on success.
*/
extern int remove(const(char)* path);

/**
    Removes the given file.

    Params:
        path = Path to the file to remove, in UTF-16 encoding.
    
    Returns:
        0 on success.
*/
version (CRuntime_Microsoft)
extern int _wremove(const(wchar)* path);

/**
    Renames the given file.

    Params:
        oldName =   Path to the file to rename, in system encoding.
        newName =   The new path of the file, in system encoding.
    
    Returns:
        0 on success.
*/
extern int rename(const(char)* oldName, const(char)* newName);

/**
    Renames the given file.

    Params:
        oldName =   Path to the file to rename, in UTF-16 encoding.
        newName =   The new path of the file, in UTF-16 encoding.
    
    Returns:
        0 on success.
*/
version (CRuntime_Microsoft)
extern int _wrename(const(wchar)* oldName, const(wchar)* newName);
