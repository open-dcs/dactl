[GtkTemplate (ui = "/org/opendcs/dcs/ui/toolbar.ui")]
private class Dcsg.Toolbar : Gtk.HeaderBar {

    [GtkChild]
    private Gtk.MenuButton btn_settings;

    [GtkChild]
    private Gtk.Button btn_previous;

    [GtkChild]
    private Gtk.Button btn_next;

    [GtkChild]
    private Gtk.Image img_previous;

    [GtkChild]
    private Gtk.Image img_next;

    construct {
        var app = Dcsg.Application.get_default ();
        var model = app.model;

        title = "Data Acquisition and Control";
        subtitle = model.config_filename;

        btn_settings.menu_model = (GLib.MenuModel) Dcsg.load_ui ("menu.ui")
                                                       .get_object ("app-menu");

        btn_settings.use_popover = true;
        btn_settings.relief = Gtk.ReliefStyle.NONE;
        btn_settings.show ();
    }
}
