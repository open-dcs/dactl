namespace Dcs {
    public delegate void ModelUpdatedFunc ();
}

/**
 * Main application class responsible for interfacing with data and different
 * interface types.
 */
public class Dcs.Model : GLib.Object, Dcs.Container {

    private string _name = "Untitled";
    /**
     * A name for the configuration
     */
    public string name {
        get { return _name; }
        set {
            _name = value;
            lock (config) {
                config.set_string_property ("app", value);
            }
        }
    }

    private bool _admin = false;
    /**
     * Allow administrative functionality
     */
    public bool admin {
        get { return _admin; }
        set {
            _admin = value;
            lock (config) {
                config.set_boolean_property ("admin", value);
            }
        }
    }

    private bool _def_enabled = false;
    /**
     * Flag to set if user has set the calibrations to <default>
     */
    public bool def_enabled {
        get { return _def_enabled; }
        set { _def_enabled = value; }
    }

    private Gee.Map<string, Dcs.Object> _objects;
    /**
     * {@inheritDoc}
     */
    public Gee.Map<string, Dcs.Object> objects {
        get { return (_objects); }
        set { update_objects (value); }
    }

    /**
     * Default configuration file name.
     */
    public string config_filename { get; set; default = "dcs.xml"; }

    /**
     * Flag indicating thread activity... I think.
     * XXX pretty sure this isn't being used anymore.
     */
    public bool active { get; set; default = false; }

    /* Basic output verbosity, should use an integer to allow for -vvv */
    public bool verbose { get; set; default = false; }

    /* Application data */
    public Dcs.LegacyConfig config { get; private set; }

    /* CLD data */
    public Cld.XmlConfig xml { get; private set; }
    public Cld.Context ctx { get; private set; }

    /* GSettings data */
    public Settings settings { get; private set; }

    /**
     * Emitted whenever the state of a log has been changed.
     * XXX not sure this is used anymore
     */
    public signal void log_state_changed (string log, bool state);

    /**
     * Emitted whenever the object map has been updated.
     *
     * @param id the ID of the object that was updated in the map
     */
    public signal void updated (string? id);

    /**
     * Default construction.
     */
    public Model (string config_filename) {
        this.config_filename = config_filename;

        if (!FileUtils.test (config_filename, FileTest.EXISTS)) {
            /* XXX might be better if somehow done after gui was launched
             *     so that a dialog could be given, or use conditional
             *     Model construction */
            critical ("Configuration selection '%s' does not exist.",
                      config_filename);
        }

        /* Load the entire application configuration file */
        config = new Dcs.LegacyConfig (this.config_filename);

        var factory = Dcs.MetaFactory.get_default ();

        try {
            /* Get the nodeset to use from the configuration */
            Xml.Node *dcs_node = config.get_xml_node ("/dcs/ui:objects/ui:object");
            objects = factory.make_object_map (dcs_node);
            /* Load the CLD specific configuration and builder */
            Xml.Node *cld_node = config.get_xml_node ("/dcs/cld:objects");
            xml = new Cld.XmlConfig.from_node (cld_node);
            ctx = new Cld.Context.from_config (xml);
        } catch (GLib.Error e) {
            error (e.message);
        }

        object_added.connect ((id) => { updated (id); });
        object_removed.connect ((id) => { updated (id); });

        setup_model ();
    }

    /**
     * Some generic setup for the configuration components.
     */
    private void setup_model () {
        config.property_changed.connect (config_property_changed_cb);

        /* Property loading */
        name = config.get_string_property ("app");
        admin = config.get_boolean_property ("admin");
    }

    /**
     * Callback to handle configuration changes that could be done in different
     * pieces of the application.
     */
    private void config_property_changed_cb (string property) {
        //message ("Property '%s' was changed.\n", property);
    }

    /**
     * {@inheritDoc}
     */
    [Version (deprecated = true, deprecated_since = "0.2")]
    public void update_objects (Gee.Map<string, Dcs.Object> val) {
        _objects = val;
        updated (null);
    }
}

public class Dcs.FooModel : Dcs.Node {

    public FooModel () {
        this.id = "root";
    }
}
