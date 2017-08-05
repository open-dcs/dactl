public class Dcs.DAQ.MccUsbDevice : GLib.Object, Dcs.Net.ServiceProvider {

    public Dcs.Net.Service service { get; construct set; }

    public void activate () {
        debug ("Measurement Computing USB device activated");
    }

    public void deactivate () {
        debug ("Measurement Computing USB device deactivated");
    }

    public void start () {
        service.test_nothing (get_type ().name ());
    }

    public void pause () {
        service.test_nothing (get_type ().name ());
    }

    public void stop () {
        service.test_nothing (get_type ().name ());
    }
}

[ModuleInit]
public void peas_register_types (GLib.TypeModule module) {
    var peas = module as Peas.ObjectModule;

    peas.register_extension_type (typeof (Dcs.Net.ServiceProvider), typeof (Dcs.DAQ.MccUsbDevice));
}
