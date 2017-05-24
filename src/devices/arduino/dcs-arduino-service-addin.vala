public class Dcs.ArduinoServiceAddin : GLib.Object, Dcs.Net.ServiceProvider {

    public Dcs.Net.Service service { get; construct set; }

	private Dcs.Net.Publisher publisher;

    private bool running = false;

    public void activate () {
        debug ("Arduino device activated");
    }

    public void deactivate () {
        debug ("Arduino device deactivated");
    }

    public void start () {
        debug ("Arduino device starting...");
        var model = service.get_model ();
        var net = model.@get ("net");
        /*
         *debug (net.to_string ());
         */
        var publishers = net.get_children (typeof (Dcs.Net.Publisher));
        /* FIXME This is dumb, get_children shouldn't allocate an empty list */
        if (publishers == null) {
            warning ("Couldn't find any publishers");
            return;
        } else if (publishers.size == 0) {
            warning ("Couldn't find any publishers");
            return;
        }
        publisher = (Dcs.Net.Publisher) publishers.@get (0);
        /* TODO Add more verbose checking */
        if (publisher == null) {
            warning ("Couldn't get publisher");
            running = false;
        } else {
            running = true;
            /*
             *debug (publisher.to_string ());
             */
            send_messages.begin ((obj, res) => {
                try {
                    send_messages.end (res);
                } catch (ThreadError e) {
                    error (e.message);
                }
            });
        }
    }

    public void pause () {
        debug ("Arduino device pausing...");
    }

    public void stop () {
        debug ("Arduino device stopping...");
        running = false;
    }

    private async void send_messages () throws ThreadError {
        SourceFunc callback = send_messages.callback;

        /* XXX Just some data for testing */
        var json = """
            {'measurement':[
                {'channel':'ai0','value':0.0},
                {'channel':'ai1','value':1.0}
            ]}
        """;
        var payload = Json.from_string (json);

        ThreadFunc<void*> run = () => {
            try {
                while (running) {
                    Dcs.Message message = new Dcs.Message.object ("msg0", payload);
                    publisher.send_message (message);
                    Posix.sleep (1);
                }
            } catch (GLib.Error e) {
                error (e.message);
            }

            Idle.add ((owned) callback);
            return null;
        };

        Thread.create<void*> (run, false);
        yield;
    }
}
