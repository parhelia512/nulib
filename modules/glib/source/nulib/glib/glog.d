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

extern (C) nothrow @nogc:

/**
    Logs an error or debugging message.
*/
extern void g_log(const(char)* log_domain, GLogLevel log_level, const(char)* format, ...);