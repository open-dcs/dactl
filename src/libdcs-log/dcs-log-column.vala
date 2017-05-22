public class Dcs.Log.Task : Dcs.Node {

    /**
     * {@inheritDoc}
     */
    public virtual Json.Node json_serialize () throws GLib.Error {
        var builder = new Json.Builder ();
        builder.begin_object ();
        builder.set_member_name (id);
        builder.begin_object ();
        builder.set_member_name ("type");
        builder.add_string_value ("column");
        builder.set_member_name ("properties");
        builder.begin_object ();
        builder.end_object ();
        builder.end_object ();
        builder.end_object ();

        var node = builder.get_root ();
        if (node == null) {
            throw new Dcs.SerializationError.SERIALIZE_FAILURE (
                "Failed to serialize publisher %s", id);
        }

        return node;
    }

    /**
     * {@inheritDoc}
     */
    public virtual void json_deserialize (Json.Node node) throws GLib.Error {
        var obj = node.get_object ();
        id = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (id);

        if (data.has_member ("properties")) {
            var props = data.get_object_member ("properties");
            /*
             *port = (int) props.get_int_member ("port");
             *address = props.get_string_member ("address");
             *transport_spec = props.get_string_member ("transport-spec");
             */
        }
    }
}
