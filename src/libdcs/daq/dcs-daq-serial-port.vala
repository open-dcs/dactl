public class Dcs.DAQ.SerialPort : Dcs.DAQ.Port {

    /**
     * Parity bit options.
     */
    public enum Parity {
        NONE,
        ODD,
        EVEN,
        MARK,
        SPACE;

        public string to_string () {
            switch (this) {
                case NONE:  return "None";
                case ODD:   return "Odd";
                case EVEN:  return "Even";
                case MARK:  return "Mark";
                case SPACE: return "Space";
                default: assert_not_reached ();
            }
        }

        public string to_char () {
            switch (this) {
                case NONE:  return "N";
                case ODD:   return "O";
                case EVEN:  return "E";
                case MARK:  return "M";
                case SPACE: return "S";
                default: assert_not_reached ();
            }
        }

        public static Parity[] all () {
            return { NONE, ODD, EVEN, MARK, SPACE };
        }

        public static Parity parse (string value) {
            try {
                var regex_none  = new Regex ("none", RegexCompileFlags.CASELESS);
                var regex_odd   = new Regex ("odd", RegexCompileFlags.CASELESS);
                var regex_even  = new Regex ("even", RegexCompileFlags.CASELESS);
                var regex_mark  = new Regex ("mark", RegexCompileFlags.CASELESS);
                var regex_space = new Regex ("space", RegexCompileFlags.CASELESS);

                if (regex_none.match (value))
                    return NONE;
                else if (regex_odd.match (value))
                    return ODD;
                else if (regex_even.match (value))
                    return EVEN;
                else if (regex_mark.match (value))
                    return MARK;
                else if (regex_space.match (value))
                    return SPACE;
            } catch (RegexError e) {
                message ("Error %s", e.message);
            }

            /* XXX need to return something */
            return NONE;
        }
    }

    /**
     * Handshake options.
     */
    public enum Handshake {
        NONE,
        HARDWARE,
        SOFTWARE,
        BOTH;

        public string to_string () {
            switch (this) {
                case NONE:     return "None";
                case HARDWARE: return "Hardware";
                case SOFTWARE: return "Software";
                case BOTH:     return "Both";
                default: assert_not_reached ();
            }
        }

        public static Handshake[] all () {
            return { NONE, HARDWARE, SOFTWARE, BOTH };
        }

        public static Handshake parse (string value) {
            try {
                var regex_none     = new Regex ("none", RegexCompileFlags.CASELESS);
                var regex_hardware = new Regex ("hardware", RegexCompileFlags.CASELESS);
                var regex_software = new Regex ("software", RegexCompileFlags.CASELESS);
                var regex_both     = new Regex ("both", RegexCompileFlags.CASELESS);

                if (regex_none.match (value))
                    return NONE;
                else if (regex_hardware.match (value))
                    return HARDWARE;
                else if (regex_software.match (value))
                    return SOFTWARE;
                else if (regex_both.match (value))
                    return BOTH;
            } catch (RegexError e) {
                message ("Error %s", e.message);
            }

            /* XXX need to return something */
            return NONE;
        }
    }

    /**
     * Access options.
     */
    public enum AccessMode {
        READWRITE,
        READONLY,
        WRITEONLY;

        public string to_string () {
            switch (this) {
                case READWRITE: return "Read and Write";
                case READONLY:  return "Read Only";
                case WRITEONLY: return "Write Only";
                default: assert_not_reached ();
            }
        }

        public static AccessMode[] all () {
            return { READWRITE, READONLY, WRITEONLY };
        }

        public static AccessMode parse (string value) {
            try {
                var regex_rw = new Regex ("rw|read(\\040and\\040)*write", RegexCompileFlags.CASELESS);
                var regex_ro = new Regex ("ro|read(\\040)*only", RegexCompileFlags.CASELESS);
                var regex_wo = new Regex ("wo|write(\\040)*only", RegexCompileFlags.CASELESS);

                if (regex_rw.match (value))
                    return READWRITE;
                else if (regex_ro.match (value))
                    return READONLY;
                else if (regex_wo.match (value))
                    return WRITEONLY;
            } catch (RegexError e) {
                message ("Error %s", e.message);
            }

            /* XXX need to return something */
            return READWRITE;
        }
    }

    public string port { get; set; default = "/dev/ttyS0"; }

    public Parity parity { get; set; default = Parity.NONE; }

    public Handshake handshake { get; set; default = Handshake.HARDWARE; }

    public AccessMode access_mode { get; set; default = AccessMode.READWRITE; }

    private uint _baud_rate = Posix.B9600;

    public uint baud_rate {
        get { return _baud_rate; }
        set {
            switch (value) {
                case 300:     _baud_rate = Posix.B300;             break;
                case 600:     _baud_rate = Posix.B600;             break;
                case 1200:    _baud_rate = Posix.B1200;            break;
                case 2400:    _baud_rate = Posix.B2400;            break;
                case 4800:    _baud_rate = Posix.B4800;            break;
                case 9600:    _baud_rate = Posix.B9600;            break;
                case 19200:   _baud_rate = Posix.B19200;           break;
                case 38400:   _baud_rate = Posix.B38400;           break;
                case 57600:   _baud_rate = Posix.B57600;           break;
                case 115200:  _baud_rate = Posix.B115200;          break;
                case 230400:  _baud_rate = Posix.B230400;          break;
                case 460800:  _baud_rate = Linux.Termios.B460800;  break;
                case 576000:  _baud_rate = Linux.Termios.B576000;  break;
                case 921600:  _baud_rate = Linux.Termios.B921600;  break;
                case 1000000: _baud_rate = Linux.Termios.B1000000; break;
                case 2000000: _baud_rate = Linux.Termios.B2000000; break;
                default:      _baud_rate = Posix.B9600;            break;
            }
        }
    }

    public int data_bits { get; set; default = 8; }

    public int stop_bits { get; set; default = 1; }

    public bool echo { get; set; default = false; }

    /**
     * {@inheritDoc}
     */
    public override Json.Node json_serialize () throws GLib.Error {
        var builder = new Json.Builder ();
        builder.begin_object ();
        builder.set_member_name (id);
        builder.begin_object ();
        builder.set_member_name ("type");
        builder.add_string_value ("serial-port");
        builder.set_member_name ("properties");
        builder.begin_object ();
        builder.set_member_name ("port");
        builder.add_string_value (port);
        builder.set_member_name ("parity");
        builder.add_string_value (parity.to_string ());
        builder.set_member_name ("handshake");
        builder.add_string_value (handshake.to_string ());
        builder.set_member_name ("access-mode");
        builder.add_string_value (access_mode.to_string ());
        builder.set_member_name ("baud-rate");
        builder.add_int_value ((int64) baud_rate);
        builder.set_member_name ("stop-bits");
        builder.add_int_value ((int64) data_bits);
        builder.set_member_name ("data-bits");
        builder.add_int_value ((int64) data_bits);
        builder.set_member_name ("echo");
        builder.add_boolean_value (echo);
        builder.end_object ();
        builder.end_object ();
        builder.end_object ();

        var node = builder.get_root ();
        if (node == null) {
            throw new Dcs.SerializationError.SERIALIZE_FAILURE (
                "Failed to serialize publisher %s", id);
        }

        return node;
    }

    /**
     * {@inheritDoc}
     */
    public override void json_deserialize (Json.Node node) throws GLib.Error {
        var obj = node.get_object ();
        id = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (id);

        if (data.has_member ("properties")) {
            var props = data.get_object_member ("properties");
            /*
             *port = (int) props.get_int_member ("port");
             *address = props.get_string_member ("address");
             *transport_spec = props.get_string_member ("transport-spec");
             */
        }
    }
}
