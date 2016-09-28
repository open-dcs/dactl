[GtkTemplate (ui = "/org/opendcs/dcs/ui/settings-toolbar.ui")]
private class Dcsg.SettingsToolbar : Gtk.HeaderBar {

    [GtkChild]
    private Gtk.Button btn_ok;

    [GtkChild]
    private Gtk.Button btn_cancel;

    public signal void ok ();

    public signal void cancel ();

    construct {
        title = "Settings";
        //subtitle = "General";

        var ctx = btn_ok.get_style_context ();
        ctx.add_class ("suggested-action");
    }

    [GtkCallback]
    private void btn_ok_clicked_cb () {
        ok ();
    }

    [GtkCallback]
    private void btn_cancel_clicked_cb () {
        cancel ();
    }
}
