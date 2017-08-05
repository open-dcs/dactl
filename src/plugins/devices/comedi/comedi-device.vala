public class Dcs.DAQ.ComediDevice : GLib.Object, Dcs.Net.ServiceProvider {

    public Dcs.Net.Service service { get; construct set; }

    public void activate () {
        debug ("Comedi device activated");
    }

    public void deactivate () {
        debug ("Comedi device deactivated");
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

    peas.register_extension_type (typeof (Dcs.Net.ServiceProvider), typeof (Dcs.DAQ.ComediDevice));
}
