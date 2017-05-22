public class Dcs.DAQ.Router : Dcs.Net.Router {

    /*
     *private const Dcs.Net.RouteEntry[] routes = {
     *    { "/",                 Dcs.Net.RouteArg.CALLBACK, (void*) route_default,  null },
     *    { "/channel/<int:id>", Dcs.Net.RouteArg.CALLBACK, (void*) route_channel,  null },
     *    { "/channels",         Dcs.Net.RouteArg.CALLBACK, (void*) route_channels, null },
     *    { null }
     *};
     */

    private const string bad_request = "jsonp(\"XXX\": {\"status\": 400})";

    public Router (Dcs.Net.Service service) {
        this.service = service;
        port = 8080;
        init ();
    }

    public Router.with_port (Dcs.Net.Service service, int port) {
        this.service = service;
        GLib.Object (port: port);
        init ();
    }

    private void init () {
        base.init ();
        debug (_("Initializing the DAQ REST service"));

        add_handler (null,                route_default);
        add_handler ("/api/daq/channels", route_channels);
        add_handler ("/api/daq/devices",  route_devices);
        add_handler ("/api/daq/ports",    route_ports);
        add_handler ("/api/daq/sensors",  route_sensors);
        add_handler ("/api/daq/signals",  route_signals);
        add_handler ("/api/daq/tasks",    route_tasks);

        // XXX idea discussed for having plugins that provide their own
        // configuration pages as a route
        /*
         *foreach (var plugin in plugins) {
         *    add_handler ("/config/device/" + plugin.id, plugin.route_config);
         *    http://10.0.0.10/config/device/dev0
         *}
         */

        /*
         *add_routes (routes);
         */
    }

    /**
     * Default route serves static index page.
     */
    private void route_default (Soup.Server server,
                                Soup.Message msg,
                                string path,
                                GLib.HashTable? query,
                                Soup.ClientContext client) {

/*
 *        unowned Dcs.DAQ.Router self = server as Dcs.DAQ.Router;
 *
 *        // XXX async example that simulates load, should change
 *        Timeout.add_seconds (0, () => {
 *            string html_head = "<head><title>Index</title></head>";
 *            string html_body = "<body><h1>Index:</h1></body>";
 *            msg.set_response ("text/html", Soup.MemoryUse.COPY,
 *                              "<html>%s%s</html>".printf (html_head,
 *                                                          html_body).data);
 *
 *            // Resumes HTTP I/O on msg:
 *            self.unpause_message (msg);
 *            debug ("REST default handler end");
 *            return false;
 *        }, Priority.DEFAULT);
 *
 *        self.pause_message (msg);
 */

        var filename = GLib.Path.build_filename (Dcs.Build.TMPLDIR, "index.tmpl");
        var file = GLib.File.new_for_path (filename);
        var tmpl = new Template.Template (null);

        try {
            tmpl.parse_file (file, null);
            var scope = new Template.Scope ();
            var title = scope.get ("title");
            title.assign_string ("OpenDCS DAQ Service");
            var expanded = tmpl.expand_string (scope);
            stdout.printf ("%s\n", expanded);
            msg.set_response ("text/html", Soup.MemoryUse.COPY, expanded.data);
        } catch (GLib.Error e) {
            critical (e.message);
        }
    }

    private void route_channels (Soup.Server server,
                                 Soup.Message msg,
                                 string path,
                                 GLib.HashTable? query,
                                 Soup.ClientContext client) {
        /* Leaving in leading / results in empty 0th token */
        string[] tokens = path.substring (1).split ("/");

        switch (msg.method.up ()) {
            case "PUT":
                break;
            case "GET":
                break;
            case "POST":
                break;
            case "DELETE":
                break;
            default:
                send_bad_request (msg, tokens[3], 502, "Unsupported request");
                break;
        }
    }

    private void route_devices (Soup.Server server,
                                Soup.Message msg,
                                string path,
                                GLib.HashTable? query,
                                Soup.ClientContext client) {
        /* Leaving in leading / results in empty 0th token */
        string[] tokens = path.substring (1).split ("/");

        switch (msg.method.up ()) {
            case "PUT":
                var obj = new Dcs.DAQ.Device ();
                //(obj as Dcs.DAQ.Device).json_deserialize ();
                var daq = service.get_model ().@get ("daq");
                try {
                    daq.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, "daq-" + tokens[2], 504,
                                      "Failed to add the object provided");
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.DAQ.Device);
                if (tokens.length >= 4) {
                    var daq = service.get_model ().@get ("daq");
                    var node = daq.@get (tokens[3]);
                    if (node != null) {
                        json = node.json_serialize ();
                    } else {
                        send_bad_request (msg, tokens[2], 501, "Object not found");
                        return;
                    }
                } else {
                    var nodes = service.get_model ().get_descendants (type);
                    var builder = new Json.Builder ();
                    builder.begin_object ();
                    builder.set_member_name (tokens[2]);
                    if (nodes != null) {
                        builder.begin_array ();
                        foreach (var node in nodes) {
                            var json_node = (node as Dcs.DAQ.Device).json_serialize ();
                            builder.add_value (json_node);
                        }
                        builder.end_array ();
                    }
                    builder.end_object ();
                    json = builder.get_root ();
                }
                var response = Json.to_string (json, false);
                msg.status_code = Soup.Status.OK;
                msg.response_headers.append ("Access-Control-Allow-Origin", "*");
                msg.set_response ("application/json",
                                  Soup.MemoryUse.COPY,
                                  response.data);
                break;
            case "POST":
                if (tokens.length < 4) {
                    send_bad_request (msg, "daq-" + tokens[2], 503,
                                      msg.method.up () + " request requires ID");
                }
                send_unimplemented_request (msg, "daq-");
                break;
            case "DELETE":
                if (tokens.length < 4) {
                    send_bad_request (msg, "daq-" + tokens[2], 503,
                                      msg.method.up () + " request requires ID");
                }
                send_unimplemented_request (msg, "daq-");
                break;
            default:
                send_bad_request (msg, tokens[3], 502, "Unsupported request");
                break;
        }
    }

    private void route_ports (Soup.Server server,
                              Soup.Message msg,
                              string path,
                              GLib.HashTable? query,
                              Soup.ClientContext client) {
        /* Leaving in leading / results in empty 0th token */
        string[] tokens = path.substring (1).split ("/");

        switch (msg.method.up ()) {
            case "PUT":
                break;
            case "GET":
                break;
            case "POST":
                break;
            case "DELETE":
                break;
            default:
                send_bad_request (msg, tokens[3], 502, "Unsupported request");
                break;
        }
    }

    private void route_sensors (Soup.Server server,
                                Soup.Message msg,
                                string path,
                                GLib.HashTable? query,
                                Soup.ClientContext client) {
        /* Leaving in leading / results in empty 0th token */
        string[] tokens = path.substring (1).split ("/");

        switch (msg.method.up ()) {
            case "PUT":
                break;
            case "GET":
                break;
            case "POST":
                break;
            case "DELETE":
                break;
            default:
                send_bad_request (msg, tokens[3], 502, "Unsupported request");
                break;
        }
    }

    private void route_signals (Soup.Server server,
                                Soup.Message msg,
                                string path,
                                GLib.HashTable? query,
                                Soup.ClientContext client) {
        /* Leaving in leading / results in empty 0th token */
        string[] tokens = path.substring (1).split ("/");

        switch (msg.method.up ()) {
            case "PUT":
                break;
            case "GET":
                break;
            case "POST":
                break;
            case "DELETE":
                break;
            default:
                send_bad_request (msg, tokens[3], 502, "Unsupported request");
                break;
        }
    }

    private void route_tasks (Soup.Server server,
                              Soup.Message msg,
                              string path,
                              GLib.HashTable? query,
                              Soup.ClientContext client) {
        /* Leaving in leading / results in empty 0th token */
        string[] tokens = path.substring (1).split ("/");

        switch (msg.method.up ()) {
            case "PUT":
                break;
            case "GET":
                break;
            case "POST":
                break;
            case "DELETE":
                break;
            default:
                send_bad_request (msg, tokens[3], 502, "Unsupported request");
                break;
        }
    }
}
