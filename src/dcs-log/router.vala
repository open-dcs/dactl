internal class Dcs.Recorder.Router : Dcs.Net.Router {

    public Router (Dcs.Net.Service service) {
        this.service = service;
        port = 8081;
        init ();
    }

    public Router.with_port (Dcs.Net.Service service, int port) {
        this.service = service;
        GLib.Object (port: port);
        init ();
    }

    private void init () {
        base.init ();
        debug (_("Initializing the Recorder REST service"));

        add_handler (null,                route_default);
        add_handler ("/api/log/backends", route_backends);
        add_handler ("/api/log/logs",     route_logs);
        add_handler ("/api/log/columns",  route_columns);
        add_handler ("/api/log/query",    route_query);
    }

    /**
     * Default route serves static index page.
     */
    private void route_default (Soup.Server server,
                                Soup.Message msg,
                                string path,
                                GLib.HashTable? query,
                                Soup.ClientContext client) {

        unowned Dcs.Recorder.Router self = server as Dcs.Recorder.Router;

        // XXX async example that simulates load, should change
        Timeout.add_seconds (0, () => {
            string html_head = "<head><title>Index</title></head>";
            string html_body = "<body><h1>Index:</h1></body>";
            msg.set_response ("text/html", Soup.MemoryUse.COPY,
                              "<html>%s%s</html>".printf (html_head,
                                                          html_body).data);

            // Resumes HTTP I/O on msg:
            self.unpause_message (msg);
            debug ("REST default handler end");
            return false;
        }, Priority.DEFAULT);

        self.pause_message (msg);
    }

    private void route_backends (Soup.Server server,
                                 Soup.Message msg,
                                 string path,
                                 GLib.HashTable? query,
                                 Soup.ClientContext client) {
        /* Leaving in leading / results in empty 0th token */
        string[] tokens = path.substring (1).split ("/");

        if (tokens[1] != "log") {
            send_bad_request (msg, "log", Dcs.Net.RouterErrorCode.WRONG_NAMESPACE);
            return;
        }

        switch (msg.method.up ()) {
            case "PUT":
                var obj = new Dcs.Log.Backend ();
                var json = Json.from_string ((string) msg.request_body.data);
                (obj as Dcs.Log.Backend).json_deserialize (json);
                var log = service.get_model ().@get ("log");
                try {
                    log.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, "log-" + tokens[2], Dcs.Net.RouterErrorCode.OBJECT_INSERT_FAILED);
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.Log.Backend);
                if (tokens.length >= 4) {
                    var log = service.get_model ().@get ("log");
                    var node = log.@get (tokens[3]);
                    if (node != null) {
                        json = (node as Dcs.Log.Backend).json_serialize ();
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
                            var json_node = (node as Dcs.Log.Backend).json_serialize ();
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
                    send_bad_request (msg, "log-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var json = Json.from_string ((string) msg.request_body.data);
                var log = service.get_model ().@get ("log");
                var node = log.@get (tokens[3]);
                if (node != null) {
                    (node as Dcs.Log.Backend).json_deserialize (json);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            case "DELETE":
                if (tokens.length < 4) {
                    send_bad_request (msg, "log-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var log = service.get_model ().@get ("log");
                var node = log.@get (tokens[3]);
                if (node != null) {
                    log.remove (node);
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

    /* FIXME Change logs to files */
    private void route_logs (Soup.Server server,
                             Soup.Message msg,
                             string path,
                             GLib.HashTable? query,
                             Soup.ClientContext client) {
        /* Leaving in leading / results in empty 0th token */
        string[] tokens = path.substring (1).split ("/");

        if (tokens[1] != "log") {
            send_bad_request (msg, "log", Dcs.Net.RouterErrorCode.WRONG_NAMESPACE);
            return;
        }

        switch (msg.method.up ()) {
            case "PUT":
                var obj = new Dcs.Log.File ();
                var json = Json.from_string ((string) msg.request_body.data);
                (obj as Dcs.Log.File).json_deserialize (json);
                var log = service.get_model ().@get ("log");
                try {
                    log.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, "log-" + tokens[2], Dcs.Net.RouterErrorCode.OBJECT_INSERT_FAILED);
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.Log.File);
                if (tokens.length >= 4) {
                    var log = service.get_model ().@get ("log");
                    var node = log.@get (tokens[3]);
                    if (node != null) {
                        json = (node as Dcs.Log.File).json_serialize ();
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
                            var json_node = (node as Dcs.Log.File).json_serialize ();
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
                    send_bad_request (msg, "log-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var json = Json.from_string ((string) msg.request_body.data);
                var log = service.get_model ().@get ("log");
                var node = log.@get (tokens[3]);
                if (node != null) {
                    (node as Dcs.Log.File).json_deserialize (json);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            case "DELETE":
                if (tokens.length < 4) {
                    send_bad_request (msg, "log-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var log = service.get_model ().@get ("log");
                var node = log.@get (tokens[3]);
                if (node != null) {
                    log.remove (node);
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

    /**
     * FIXME This route belongs in the backend as /api/log/backends/<id>/columns
     */
    private void route_columns (Soup.Server server,
                                Soup.Message msg,
                                string path,
                                GLib.HashTable? query,
                                Soup.ClientContext client) {
        /* Leaving in leading / results in empty 0th token */
        string[] tokens = path.substring (1).split ("/");

        if (tokens[1] != "log") {
            send_bad_request (msg, "log", Dcs.Net.RouterErrorCode.WRONG_NAMESPACE);
            return;
        }

        switch (msg.method.up ()) {
            case "PUT":
                var obj = new Dcs.Log.Column ();
                var json = Json.from_string ((string) msg.request_body.data);
                (obj as Dcs.Log.Column).json_deserialize (json);
                var log = service.get_model ().@get ("log");
                try {
                    log.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, "log-" + tokens[2], Dcs.Net.RouterErrorCode.OBJECT_INSERT_FAILED);
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.Log.Column);
                if (tokens.length >= 4) {
                    var log_ns = service.get_model ().@get ("log");
                    var query_toks = msg.uri.query.split ("&");
                    string? log_id = null;
                    foreach (var toks in query_toks) {
                        var log_toks = toks.split ("=");
                        if (log_toks[0] == "log") {
                            log_id = log_toks[1];
                        }
                    }
                    if (log_id != null) {
                        var log = log_ns.@get (log_id);
                        var node = log.@get (tokens[3]);
                        if (node != null) {
                            json = (node as Dcs.Log.Column).json_serialize ();
                        } else {
                            send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                            return;
                        }
                    } else {
                        send_bad_request (msg, "log-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
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
                            var json_node = (node as Dcs.Log.Column).json_serialize ();
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
                    send_bad_request (msg, "log-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var json = Json.from_string ((string) msg.request_body.data);
                var log = service.get_model ().@get ("log");
                var node = log.@get (tokens[3]);
                if (node != null) {
                    (node as Dcs.Log.Column).json_deserialize (json);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            case "DELETE":
                if (tokens.length < 4) {
                    send_bad_request (msg, "log-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var log = service.get_model ().@get ("log");
                var node = log.@get (tokens[3]);
                if (node != null) {
                    log.remove (node);
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

    private void route_query (Soup.Server server,
                              Soup.Message msg,
                              string path,
                              GLib.HashTable? query,
                              Soup.ClientContext client) {
        /* Leaving in leading / results in empty 0th token */
        string[] tokens = path.substring (1).split ("/");

        if (tokens[1] != "log") {
            send_bad_request (msg, "log", Dcs.Net.RouterErrorCode.WRONG_NAMESPACE);
            return;
        }

        /* TODO Make a real query with parameters and allow the backend to
         * pass back data for the response if it's able to */

        switch (msg.method.up ()) {
            case "GET":
                send_unimplemented_request (msg, tokens[2]);
                break;
            default:
                send_bad_request (msg, tokens[3], Dcs.Net.RouterErrorCode.UNSUPPORTED_REQUEST);
                break;
        }
    }
}
