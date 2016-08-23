[GtkTemplate (ui = "/org/opendcs/dcs/ui/csv-export-toolbar.ui")]
private class Dcsg.CsvExportToolbar : Gtk.HeaderBar {

    [GtkChild]
    private Gtk.Button back_button;

    [GtkChild]
    private Gtk.Image back_image;

    construct {
        title = "CSV Export";

        back_image.icon_name = "go-previous-symbolic";
    }
}
