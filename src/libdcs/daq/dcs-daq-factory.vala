public class Dcs.DAQ.Factory : GLib.Object, Dcs.FooFactory {

    /* Singleton */
    private static Once<Dcs.DAQ.Factory> _instance;

    /**
     * Instantiate singleton for the DAQ object factory.
     *
     * @return Instance of the factory.
     */
    public static unowned Dcs.DAQ.Factory get_default () {
        return _instance.once(() => { return new Dcs.DAQ.Factory (); });
    }

    /**
     * {@inheritDoc}
     */
    public virtual Dcs.Node produce (Type type) throws GLib.Error {
        Dcs.Node node = null;

        switch (type.name ()) {
            case "DcsDAQDevice":
                node = new Dcs.DAQ.Device ();
                break;
            case "DcsDAQSensor":
                node = new Dcs.DAQ.Sensor ();
                break;
            case "DcsDAQSerialPort":
                node = new Dcs.DAQ.SerialPort ();
                break;
            case "DcsDAQSignal":
                node = new Dcs.DAQ.Signal ();
                break;
            case "DcsDAQTask":
                node = new Dcs.DAQ.Task ();
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
            case "device":
                node = new Dcs.DAQ.Device ();
                type = typeof (Dcs.DAQ.Device);
                break;
            case "sensor":
                node = new Dcs.DAQ.Sensor ();
                type = typeof (Dcs.DAQ.Sensor);
                break;
            case "serial-port":
                node = new Dcs.DAQ.SerialPort ();
                type = typeof (Dcs.DAQ.SerialPort);
                break;
            case "signal":
                node = new Dcs.DAQ.Signal ();
                type = typeof (Dcs.DAQ.Signal);
                break;
            case "task":
                node = new Dcs.DAQ.Task ();
                type = typeof (Dcs.DAQ.Task);
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
        node.id = "daq";

        try {
            foreach (var item in config) {
                debug ("Consuming config nodes in DaqFactory");
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
