public class Dcs.DAQ.DeviceManager : Dcs.PluginManager {

    private Dcs.Net.Service service;

    public Dcs.DAQ.Device ext { get; set; }

    public DeviceManager (Dcs.Net.Service service) {
        this.service = service;

        engine = Peas.Engine.get_default ();
        ext = new Dcs.DAQ.Device (service);
        search_path = Dcs.Build.DEVICE_DIR;

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
