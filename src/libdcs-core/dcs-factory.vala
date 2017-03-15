public errordomain Dcs.FactoryError {
    INVALID_FORMAT,
    TYPE_NOT_FOUND,
    UNABLE_TO_PROCESS
}

public interface Dcs.Factory : GLib.Object {
    /**
     * Emitted when a build of the object tree has completed.
     */
    public signal void build_complete ();

    /**
     * Constructs the object tree using the top level object types, which for
     * the time being are only pages.
     *
     * @param node XML content to use for building application objects from
     */
    [Version (deprecated = true, deprecated_since = "0.2", replacement = "create_from_data")]
    public abstract Gee.TreeMap<string, Dcs.Object> make_object_map (Xml.Node *node);

    /**
     * Recursively constructs a node tree from a string
     *
     * XXX TBD This will take Dcs.ConfigNode as a parameter
     */
    public virtual Dcs.Node? build () throws Dcs.FactoryError {

        return null;
    }

    /**
     * Constructs an object of the type provided using the default build
     * settings for that class and returns the result.
     *
     * @param type Class type to construct.
     * @return Resulting object constructed with associated default settings
     */
    [Version (deprecated = true, deprecated_since = "0.2", replacement = "make_node")]
    public abstract Dcs.Object make_object (Type type)
                                            throws GLib.Error;

    /**
     * Constructs an object using the XML node provided and returns the result.
     *
     * @param node Configuration node to base the object off of
     * @return Resulting object constructed from the input node
     */
    public abstract Dcs.Object make_object_from_node (Xml.Node *node)
                                                      throws GLib.Error;
}

public abstract class Dcs.FooFactory : GLib.Object {

    public virtual Gee.Map<string, Dcs.Node> produce_map (Gee.List<Dcs.ConfigNode> nodes)
                                                          throws GLib.Error {
        Gee.Map<string, Dcs.Node> map = new Gee.TreeMap<string, Dcs.Node> ();

        // do stuff

        return map;
    }

    public virtual Dcs.Node produce (Type type) throws GLib.Error {
        Dcs.Node node = null;

        switch (type.name ()) {
            case "DcsFooDataSeries":
                node = new Dcs.FooDataSeries (100);
                break;
            default:
                throw new Dcs.FactoryError.TYPE_NOT_FOUND (
                    "The type requested is not a known type");
        }

        return node;
    }

    public virtual Dcs.Node produce_from_config (Dcs.ConfigNode config)
                                                 throws GLib.Error {
        Dcs.Node node = null;

        switch (config.get_type_name ()) {
            case "foo-data-series":
                node = new Dcs.FooDataSeries (config.get_int ("foo0", "size"));
                var properties = config.get_properties ();
                foreach (var key in properties.keys) {
                    node.set_property (key, properties.@get (key));
                }
                foreach (var @ref in config.get_references ()) {
                    // add reference
                }
                // add children
                break;
            default:
                throw new Dcs.FactoryError.TYPE_NOT_FOUND (
                    "The type requested is not a known type");
        }

        return node;
    }
}
