public errordomain Dcs.MessageError {
    INVALID_DATA
}

[Flags]
public enum Dcs.MessageType {
    UNKNOWN,
    ALERT,
    ERROR,
    INFO,
    WARNING
}

[Compact]
public class Dcs.Message : GLib.Object {

    /**
     * A unique hash value for the message.
     */
    //public uint16 hash { get; private construct; }

    /**
     * The message timestamp which should be set at the time of creation.
     */
    //public uint64 timestamp { get; private construct; }

    /**
     * A value to be carried with the message.
     */
    ////public T value { get; private construct; }

    /**
     * The type of the value.
     *
     * XXX Might need this to be read in when going to/from serialized content.
     */
    //protected Type type;

    /**
     * Create a new ...
     */
    //public Message.alert () {
    //}

    //public Message.error () {
    //}

    //public Message.info () {
    //}

    //public Message.warning () {
    //}

    /**
     * XXX Not really sure where to put this yet.
     *
     * @param data The message as an array of bytes.
     */
    //public abstract void deserialize (uint8[] data) throws GLib.Error {
    //}

    /**
     * XXX Not really sure where to put this yet.
     *
     * @return An array of bytes that represents the message.
     */
    //public abstract uint8[] serialize () {
        //uint8[] data = new uint[32];

        //return data;
    //}

    public string to_string () {
        return "{ \"msgid\": \"msg0\" }";
    }
}
