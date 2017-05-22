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

    private void route_logs (Soup.Server server,
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

    private void route_columns (Soup.Server server,
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

    private void route_query (Soup.Server server,
                              Soup.Message msg,
                              string path,
                              GLib.HashTable? query,
                              Soup.ClientContext client) {
        /* Leaving in leading / results in empty 0th token */
        string[] tokens = path.substring (1).split ("/");

        switch (msg.method.up ()) {
            case "GET":
                break;
            default:
                send_bad_request (msg, tokens[3], 502, "Unsupported request");
                break;
        }
    }
}
