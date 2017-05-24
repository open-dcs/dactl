/**
 * Configuration Backend object representing object data.
 */
public class Dcs.Log.Backend : Dcs.Node {

    /**
     * Opens a connection to the file/database/key-value store that's
     * being implemented by the backend plugin.
     */
    /*
     *public abstract void open () throws GLib.Error;
     */

    /**
     * Closes the connection to the file/database/key-value store that's
     * being implemented by the backend plugin.
     */
    /*
     *public abstract void close () throws GLib.Error;
     */

    public string module { get; set; }

    public bool enable { get; set; }

    public string? configuration { get; set; default = null; }
}
