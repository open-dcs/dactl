public interface Dcs.Plugin : GLib.Object {

    /**
     * This will be the worker function for the plugin.
     */
    public abstract void* run ();
}
