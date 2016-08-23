public enum Dcsg.SettingsTopbarPage {
    SETTINGS
}

[GtkTemplate (ui = "/org/opendcs/dcs/ui/settings-topbar.ui")]
private class Dcsg.SettingsTopbar : Gtk.Stack {

    private const string[] page_names = {
        "settings"
    };

    [GtkChild]
    public Dcsg.SettingsToolbar settings_toolbar;

    public signal void ok ();
    public signal void cancel ();

    construct {
        // FIXME: doesn't work from .ui file
        transition_type = Gtk.StackTransitionType.CROSSFADE;
        transition_duration = 400;
        settings_toolbar.ok.connect (do_ok);
        settings_toolbar.cancel.connect (do_cancel);
    }

    public void set_subtitle (string subtitle) {
      settings_toolbar.set_subtitle (subtitle);
    }

    private void do_ok () {
        ok ();
    }

    private void do_cancel () {
        cancel ();
    }
}
