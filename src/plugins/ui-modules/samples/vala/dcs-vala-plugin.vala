/**
 * Sample plugin using libpeas.
 */
public class Dcs.Sample.Plugin : Peas.ExtensionBase, Peas.Activatable {
//public class Dcs.Sample.Plugin : Dcs.UI.Plugin, PeasGtk.Configurable {

    private Dcs.UI.Plugin plugin;

    public GLib.Object object { owned get; construct; }

    public Plugin (Dcs.Application app) {
        debug ("UI Plugin constructor");
        //base (app);
    }

    public void activate () {
        debug ("Sample Vala plugin activated.");
        plugin = (Dcs.UI.Plugin) object;
        var app = plugin.app;

        var box0 = new Dcs.UI.Box ();
        box0.id = "plugbox0";
        var rc0 = new Dcs.UI.RichContent ();
        rc0.id = "rc0";
        rc0.uri = "https://www.google.ca";

        var window = new Dcs.UI.Window ();
        window.id = "win1";
        var page = new Dcs.UI.Page ();
        page.id = "pg1";
        var box1 = new Dcs.UI.Box ();
        box1.id = "plugbox1";
        var rc1 = new Dcs.UI.RichContent ();
        rc1.id = "rc1";
        rc1.uri = "https://www.google.ca";

        try {
            // Append to the existing window
            app.controller.add (box0, "/win0/pg0");
            app.controller.add (rc0, "/win0/pg0/plugbox0");
            // Add a new window
            app.controller.add (window, "/");
            app.controller.add (page, "/win1");
            app.controller.add (box1, "/win1/pg1");
            app.controller.add (rc1, "/win1/pg1/plugbox1");
            app.controller.update_view (null);
        } catch (Dcs.ApplicationError e) {
            critical (e.message);
        }
    }

    public void deactivate () {
        debug ("Sample vala plugin deactivated.");
        var app = plugin.app;

        try {
            app.controller.remove ("/win0/pg0/plugbox0/rc0");
            app.controller.remove ("/win0/pg0/plugbox0");

            app.controller.remove ("/win1/pg1/plugbox1/rc1");
            app.controller.remove ("/win1/pg1/plugbox1");
            app.controller.remove ("/win1/pg1");
            app.controller.remove ("/win1");
        } catch (Dcs.ApplicationError e) {
            critical (e.message);
        }
    }

    public void update_state () {
        debug ("Sample vala plugin update state");
    }
}

public class Dcs.Sample.PluginConfig : Peas.ExtensionBase, PeasGtk.Configurable {

    public PluginConfig () {
        GLib.Object ();
    }

    public Gtk.Widget create_configure_widget () {
        var label = new Gtk.Label ("Sample plugin configuration.");
        return label;
    }
}

[ModuleInit]
public void peas_register_types (GLib.TypeModule module) {
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type (typeof (Peas.Activatable),
                                       typeof (Dcs.Sample.Plugin));
    objmodule.register_extension_type (typeof (PeasGtk.Configurable),
                                       typeof (Dcs.Sample.PluginConfig));
}
