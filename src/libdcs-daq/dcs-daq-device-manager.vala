public class Dcs.DAQ.DeviceManager : Dcs.PluginManager {

    private Dcs.Net.Service service;

    public DeviceManager (Dcs.Net.Service service) {
        this.service = service;

        engine = Peas.Engine.get_default ();
        search_path = Dcs.Build.DEVICE_DIR;

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

    public void enable_device (string name) throws GLib.Error {
        var info = engine.get_plugin_info (name);
        if (info == null) {
            throw new Dcs.PluginError.NOT_FOUND (
                "Cannot enable device %s, not found", name);
        }
        var extension = extensions.get_extension (info);
        (extension as Dcs.Net.ServiceProvider).activate ();
    }

    public void disable_device (string name) throws GLib.Error {
        var info = engine.get_plugin_info (name);
        if (info == null) {
            throw new Dcs.PluginError.NOT_FOUND (
                "Cannot disable device %s, not found", name);
        }
        var extension = extensions.get_extension (info);
        (extension as Dcs.Net.ServiceProvider).deactivate ();
    }

    public void start_devices () {
        extensions.@foreach ((exts, info, ext) => {
            (ext as Dcs.Net.ServiceProvider).start ();
        });
    }
}
