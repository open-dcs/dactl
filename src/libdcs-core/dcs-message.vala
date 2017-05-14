public errordomain Dcs.MessageError {
    INVALID_DATA,
    NULL_PAYLOAD
}

[Flags]
public enum Dcs.MessageType {
    UNKNOWN,
    OBJECT,
    CONFIG,
    ALERT,
    ERROR,
    INFO,
    WARNING;

    public string to_string () {
        switch (this) {
            case UNKNOWN: return "unknown";
            case OBJECT:  return "object";
            case CONFIG:  return "config";
            case ALERT:   return "alert";
            case ERROR:   return "error";
            case INFO:    return "info";
            case WARNING: return "warning";
            default: assert_not_reached ();
        }
    }

    public static Dcs.MessageType parse (string value) throws GLib.Error {
        try {
            var regex_object = new Regex ("object", RegexCompileFlags.CASELESS);
            var regex_config = new Regex ("config", RegexCompileFlags.CASELESS);
            var regex_alert = new Regex ("alert", RegexCompileFlags.CASELESS);
            var regex_error = new Regex ("error", RegexCompileFlags.CASELESS);
            var regex_info = new Regex ("info", RegexCompileFlags.CASELESS);
            var regex_warning = new Regex ("warning", RegexCompileFlags.CASELESS);

            if (regex_object.match (value)) {
                return OBJECT;
            } else if (regex_config.match (value)) {
                return CONFIG;
            } else if (regex_alert.match (value)) {
                return ALERT;
            } else if (regex_error.match (value)) {
                return ERROR;
            } else if (regex_info.match (value)) {
                return INFO;
            } else if (regex_warning.match (value)) {
                return WARNING;
            }
        } catch (GLib.RegexError e) {
            throw e;
        }

        return UNKNOWN;
    }
}

[Compact]
public class Dcs.Message : GLib.Object, Dcs.Serializable {

    /**
     * An ID for the message.
     *
     * XXX Consider using a sequence number managed by a QueueManager?
     */
    public string id { get; construct set; }

    /**
     * A unique hash value for the message.
     *
     * TODO Use this to create a hash of a JSON node to validate transmission.
     */
    //public uint16 hash { get; private construct; }

    /**
     * The message timestamp which should be set at the time of creation.
     */
    public int64 timestamp { get; private set; }

    /**
     * The type of message represented.
     */
    public Dcs.MessageType message_type { get; private set; }

    /**
     * The message contents.
     */
    protected uint8[] payload;

    private Json.Node payload_node;

    construct {
        timestamp = GLib.get_real_time ();
    }

    /**
     * Create a new alert message.
     */
    public Message.alert (string id) {
        GLib.Object (id: id);
        message_type = Dcs.MessageType.ALERT;
        payload = "[ALERT] code 100".data;
    }

    /**
     * Create a new error message.
     */
    public Message.error (string id) {
        GLib.Object (id: id);
        message_type = Dcs.MessageType.ERROR;
        payload = "[ERROR] code 200".data;
    }

    /**
     * Create a new information message.
     */
    public Message.info (string id) {
        GLib.Object (id: id);
        message_type = Dcs.MessageType.INFO;
        payload = "[INFO] code 300".data;
    }

    /**
     * Create a new warning message.
     */
    public Message.warning (string id) {
        GLib.Object (id: id);
        message_type = Dcs.MessageType.WARNING;
        payload = "[WARNING] code 400".data;
    }

    /**
     * Create a new message representing an object.
     */
    public Message.object (string id, Json.Node payload_node) {
        GLib.Object (id: id);
        message_type = Dcs.MessageType.OBJECT;
        this.payload_node = payload_node;
    }

    /**
     * {@inheritDoc}
     */
    public virtual void deserialize (string data) throws GLib.Error {
        try {
            var root = Json.from_string (data);
            var obj = root.get_object ();
            var members = obj.get_members ();
            id = members.nth_data (0);
            var node = obj.get_member (members.nth_data (0));
            var node_obj = node.get_object ();
            message_type = Dcs.MessageType.parse (
                node_obj.get_string_member ("type"));
            timestamp = node_obj.get_int_member ("timestamp");
            switch (message_type) {
                case Dcs.MessageType.OBJECT:
                    payload_node = node_obj.get_member ("payload");
                    var str = Json.to_string (payload_node, false);
                    payload = str.data;
                    break;
                case Dcs.MessageType.CONFIG:
                    break;
                case Dcs.MessageType.ALERT:
                case Dcs.MessageType.ERROR:
                case Dcs.MessageType.INFO:
                case Dcs.MessageType.WARNING:
                    var message = node_obj.get_string_member ("message");
                    payload = message.data;
                    break;
                default:
                    break;
            }
        } catch (GLib.Error e) {
            throw e;
        }
    }

    /**
     * {@inheritDoc}
     */
    public virtual string serialize () throws GLib.Error {
        var builder = new Json.Builder ();
        builder.begin_object ();
        builder.set_member_name (id);
        builder.begin_object ();
        builder.set_member_name ("type");
        builder.add_string_value (message_type.to_string ());
        builder.set_member_name ("timestamp");
        builder.add_int_value (timestamp);
        switch (message_type) {
            case Dcs.MessageType.OBJECT:
                if (payload_node == null) {
                    throw new Dcs.MessageError.NULL_PAYLOAD ("Empty payload");
                }
                try {
                    //var payload_node = Json.from_string ((string) payload);
                    builder.set_member_name ("payload");
                    builder.add_value (payload_node);
                } catch (GLib.Error e) {
                    throw e;
                }
                break;
            case Dcs.MessageType.CONFIG:
                break;
            case Dcs.MessageType.ALERT:
            case Dcs.MessageType.ERROR:
            case Dcs.MessageType.INFO:
            case Dcs.MessageType.WARNING:
                builder.set_member_name ("message");
                builder.add_string_value ((string) payload);
                break;
            default:
                break;
        }
        builder.end_object ();
        builder.end_object ();

        var generator = new Json.Generator ();
        var node = builder.get_root ();
        generator.set_root (node);

        return generator.to_data (null);
    }

    public string to_string () {
        return serialize ();
    }
}
