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

public abstract class Dcs.Net.RestService : Soup.Server {

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

    private const string bad_request = "jsonp('XXX': {'status': 500})";

    /**
     * Perform initialization of routes generic to all net based services.
     */
    protected void init () {
        debug (_("Initializing REST for a network service on port %d"), port);
        listen_all (port, 0);

        add_handler ("/api/net/publishers",  route_publishers);
        add_handler ("/api/net/publisher",   route_publisher);
        add_handler ("/api/net/subscribers", route_subscribers);
        add_handler ("/api/net/subscriber",  route_subscriber);
        add_handler ("/api/net/requesters",  route_requesters);
        add_handler ("/api/net/requester",   route_requester);
        add_handler ("/api/net/repliers",    route_repliers);
        add_handler ("/api/net/replier",     route_replier);
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

    protected void send_bad_request (Soup.Message msg, string context, int status) {
        var response = "jsonp({\"%s\": {\"status\": %d}})".printf (context, status);
        msg.status_code = Soup.Status.BAD_REQUEST;
        msg.response_headers.append ("Access-Control-Allow-Origin", "*");
        msg.set_response ("application/json", Soup.MemoryUse.COPY, response.data);
    }

    protected void send_unimplemented_request (Soup.Message msg, string context) {
        var response = "jsonp({\"%s\": {\"status\": \"unimplemented\"}})".printf (context);
        msg.status_code = Soup.Status.OK;
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
            send_bad_request (msg, "router uninitialized", 500);
            return;
        }

        switch (msg.method.up ()) {
            case "GET":
                var publishers = service.get_model ().get_descendants (typeof (Dcs.Net.Publisher));
                var builder = new Json.Builder ();
                builder.begin_object ();
                builder.set_member_name ("publishers");
                builder.begin_array ();
                foreach (var publisher in publishers) {
                    //var pub_node = Json.gobject_serialize (publisher);
                    var pub_node = (publisher as Dcs.Net.Publisher).json_serialize ();
                    builder.add_value (pub_node);
                }
                builder.end_array ();
                builder.end_object ();
                var node = builder.get_root ();
                var response = "jsonp(%s)".printf (Json.to_string (node, false));
                msg.status_code = Soup.Status.OK;
                msg.response_headers.append ("Access-Control-Allow-Origin", "*");
                msg.set_response ("application/json",
                                  Soup.MemoryUse.COPY,
                                  response.data);
                break;
            default:
                send_bad_request (msg, "publishers", 511);
                break;
        }
    }

    /**
     * TODO Add documentation.
     */
    private void route_publisher (Soup.Server server,
                                  Soup.Message msg,
                                  string path,
                                  GLib.HashTable? query,
                                  Soup.ClientContext client) {
        if (service == null) {
            send_bad_request (msg, "router uninitialized", 500);
            return;
        }

        /* Some nonsense about skipping tokens */
        string[] tokens = path.substring (1).split ("/");

        if (tokens.length < 2) {
            send_bad_request (msg, "no id provided", 501);
        }

        /* CRUD for publisher */
        switch (msg.method.up ()) {
            case "PUT":
                /* Deserialize object and add to net node */
                send_unimplemented_request (msg, "publisher-put");
                break;
            case "GET":
                /* Retrieve object from net node and send serialized */
                send_unimplemented_request (msg, "publisher-get");
                break;
            case "POST":
                /* Retrieve object from net node and update */
                send_unimplemented_request (msg, "publisher-post");
                break;
            case "DELETE":
                /* Remove object from net node */
                /* XXX This is a potentially dangerous operation, need to test */
                send_unimplemented_request (msg, "publisher-delete");
                break;
            default:
                send_bad_request (msg, "publisher", 511);
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
            send_bad_request (msg, "router uninitialized", 500);
            return;
        }

        switch (msg.method.up ()) {
            case "GET":
                var subscribers = service.get_model ().get_descendants (typeof (Dcs.Net.Subscriber));
                var builder = new Json.Builder ();
                builder.begin_object ();
                builder.set_member_name ("subscribers");
                builder.begin_array ();
                foreach (var subscriber in subscribers) {
                    var pub_node = Json.gobject_serialize (subscriber);
                    builder.add_value (pub_node);
                }
                builder.end_array ();
                builder.end_object ();
                var node = builder.get_root ();
                var response = "jsonp(%s)".printf (Json.to_string (node, false));
                msg.status_code = Soup.Status.OK;
                msg.response_headers.append ("Access-Control-Allow-Origin", "*");
                msg.set_response ("application/json",
                                  Soup.MemoryUse.COPY,
                                  response.data);
                break;
            default:
                send_bad_request (msg, "subscribers", 521);
                break;
        }
    }

