module nulib.data.option;
public import nulib.data.sumtype;

/**
    An option type that wraps an optional value.

    Use sumtype matching to extract the value or
    $(D unwrap)
*/
alias Option(T) = SumType!(Nothing, T);

/**
    None value; to be passed to Option(T)
*/
struct Nothing { }
enum None = Nothing.init;

/**
    Some value; to be passed to Option(T)
*/
template Some(T) {
    Option!T Some(T value) {
        return Option!T(value);
    }
}

/**
    Unwraps an option type, expecting it to be
    a valid "some" type.

    Params:
        opt = The option type to unwrap.
    
    Returns:
        The unwrapped data.
*/
T expect(T, OptT)(OptT opt) if (is(OptT == Option!T)) {
    return opt.get!T;
}

@("Option")
unittest {
    Option!string myTestFunction(bool f) {
        return f ? 
            Option!string(None) : 
            Some("Hello, world!");
    }

    auto opt1 = myTestFunction(true);
    auto opt2 = myTestFunction(false);

    assert(opt1.has!Nothing);
    assert(opt2.has!string);
    assert(opt2.get!string == "Hello, world!");
}