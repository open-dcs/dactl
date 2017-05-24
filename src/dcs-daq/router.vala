public class Dcs.DAQ.Router : Dcs.Net.Router {

    /*
     *private const Dcs.Net.RouteEntry[] routes = {
     *    { "/",                 Dcs.Net.RouteArg.CALLBACK, (void*) route_default,  null },
     *    { "/channel/<int:id>", Dcs.Net.RouteArg.CALLBACK, (void*) route_channel,  null },
     *    { "/channels",         Dcs.Net.RouteArg.CALLBACK, (void*) route_channels, null },
     *    { null }
     *};
     */

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

        if (tokens[1] != "daq") {
            send_bad_request (msg, "daq", Dcs.Net.RouterErrorCode.WRONG_NAMESPACE);
            return;
        }

        switch (msg.method.up ()) {
            case "PUT":
                send_unimplemented_request (msg, tokens[2] + "-" + tokens[3]);
                break;
            case "GET":
                send_unimplemented_request (msg, tokens[2] + "-" + tokens[3]);
                break;
            case "POST":
                send_unimplemented_request (msg, tokens[2] + "-" + tokens[3]);
                break;
            case "DELETE":
                send_unimplemented_request (msg, tokens[2] + "-" + tokens[3]);
                break;
            default:
                send_bad_request (msg, tokens[3], Dcs.Net.RouterErrorCode.UNSUPPORTED_REQUEST);
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

        if (tokens[1] != "daq") {
            send_bad_request (msg, "daq", Dcs.Net.RouterErrorCode.WRONG_NAMESPACE);
            return;
        }

        switch (msg.method.up ()) {
            case "PUT":
                var obj = new Dcs.DAQ.Device ();
                var json = Json.from_string ((string) msg.request_body.data);
                (obj as Dcs.DAQ.Device).json_deserialize (json);
                var daq = service.get_model ().@get ("daq");
                try {
                    daq.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.OBJECT_INSERT_FAILED);
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.DAQ.Device);
                if (tokens.length >= 4) {
                    var daq = service.get_model ().@get ("daq");
                    var node = daq.@get (tokens[3]);
                    if (node != null) {
                        json = (node as Dcs.DAQ.Device).json_serialize ();
                    } else {
                        send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
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
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var json = Json.from_string ((string) msg.request_body.data);
                var daq = service.get_model ().@get ("daq");
                var node = daq.@get (tokens[3]);
                if (node != null) {
                    (node as Dcs.DAQ.Device).json_deserialize (json);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            case "DELETE":
                if (tokens.length < 4) {
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var daq = service.get_model ().@get ("daq");
                var node = daq.@get (tokens[3]);
                if (node != null) {
                    daq.remove (node);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            default:
                send_bad_request (msg, tokens[3], Dcs.Net.RouterErrorCode.UNSUPPORTED_REQUEST);
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

        if (tokens[1] != "daq") {
            send_bad_request (msg, "daq", Dcs.Net.RouterErrorCode.WRONG_NAMESPACE);
            return;
        }

        /* FIXME This needs to detect port type, only testing with serial ports now */

        switch (msg.method.up ()) {
            case "PUT":
                var obj = new Dcs.DAQ.SerialPort ();
                var json = Json.from_string ((string) msg.request_body.data);
                (obj as Dcs.DAQ.SerialPort).json_deserialize (json);
                var daq = service.get_model ().@get ("daq");
                try {
                    daq.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.OBJECT_INSERT_FAILED);
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.DAQ.SerialPort);
                if (tokens.length >= 4) {
                    var daq = service.get_model ().@get ("daq");
                    var node = daq.@get (tokens[3]);
                    if (node != null) {
                        json = (node as Dcs.DAQ.SerialPort).json_serialize ();
                    } else {
                        send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
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
                            var json_node = (node as Dcs.DAQ.SerialPort).json_serialize ();
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
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var json = Json.from_string ((string) msg.request_body.data);
                var daq = service.get_model ().@get ("daq");
                var node = daq.@get (tokens[3]);
                if (node != null) {
                    (node as Dcs.DAQ.SerialPort).json_deserialize (json);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            case "DELETE":
                if (tokens.length < 4) {
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var daq = service.get_model ().@get ("daq");
                var node = daq.@get (tokens[3]);
                if (node != null) {
                    daq.remove (node);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            default:
                send_bad_request (msg, tokens[3], Dcs.Net.RouterErrorCode.UNSUPPORTED_REQUEST);
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

        if (tokens[1] != "daq") {
            send_bad_request (msg, "daq", Dcs.Net.RouterErrorCode.WRONG_NAMESPACE);
            return;
        }

        switch (msg.method.up ()) {
            case "PUT":
                var obj = new Dcs.DAQ.Sensor ();
                var json = Json.from_string ((string) msg.request_body.data);
                (obj as Dcs.DAQ.Sensor).json_deserialize (json);
                var daq = service.get_model ().@get ("daq");
                try {
                    daq.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.OBJECT_INSERT_FAILED);
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.DAQ.Sensor);
                if (tokens.length >= 4) {
                    var daq = service.get_model ().@get ("daq");
                    var node = daq.@get (tokens[3]);
                    if (node != null) {
                        json = (node as Dcs.DAQ.Sensor).json_serialize ();
                    } else {
                        send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
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
                            var json_node = (node as Dcs.DAQ.Sensor).json_serialize ();
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
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var json = Json.from_string ((string) msg.request_body.data);
                var daq = service.get_model ().@get ("daq");
                var node = daq.@get (tokens[3]);
                if (node != null) {
                    (node as Dcs.DAQ.Sensor).json_deserialize (json);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            case "DELETE":
                if (tokens.length < 4) {
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var daq = service.get_model ().@get ("daq");
                var node = daq.@get (tokens[3]);
                if (node != null) {
                    daq.remove (node);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            default:
                send_bad_request (msg, tokens[3], Dcs.Net.RouterErrorCode.UNSUPPORTED_REQUEST);
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

        if (tokens[1] != "daq") {
            send_bad_request (msg, "daq", Dcs.Net.RouterErrorCode.WRONG_NAMESPACE);
            return;
        }

        switch (msg.method.up ()) {
            case "PUT":
                var obj = new Dcs.DAQ.Signal ();
                var json = Json.from_string ((string) msg.request_body.data);
                (obj as Dcs.DAQ.Signal).json_deserialize (json);
                var daq = service.get_model ().@get ("daq");
                try {
                    daq.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.OBJECT_INSERT_FAILED);
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.DAQ.Signal);
                if (tokens.length >= 4) {
                    var daq = service.get_model ().@get ("daq");
                    var node = daq.@get (tokens[3]);
                    if (node != null) {
                        json = (node as Dcs.DAQ.Signal).json_serialize ();
                    } else {
                        send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
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
                            var json_node = (node as Dcs.DAQ.Signal).json_serialize ();
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
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var json = Json.from_string ((string) msg.request_body.data);
                var daq = service.get_model ().@get ("daq");
                var node = daq.@get (tokens[3]);
                if (node != null) {
                    (node as Dcs.DAQ.Signal).json_deserialize (json);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            case "DELETE":
                if (tokens.length < 4) {
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var daq = service.get_model ().@get ("daq");
                var node = daq.@get (tokens[3]);
                if (node != null) {
                    daq.remove (node);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            default:
                send_bad_request (msg, tokens[3], Dcs.Net.RouterErrorCode.UNSUPPORTED_REQUEST);
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

        if (tokens[1] != "daq") {
            send_bad_request (msg, "daq", Dcs.Net.RouterErrorCode.WRONG_NAMESPACE);
            return;
        }

        switch (msg.method.up ()) {
            case "PUT":
                var obj = new Dcs.DAQ.Task ();
                var json = Json.from_string ((string) msg.request_body.data);
                (obj as Dcs.DAQ.Task).json_deserialize (json);
                var daq = service.get_model ().@get ("daq");
                try {
                    daq.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.OBJECT_INSERT_FAILED);
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.DAQ.Task);
                if (tokens.length >= 4) {
                    var daq = service.get_model ().@get ("daq");
                    var node = daq.@get (tokens[3]);
                    if (node != null) {
                        json = (node as Dcs.DAQ.Task).json_serialize ();
                    } else {
                        send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
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
                            var json_node = (node as Dcs.DAQ.Task).json_serialize ();
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
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var json = Json.from_string ((string) msg.request_body.data);
                var daq = service.get_model ().@get ("daq");
                var node = daq.@get (tokens[3]);
                if (node != null) {
                    (node as Dcs.DAQ.Task).json_deserialize (json);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            case "DELETE":
                if (tokens.length < 4) {
                    send_bad_request (msg, "daq-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var daq = service.get_model ().@get ("daq");
                var node = daq.@get (tokens[3]);
                if (node != null) {
                    daq.remove (node);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            default:
                send_bad_request (msg, tokens[3], Dcs.Net.RouterErrorCode.UNSUPPORTED_REQUEST);
                break;
        }
    }
}
