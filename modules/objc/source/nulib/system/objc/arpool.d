/**
    Objective-C numem auto release pool hooks.

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.system.objc.arpool;
import objc.autorelease;

private:

extern(C)
export
__gshared void* function() @nogc nothrow @system nuopt_autoreleasepool_push = () {
    return autoreleasepool_push().ctxptr;
};

extern(C)
export
__gshared void function(void*) @nogc nothrow @system nuopt_autoreleasepool_pop = (void* ctxptr) {
    autoreleasepool_pop(arpool_ctx(ctxptr));
};