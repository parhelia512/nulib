/**
    Serializable Interface

    Interfaces for creating classes which may be serialized and deserialized.

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.io.serialize;

/**
    Interface a class may implement to indicate it can be serialized.
*/
interface ISerializable {
@nogc:

    /**
        Called on the object to serialize it using the given serializer.

        Params:
            serializer = the serializer to use.
    */
    void serialize(ref ISerializer serializer);
}

/**
    Interface a class may implement to indicate it can be deserialized.
*/
interface IDeserializable {
@nogc:

    /**
        Deserializes state from a deserializer.
    */
    void deserialize(ref IDeserializer deserializer);
}

interface ISerializer { }

interface IDeserializer { }