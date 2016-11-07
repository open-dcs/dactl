public class Dcs.UI.Plugin : GLib.Object, Dcs.Extension {

    public Dcs.Application app { get; construct set; }

    public Plugin (Dcs.Application app) {
        debug ("UI Plugin constructor");
        this.app = app;
    }
}

public class Dcs.UI.PluginManager : Dcs.PluginManager {

    private Dcs.Application app;

    public Dcs.UI.Plugin ext { get; set; }

    public PluginManager (Dcs.Application app) {
        this.app = app;

        engine = Peas.Engine.get_default ();
        ext = new Dcs.UI.Plugin (app);
        // XXX UI plugins are installed to the default location - change???

        init ();
        add_extension ();
        load_plugins ();
    }

    protected override void add_extension () {
        // The extension set
        extensions = new Peas.ExtensionSet (engine,
                                            typeof (Peas.Activatable),
                                            "object",
                                            ext,
                                            null);

        extensions.extension_added.connect ((info, extension) => {
            (extension as Peas.Activatable).activate ();
        });

        extensions.extension_removed.connect ((info, extension) => {
            (extension as Peas.Activatable).deactivate ();
        });
    }
}
