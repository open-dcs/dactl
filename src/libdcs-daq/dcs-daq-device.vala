public class Dcs.DAQ.Device : Dcs.PluginExtension {

    public Dcs.Net.ZmqService zmq_service { get; construct set; }

    public Device (Dcs.Net.ZmqService zmq_service) {
        debug ("Device constructor");
        this.zmq_service = zmq_service;
    }

    /*
     *public virtual void* run () {
     *    debug ("Device worker function");
     *    return null;
     *}
     */
}
