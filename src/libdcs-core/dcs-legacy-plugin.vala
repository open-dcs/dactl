/**
 * This file is a modified version taken from Rygel.
 */

/**
 * Errors related to plugin types.
 */
public errordomain Dcs.PluginError {
    NO_CONFIGURABLE_SETTINGS,
    CONTROL_NOT_AVAILABLE
}

/**
 * DcsPluginCapabilities is a set of flags that represent various
 * capabilities of plugins.
 */
[Flags]
public enum Dcs.PluginCapabilities {
    NONE = 0,

    /* Supports CLD object access */
    CLD_OBJECT,

    /* Diagnostics (DIAGE) support */
    DIAGNOSTICS,
}

/**
 * This represents a legacy Dcs plugin.
 *
 * Plugin libraries should provide an object of this class or a subclass in
 * their module_init () function.
 */

[Version (deprecated = true, deprecated_since = "0.2", replacement = "")]
public class Dcs.LegacyPlugin : GLib.Object {

    public PluginCapabilities capabilities { get; construct set; }

    public string name { get; construct; }

    public string title { get; construct set; }

    public string description { get; construct; }

    public bool active { get; set; }

    private bool _has_factory = false;
    public virtual bool has_factory { get { return _has_factory; } }

    public Dcs.Factory factory { get; protected set; }

    /**
     * Create an instance of the plugin.
     *
     * @param name  The non-human-readable name for the plugin, used in the
     *              Dcs configuration file.
     * @param title An optional human-readable name provided by the plugin. If
     *              the title is empty then the name will be used.
     * @param description  An optional human-readable description service
     *                     provided by the plugin.
     * @param capabilities The functionality and services that the plugin
     *                     provides.
     */
    public LegacyPlugin (string  name,
                         string? title,
                         string? description = null,
                         PluginCapabilities capabilities = PluginCapabilities.NONE) {
        GLib.Object (name : name,
                     title : title,
                     description : description,
                     capabilities : capabilities);
    }

    public override void constructed () {
        base.constructed ();

        this.active = true;

        if (this.title == null) {
            this.title = this.name;
        }
    }

    /**
     * Performs any post construction configuration if necessary.
     *
     * @param node An XML node containing the configuration settings.
     */
    /*
     *public virtual void post_construction (Xml.Node *node) throws GLib.Error {
     *    throw new PluginError.NO_CONFIGURABLE_SETTINGS
     *                (_("Plugin `%s' contains no configuration settings"), name);
     *}
     */

    /**
     * Return the UI control for this plugin.
     *
     * @return Corresponding Dcs UI control as a Dcs.Object.
     */
    /*
     *public virtual Dcs.Object get_control () throws GLib.Error {
     *    throw new PluginError.CONTROL_NOT_AVAILABLE
     *                (_("Plugin `%s' contains no configuration settings"), name);
     *}
     */
}
