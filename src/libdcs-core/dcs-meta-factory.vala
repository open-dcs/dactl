/**
 * Class use to build objects from configuration data.
 */
public class Dcs.MetaFactory : GLib.Object, Dcs.Factory {

    /* Factory singleton */
    private static Dcs.MetaFactory app_factory;

    private static Gee.ArrayList<Dcs.Factory> factories;

    /**
     * Retrieves the singleton for the class creating it first if it's not
     * already available.
     */
    public static Dcs.MetaFactory get_default () {
        if (factories == null) {
            factories = new Gee.ArrayList<Dcs.Factory> ();
        }

        if (app_factory == null) {
            app_factory = new Dcs.MetaFactory ();
        }

        return app_factory;
    }

    public static void register_factory (Dcs.Factory factory) {
        if (factories == null) {
            factories = new Gee.ArrayList<Dcs.Factory> ();
        }
        factories.add (factory);
    }

    /**
     * {@inheritDoc}
     */
    public Gee.TreeMap<string, Dcs.Object> make_object_map (Xml.Node *node) {
        var objects = new Gee.TreeMap<string, Dcs.Object> ();

        /**
         * FIXME: Instead of passing in /dcs/objects/object this should
         *        receive just the root node and then parse out the namespaces
         *        for each factory.
         */
        foreach (var factory in Dcs.MetaFactory.factories) {
            var map = factory.make_object_map (node);
            objects.set_all (map);
        }

        build_complete ();

        return objects;
    }

    /**
     * {@inheritDoc}
     */
    public Dcs.Object make_object (Type type)
                                   throws GLib.Error {
        Dcs.Object object = null;

        foreach (var factory in Dcs.MetaFactory.factories) {
            try {
                object = factory.make_object (type);
            } catch (GLib.Error e) {
                critical (e.message);
            }
        }

        /* The type was not found in any of the registered factories, check the
         * application last */
        if (object == null) {
            switch (type.name ()) {
                case "DcsFoo":
                    break;
                default:
                    throw new Dcs.FactoryError.TYPE_NOT_FOUND (
                        _("The type requested is not a known Dcs type."));
            }
        }

        return object;
    }

    /**
     * {@inheritDoc}
     */
    public Dcs.Object make_object_from_node (Xml.Node *node)
                                             throws GLib.Error {
        Dcs.Object object = null;

        foreach (var factory in Dcs.MetaFactory.factories) {
            try {
                object = factory.make_object_from_node (node);
            } catch (GLib.Error e) {
                critical (e.message);
            }
        }

        /* The type was not found in any of the registered factories, check the
         * application last */
        if (object == null) {
            if (node->name == "object") {
                var type = node->get_prop ("type");
                switch (type) {
                    case "foo":
                        break;
                    default:
                        throw new Dcs.FactoryError.TYPE_NOT_FOUND (
                            _("The type requested is not a known Dcs type."));
                }
            }
        }

        return object;
    }
}
