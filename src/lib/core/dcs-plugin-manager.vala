/**
 * Common plugin management funcionality.
 */
public abstract class Dcs.PluginManager {

    protected Peas.Engine engine;

    protected Peas.ExtensionSet extensions;

    protected Peas.ExtensionSet config_extensions;

    protected Peas.ExtensionSet factory_extensions;

    protected string search_path = Dcs.Build.PLUGIN_DIR;

    public signal void plugin_available (Dcs.Extension extension);

    protected virtual void init () {
		GLib.Environment.set_variable ("PEAS_ALLOW_ALL_LOADERS", "1", true);
		engine.enable_loader ("python3");

		debug ("Loading plugins from %s", search_path);
		engine.add_search_path (search_path, null);

        /* Add the common plugin extensions to recognize */
        add_extension ();
        add_config_extension ();
        add_factory_extension ();
    }

    /**
     * Adds a default extension.
     *
     * TODO This was used for a generic extension type, now that specific
     * extensions are being added to define provider and addin types this should
     * be taken out in favor of the others.
     */
    [Version (deprecated = false, deprecated_since = "0.3")]
    protected abstract void add_extension ();

    /**
     * Add extensions for plugins that provide a configuration class.
     */
    [Version (experimental = true)]
    protected virtual void add_config_extension () {
        config_extensions = new Peas.ExtensionSet (engine,
                                                   typeof (Dcs.ConfigProvider));

        config_extensions.extension_added.connect ((info, extension) => {
            debug ("%s configuration was added", info.get_name ());
        });

        config_extensions.extension_removed.connect ((info, extension) => {
            debug ("%s configuration was removed", info.get_name ());
        });
    }

    /**
     * Add extensions for plugins that provide a factory class.
     */
    [Version (experimental = true)]
    protected virtual void add_factory_extension () {
        factory_extensions = new Peas.ExtensionSet (engine,
                                                    typeof (Dcs.FactoryProvider));

        factory_extensions.extension_added.connect ((info, extension) => {
            debug ("%s factory was added", info.get_name ());
        });

        factory_extensions.extension_removed.connect ((info, extension) => {
            debug ("%s factory was removed", info.get_name ());
        });
    }

    /**
     * Load plugins from the search path provided during initialization.
     */
    protected virtual void load_plugins () {
        foreach (var plug in engine.get_plugin_list ()) {
            if (engine.try_load_plugin (plug)) {
                debug (_(plug.get_name () + " loaded by the plugin manager"));
            }
        }
    }

    /**
     * The list of plugins that have been loaded.
     *
     * @return Array of plugin names
     */
    public string[] loaded_plugins () {
        return engine.loaded_plugins;
    }

    /**
     * Just used during testing.
     */
    public void dump_plugins () {
        foreach (var info in engine.get_plugin_list ()) {
            var extension = extensions.get_extension (info);
            var type = extension.get_type ();
            debug ("-- %s --", info.get_name ());
            debug ("Extension type: %s", type.name ());
            debug ("Description: %s", info.get_description ());
            debug ("Module dir: %s", info.get_module_dir ());
            debug ("Module name: %s", info.get_module_name ());
            debug ("Module data dir: %s", info.get_data_dir ());
            var config_extension = config_extensions.get_extension (info);
            if (config_extension != null) {
                debug ("Config extension type: %s", config_extension.get_type ().name ());
            }
            var factory_extension = factory_extensions.get_extension (info);
            if (factory_extension != null) {
                debug ("Factory extension type: %s", factory_extension.get_type ().name ());
            }
        }
    }

    public void load_plugin_configurations () {
        foreach (var info in engine.get_plugin_list ()) {
            var extension = config_extensions.get_extension (info);
            string? filename = null;
            string[] filenames = {
                /* Attempt to load from user config path first */
                GLib.Path.build_filename (GLib.Environment.get_home_dir (),
                                          ".config", "dcs",
                                          info.get_external_data ("Type"),
                                          info.get_module_name () + ".xml"),
                GLib.Path.build_filename (GLib.Environment.get_home_dir (),
                                          ".config", "dcs",
                                          info.get_external_data ("Type"),
                                          info.get_module_name () + ".json"),
                /* Then from the system path */
                GLib.Path.build_filename (Dcs.Build.DATADIR,
                                          info.get_external_data ("Type"),
                                          info.get_module_name () + ".xml"),
                GLib.Path.build_filename (Dcs.Build.DATADIR,
                                          info.get_external_data ("Type"),
                                          info.get_module_name () + ".json")
            };

            if (extension == null) {
                debug ("%s doesn't provide a configuration", info.get_name ());
            } else {
                foreach (var file in filenames) {
                    if (FileUtils.test (file, FileTest.EXISTS)) {
                        filename = file;
                        break;
                    } else {
                        debug ("File %s does not exist, trying next", file);
                    }
                }

                if (filename != null) {
                    debug ("Loading plugin configuration %s", filename);
                    (extension as Dcs.ConfigProvider).config = new Dcs.ConfigFile.from_file (filename);
                    /*
                     *(extension as Dcs.ConfigProvider).config.dump (stdout);
                     */
                } else {
                    warning ("Unable to find plugin config, may not load properly");
                }
            }
        }
    }

    public void register_plugin_configurations () {
        config_extensions.@foreach ((exts, info, ext) => {
            Dcs.MetaConfig.register_config ((ext as Dcs.ConfigProvider).config);
        });
    }

    public void register_plugin_factories () {
        factory_extensions.@foreach ((exts, info, ext) => {
            Dcs.FooMetaFactory.register_factory ((ext as Dcs.FactoryProvider).factory);
        });
    }
}
