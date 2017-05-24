public class Dcs.Control.Router : Dcs.Net.Router {

    public Router (Dcs.Net.Service service) {
        this.service = service;
        port = 8082;
        init ();
    }

    public Router.with_port (Dcs.Net.Service service, int port) {
        this.service = service;
        GLib.Object (port: port);
        init ();
    }

    private void init () {
        base.init ();
        debug (_("Initializing the Control REST service"));

        add_handler (null,                       route_default);
        add_handler ("/api/control/controllers", route_controllers);
    }

    /**
     * Default route serves static index page.
     */
    private void route_default (Soup.Server server,
                                Soup.Message msg,
                                string path,
                                GLib.HashTable? query,
                                Soup.ClientContext client) {

        unowned Dcs.Control.Router self = server as Dcs.Control.Router;

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

    private void route_controllers (Soup.Server server,
                                    Soup.Message msg,
                                    string path,
                                    GLib.HashTable? query,
                                    Soup.ClientContext client) {
        /* Leaving in leading / results in empty 0th token */
        string[] tokens = path.substring (1).split ("/");

        if (tokens[1] != "control") {
            send_bad_request (msg, "control", Dcs.Net.RouterErrorCode.WRONG_NAMESPACE);
            return;
        }

        switch (msg.method.up ()) {
            case "PUT":
                var obj = new Dcs.Control.Controller ();
                var json = Json.from_string ((string) msg.request_body.data);
                (obj as Dcs.Control.Controller).json_deserialize (json);
                var control = service.get_model ().@get ("control");
                try {
                    control.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, "control-" + tokens[2], Dcs.Net.RouterErrorCode.OBJECT_INSERT_FAILED);
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.Control.Controller);
                if (tokens.length >= 4) {
                    var control = service.get_model ().@get ("control");
                    var node = control.@get (tokens[3]);
                    if (node != null) {
                        json = (node as Dcs.Control.Controller).json_serialize ();
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
                            var json_node = (node as Dcs.Control.Controller).json_serialize ();
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
                    send_bad_request (msg, "control-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var json = Json.from_string ((string) msg.request_body.data);
                var control = service.get_model ().@get ("control");
                var node = control.@get (tokens[3]);
                if (node != null) {
                    (node as Dcs.Control.Controller).json_deserialize (json);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            case "DELETE":
                if (tokens.length < 4) {
                    send_bad_request (msg, "control-" + tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var control = service.get_model ().@get ("control");
                var node = control.@get (tokens[3]);
                if (node != null) {
                    control.remove (node);
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
