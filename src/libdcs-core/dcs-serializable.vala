public errordomain Dcs.SerializationError {
    INVALID_CONTENT,
    INVALID_TYPE
}

public interface Dcs.Serializable : GLib.Object {
    /**
     * Serialize the object.
     *
     * @return the serialized data that represents the object.
     */
    public abstract string serialize () throws GLib.Error;

    /**
     * Deserialize the data into the object.
     *
     * @param data the data that represents the object to be deserialized.
     */
    public abstract void deserialize (string data) throws GLib.Error;
}
