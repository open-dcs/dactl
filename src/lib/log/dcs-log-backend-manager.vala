public class Dcs.Log.BackendManager : Dcs.PluginManager {

    private Dcs.Net.Service service;

    public BackendManager (Dcs.Net.Service service) {
        this.service = service;

        engine = Peas.Engine.get_default ();
        //search_path = Dcs.Build.BACKEND_DIR;
        search_path = "/usr/local/lib/dcs/backends/";

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
                                            service,
                                            null);

        extensions.extension_added.connect ((info, extension) => {
            debug ("%s was added", info.get_name ());
        });

        extensions.extension_removed.connect ((info, extension) => {
            debug ("%s was removed", info.get_name ());
        });
    }

    public void enable_backend (string name) throws GLib.Error {
        var info = engine.get_plugin_info (name);
        if (info == null) {
            throw new Dcs.PluginError.NOT_FOUND (
                "Cannot enable backend %s, not found", name);
        }
        var extension = extensions.get_extension (info);
        (extension as Dcs.Net.ServiceProvider).activate ();
    }

    public void disable_backend (string name) throws GLib.Error {
        var info = engine.get_plugin_info (name);
        if (info == null) {
            throw new Dcs.PluginError.NOT_FOUND (
                "Cannot disable backend %s, not found", name);
        }
        var extension = extensions.get_extension (info);
        (extension as Dcs.Net.ServiceProvider).deactivate ();
    }

    public void start_backends () {
        extensions.@foreach ((exts, info, ext) => {
            (ext as Dcs.Net.ServiceProvider).start ();
        });
    }
}
