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
                        "The type requested is not a known Dcs type.");
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
                            "The type requested is not a known Dcs type.");
                }
            }
        }

        return object;
    }
}

public class Dcs.FooMetaFactory : GLib.Object, Dcs.FooFactory {

    private static Gee.ArrayList<Dcs.FooFactory> factories;

    /* Singleton for this factory */
    private static Once<Dcs.FooMetaFactory> _instance;

    public static unowned Dcs.FooMetaFactory get_default () {
        return _instance.once (() => { return new Dcs.FooMetaFactory (); });
    }

    public static void register_factory (Dcs.FooFactory factory) {
        if (factories == null) {
            factories = new Gee.ArrayList<Dcs.FooFactory> ();
        }
        factories.add (factory);
    }

    public virtual Dcs.Node produce (Type type) throws GLib.Error {
        Dcs.Node node = null;

        foreach (var factory in factories) {
            try {
                node = factory.produce (type);
            } catch (GLib.Error e) {
                if (!(e is Dcs.FactoryError.TYPE_NOT_FOUND ||
                      e is Dcs.FactoryError.INVALID_FORMAT ||
                      e is Dcs.FactoryError.UNABLE_TO_PROCESS)) {
                    throw e;
                }
            }
        }

        /* The type was not found in any of the registered factories */
        if (node == null) {
            throw new Dcs.FactoryError.TYPE_NOT_FOUND (
                "The type requested is not a known Dcs type.");
        }

        return node;
    }

    public virtual Dcs.Node produce_from_config (Dcs.ConfigNode config)
                                                 throws GLib.Error {
        Dcs.Node node = null;

        foreach (var factory in factories) {
            try {
                node = factory.produce_from_config (config);
            } catch (GLib.Error e) {
                if (!(e is Dcs.FactoryError.TYPE_NOT_FOUND ||
                      e is Dcs.FactoryError.INVALID_FORMAT ||
                      e is Dcs.FactoryError.UNABLE_TO_PROCESS)) {
                    throw e;
                }
            }
        }

        /* The type was not found in any of the registered factories */
        if (node == null) {
            throw new Dcs.FactoryError.TYPE_NOT_FOUND (
                "The type requested is not a known Dcs type.");
        }

        return node;
    }

    public virtual Dcs.Node produce_from_config_list (Gee.List<Dcs.ConfigNode> config)
                                                      throws GLib.Error {
        Dcs.Node node = new Dcs.Node ();
        node.id = "root0";

        foreach (var factory in factories) {
            try {
                debug ("Consuming config nodes in MetaFactory");
                node.add (factory.produce_from_config_list (config));
            } catch (GLib.Error e) {
                if (!(e is Dcs.FactoryError.TYPE_NOT_FOUND ||
                      e is Dcs.FactoryError.INVALID_FORMAT ||
                      e is Dcs.FactoryError.UNABLE_TO_PROCESS)) {
                    throw e;
                }
            }
        }

        if (node == null) {
            throw new Dcs.FactoryError.UNABLE_TO_PROCESS (
                "The configuration failed to generate a valid node set.");
        }

        return node;
    }
}
