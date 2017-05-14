public class Dcs.DAQ.Comedi.Device : Dcs.DAQ.Device {

    private Dcs.DAQ.Device device;

    public GLib.Object object { construct; owned get; }

    public Device (Dcs.Net.Service service) {
        debug ("Comedi device constructor");
        base (service);
    }

    public void activate () {
        debug ("Comedi device activated");
    }

    public void deactivate () {
        debug ("Comedi device deactivated");
    }

    public void update_state () { }

    public void run () {
        device = (Dcs.DAQ.Device) object;
        /*
         *device.zmq_service.data_published.connect ((data) => {
         *    debug ((string) data);
         *});
         */
    }
}

[ModuleInit]
public void peas_register_types (GLib.TypeModule module) {
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type (typeof (Peas.Activatable),
                                       typeof (Dcs.DAQ.Comedi.Device));
}
