public errordomain Dcs.ApplicationError {
    INVALID_ADD_REQUEST,
    INVALID_REMOVE_REQUEST
}

public interface Dcs.Application : GLib.Object {

    /**
     * Model used to update the view.
     */
    public abstract Dcs.Model model { get; set; }

    /**
     * View to provide the user access to the data in the model.
     */
    public abstract Dcs.View view { get; set; }

    /**
     * Controller to update the model and perform any functionality requested
     * by the view.
     */
    public abstract Dcs.Controller controller { get; set; }

    /**
     * A list of legacy plugins that are used with the PluginLoader.
     */
    public abstract Gee.ArrayList<Dcs.LegacyPlugin> plugins { get; set; }

    /**
     * Emitted when the application has been stopped.
     */
    public abstract signal void closed ();

    /**
     * The implementing application can use this to implement an options
     * handler.
     */
    public abstract int launch (string[] args);

    //public abstract void shutdown ();

    /**
     * The methods startup, activate, and command_line need to be overridden in
     * the application classes that derive this but it seemed pointless to force
     * it through this interface.
     */
/*
 *    protected abstract int _command_line (GLib.ApplicationCommandLine cmdline);
 *
 *    protected abstract void _startup ();
 *
 *    protected abstract void _activate ();
 */

    /**
     * Provided to allow the application to do post load operations like
     * loading a configuration.
     */
    public abstract void register_plugin (Dcs.LegacyPlugin plugin);
}
