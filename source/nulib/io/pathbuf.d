/**
    Path buffers

    Contains helpers for constructing paths in a type-safe way.

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.io.pathbuf;
import nulib.string;

version(Windows) enum NU_PATHSEP = "\\";
else enum NU_PATHSEP = "/";

/**
    Nulib Pathbuffer.
*/
struct PathBuf {
@nogc nothrow:
private:
    nstring store;

public:
    
}