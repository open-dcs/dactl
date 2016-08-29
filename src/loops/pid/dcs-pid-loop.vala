public class Dcs.Control.PID.Loop : Peas.ExtensionBase, Peas.Activatable, Dcs.Control.Loop {
//public class Dcs.Control.PID.Loop : Dcs.Control.AbstractLoop, Peas.Activatable {

    private Dcs.Control.LoopProxy proxy;

    public GLib.Object object { construct; owned get; }

    public Loop (Dcs.Net.ZmqService zmq_service) {
        debug ("PID loop constructor");
    }

    /**
     * Starts a PID control loop.
     */
    public void start () throws GLib.Error {
    }

    /**
     * Stops the currently running PID control loop.
     */
    public void stop () throws GLib.Error {
    }

    /**
     * Executed when the plugin is loaded by the manager class.
     */
    public void activate () {
        debug ("PID loop activated");
        proxy = (Dcs.Control.LoopProxy) object;
        proxy.zmq_client.data_received.connect ((data) => {
            debug ((string) data);
        });
    }

    public void deactivate () { }

    public void update_state () { }
}

[ModuleInit]
public void peas_register_types (GLib.TypeModule module) {
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type (typeof (Peas.Activatable),
                                       typeof (Dcs.Control.PID.Loop));
}
