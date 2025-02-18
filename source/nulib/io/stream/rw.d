/**
    Stream Readers and Writers.

    Utility classes for reading from and writing to streams.

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.io.stream.rw;
import nulib.io.stream;
import numem;

/**
    A stream reader is a helper class which makes it easier to
    read data from streams.
*/
final
class StreamReader {
@nogc:
private:
    Stream stream;

public:
    this(Stream stream) {
        enforce(stream.canRead(), nogc_new!StreamUnsupportedException(stream));
        this.stream = stream;
    }
}


/**
    A stream writer is a helper class which makes it easier to
    write data to streams.
*/
final
class StreamWriter {
@nogc:
private:
    Stream stream;

public:
    this(Stream stream) {
        enforce(stream.canWrite(), nogc_new!StreamUnsupportedException(stream));
        this.stream = stream;
    }
}
