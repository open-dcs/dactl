[GtkTemplate (ui = "/org/opendcs/dcs/ui/widget-settings-page.ui")]
private class Dcsg.WidgetSettingsPage : Gtk.Box {

    [GtkChild]
    private Gtk.Box content;

    construct {
        var app = Dcsg.Application.get_default ();
        var widgets = app.model.get_object_map (typeof (Dcs.UI.CompositeWidget));

        foreach (var widget in widgets.values) {
            message ("Adding `%s' as a widget settings box", widget.id);
            var widget_settings = new Dcsg.WidgetSettings (widget as Dcs.UI.CompositeWidget);
            content.pack_start (widget_settings as Gtk.Widget, true, true, 0);
        }
    }
}
