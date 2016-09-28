// Just the one for now
private enum Dcsg.SidebarPage {
    SETTINGS,
    NONE,
}

[GtkTemplate (ui = "/org/opendcs/dcs/ui/sidebar.ui")]
private class Dcsg.Sidebar : Gtk.Revealer {

    [GtkChild]
    private Dcsg.SettingsSidebar settings_sidebar;

    [GtkChild]
    private Gtk.Notebook notebook;

    public Dcsg.SidebarPage page { get; set; }

    public GLib.SimpleAction settings_selection_action { get; private set; }

    construct {
        settings_selection_action = new SimpleAction ("settings-selection", null);
        settings_sidebar.selection_action = settings_selection_action;
        notify["page"].connect (page_changed_cb);
        set_valign (Gtk.Align.START);
        set_transition_duration (750);
    }

    /**
     * There's only one page right now, using enum just in case that changes.
     */
    private void page_changed_cb () {
        switch (page) {
            case Dcsg.SidebarPage.SETTINGS:
                reveal_child = true;
                notebook.page = page;
                break;
            default:
                reveal_child = false;
                break;
        }
    }
}
