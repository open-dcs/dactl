public errordomain Dcs.SerializationError {
    INVALID_CONTENT,
    INVALID_TYPE,
    SERIALIZE_FAILURE,
    DESERIALIZE_FAILURE
}

public interface Dcs.Serializable : GLib.Object {
    /**
     * Serialize the object.
     *
     * @return the serialized data that represents the object.
     *
     * @throws Dcs.SerializationError Error if fail to serialize,
     *         see {@link Dcs.SerializationError}
     */
    public abstract string serialize () throws GLib.Error;

    /**
     * Deserialize the data into the object.
     *
     * @param data the data that represents the object to be deserialized.
     *
     * @throws Dcs.SerializationError Error if fail to serialize,
     *         see {@link Dcs.SerializationError}
     */
    public abstract void deserialize (string data) throws GLib.Error;

    /**
     * Serialize the object to a JSON node.
     *
     * @return the serialized data that represents the object.
     *
     * @throws Dcs.SerializationError Error if fail to serialize,
     *         see {@link Dcs.SerializationError}
     */
    [Version (experimental = "true", experimental_until = "0.3")]
    public abstract Json.Node json_serialize () throws GLib.Error;

    /**
     * Deserialize the data from a JSON node into the object.
     *
     * @param data the data that represents the object to be deserialized.
     *
     * @throws Dcs.SerializationError Error if fail to serialize,
     *         see {@link Dcs.SerializationError}
     */
    [Version (experimental = "true", experimental_until = "0.3")]
    public abstract void json_deserialize (Json.Node node) throws GLib.Error;
}
