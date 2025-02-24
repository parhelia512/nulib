/**
    GLib Logging

    Copyright: Copyright © 1995-1997, Peter Mattis, Spencer Kimball and Josh MacDonald
    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 https://gitlab.gnome.org/GNOME/glib/-/blob/main/LICENSES/LGPL-2.1-or-later.txt, LGPL-2.1-or-later)
    Authors:   Luna Nielsen
*/
module nulib.glib.glog;

/**
    Flags specifying the level of log messages.
*/
alias GLogLevel = int;
enum GLogLevel
    G_LOG_FLAG_RECURSION = 1,
    G_LOG_FLAG_FATAL = 2,
    G_LOG_LEVEL_ERROR = 4,
    G_LOG_LEVEL_CRITICAL = 8,
    G_LOG_LEVEL_WARNING = 16,
    G_LOG_LEVEL_MESSAGE = 32,
    G_LOG_LEVEL_INFO = 64,
    G_LOG_LEVEL_DEBUG = 128,
    G_LOG_LEVEL_MASK = -4;

/**
    Convenience template which calls $(D g_log) for you
    with the log level set to info.
*/
pragma(inline, true)
void g_info(Args...)(const(char)* log_domain, const(char)* format, Args args) {
    g_log(log_domain, G_LOG_LEVEL_INFO, format, args);
}

/**
    Convenience template which calls $(D g_log) for you
    with the log level set to message.
*/
pragma(inline, true)
void g_message(Args...)(const(char)* log_domain, const(char)* format, Args args) {
    g_log(log_domain, G_LOG_LEVEL_MESSAGE, format, args);
}

/**
    Convenience template which calls $(D g_log) for you
    with the log level set to debug.
*/
pragma(inline, true)
void g_debug(Args...)(const(char)* log_domain, const(char)* format, Args args) {
    g_log(log_domain, G_LOG_LEVEL_DEBUG, format, args);
}

/**
    Convenience template which calls $(D g_log) for you
    with the log level set to warning.
*/
pragma(inline, true)
void g_warning(Args...)(const(char)* log_domain, const(char)* format, Args args) {
    g_log(log_domain, G_LOG_LEVEL_WARNING, format, args);
}

/**
    Convenience template which calls $(D g_log) for you
    with the log level set to error.
*/
pragma(inline, true)
void g_error(Args...)(const(char)* log_domain, const(char)* format, Args args) {
    g_log(log_domain, G_LOG_LEVEL_ERROR, format, args);
}

/**
    Convenience template which calls $(D g_log) for you
    with the log level set to error, if the $(D expr) evaluates truthily.
*/
pragma(inline, true)
void g_errorif(Expr, Args...)(Expr expr, const(char)* log_domain, const(char)* format, Args args) {
    if (expr)
        g_log(log_domain, G_LOG_LEVEL_ERROR, format, args);
}

extern (C) nothrow @nogc:

/**
    Logs an error or debugging message.
*/
extern void g_log(const(char)* log_domain, GLogLevel log_level, const(char)* format, ...);