/**
    Associative Arrays

    This module implements BTree-backed associative arrays.
    @nogc associative array, replacement for std::map.

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    Copyright: Guillaume Piolat 2015-2024.
    Copyright: Copyright (C) 2008- by Steven Schveighoffer. Other code
    Copyright: 2010- Andrei Alexandrescu. All rights reserved by the respective holders.
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   
        Steven Schveighoffer, 
        $(HTTP erdani.com, Andrei Alexandrescu), 
        Guillaume Piolat,
        Luna Nielsen
*/
module nulib.collections.map;
import nulib.collections.internal.btree;
import numem;

@nogc:

/**
    An associative container which contains key-value pairs.

    Notes:
        Weak types do not own the memory of their contents.
        It is up to you to free any indicies.
*/
alias weak_map(Key, Value) = MapImpl!(Key, Value, (a, b) => a < b, false, false);

/**
    An associative container which contains key-value pairs.
*/
alias map(Key, Value) = MapImpl!(Key, Value, (a, b) => a < b, false, true);

/**
    An associative container which contains key-value pairs.

    A multimap may contain multiple entries with the same $(D Key) value.

    Notes:
        Weak types do not own the memory of their contents.
        It is up to you to free any indicies.
*/
alias weak_multimap(Key, Value) = MapImpl!(Key, Value, (a, b) => a < b, true, false);

/**
    An associative container which contains key-value pairs.

    A multimap may contain multiple entries with the same $(D Key) value.
*/
alias multimap(Key, Value) = MapImpl!(Key, Value, (a, b) => a < b, true, true);

/**
    Tree-map, designed to replace std::map usage.
    The API should looks closely like the builtin associative arrays.
    O(log(n)) insertion, removal, and search time.
*/
struct MapImpl(K, V, alias less = KeyCompareDefault!Key, bool allowDuplicates = false, bool ownsMemory = false) {
public:
@nogc:

    @disable this(this);

    @trusted
    ~this() {
    }

    /// Insert an element in the container, if the container doesn't already contain 
    /// an element with equivalent key. 
    /// Returns: `true` if the insertion took place.
    @trusted
    bool insert(K key, V value) {
        return _tree.insert(key, value);
    }

    /// Removes an element from the container.
    /// Returns: `true` if the removal took place.
    @trusted
    bool remove(K key) {

        // Delete memory if this map owns it.
        static if (ownsMemory) {
            if (key in _tree) {
                nogc_delete(_tree[key]);
            }
        }

        return _tree.remove(key) != 0;
    }

    /// Removes all elements from the map.
    @trusted
    void clearContents() {
        nogc_delete(_tree);
        // _tree reset to .init, still valid
    }

    /// Returns: A pointer to the value corresponding to this key, or null if not available.
    ///          Live builtin associative arrays.
    @trusted
    inout(V)* opBinaryRight(string op)(K key) inout if (op == "in") {
        return key in _tree;
    }

    /// Returns: A reference to the value corresponding to this key.
    ///          Null pointer crash if key doesn't exist. 
    @trusted
    ref inout(V) opIndex(K key) inout {
        inout(V)* p = key in _tree;
        assert(p !is null);
        return *p;
    }

    /// Updates a value associated with a key, creates it if necessary.
    @trusted
    void opIndexAssign(V value, K key) {
        V* p = key in _tree;
        if (p is null) {
            insert(key, value); // PERF: this particular call can assume no-dupe
        } else
            *p = value;
    }

    /// Returns: `true` if this key is contained.
    @trusted
    bool contains(K key) const {
        return _tree.contains(key);
    }

    /// Returns: Number of elements in the map.
    @trusted
    size_t length() const {
        return _tree.length;
    }

    /// Returns: `ttue` is the map has no element.
    @trusted
    bool empty() const {
        return _tree.empty;
    }

    // Iterate by value only

    /// Fetch a forward range on all values.
    @trusted
    auto byValue() {
        return _tree.byValue();
    }

    /// ditto
    @trusted
    auto byValue() const {
        return _tree.byValue();
    }

    // default opSlice is like byValue for builtin associative arrays
    alias opSlice = byValue;

    // Iterate by key only

    /// Fetch a forward range on all keys.
    @trusted
    auto byKey() {
        return _tree.byKey();
    }

    /// ditto
    @trusted
    auto byKey() const {
        return _tree.byKey();
    }

    // Iterate by key-value
    @trusted
    auto byKeyValue() {
        return _tree.byKeyValue();
    }

    /// ditto
    @trusted
    auto byKeyValue() const {
        return _tree.byKeyValue();
    }

    /+
    // Iterate by single value (return a range where all elements have equal key)

    /// Fetch a forward range on all elements with given key.
    Range!(MapRangeType.value) byGivenKey(K key)
    {
       if (!isInitialized)
            return Range!(MapRangeType.value).init;

        auto kv = KeyValue(key, V.init);
        return Range!(MapRangeType.value)(_rbt.range(kv));
    }

    /// ditto
    ConstRange!(MapRangeType.value) byGivenKey(K key) const
    {
        if (!isInitialized)
            return ConstRange!(MapRangeType.value).init;

        auto kv = KeyValue(key, V.init);
        return ConstRange!(MapRangeType.value)(_rbt.range(kv));
    }

    /// ditto
    ImmutableRange!(MapRangeType.value) byGivenKey(K key) immutable
    {
        if (!isInitialized)
            return ImmutableRange!(MapRangeType.value).init;

        auto kv = KeyValue(key, V.init);
        return ImmutableRange!(MapRangeType.value)(_rbt.range(kv));
    }*
    +/

private:

    alias InternalTree = BTree!(K, V, less, allowDuplicates, false);
    InternalTree _tree;
}

@("map: initialization")
unittest {
    // It should be possible to use most function of an uninitialized Map
    // All except functions returning a range will work.
    map!(int, string) m;

    assert(m.length == 0);
    assert(m.empty);
    assert(!m.contains(7));

    auto range = m.byKey();
    assert(range.empty);
    foreach (e; range) {
    }

    m[1] = "fun";
}

@("map: key collission")
unittest {
    void test(bool removeKeys) @nogc {
        {
            auto test = nogc_new!(map!(int, string))();
            int N = 100;
            foreach (i; 0 .. N) {
                int key = (i * 69069) % 65536;
                test.insert(key, "this is a test");
            }
            foreach (i; 0 .. N) {
                int key = (i * 69069) % 65536;
                assert(test.contains(key));
            }

            if (removeKeys) {
                foreach (i; 0 .. N) {
                    int key = (i * 69069) % 65536;
                    test.remove(key);
                }
            }
            foreach (i; 0 .. N) {
                int key = (i * 69069) % 65536;
                assert(removeKeys ^ test.contains(key)); // either keys are here or removed
            }
        }
    }

    test(true);
    test(false);
}

@("map: lookup")
unittest {
    // Associative array of ints that are
    // indexed by string keys.
    // The KeyType is string.
    map!(string, int) aa; 
    aa["hello"] = 3; // set value associated with key "hello" to 3
    int value = aa["hello"]; // lookup value from a key
    assert(value == 3);

    int* p;

    p = ("hello" in aa);
    if (p !is null) {
        *p = 4; // update value associated with key
        assert(aa["hello"] == 4);
    }

    aa.remove("hello");
}