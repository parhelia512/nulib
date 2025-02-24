/**
    GLib Errors and Quarks.

    Copyright: Copyright © 1995-1997, Peter Mattis, Spencer Kimball and Josh MacDonald
    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 https://gitlab.gnome.org/GNOME/glib/-/blob/main/LICENSES/LGPL-2.1-or-later.txt, LGPL-2.1-or-later)
    Authors:   Luna Nielsen
*/
module nulib.glib.gerror;
import nulib.string;
import numem;

enum gIsModuleString(alias sym) = 
    is(typeof(sym) == inout(char)*) &&
    !__traits(compiles, { sym = "New value"; });

/**
    An index into the string table of GLib.
*/
struct GQuark {
@nogc nothrow:
private:
    uint g_value = 0;

public:
    alias toString this;
    @disable this();

    /**
        The index value of the quark.
    */
    @property uint value() { return g_value; }

    /**
        The underlying C string for this quark.
    */
    @property const(char)* ptr() { return g_quark_to_string(this); }
    
    /**
        Tries to find a quark by its string value.

        Params:
            value = The string to search for.
        
        Returns:
            A GQuark, check its validity with $(D isValid)

        Note:
            This function must not be used before library 
            constructors have finished running.
    */
    static GQuark find(inout(char)* value) {
        return g_quark_try_string(value);
    }

    /**
        Creates a GQuark from a null-terminated string.
    */
    static GQuark fromString(ref inout(char)* value) {
        return g_quark_from_string(value);
    }

    /**
        Creates a GQuark from a slice based string.
    */
    static GQuark fromString(ref inout(char)[] value) {
        return g_quark_from_string(nstring(value).ptr); // nstring null terminates the string.
    }

    /**
        Creates a quark from a static string reference.
        
        Static strings can only appear on a module level.
    */
    static GQuark fromString(alias staticString)() if (gIsModuleString!staticString) {
        return g_quark_from_static_string(staticString);
    }

    /**
        Gets whether the GQuark contains a valid value.

        Returns:
            $(D true) if the GQuark contains a value other than 0,
            $(D false) otherwise.
    */
    bool isValid() {
        return value != 0;
    }

    /**
        Gets a string from the GQuark, the GQuark owns the string
        and it should not be freed.
    */
    string toString() {
        const(char)* text = g_quark_to_string(this);
        return cast(string)text[0..nu_strlen(text)];
    }
}

/**
    Type of error codes that may be returned by GError.
*/
alias GErrorCode = int;

/**
    A GLib error containing information about errors which have occured.

    Note:
        GErrors are not reference counted, you will need to manually free
        them using $(D GError.free).
*/
struct GError {
@nogc nothrow:
private:
    GQuark g_domain;
    GErrorCode g_code;
    const(char)* g_message;

public:
    @disable this();

    /**
        The domain of the error.
    */
    @property GQuark domain() { return g_domain; }

    /**
        The GLib Error Code of the Error.
    */
    @property GErrorCode code() { return g_code; }

    /**
        The error message.
    */
    @property string message() { return g_message is null ? null : cast(string)g_message[0..nu_strlen(g_message)]; }

    /**
        Creates a new GError with the specified format string.

        Params:
            domain =    The error domain in which to create the error.
            code =      The $(D GErrorCode) of the error.
            format =    The format string for the error text.
            args =      Arguments to pass to the format function.
        
        Returns:
            A newly allocated GError.
    */
    static GError* create(Args...)(GQuark domain, GErrorCode code, const(char)* format, Args args) {
        return g_error_new(domain, code, format, args);
    }

    /**
        Frees self.
    */
    void free() { g_error_free(&this); }

    /**
        Checks for equality between GError instances.

        Params:
            other = the error to compare with

        Returns:
            $(D true) if other refers to the same kind of error,
            $(D false) otherwise.
    */
    bool opEquals(inout(GError)* other) {
        return g_error_matches(other, domain, code);
    }

    /**
        Wraps the GError into an exception.

        Params:
            nextInChain =   Next exception in the exception chain, if any.
            file        =   The file the error occured in, automatically 
                            filled out by the compiler.
            line        =   The line on which the exception was created,
                            automatically filled out by the compiler.
        
        Returns:
            A new GException wrapping a $(B copy) of the GError,
            the original value is freed by this call.
            Attempting to access the GError after wrapping it in a
            GException is undefined behaviour, but probably a crash.

        Examples:
            ---
            GError* err;
            g_thread_try_new(null, (void* value) { return null; }, null, err);
            if (err)
                throw err.toException();
            ---
    */
    pragma(inline, true)
    GException toException(Throwable nextInChain = null, string file = __FILE__, size_t line = __LINE__) {
        auto g_error_copied = g_error_copy(&this);
        g_error_free(&this);
        return assumeNoThrowNoGC(
            (GError* err, Throwable nextInChain, string file, size_t line) { return nogc_new!GException(err, nextInChain, file, line); },
            g_error_copied, 
            nextInChain, 
            file, 
            line
        );
    }
}

/**
    Wrapper for GErrors.

    GExceptions allow for GErrors to be thrown into D code for handling,
    the GError will automatically be freed when the GException is freed.
*/
class GException : NuException {
@nogc:
private:
    GError* g_error;

public:

    /**
        Constructs a GException from a GError.
    */
    this(GError* error, Throwable nextInChain = null, string file = __FILE__, size_t line = __LINE__) {
        this.g_error = error;
        super(g_error.message, nextInChain, file, line);
    }

    /**
        Frees the GException.
    */
    override
    void free() @trusted {
        super.free();
        g_error_free(g_error);
    }
}

extern(C) @nogc nothrow:

/**
    Returns a canonical representation for string.
    Interned strings can be compared for equality by 
    comparing the pointers, instead of using strcmp().
    
    g_intern_static_string() does not copy the string,
    therefore string must not be freed or modified.
*/
extern const(char)* g_intern_static_string(const(char)* str);

private:

// GQuark
extern GQuark g_quark_from_static_string(const const(char)* str);
extern GQuark g_quark_from_string(const(char)* str);
extern const(char)* g_quark_to_string(GQuark quark);
extern GQuark g_quark_try_string(const(char)* str);

// GError
extern void g_error_free(GError* error);
extern GError* g_error_copy(const(GError)* error);
extern GError* g_error_new(GQuark domain, int code, const(char)* format, ...);
extern bool g_error_matches(const(GError)* error, GQuark domain, int code);