public class Dcs.MetaConfig : Dcs.AbstractConfig {

    private string @namespace { get; private set; default = "dcs"; }

    private Dcs.ConfigFormat format = Dcs.ConfigFormat.MIXED;

    private static Gee.ArrayList<Dcs.Config> config_list;

    private static Dcs.MetaConfig meta_config;

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
        return _instance.once (() => {
            meta_config = new Dcs.MetaConfig ();
            return meta_config;
        });
    }

    public static void register_config (Dcs.Config config) {
        if (Dcs.MetaConfig.config_list == null) {
            Dcs.MetaConfig.config_list = new Gee.ArrayList<Dcs.Config> ();
        }

        config_list.add (config);

        if (_instance.status == OnceStatus.READY) {
            meta_config.connect_signals (config);
        }
    }

    private void connect_signals (Dcs.Config config) {
        /* TODO connect signals from each config here */
    }

    /**
     * {@inheritDoc}
     */
    public override Gee.List<Dcs.ConfigNode> get_children () {
        var list = new Gee.ArrayList<Dcs.ConfigNode> (
            (Gee.EqualDataFunc<Dcs.ConfigNode>) Dcs.ConfigNode.equals);

        foreach (var config in config_list) {
            if (config is Dcs.AbstractConfig &&
                (config as Dcs.AbstractConfig).has_children ()) {
                list.add_all ((config as Dcs.AbstractConfig).get_children ());
            }
        }

        return list.read_only_view;
    }

    /**
     * {@inheritDoc}
     */
    public override void dump (GLib.FileStream stream) {
        foreach (var config in config_list) {
            try {
                var type = config.get_type ();
                var str = "*** ( %s - %s ) ***\n".printf (
                    type.name (), config.get_namespace ());
                stream.puts (str);
                config.dump (stream);
            } catch (GLib.Error e) {
                debug (e.message);
            }
        }
    }

    public override string get_namespace () throws GLib.Error {
        if (@namespace != "dcs") {
            throw new Dcs.ConfigError.INVALID_NAMESPACE (_("Invalid namespace has been set"));
        }
        return @namespace;
    }

    public override Dcs.ConfigFormat get_format () throws GLib.Error {
        if (format != Dcs.ConfigFormat.MIXED) {
            throw new Dcs.ConfigError.INVALID_FORMAT (_("Invalid format has been set"));
        }
        return format;
    }

    /**
     * {@inheritDoc}
     */
    public override string get_string (string ns,
                                       string key)
                                       throws GLib.Error {
		string value = null;

        foreach (var config in config_list) {
            try {
                value = config.get_string (ns, key);
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET
                    || e is Dcs.ConfigError.INVALID_KEY)) {
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
    public override Gee.ArrayList<string> get_string_list (string ns,
                                                           string key)
                                                           throws GLib.Error {
        Gee.ArrayList<string> value = null;

        foreach (var config in config_list) {
            try {
                value = config.get_string_list (ns, key);
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET
                    || e is Dcs.ConfigError.INVALID_KEY)) {
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
    public override int get_int (string ns,
                                 string key)
                                 throws GLib.Error {
		int value = 0;
		bool value_set = false;

        foreach (var config in config_list) {
            try {
                value = config.get_int (ns, key);
                value_set = true;
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET
                    || e is Dcs.ConfigError.INVALID_KEY)) {
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
    public override Gee.ArrayList<int> get_int_list (string ns,
                                                     string key)
                                                     throws GLib.Error {
        Gee.ArrayList<int> value = null;

        foreach (var config in config_list) {
            try {
                value = config.get_int_list (ns, key);
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET
                    || e is Dcs.ConfigError.INVALID_KEY)) {
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
    public override bool get_bool (string ns,
                                   string key)
                                   throws GLib.Error {
		bool value = false;
		bool value_set = false;

        foreach (var config in config_list) {
            try {
                value = config.get_bool (ns, key);
                value_set = true;
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET
                    || e is Dcs.ConfigError.INVALID_KEY)) {
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
    public override double get_double (string ns,
                                       string key)
                                       throws GLib.Error {
        double value = 0.0;
        bool value_set = false;

        foreach (var config in config_list) {
            try {
                value = config.get_double (ns, key);
                value_set = true;
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET
                    || e is Dcs.ConfigError.INVALID_KEY)) {
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
    public override void set_string (string ns,
                                     string key,
                                     string value) throws GLib.Error {
        foreach (var config in config_list) {
            try {
                config.set_string (ns, key, value);
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET
                    || e is Dcs.ConfigError.INVALID_KEY)) {
                    throw e;
                }
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_int (string ns,
                                  string key,
                                  int value) throws GLib.Error {
        foreach (var config in config_list) {
            try {
                config.set_int (ns, key, value);
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET
                    || e is Dcs.ConfigError.INVALID_KEY)) {
                    throw e;
                }
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_bool (string ns,
                                   string key,
                                   bool value) throws GLib.Error {
        foreach (var config in config_list) {
            try {
                config.set_bool (ns, key, value);
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET
                    || e is Dcs.ConfigError.INVALID_KEY)) {
                    throw e;
                }
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_double (string ns,
                                     string key,
                                     double value) throws GLib.Error {
        foreach (var config in config_list) {
            try {
                config.set_double (ns, key, value);
            } catch (Dcs.ConfigError e) {
                if (!(e is Dcs.ConfigError.NO_VALUE_SET
                    || e is Dcs.ConfigError.INVALID_KEY)) {
                    throw e;
                }
            }
        }
    }
}
