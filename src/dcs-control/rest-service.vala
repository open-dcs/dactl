internal class Dcs.Control.RestService : Dcs.Net.RestService {

    private const string bad_request = "jsonp('XXX': {'status': 400})";

    public RestService () {
        init ();
    }

    public RestService.with_port (int port) {
        GLib.Object (port: port);
        init ();
    }

    private void init () {
        debug ("Starting Control REST service on port %d", port);
        listen_all (port, 0);

        add_handler (null,        route_default);
        add_handler ("/control",  route_control);
        add_handler ("/controls", route_controls);
    }

    /* API routes */

    /**
     * Default route serves static index page.
     */
    private void route_default (Soup.Server server,
                                Soup.Message msg,
                                string path,
                                GLib.HashTable? query,
                                Soup.ClientContext client) {

        unowned Dcs.Control.RestService self = server as Dcs.Control.RestService;

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

    /**
     * Control routes to display all or work with CRUD.
     */
    private void route_control (Soup.Server server,
                                Soup.Message msg,
                                string path,
                                GLib.HashTable? query,
                                Soup.ClientContext client) {

        // Leaving in leading / results in empty 0th token
        string[] tokens = path.substring (1).split ("/");

        // CRUD for control requests
        switch (msg.method.up ()) {
            case "PUT":
                debug (_("PUT control: not implemented"));
                break;
            case "GET":
                debug (_("GET control: not implemented"));
                break;
            case "POST":
                debug (_("POST control: not implemented"));
                break;
            case "DELETE":
                debug (_("DELETE control: not implemented"));
                break;
            default:
                msg.status_code = Soup.Status.BAD_REQUEST;
                msg.response_headers.append ("Access-Control-Allow-Origin", "*");
                msg.set_response ("application/json",
                                  Soup.MemoryUse.COPY,
                                  bad_request.replace ("XXX", "control").data);
                break;
        }
    }

    private void route_controls (Soup.Server server,
                             Soup.Message msg,
                             string path,
                             GLib.HashTable? query,
                             Soup.ClientContext client) {

        var response = "jsonp('controls': { 'response': 'test' })";
        debug ("GET controls: %s", response);

        msg.status_code = Soup.Status.OK;
        msg.response_headers.append ("Access-Control-Allow-Origin", "*");
        msg.set_response ("application/json",
                          Soup.MemoryUse.COPY,
                          response.data);
    }
}
