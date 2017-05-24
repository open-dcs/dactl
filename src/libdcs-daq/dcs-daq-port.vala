public abstract class Dcs.DAQ.Port : Dcs.Node {

    /**
     * {@inheritDoc}
     */
    public abstract Json.Node json_serialize () throws GLib.Error;

    /**
     * {@inheritDoc}
     */
    public abstract void json_deserialize (Json.Node node) throws GLib.Error;
}
