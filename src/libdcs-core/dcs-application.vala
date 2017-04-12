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
    public signal void closed ();

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

public interface Dcs.Runnable : GLib.Object {

    /**
     * The implementing application can use this to implement an options
     * handler.
     */
    public abstract int launch (string[] args);
}

/**
 * Base application class for DCS utilities and services to derive.
 *
 * TODO add plugin manager
 * TODO document
 * TODO remove runnable? running through launch is redundant as it is
 */
public abstract class Dcs.FooApplication : GLib.Application, Dcs.Runnable {

    protected Dcs.MetaConfig config;

    protected Dcs.FooMetaFactory factory;

    /**
     * Model used to update the view.
     */
    protected Dcs.Model model;

    /**
     * View to provide the user access to the data in the model.
     */
    protected Dcs.View view;

    /**
     * Controller to update the model and perform any functionality requested
     * by the view.
     */
    protected Dcs.Controller controller;

    /**
     * Emitted when the application has been stopped.
     */
    public signal void closed ();

    protected void init () {
        config = Dcs.MetaConfig.get_default ();
        factory = Dcs.FooMetaFactory.get_default ();
    }

    public virtual Dcs.Config get_config () {
        return config;
    }

    public virtual Dcs.FooFactory get_factory () {
        return factory;
    }

    public virtual Dcs.Model get_model () {
        return model;
    }

    public virtual Dcs.View get_view () {
        return view;
    }

    public virtual Dcs.Controller get_controller () {
        return controller;
    }

    /**
     * {@inheritDoc}
     */
    public virtual int launch (string[] args) {
        return (this as GLib.Application).run (args);
    }
}
