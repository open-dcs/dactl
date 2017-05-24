[Version (experimental = "true", experimental_until = "0.3")]
public struct Dcs.Net.RouteEntry {
    public unowned string? path;
    public Dcs.Net.RouteArg arg;
    public void* arg_data;
    public unowned string description;
}

[Version (experimental = "true", experimental_until = "0.3")]
public enum Dcs.Net.RouteArg {
    NONE,
    CALLBACK;
}

[Flags]
public enum Dcs.Net.RouterErrorCode {
    UNINITIALIZED        = 500,
    UNSUPPORTED_REQUEST  = 501,
    MISSING_ID           = 502,
    OBJECT_NOT_FOUND     = 503,
    OBJECT_INSERT_FAILED = 504,
    OBJECT_UPDATE_FAILED = 505,
    OBJECT_DELETE_FAILED = 506,
    WRONG_NAMESPACE      = 507;

    public string to_string () {
        switch (this) {
            case UNINITIALIZED:        return "Router uninitialized";
            case UNSUPPORTED_REQUEST:  return "Unsupported request";
            case MISSING_ID:           return "Request requires ID";
            case OBJECT_NOT_FOUND:     return "Object not found";
            case OBJECT_INSERT_FAILED: return "Failed to insert the object provided";
            case OBJECT_UPDATE_FAILED: return "Failed to update the object provided";
            case OBJECT_DELETE_FAILED: return "Failed to delete the object provided";
            case WRONG_NAMESPACE:      return "Wrong namespace in request";
            default: assert_not_reached ();
        }
    }
}

public abstract class Dcs.Net.Router : Soup.Server {

    /**
     * The TCP port to listen to. Setting should restart gracefully.
     */
    public int port { get; construct set; default = 8088; }

    protected Dcs.Net.Service service;

    /**
     * Would like to have an entry table but it may make more sense to use
     * delegates in the entry.
     */
    [Version (experimental = "true", experimental_until = "0.3")]
    private Dcs.Net.RouteEntry[] entries;

    /**
     * Perform initialization of routes generic to all net based services.
     */
    protected void init () {
        debug (_("Initializing REST for a network service on port %d"), port);
        listen_all (port, 0);

        add_handler ("/api/net/publishers",  route_publishers);
        add_handler ("/api/net/subscribers", route_subscribers);
        add_handler ("/api/net/requesters",  route_requesters);
        add_handler ("/api/net/repliers",    route_repliers);
    }

    /**
     * Add a list of routes as a group.
     *
     * XXX This doesn't work, server instance or path in callback are null.
     *
     * @param routes The list of route entries to add.
     */
    [Version (experimental = "true", experimental_until = "0.3")]
    public void add_routes (Dcs.Net.RouteEntry[] routes) {
        entries = routes;
        foreach (var route in entries) {
            if (route.path != null) {
                debug ("Add route: %s", route.path);
                switch (route.arg) {
                    case Dcs.Net.RouteArg.CALLBACK:
                        if (route.path == "/") {
                            route.path = null;
                        }
                        add_handler (route.path, (Soup.ServerCallback) route.arg_data);
                        break;
                    default:
                        break;
                }
            }
        }
    }

    /**
     * Convenience function to send an action complete message.
     *
     * @param msg Soup message to respond to.
     * @param context Message or domain to add.
     */
    protected void send_action_complete (Soup.Message msg, string context) {
        var response = "{\"%s\": {\"%s\": \"complete\"}}".printf (context, msg.method);
        msg.status_code = Soup.Status.OK;
        msg.response_headers.append ("Access-Control-Allow-Origin", "*");
        msg.set_response ("application/json", Soup.MemoryUse.COPY, response.data);
    }

    /**
     * Convenience function to send a bad request message.
     *
     * TODO Refine this concept, probably doesn't make have context string.
     *
     * @param msg Soup message to respond to.
     * @param context Domain of error.
     * @param status Error code to respond with.
     * @param error Error message to send.
     */
    protected void send_bad_request (Soup.Message msg, string context, Dcs.Net.RouterErrorCode code) {
        var response = "{\"%s\": {\"code\": %d, \"error\": \"%s\"}}".printf (context, code, code.to_string ());
        msg.status_code = Soup.Status.BAD_REQUEST;
        msg.response_headers.append ("Access-Control-Allow-Origin", "*");
        msg.set_response ("application/json", Soup.MemoryUse.COPY, response.data);
    }

