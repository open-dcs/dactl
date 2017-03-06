[GtkTemplate (ui = "/org/opendcs/dcs/ui/plugin-settings.ui")]
private class Dcsg.PluginSettings : Gtk.Box {

    [GtkChild]
    private PeasGtk.PluginManager plugin_manager;

    [GtkChild]
    private PeasGtk.PluginManagerView plugin_manager_view;

    [GtkChild]
    private Gtk.TreeSelection plugin_selection;

    public void update_preferences () {
        /* XXX TBD */
    }
}
