public class Dcs.MetaConfig : Dcs.Config, GLib.Object {

    public string ns { get; private set; default = "dcs"; }

    public Dcs.ConfigFormat format {
        get { return get_format (); }
        private set { format = value; }
    }

    private Gee.ArrayList<Dcs.Config> config_list;

    private static Once<Dcs.MetaConfig> _instance;

    construct {
        format = Dcs.ConfigFormat.MIXED;
        config_list = new Gee.ArrayList<Dcs.Config> ();
    }

    /**
     * Instantiate singleton for configuration container.
     *
     * @return Instance of the configuration container.
     */
    public static unowned Dcs.MetaConfig get_default () {
        return _instance.once (() => { return new Dcs.MetaConfig (); });
    }

    public string get_namespace () throws GLib.Error {
        if (ns != "dcs") {
            throw new Dcs.ConfigError.INVALID_NAMESPACE (_("Invalid namespace has been set"));
        }
        return ns;
    }

    public Dcs.ConfigFormat get_format () throws GLib.Error {
        if (format != Dcs.ConfigFormat.MIXED) {
            throw new Dcs.ConfigError.INVALID_FORMAT (_("Invalid format has been set"));
        }
        return format;
    }

    /**
     * {@inheritDoc}
     */
    public string get_string (string ns,
                              string key)
                              throws GLib.Error {
		string value = null;

        foreach (var config in config_list) {
            try {
                value = config.get_string (ns, key);
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET)) {
                    throw e;
                }
            }
        }

        if (value != null) {
            return value;
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (_("No value available"));
		}
    }

    /**
     * {@inheritDoc}
     */
    public Gee.ArrayList<string> get_string_list (string ns,
                                                  string key)
                                                  throws GLib.Error {
        Gee.ArrayList<string> value = null;

        foreach (var config in config_list) {
            try {
                value = config.get_string_list (ns, key);
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET)) {
                    throw e;
                }
            }
        }

        if (value != null) {
            return value;
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (_("No value available"));
		}
    }

    /**
     * {@inheritDoc}
     */
    public int get_int (string ns,
                        string key)
                        throws GLib.Error {
		int value = 0;
		bool value_set = false;

        foreach (var config in config_list) {
            try {
                value = config.get_int (ns, key);
                value_set = true;
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET)) {
                    throw e;
                }
            }
        }

        if (value_set) {
            return value;
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (_("No value available"));
		}
    }

    /**
     * {@inheritDoc}
     */
    public Gee.ArrayList<int> get_int_list (string ns,
                                            string key)
                                            throws GLib.Error {
        Gee.ArrayList<int> value = null;

        foreach (var config in config_list) {
            try {
                value = config.get_int_list (ns, key);
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET)) {
                    throw e;
                }
            }
        }

        if (value != null) {
            return value;
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (_("No value available"));
		}
    }

    /**
     * {@inheritDoc}
     */
    public bool get_bool (string ns,
                          string key)
                          throws GLib.Error {
		bool value = false;
		bool value_set = false;

        foreach (var config in config_list) {
            try {
                value = config.get_bool (ns, key);
                value_set = true;
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET)) {
                    throw e;
                }
            }
        }

        if (value_set) {
            return value;
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (_("No value available"));
		}
    }

    /**
     * {@inheritDoc}
     */
    public double get_double (string ns,
                              string key)
                              throws GLib.Error {
        double value = 0.0;
        bool value_set = false;

        foreach (var config in config_list) {
            try {
                value = config.get_double (ns, key);
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET)) {
                    throw e;
                }
            }
        }

        if (value_set) {
            return value;
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (_("No value available"));
        }
    }

    /**
     * {@inheritDoc}
     */
    public void set_string (string ns,
                            string key,
                            string value) throws GLib.Error {
        foreach (var config in config_list) {
            try {
                config.set_string (ns, key, value);
            } catch (Dcs.ConfigError e) {
                throw e;
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    public void set_int (string ns,
                         string key,
                         int value) throws GLib.Error {
        foreach (var config in config_list) {
            try {
                config.set_int (ns, key, value);
            } catch (Dcs.ConfigError e) {
                throw e;
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    public void set_bool (string ns,
                          string key,
                          bool value) throws GLib.Error {
        foreach (var config in config_list) {
            try {
                config.set_bool (ns, key, value);
            } catch (Dcs.ConfigError e) {
                throw e;
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    public void set_double (string ns,
                            string key,
                            double value) throws GLib.Error {
        foreach (var config in config_list) {
            try {
                config.set_double (ns, key, value);
            } catch (Dcs.ConfigError e) {
                throw e;
            }
        }
    }
}
