/**
 * Interface for plugins that are to be used as a backend for logging data.
 */
public interface Dcs.Log.Backend : GLib.Object {

    /**
     * Opens a connection to the file/database/key-value store that's
     * being implemented by the backend plugin.
     */
    public abstract void open () throws GLib.Error;

    /**
     * Closes the connection to the file/database/key-value store that's
     * being implemented by the backend plugin.
     */
    public abstract void close () throws GLib.Error;
}

/*
 *public abstract class Dcs.Log.AbstractBackend : GLib.Object, Dcs.Log.Backend, Dcs.Extension {
 *
 *    public abstract void open () throws GLib.Error;
 *
 *    public abstract void close () throws GLib.Error;
 *}
 */

/**
 * Proxy for the plugin that can be used to connect any data or signals from
 * a class that wants to load logging backends.
 */
public class Dcs.Log.BackendProxy : GLib.Object {

    public Dcs.Net.ZmqClient zmq_client { get; construct set; }

    /**
     * Return a new instance of BackendProxy.
     *
     * @param zmq_client Client connection to receive messages on.
     */
    public BackendProxy (Dcs.Net.ZmqClient zmq_client) {
        debug ("Backend constructor");
        this.zmq_client = zmq_client;
    }
}
