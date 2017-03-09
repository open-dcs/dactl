public errordomain Dcs.ConfigError {
    FILE_NOT_FOUND,
    NO_VALUE_SET,
    NO_VALUE_FOUND,
    VALUE_OUT_OF_RANGE,
    INVALID_FORMAT,
    INVALID_NAMESPACE,
    INVALID_KEY,
    INVALID_XPATH_EXPR,
    PROPERTY_TYPE,
    UNSUPPORTED_FORMAT,
    XML_DOCUMENT_EMPTY
}

public enum Dcs.ConfigFormat {
    OPTIONS,
    INI,
    JSON,
    XML,
    MIXED,
    INVALID;

    public bool is_valid () {
        switch (this) {
            case OPTIONS: return true;
            case INI:     return true;
            case JSON:    return true;
            case XML:     return true;
            case MIXED:   return true;
            case INVALID:
            default:      return false;
        }
    }
}

public enum Dcs.ConfigEntry {
    NAMESPACE,
    FORMAT
}

/**
 * Interface for handling DCS configurations.
 */
public interface Dcs.Config : GLib.Object {

    /**
     * Emitted when any known configuration setting has changed.
     */
    public signal void config_changed (Dcs.ConfigEntry entry);

    /**
     * Emitted when a custom setting has changed.
     */
    public signal void setting_changed (string ns, string key);

    /**
     * Check if the type of the property in the class given matches the desired
     * type provided.
     *
     * XXX Should this just return a boolean instead of throwing errors?
     *
     * @param class_type Class to check property existence and type correctness
     * @param check_type Type of the property to check against
     * @param property Name of the property to check
     *
     * @throws Dcs.ConfigError Configuration error, see {@link Dcs.ConfigError}.
     */
    public static void check_property_type (GLib.Type class_type,
                                            GLib.Type check_type,
                                            string property) throws GLib.Error {
        var ocl = (GLib.ObjectClass) class_type.class_ref ();
        unowned GLib.ParamSpec? spec = ocl.find_property (property);

        if (spec == null) {
            throw new Dcs.ConfigError.INVALID_KEY ("No property with that name");
        } else if (spec.value_type != check_type) {
            throw new Dcs.ConfigError.PROPERTY_TYPE (
                "The wrong type was requested for the property");
        }
    }

    /**
     * Dump the configuration to the file stream provided. Used for
     * debugging purposes.
     *
     * @param stream Output stream to write to.
     */
    public virtual void dump (GLib.FileStream stream) {
        var type = get_type ();
        stream.write (type.name ().data);
        stream.write ({ 13, 10 });
        var ocl = (GLib.ObjectClass) type.class_ref ();
        foreach (var spec in ocl.list_properties ()) {
            //GLib.Value value;
            //@get (spec.get_name (), out value);
            stream.write (spec.get_name ().data);
        }
    }

    /**
     * Get the configuration namespace used.
     *
     * @return Configuration namespace.
     *
     * @throws Dcs.ConfigError Configuration error, see {@link Dcs.ConfigError}.
     */
    public abstract string get_namespace () throws GLib.Error;

    /**
     * Get the current configuration format used.
     *
     * @return Configuration format, see {@link Dcs.ConfigFormat}.
     *
     * @throws Dcs.ConfigError Configuration error, see {@link Dcs.ConfigError}.
     */
    public abstract Dcs.ConfigFormat get_format () throws GLib.Error;

    /**
     * Retrieve a string property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract string get_string (string ns,
                                       string key)
                                       throws GLib.Error;

    /**
     * Retrieve a string list property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract Gee.ArrayList<string> get_string_list (string ns,
                                                           string key)
                                                           throws GLib.Error;

    /**
     * Retrieve an int property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract int get_int (string ns,
                                 string key)
                                 throws GLib.Error;

    /**
     * Retrieve an int list property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract Gee.ArrayList<int> get_int_list (string ns,
                                                     string key)
                                                     throws GLib.Error;

    /**
     * Retrieve a boolean property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract bool get_bool (string ns,
                                   string key)
                                   throws GLib.Error;

    /**
     * Retrieve an double property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract double get_double (string ns,
                                       string key) throws GLib.Error;

    /**
     * TODO fill me in
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to set.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract void set_string (string ns,
                                     string key,
                                     string value) throws GLib.Error;

    /**
     * TODO fill me in
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to set.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract void set_int (string ns,
                                  string key,
                                  int value) throws GLib.Error;

    /**
     * TODO fill me in
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to set.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract void set_bool (string ns,
                                   string key,
                                   bool value) throws GLib.Error;

    /**
     * TODO fill me in
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to set.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract void set_double (string ns,
                                     string key,
                                     double value) throws GLib.Error;

    /**
     * TODO fill me in
     */
    protected static string json_get_string (Json.Node node,
                                             string key) {
        var obj = node.get_object ();
        var prop = obj.get_member ("properties");
        var prop_obj = prop.get_object ();
        var sprop = prop_obj.get_member (key);
        var type = sprop.get_value_type ();

        if (type.is_a (typeof (string))) {
            return prop_obj.get_string_member (key);
        }

        return null;
    }

