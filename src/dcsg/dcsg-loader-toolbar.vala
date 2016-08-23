[GtkTemplate (ui = "/org/opendcs/dcs/ui/loader-toolbar.ui")]
private class Dcsg.LoaderToolbar : Gtk.HeaderBar {

    [GtkChild]
    private Gtk.Button back_button;

    [GtkChild]
    private Gtk.Image back_image;

    construct {
        title = "File Loader";

        back_image.icon_name = "go-previous-symbolic";
    }
}
