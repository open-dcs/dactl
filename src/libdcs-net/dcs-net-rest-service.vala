public struct Dcs.Net.RouteEntry {
    public unowned string? path;
    public Dcs.Net.RouteArg arg;
    public void* arg_data;
    public unowned string description;
}

public enum Dcs.Net.RouteArg {
    NONE,
    CALLBACK;
}

public abstract class Dcs.Net.RestService : Soup.Server {

    /**
     * The TCP port to listen to. Setting should restart gracefully.
     */
    public int port { get; construct set; default = 8088; }

    private Dcs.Net.RouteEntry[] entries;

    /**
     * Add a list of routes as a group.
     *
     * XXX This doesn't work, server instance or path in callback are null.
     *
     * @param routes The list of route entries to add.
     */
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
}
