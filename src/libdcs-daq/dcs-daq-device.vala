public class Dcs.DAQ.Device : GLib.Object {

    public Dcs.Net.ZmqService zmq_service { get; construct set; }

    public Device (Dcs.Net.ZmqService zmq_service) {
        debug ("Device constructor");
        this.zmq_service = zmq_service;
    }
}
