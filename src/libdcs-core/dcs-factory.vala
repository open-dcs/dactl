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

public interface Dcs.FooFactory : GLib.Object {

    public abstract Dcs.Node produce (Type type) throws GLib.Error;

    public abstract Dcs.Node produce_from_config (Dcs.ConfigNode config)
                                                  throws GLib.Error;

    public abstract Dcs.Node produce_from_config_list (Gee.List<Dcs.ConfigNode> config)
                                                       throws GLib.Error;
}

public class Dcs.FooBarFactory : Dcs.FooFactory, GLib.Object {

    public virtual Dcs.Node produce (Type type) throws GLib.Error {
        Dcs.Node node = null;

        switch (type.name ()) {
            case "DcsFooDataSeries":
                node = new Dcs.FooDataSeries ();
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
        Type type;
        Gee.Map<string, Variant> properties = config.get_properties ();

        switch (config.get_type_name ()) {
            case "foo-data-series":
                node = new Dcs.FooDataSeries ();
                type = typeof (Dcs.FooDataSeries);
                break;
            default:
                throw new Dcs.FactoryError.TYPE_NOT_FOUND (
                    "The type requested is not a known type");
        }

        ObjectClass ocl = (ObjectClass) type.class_ref ();

        foreach (var key in properties.keys) {
            var prop = properties.@get (key);
            var spec = ocl.find_property (key);
            if (spec != null) {
                // XXX there's some array types in here not accounted for
                if (prop.is_of_type (VariantType.STRING)) {
                    node.set_property (key, prop.get_string ());
                } else if (prop.is_of_type (VariantType.INT64)) {
                    node.set_property (key, (int) prop.get_int64 ());
                } else if (prop.is_of_type (VariantType.BOOLEAN)) {
                    node.set_property (key, prop.get_boolean ());
                } else if (prop.is_of_type (VariantType.DOUBLE)) {
                    node.set_property (key, prop.get_double ());
                } else if (prop.is_of_type (VariantType.ARRAY)) {
                    // XXX do something
                }
            }
        }

        // add references
        foreach (var @ref in config.get_references ()) {
        }

        // add children
        foreach (var child in config.get_children ()) {
            node.add (produce_from_config (child));
        }

        node.id = config.get_namespace ();

        return node;
    }

    public virtual Dcs.Node produce_from_config_list (Gee.List<Dcs.ConfigNode> config)
                                                      throws GLib.Error {
        Dcs.Node node = null;

        try {
            foreach (var item in config) {
                node.add (produce_from_config (item));
            }
        } catch (GLib.Error e) {
            if (!(e is Dcs.FactoryError.TYPE_NOT_FOUND)) {
                throw e;
            }
        }

        return node;
    }
}
