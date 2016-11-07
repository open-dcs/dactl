/**
 * This class is responsible for plugin loading.
 *
 * It probes for shared library files in a specific directory, tries to
 * find a module_init() function with this signature:
 * ``void module_init (DcsPluginLoader* loader);``
 *
 * It then calls that function, passing a pointer to itself. The loaded
 * module can then add plugins to Dcs by calling the
 * dcs_plugin_loader_add_plugin() function.
 */
public class Dcs.PluginLoader : Dcs.ModuleLoader {

    private delegate void ModuleInitFunc (Dcs.PluginLoader loader);

    private Gee.HashMap<string, Dcs.LegacyPlugin> plugin_hash;
    private Gee.HashSet<string> loaded_modules;

    // Signals
    public signal void plugin_available (Dcs.LegacyPlugin plugin);

    public PluginLoader () {
        GLib.Object (base_path: get_config_path ());
    }

    public override void constructed () {
        base.constructed ();

        if (this.base_path == null) {
            this.base_path = get_config_path ();
        }

        this.plugin_hash = new Gee.HashMap<string, Dcs.LegacyPlugin> ();
        this.loaded_modules = new Gee.HashSet<string> ();
    }

    /**
     * Checks if a plugin is disabled by the user
     *
     * @param name the name of plugin to check for.
     *
     * @return true if plugin is disabled, false if not.
     */
    public bool plugin_disabled (string name) {
        var enabled = true;
        /*
         *try {
         *    var config = MetaConfig.get_default ();
         *    enabled = config.get_enabled (name);
         *} catch (GLib.Error err) {}
         */

        return !enabled;
    }

    public void add_plugin (Dcs.LegacyPlugin plugin) {
        debug (_("New plugin '%s' available"), plugin.name);
        this.plugin_hash.set (plugin.name, plugin);
        this.plugin_available (plugin);
    }

    public Dcs.LegacyPlugin? get_plugin_by_name (string name) {
        return this.plugin_hash.get (name);
    }

    public Gee.Collection<Dcs.LegacyPlugin> list_plugins () {
        return this.plugin_hash.values;
    }

    protected override bool load_module_from_file (File module_file) {
        if (module_file.get_basename () in this.loaded_modules) {
            warning (_("A module named %s is already loaded"),
                     module_file.get_basename ());

            return true;
        }

        Module module = Module.open (module_file.get_path (),
                                     ModuleFlags.BIND_LOCAL);
        if (module == null) {
            warning (_("Failed to load module from path '%s': %s"),
                     module_file.get_path (),
                     Module.error ());

            return true;
        }

        void* function;

        if (!module.symbol("module_init", out function)) {
            warning (_("Failed to find entry point function '%s' in '%s': %s"),
                     "module_init",
                     module_file.get_path (),
                     Module.error ());

            return true;
        }

        unowned ModuleInitFunc module_init = (ModuleInitFunc) function;

        assert (module_init != null);
        this.loaded_modules.add (module_file.get_basename ());

        // We don't want our modules to ever unload
        module.make_resident ();

        module_init (this);

        debug ("Loaded module source: '%s'", module.name());

        return true;
    }

    protected override bool load_module_from_info (Dcs.PluginInformation info) {
        if (this.plugin_disabled (info.name)) {
            debug ("Module '%s' disabled by user. Ignoring…",
                   info.name);

            return true;
        }

        var module_file = File.new_for_path (info.module_path);

        return this.load_module_from_file (module_file);
    }

    private static string get_config_path () {
        var path = Dcs.Build.PLUGIN_DIR;
        /*
         *try {
         *    var config = MetaConfig.get_default ();
         *    path = config.get_plugin_path ();
         *} catch (Error error) { }
         */

        return path;
    }
}
