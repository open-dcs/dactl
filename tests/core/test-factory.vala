/**
 * Dummy class to instantiate an interface for testing.
 */
public class Dcs.Test.Factory : GLib.Object, Dcs.Factory {

    private struct ConfigNode {
        string id;
        string type;
        Gee.HashMap<string, GLib.Variant> properties;
        Gee.ArrayList<string> references;
    }

    /* Singleton */
    private static Once<Dcs.Test.Factory> _instance;

    /**
     * Instantiate singleton for the test node factory.
     *
     * @return Instance of the factory.
     */
    public static unowned Dcs.Test.Factory get_default () {
        return _instance.once(() => { return new Dcs.Test.Factory (); });
    }

    public string id { get; set; }

    /**
     * {@inheritdoc}
     */
    public Gee.TreeMap<string, Dcs.Object> make_object_map (Xml.Node *node) {
        return null;
    }

    /**
     * {@inheritDoc}
     */
    public Dcs.Node? build () throws Dcs.FactoryError {

        return new Dcs.Test.Node ("test_node") as Dcs.Node;
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