    /**
     * TODO Add documentation.
     */
    private void route_subscriber (Soup.Server server,
                                   Soup.Message msg,
                                   string path,
                                   GLib.HashTable? query,
                                   Soup.ClientContext client) {
        if (service == null) {
            send_bad_request (msg, "router uninitialized", 500);
            return;
        }

        /* Some nonsense about skipping tokens */
        string[] tokens = path.substring (1).split ("/");

        if (tokens.length < 2) {
            send_bad_request (msg, "no id provided", 501);
        }

        /* CRUD for subscriber */
        switch (msg.method.up ()) {
            case "PUT":
                /* Deserialize object and add to net node */
                send_unimplemented_request (msg, "subscriber-put");
                break;
            case "GET":
                /* Retrieve object from net node and send serialized */
                send_unimplemented_request (msg, "subscriber-get");
                break;
            case "POST":
                /* Retrieve object from net node and update */
                send_unimplemented_request (msg, "subscriber-post");
                break;
            case "DELETE":
                /* Remove object from net node */
                /* XXX This is a potentially dangerous operation, need to test */
                send_unimplemented_request (msg, "subscriber-delete");
                break;
            default:
                send_bad_request (msg, "subscriber", 521);
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
            send_bad_request (msg, "router uninitialized", 500);
            return;
        }

        switch (msg.method.up ()) {
            case "GET":
                var requesters = service.get_model ().get_descendants (typeof (Dcs.Net.Requester));
                var builder = new Json.Builder ();
                builder.begin_object ();
                builder.set_member_name ("requesters");
                builder.begin_array ();
                foreach (var requester in requesters) {
                    var pub_node = Json.gobject_serialize (requester);
                    builder.add_value (pub_node);
                }
                builder.end_array ();
                builder.end_object ();
                var node = builder.get_root ();
                var response = "jsonp(%s)".printf (Json.to_string (node, false));
                msg.status_code = Soup.Status.OK;
                msg.response_headers.append ("Access-Control-Allow-Origin", "*");
                msg.set_response ("application/json",
                                  Soup.MemoryUse.COPY,
                                  response.data);
                break;
            default:
                send_bad_request (msg, "requesters", 531);
                break;
        }
    }

    /**
     * TODO Add documentation.
     */
    private void route_requester (Soup.Server server,
                                  Soup.Message msg,
                                  string path,
                                  GLib.HashTable? query,
                                  Soup.ClientContext client) {
        if (service == null) {
            send_bad_request (msg, "router uninitialized", 500);
            return;
        }

        /* Some nonsense about skipping tokens */
        string[] tokens = path.substring (1).split ("/");

        if (tokens.length < 2) {
            send_bad_request (msg, "no id provided", 501);
        }

        /* CRUD for requester */
        switch (msg.method.up ()) {
            case "PUT":
                /* Deserialize object and add to net node */
                send_unimplemented_request (msg, "requester-put");
                break;
            case "GET":
                /* Retrieve object from net node and send serialized */
                send_unimplemented_request (msg, "requester-get");
                break;
            case "POST":
                /* Retrieve object from net node and update */
                send_unimplemented_request (msg, "requester-post");
                break;
            case "DELETE":
                /* Remove object from net node */
                /* XXX This is a potentially dangerous operation, need to test */
                send_unimplemented_request (msg, "requester-delete");
                break;
            default:
                send_bad_request (msg, "requester", 531);
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
            send_bad_request (msg, "router uninitialized", 500);
            return;
        }

        switch (msg.method.up ()) {
            case "GET":
                var repliers = service.get_model ().get_descendants (typeof (Dcs.Net.Replier));
                var builder = new Json.Builder ();
                builder.begin_object ();
                builder.set_member_name ("repliers");
                builder.begin_array ();
                foreach (var replier in repliers) {
                    var pub_node = Json.gobject_serialize (replier);
                    builder.add_value (pub_node);
                }
                builder.end_array ();
                builder.end_object ();
                var node = builder.get_root ();
                var response = "jsonp(%s)".printf (Json.to_string (node, false));
                msg.status_code = Soup.Status.OK;
                msg.response_headers.append ("Access-Control-Allow-Origin", "*");
                msg.set_response ("application/json",
                                  Soup.MemoryUse.COPY,
                                  response.data);
                break;
            default:
                send_bad_request (msg, "repliers", 541);
                break;
        }
    }

    /**
     * TODO Add documentation.
     */
    private void route_replier (Soup.Server server,
                                Soup.Message msg,
                                string path,
                                GLib.HashTable? query,
                                Soup.ClientContext client) {
        if (service == null) {
            send_bad_request (msg, "router uninitialized", 500);
            return;
        }

        /* Some nonsense about skipping tokens */
        string[] tokens = path.substring (1).split ("/");

        if (tokens.length < 2) {
            send_bad_request (msg, "no id provided", 501);
        }

        /* CRUD for replier */
        switch (msg.method.up ()) {
            case "PUT":
                /* Deserialize object and add to net node */
                send_unimplemented_request (msg, "replier-put");
                break;
            case "GET":
                /* Retrieve object from net node and send serialized */
                send_unimplemented_request (msg, "replier-get");
                break;
            case "POST":
                /* Retrieve object from net node and update */
                send_unimplemented_request (msg, "replier-post");
                break;
            case "DELETE":
                /* Remove object from net node */
                /* XXX This is a potentially dangerous operation, need to test */
                send_unimplemented_request (msg, "replier-delete");
                break;
            default:
                send_bad_request (msg, "replier", 531);
                break;
        }
    }
}
