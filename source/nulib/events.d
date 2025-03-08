module nulib.events;
import nulib.collections.vector;
import nulib.collections.map;
import numem.core.traits;
import numem.core.lifetime;
import numem.object;

alias Event(RecvType, ArgTypes...) = void function(void* sender, RecvType self, ArgsTypes...) @nogc;

/**
    An event handler, which allows mass dispatching to callbacks.

    Params:
        RecvType = The (base) type of the reciever object.
        ArgTypes = The types of the arguments to pass to the reciever handler.
*/
struct EventHandler(RecvType, ArgTypes...) {
private:
@nogc:
    struct _EventListener {
        RecvType listener;
        Event!(RecvType, ArgTypes) callback;
    }

    vector!_EventListener listeners_;

    ptrdiff_t findListener(RecvType recv) {
        foreach(i; 0..listeners_.length) {
            if (listeners_[i] is recv) {
                return i;
            }
        }
        return -1;
    }

    void addListener(_EventListener listener) {
        if (findListener(listener.listener) >= 0)
            return;
        
        static if (isValidObjectiveC!RecvType) {
            listener.listener.retain();
        } else static if (is(T : NuRefCounted)) {
            listener.listener.retain();
        }

        listeners_ ~= listener;
    }

    void removeListener(RecvType listener) {
        if (auto lidx = findListener(listener.listener) >= 0) {
            listeners_.remove(lidx);
        }
    }

public:
    alias EventType = Event!(RecvType, ArgTypes);


    /**
        The amount of listeners currently bound to the event handler.
    */
    @property size_t listeners() { return listeners_.length; }

    /**
        Adds a listener to the event.
    */
    void opOpAssign(string op = "~", alias sptr = this)(EventType callback, RecvType self = sptr) {
        this.addListener(_EventListener(self, callback));
    }

    /**
        Removes a listener from the event.
    */
    void opOpAssign(string op = "-", alias sptr = this)(RecvType self) {
        this.removeListener(self);
    }
}