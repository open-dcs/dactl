/**
 * Dummy class to instantiate an interface for testing.
 */
public class Dcs.Test.Factory : GLib.Object, Dcs.Factory {

    public string id { get; set; }

    /**
     * {@inheritdoc}
     */
    public Gee.TreeMap<string, Dcs.Object> make_object_map (Xml.Node *node) {
        return null;
    }

    /**
     * {@inheritdoc}
     */
    public Dcs.Object make_object (Type type) throws GLib.Error {

        return null;
    }

    /**
     * {@inheritdoc}
     */
    public Dcs.Object make_object_from_node (Xml.Node *node) throws GLib.Error {

        return null;
    }
}
