public class Dcs.CLI.Factory : GLib.Object, Dcs.Factory {

    /* Singleton */
    private static Once<Dcs.CLI.Factory> _instance;

    /**
     * Instantiate singleton for the CLI object factory.
     *
     * @return Instance of the factory.
     */
    public static unowned Dcs.CLI.Factory get_default () {
        return _instance.once(() => { return new Dcs.CLI.Factory (); });
    }

    /**
     * {@inheritDoc}
     */
    public Gee.TreeMap<string, Dcs.Object> make_object_map (Xml.Node *node) {
        var objects = new Gee.TreeMap<string, Dcs.Object> ();
        for (Xml.Node *iter = node; iter != null; iter = iter->next) {
            try {
                Dcs.Object object = make_object_from_node (iter);

                /* XXX is this check necessary with the exception? */
                if (object != null) {
                    objects.set (object.id, object);
                    debug ("Loading object of type `%s' with id `%s'",
                           iter->get_prop ("type"), object.id);
                }
            } catch (GLib.Error e) {
                critical (e.message);
            }
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

        switch (type.name ()) {
            case "DcsCLISomething":   break;
            default:
                throw new Dcs.FactoryError.TYPE_NOT_FOUND (
                    _("The type requested is not a known DCS type"));
        }

        return object;
    }

    /**
     * {@inheritDoc}
     */
    public Dcs.Object make_object_from_node (Xml.Node *node)
                                               throws GLib.Error {
        Dcs.Object object = null;

        if (node->type == Xml.ElementType.ELEMENT_NODE &&
            node->type != Xml.ElementType.COMMENT_NODE) {
            if (node->name == "object") {
                var type = node->get_prop ("type");
                switch (type) {
                    case "something":   return make_something (node);
                    default:
                        throw new Dcs.FactoryError.TYPE_NOT_FOUND (
                            _("The type requested is not a known DCS type"));
                }
            }
        }

        return object;
    }

    private Dcs.Object? make_something (Xml.Node *node) {
        //return new Dcs.CLI.Something.from_xml_node (node);
        return null;
    }
}
