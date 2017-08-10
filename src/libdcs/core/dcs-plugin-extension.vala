/**
 * XXX I think this is probably completely unnecessary and should be removed
 */
[Version (deprecated = true, deprecated_since = "0.2")]
public interface Dcs.Extension : GLib.Object {

    public signal void enabled ();

    public signal void disabled ();

    public void enable () {
        enabled ();
    }

    public void disable () {
        disabled ();
    }
}

[Version (deprecated = true, deprecated_since = "0.2")]
public abstract class Dcs.PluginExtension : Peas.ExtensionBase,
                                            Dcs.Extension,
                                            Peas.Activatable {

    public bool is_enabled { get; private set; }

    public GLib.Object object { construct; owned get; }

    public Dcs.PluginFactory factory { get; protected set; }

    public void activate () {
        info ("Extension %s enabled", plugin_info.get_name ());
        enabled.connect (() => { is_enabled = true; });
        disabled.connect (() => { is_enabled = false; });
    }

    public void deactivate () {
        info ("Extension %s disabled", plugin_info.get_name ());
    }

    public void update_state () { }

    public void dump () {
    }
}

