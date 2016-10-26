public class Dcs.Control.LoopManager : Dcs.PluginManager {

    private Dcs.Net.ZmqClient zmq_client;

    private Dcs.Net.ZmqService zmq_service;

    public Dcs.Control.LoopProxy ext { get; set; }

    public LoopManager (Dcs.Net.ZmqClient zmq_client,
                        Dcs.Net.ZmqService zmq_service) {
        this.zmq_client = zmq_client;
        this.zmq_service = zmq_service;

        engine = Peas.Engine.get_default ();
        ext = new Dcs.Control.LoopProxy (zmq_client, zmq_service);
        search_path = Dcs.Build.LOOP_DIR;

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
