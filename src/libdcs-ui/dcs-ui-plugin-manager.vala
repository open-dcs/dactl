public class Dcs.UI.Plugin : GLib.Object {

    public Dcs.ApplicationView view { get; construct set; }

    public Plugin (Dcs.ApplicationView view) {
        debug ("UI Plugin constructor");
        this.view = view;
    }
}

public class Dcs.UI.PluginManager : Dcs.PluginManager {

    private Dcs.ApplicationView view;

    public Dcs.UI.Plugin ext { get; set; }

    public PluginManager (Dcs.ApplicationView view) {
        this.view = view;

        engine = Peas.Engine.get_default ();
        ext = new Dcs.UI.Plugin (view);
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
