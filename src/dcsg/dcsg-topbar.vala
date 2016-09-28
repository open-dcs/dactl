public enum Dcsg.TopbarPage {
    APPLICATION,
    SETTINGS
}

[GtkTemplate (ui = "/org/opendcs/dcs/ui/topbar.ui")]
private class Dcsg.Topbar : Gtk.Stack {

    private const string[] page_names = {
        "application", "loader", "configuration", "export", "settings"
    };

    [GtkChild]
    public Dcsg.ApplicationToolbar application_toolbar;

    [GtkChild]
    public Dcsg.LoaderToolbar loader_toolbar;

    [GtkChild]
    public Dcsg.ConfigurationToolbar configuration_toolbar;

    [GtkChild]
    public Dcsg.CsvExportToolbar export_toolbar;

    //[GtkChild]
    //public Dcsg.SettingsToolbar settings_toolbar;

    construct {
        // FIXME: doesn't work from .ui file
        transition_type = Gtk.StackTransitionType.CROSSFADE;
        transition_duration = 400;
    }
}
