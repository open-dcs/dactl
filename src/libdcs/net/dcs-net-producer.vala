public enum Dcs.Net.ProviderFlags {
    NONE,
    REST,
    ZMQ
}

public interface Dcs.Net.Provider : GLib.Object {

    //public Dcs.Net.ProviderFlags flags = Dcs.Net.ProviderFlags.NONE;

    //protected Dcs.Net.Router router;

    //protected Dcs.Net.ZmqService zmq;
}
