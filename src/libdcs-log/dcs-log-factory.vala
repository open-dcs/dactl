public class Dcs.Log.Factory : GLib.Object, Dcs.FooFactory {

    /* Singleton */
    private static Once<Dcs.Log.Factory> _instance;

    /**
     * Instantiate singleton for the Log object factory.
     *
     * @return Instance of the factory.
     */
    public static unowned Dcs.Log.Factory get_default () {
        return _instance.once(() => { return new Dcs.Log.Factory (); });
    }

    /**
     * {@inheritDoc}
     */
    public virtual Dcs.Node produce (Type type) throws GLib.Error {
        Dcs.Node node = null;

        switch (type.name ()) {
            case "DcsLogBackend":
                node = new Dcs.Log.Backend ();
                break;
            case "DcsLogFile":
                node = new Dcs.Log.File ();
                break;
            case "DcsLogColumn":
                node = new Dcs.Log.Column ();
                break;
            case "DcsLogQuery":
                node = new Dcs.Log.Query ();
                break;
            default:
                throw new Dcs.FactoryError.TYPE_NOT_FOUND (
                    "The type requested is not a known type");
        }

        return node;
    }

    /**
     * {@inheritDoc}
     */
    public virtual Dcs.Node produce_from_config (Dcs.ConfigNode config)
                                                 throws GLib.Error {
        Dcs.Node node = null;
        Type type;
        Gee.Map<string, Variant> properties = config.get_properties ();

        switch (config.get_type_name ()) {
            case "backend":
                node = new Dcs.Log.Backend ();
                type = typeof (Dcs.Log.Backend);
                break;
            case "file":
                node = new Dcs.Log.File ();
                type = typeof (Dcs.Log.File);
                break;
            case "column":
                node = new Dcs.Log.Column ();
                type = typeof (Dcs.Log.Column);
                break;
            case "query":
                node = new Dcs.Log.Query ();
                type = typeof (Dcs.Log.Query);
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

    /**
     * {@inheritDoc}
     */
    public virtual Dcs.Node produce_from_config_list (Gee.List<Dcs.ConfigNode> config)
                                                      throws GLib.Error {
        Dcs.Node node = new Dcs.Node ();
        node.id = "log";

        try {
            foreach (var item in config) {
                debug ("Consuming config nodes in LogFactory");
                var child = produce_from_config (item);
                if (child != null) {
                    node.add ((owned) child);
                }
            }
        } catch (GLib.Error e) {
            if (!(e is Dcs.FactoryError.TYPE_NOT_FOUND)) {
                throw e;
            }
        }

        return node;
    }
}