    /**
     * TODO fill me in
     */
    protected static Gee.ArrayList<string> json_get_string_list (Json.Node node,
                                                                 string key) {
        Gee.ArrayList<string> val = null;

        var obj = node.get_object ();
        var prop = obj.get_member ("properties");
        var prop_obj = prop.get_object ();
        var arr = prop_obj.get_array_member (key);
        var list = arr.get_elements ();
        foreach (var item in list) {
            var type = item.get_value_type ();
            if (type.is_a (typeof (string))) {
                if (val == null) {
                    val = new Gee.ArrayList<string> ();
                }
                val.add (item.get_string ());
            }
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    protected static int json_get_int (Json.Node node,
                                       string key) throws GLib.Error {
        int val = 0;
        bool unavailable = true;

        var obj = node.get_object ();
        var prop = obj.get_member ("properties");
        var prop_obj = prop.get_object ();
        var iprop = prop_obj.get_member (key);
        var type = iprop.get_value_type ();

        if (type.is_a (typeof (int64))) {
            val = (int) prop_obj.get_int_member (key);
            unavailable = false;
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    protected static Gee.ArrayList<int> json_get_int_list (Json.Node node,
                                                           string key) {
        Gee.ArrayList<int> val = null;

        var obj = node.get_object ();
        var prop = obj.get_member ("properties");
        var prop_obj = prop.get_object ();
        var arr = prop_obj.get_array_member (key);
        var list = arr.get_elements ();
        foreach (var item in list) {
            var type = item.get_value_type ();
            if (type.is_a (typeof (int64))) {
                if (val == null) {
                    val = new Gee.ArrayList<int> ();
                }
                val.add ((int) item.get_int ());
            }
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    protected static bool json_get_bool (Json.Node node,
                                         string key) throws GLib.Error {
        bool val = false;
        bool unavailable = true;

        var obj = node.get_object ();
        var prop = obj.get_member ("properties");
        var prop_obj = prop.get_object ();
        var bprop = prop_obj.get_member (key);
        var type = bprop.get_value_type ();

        if (type.is_a (typeof (bool))) {
            val = (bool) prop_obj.get_boolean_member (key);
            unavailable = false;
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    protected static double json_get_double (Json.Node node,
                                             string key) throws GLib.Error {
        double val = 0.0;
        bool unavailable = true;

        var obj = node.get_object ();
        var prop = obj.get_member ("properties");
        var prop_obj = prop.get_object ();
        var dprop = prop_obj.get_member (key);
        var type = dprop.get_value_type ();

        if (type.is_a (typeof (double))) {
            val = (double) prop_obj.get_double_member (key);
            unavailable = false;
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    protected static void json_set_string (Json.Node node,
                                           string key,
                                           string value) {

    }

    /**
     * TODO fill me in
     */
    protected static void json_set_int (Json.Node node,
                                        string key,
                                        int value) {
    }

    /**
     * TODO fill me in
     */
    protected static void json_set_bool (Json.Node node,
                                         string key,
                                         bool value) {
    }

    /**
     * TODO fill me in
     */
    protected static void json_set_double (Json.Node node,
                                           string key,
                                           double value) {
    }

    /**
     * TODO fill me in
     */
    protected static string xml_get_string (Xml.Node* node, string key) {
        string val = null;

        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
            if (iter->name == "property") {
                if (iter->get_prop ("name") == key) {
                    val = iter->get_content ();
                }
            }
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    protected static Gee.ArrayList<string> xml_get_string_list (Xml.Node* node,
                                                                string key) {
        Gee.ArrayList<string> val = null;

        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
            if (iter->name == "property") {
                if (iter->get_prop ("name") == key) {
                    var list = iter->get_content ();
                    foreach (var item in list.split (",")) {
                        if (val == null) {
                            val = new Gee.ArrayList<string> ();
                        }
                        val.add (item);
                    }
                }
            }
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    protected static int xml_get_int (Xml.Node* node,
                                      string key) throws GLib.Error {
        int val = 0;
        bool unavailable = true;

        // ...
        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
            if (iter->name == "property") {
                if (iter->get_prop ("name") == key) {
                    val = int.parse (iter->get_content ());
                    unavailable = false;
                }
            }
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    protected static Gee.ArrayList<int> xml_get_int_list (Xml.Node* node,
                                                          string key) {
        Gee.ArrayList<int> val = null;

        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
            if (iter->name == "property") {
                if (iter->get_prop ("name") == key) {
                    var list = iter->get_content ();
                    foreach (var item in list.split (",")) {
                        if (val == null) {
                            val = new Gee.ArrayList<int> ();
                        }
                        val.add (int.parse (item));
                    }
                }
            }
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    protected static bool xml_get_bool (Xml.Node* node,
                                        string key) throws GLib.Error {
        bool val = false;
        bool unavailable = true;

        // ...
        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
            if (iter->name == "property") {
                if (iter->get_prop ("name") == key) {
                    val = bool.parse (iter->get_content ());
                    unavailable = false;
                }
            }
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    protected static double xml_get_double (Xml.Node* node,
                                            string key) throws GLib.Error {
        double val = 0.0;
        bool unavailable = true;

        // ...
        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
            if (iter->name == "property") {
                if (iter->get_prop ("name") == key) {
                    val = double.parse (iter->get_content ());
                    unavailable = false;
                }
            }
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    protected static void xml_set_string (Xml.Node* node,
                                          string key,
                                          string value) {

    }

    /**
     * TODO fill me in
     */
    protected static void xml_set_int (Xml.Node* node,
                                       string key,
                                       int value) {
    }

    /**
     * TODO fill me in
     */
    protected static void xml_set_bool (Xml.Node* node,
                                        string key,
                                        bool value) {
    }

    /**
     * TODO fill me in
     */
    protected static void xml_set_double (Xml.Node* node,
                                          string key,
                                          double value) {
    }
}
