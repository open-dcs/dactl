/**
 * Base class that can be used for configuration implementations.
 *
 * XXX This only exists to have something to use in unit tests for now. Throwing
 * errors masks cases where the implementing class hasn't provided an
 * overriding method.
 */
public abstract class Dcs.AbstractConfig : Dcs.Config, GLib.Object {

    protected Dcs.ConfigFormat format;

    protected string @namespace = "dcs";

    /**
     * {@inheritDoc}
     */
    public virtual void dump (GLib.FileStream stream) {
        /* TODO ??? */
    }

    /**
     * {@inheritDoc}
     */
    public virtual string get_namespace () throws GLib.Error {
        if (@namespace == null) {
            throw new ConfigError.NO_VALUE_SET (_("No value available"));
        }
        return @namespace;
    }

    /**
     * {@inheritDoc}
     */
    public virtual Dcs.ConfigFormat get_format () throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual string get_string (string ns,
                                      string key)
                                      throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual Gee.ArrayList<string> get_string_list (string ns,
                                                          string key)
                                                          throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual int get_int (string ns,
                                string key)
                                throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual Gee.ArrayList<int> get_int_list (string ns,
                                                    string key)
                                                    throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual bool get_bool (string ns,
                                  string key)
                                  throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual double get_double (string ns,
                                      string key) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual Dcs.Config get_node (string ns,
                                        string key) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_string (string ns,
                                    string key,
                                    string value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_int (string ns,
                                 string key,
                                 int value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_bool (string ns,
                                  string key,
                                  bool value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_double (string ns,
                                    string key,
                                    double value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_node (string ns,
                                  string key,
                                  Dcs.Config? value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * TODO Make all of the json_/xml_ get/set methods below internal. It is
     * apparently possible to do this and still have them accessible to other
     * libraries by generating an internal header and vapi.
     *
     * XXX Alternatively these could end up in objects for Dcs.Config.Json
     * and Dcs.Config.Xml in dcs-config-util.vala, or something similar to that.
     */

    /**
     * TODO fill me in
     */
    protected static string json_get_string (Json.Node node,
                                             string key) {
        var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
        var prop = data.get_member ("properties");
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
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
        var prop = data.get_member ("properties");
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
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
        var prop = data.get_member ("properties");
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
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
        var prop = data.get_member ("properties");
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
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
        var prop = data.get_member ("properties");
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
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
        var prop = data.get_member ("properties");
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
		var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
		var prop = data.get_member ("properties");
		var prop_obj = prop.get_object ();
		prop_obj.set_string_member (key, value);
    }

    /**
     * TODO fill me in
     */
    protected static void json_set_int (Json.Node node,
                                        string key,
                                        int value) {
		var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
		var prop = data.get_member ("properties");
		var prop_obj = prop.get_object ();
		prop_obj.set_int_member (key, (int64) value);
    }

    /**
     * TODO fill me in
     */
    protected static void json_set_bool (Json.Node node,
                                         string key,
                                         bool value) {
		var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
		var prop = data.get_member ("properties");
		var prop_obj = prop.get_object ();
		prop_obj.set_boolean_member (key, value);
    }

    /**
     * TODO fill me in
     */
    protected static void json_set_double (Json.Node node,
                                           string key,
                                           double value) {
		var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
		var prop = data.get_member ("properties");
		var prop_obj = prop.get_object ();
		prop_obj.set_double_member (key, value);
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
		for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
			if (iter->name == "property") {
				if (iter->get_prop ("name") == key) {
					iter->set_content (value);
				}
			}
		}
    }

    /**
     * TODO fill me in
     */
    protected static void xml_set_int (Xml.Node* node,
                                       string key,
                                       int value) {
		for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
			if (iter->name == "property") {
				if (iter->get_prop ("name") == key) {
					iter->set_content (value.to_string ());
				}
			}
		}
    }

    /**
     * TODO fill me in
     */
    protected static void xml_set_bool (Xml.Node* node,
                                        string key,
                                        bool value) {
		for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
			if (iter->name == "property") {
				if (iter->get_prop ("name") == key) {
					iter->set_content (value.to_string ());
				}
			}
		}
    }

    /**
     * TODO fill me in
     */
    protected static void xml_set_double (Xml.Node* node,
                                          string key,
                                          double value) {
		for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
			if (iter->name == "property") {
				if (iter->get_prop ("name") == key) {
					iter->set_content (value.to_string ());
				}
			}
		}
    }
}