    /**
     * Convenience function for object requested that hasn't been implemented.
     *
     * @param msg Soup message to respond to.
     * @param context Message or domain to add.
     */
    protected void send_unimplemented_request (Soup.Message msg, string context) {
        var response = "{\"%s\": {\"status\": \"unimplemented\"}}".printf (context);
        msg.status_code = Soup.Status.NOT_IMPLEMENTED;
        msg.response_headers.append ("Access-Control-Allow-Origin", "*");
        msg.set_response ("application/json", Soup.MemoryUse.COPY, response.data);
    }

    /**
     * TODO Add documentation.
     */
    private void route_publishers (Soup.Server server,
                                   Soup.Message msg,
                                   string path,
                                   GLib.HashTable? query,
                                   Soup.ClientContext client) {
        if (service == null) {
            send_bad_request (msg, "net", Dcs.Net.RouterErrorCode.UNINITIALIZED);
            return;
        }

        /* Some nonsense about skipping tokens */
        string[] tokens = path.substring (1).split ("/");

        if (tokens[1] != "net") {
            send_bad_request (msg, "net", Dcs.Net.RouterErrorCode.WRONG_NAMESPACE);
            return;
        }

        switch (msg.method.up ()) {
            case "PUT":
                /* Deserialize object and add to net node */
                var obj = new Dcs.Net.Publisher ();
                var json = Json.from_string ((string) msg.request_body.data);
                (obj as Dcs.Net.Publisher).json_deserialize (json);
                var net = service.get_model ().@get ("net");
                try {
                    net.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_INSERT_FAILED);
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.Net.Publisher);
                if (tokens.length >= 4) {
                    var net = service.get_model ().@get ("net");
                    var node = net.@get (tokens[3]);
                    if (node != null) {
                        json = (node as Dcs.Net.Publisher).json_serialize ();
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
                            var json_node = (node as Dcs.Net.Publisher).json_serialize ();
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
                msg.set_response ("application/json", Soup.MemoryUse.COPY, response.data);
                break;
            case "POST":
                /* Retrieve object from net node and update */
                if (tokens.length < 4) {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var json = Json.from_string ((string) msg.request_body.data);
                var net = service.get_model ().@get ("net");
                var node = net.@get (tokens[3]);
                if (node != null) {
                    (node as Dcs.Net.Publisher).json_deserialize (json);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            case "DELETE":
                /* Remove object from net node */
                /* XXX This is a potentially dangerous operation, need to test */
                if (tokens.length < 4) {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }
                var net = service.get_model ().@get ("net");
                var node = net.@get (tokens[3]);
                if (node != null) {
                    net.remove (node);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            default:
                send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.UNSUPPORTED_REQUEST);
                break;
        }
    }

    /**
     * TODO Add documentation.
     */
    private void route_subscribers (Soup.Server server,
                                    Soup.Message msg,
                                    string path,
                                    GLib.HashTable? query,
                                    Soup.ClientContext client) {
        if (service == null) {
            send_bad_request (msg, "net", Dcs.Net.RouterErrorCode.UNINITIALIZED);
            return;
        }

        /* Some nonsense about skipping tokens */
        string[] tokens = path.substring (1).split ("/");

        switch (msg.method.up ()) {
            case "PUT":
                /* Deserialize object and add to net node */
                var obj = new Dcs.Net.Subscriber ();
                var json = Json.from_string ((string) msg.request_body.data);
                (obj as Dcs.Net.Subscriber).json_deserialize (json);
                var net = service.get_model ().@get ("net");
                try {
                    net.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_INSERT_FAILED);
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.Net.Subscriber);
                if (tokens.length >= 4) {
                    var net = service.get_model ().@get ("net");
                    var node = net.@get (tokens[3]);
                    if (node != null) {
                        json = (node as Dcs.Net.Subscriber).json_serialize ();
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
                            var json_node = (node as Dcs.Net.Subscriber).json_serialize ();
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
                msg.set_response ("application/json", Soup.MemoryUse.COPY, response.data);
                break;
            case "POST":
                /* Retrieve object from net node and update */
                if (tokens.length < 4) {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var json = Json.from_string ((string) msg.request_body.data);
                var net = service.get_model ().@get ("net");
                var node = net.@get (tokens[3]);
                if (node != null) {
                    (node as Dcs.Net.Subscriber).json_deserialize (json);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            case "DELETE":
                /* Remove object from net node */
                /* XXX This is a potentially dangerous operation, need to test */
                if (tokens.length < 4) {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }
                var net = service.get_model ().@get ("net");
                var node = net.@get (tokens[3]);
                if (node != null) {
                    net.remove (node);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            default:
                send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.UNSUPPORTED_REQUEST);
                break;
        }
    }

    /**
     * TODO Add documentation.
     */
    private void route_requesters (Soup.Server server,
                                   Soup.Message msg,
                                   string path,
                                   GLib.HashTable? query,
                                   Soup.ClientContext client) {
        if (service == null) {
            send_bad_request (msg, "net", Dcs.Net.RouterErrorCode.UNINITIALIZED);
            return;
        }

        /* Some nonsense about skipping tokens */
        string[] tokens = path.substring (1).split ("/");

        switch (msg.method.up ()) {
            case "PUT":
                /* Deserialize object and add to net node */
                var obj = new Dcs.Net.Requester ();
                var json = Json.from_string ((string) msg.request_body.data);
                (obj as Dcs.Net.Requester).json_deserialize (json);
                var net = service.get_model ().@get ("net");
                try {
                    net.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_INSERT_FAILED);
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.Net.Requester);
                if (tokens.length >= 4) {
                    var net = service.get_model ().@get ("net");
                    var node = net.@get (tokens[3]);
                    if (node != null) {
                        json = (node as Dcs.Net.Requester).json_serialize ();
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
                            var json_node = (node as Dcs.Net.Requester).json_serialize ();
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
                msg.set_response ("application/json", Soup.MemoryUse.COPY, response.data);
                break;
            case "POST":
                /* Retrieve object from net node and update */
                if (tokens.length < 4) {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var json = Json.from_string ((string) msg.request_body.data);
                var net = service.get_model ().@get ("net");
                var node = net.@get (tokens[3]);
                if (node != null) {
                    (node as Dcs.Net.Requester).json_deserialize (json);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            case "DELETE":
                /* Remove object from net node */
                /* XXX This is a potentially dangerous operation, need to test */
                if (tokens.length < 4) {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }
                var net = service.get_model ().@get ("net");
                var node = net.@get (tokens[3]);
                if (node != null) {
                    net.remove (node);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            default:
                send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.UNSUPPORTED_REQUEST);
                break;
        }
    }

    /**
     * TODO Add documentation.
     */
    private void route_repliers (Soup.Server server,
                                 Soup.Message msg,
                                 string path,
                                 GLib.HashTable? query,
                                 Soup.ClientContext client) {
        if (service == null) {
            send_bad_request (msg, "net", Dcs.Net.RouterErrorCode.UNINITIALIZED);
            return;
        }

        /* Some nonsense about skipping tokens */
        string[] tokens = path.substring (1).split ("/");

        switch (msg.method.up ()) {
            case "PUT":
                /* Deserialize object and add to net node */
                var obj = new Dcs.Net.Replier ();
                var json = Json.from_string ((string) msg.request_body.data);
                (obj as Dcs.Net.Replier).json_deserialize (json);
                var net = service.get_model ().@get ("net");
                try {
                    net.add (obj);
                    send_action_complete (msg, tokens[2]);
                } catch (GLib.Error e) {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_INSERT_FAILED);
                }
                break;
            case "GET":
                Json.Node json;
                var type = typeof (Dcs.Net.Replier);
                if (tokens.length >= 4) {
                    var net = service.get_model ().@get ("net");
                    var node = net.@get (tokens[3]);
                    if (node != null) {
                        json = (node as Dcs.Net.Replier).json_serialize ();
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
                            var json_node = (node as Dcs.Net.Replier).json_serialize ();
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
                msg.set_response ("application/json", Soup.MemoryUse.COPY, response.data);
                break;
            case "POST":
                /* Retrieve object from net node and update */
                if (tokens.length < 4) {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }

                var json = Json.from_string ((string) msg.request_body.data);
                var net = service.get_model ().@get ("net");
                var node = net.@get (tokens[3]);
                if (node != null) {
                    (node as Dcs.Net.Replier).json_deserialize (json);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            case "DELETE":
                /* Remove object from net node */
                /* XXX This is a potentially dangerous operation, need to test */
                if (tokens.length < 4) {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.MISSING_ID);
                    return;
                }
                var net = service.get_model ().@get ("net");
                var node = net.@get (tokens[3]);
                if (node != null) {
                    net.remove (node);
                    send_action_complete (msg, tokens[2]);
                } else {
                    send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.OBJECT_NOT_FOUND);
                }
                break;
            default:
                send_bad_request (msg, tokens[2], Dcs.Net.RouterErrorCode.UNSUPPORTED_REQUEST);
                break;
        }
    }
}
