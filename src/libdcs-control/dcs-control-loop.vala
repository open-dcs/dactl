/**
 * Interface for plugins that are to be used as a backend for logging data.
 */
public interface Dcs.Control.Loop : GLib.Object {

    /**
     * Starts the control loop running.
     *
     * XXX maybe, this is just a stub for something to figure out.
     */
    public abstract void start () throws GLib.Error;

    /**
     * Stops the control loop from running.
     *
     * XXX maybe, this is just a stub for something to figure out.
     */
    public abstract void stop () throws GLib.Error;
}

/*
 *public abstract class Dcs.Control.AbstractLoop : GLib.Object, Dcs.Control.Loop, Dcs.Extension {
 *
 *    public abstract void start () throws GLib.Error;
 *
 *    public abstract void stop () throws GLib.Error;
 *}
 */

/**
 * Proxy for the plugin that can be used to connect any data or signals from
 * a class that wants to load logging backends.
 */
public class Dcs.Control.LoopProxy : GLib.Object {

    public Dcs.Net.ZmqClient zmq_client { get; construct set; }

    public Dcs.Net.ZmqService zmq_service { get; construct set; }

    /**
     * Return a new instance of LoopProxy.
     *
     * @param zmq_client Client connection to receive messages on.
     * @param zmq_service Service to publish messages on.
     */
    public LoopProxy (Dcs.Net.ZmqClient zmq_client,
                      Dcs.Net.ZmqService zmq_service) {
        debug ("Loop constructor");
        this.zmq_client = zmq_client;
        this.zmq_service = zmq_service;
    }
}
