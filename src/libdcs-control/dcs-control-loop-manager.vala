public class Dcs.Control.LoopManager : Dcs.PluginManager {

    private Dcs.Net.Service service;

    public LoopManager (Dcs.Net.Service service) {
        this.service = service;

        engine = Peas.Engine.get_default ();
        search_path = Dcs.Build.CONTROLLER_DIR;

        init ();
        load_plugins ();
        /*
         *load_plugin_configurations ();
         */

        /*
         *dump_plugins ();
         */
    }

    protected override void add_extension () {
        // The extension set
        extensions = new Peas.ExtensionSet (engine,
                                            typeof (Dcs.Net.ServiceProvider),
                                            "service",
                                            service);

        extensions.extension_added.connect ((info, extension) => {
            /* XXX Not sure anything needs to happen when an extension is added */
            debug ("%s was added", info.get_name ());
        });

        extensions.extension_removed.connect ((info, extension) => {
            /* XXX Not sure anything needs to happen when an extension is removed */
            debug ("%s was removed", info.get_name ());
        });
    }

    public void enable_loop (string name) throws GLib.Error {
        var info = engine.get_plugin_info (name);
        if (info == null) {
            throw new Dcs.PluginError.NOT_FOUND (
                "Cannot enable controller %s, not found", name);
        }
        var extension = extensions.get_extension (info);
        (extension as Dcs.Net.ServiceProvider).activate ();
    }

    public void disable_loop (string name) throws GLib.Error {
        var info = engine.get_plugin_info (name);
        if (info == null) {
            throw new Dcs.PluginError.NOT_FOUND (
                "Cannot disable controller %s, not found", name);
        }
        var extension = extensions.get_extension (info);
        (extension as Dcs.Net.ServiceProvider).deactivate ();
    }

    public void start_loops () {
        extensions.@foreach ((exts, info, ext) => {
            (ext as Dcs.Net.ServiceProvider).start ();
        });
    }
}
