public class Dcs.XmlServiceAddin : GLib.Object, Dcs.Net.ServiceProvider {

    public Dcs.Net.Service service { get; construct set; }

    private Dcs.Net.Subscriber subscriber;

    private bool running;

    public void activate () {
        debug ("XML backend activated");
    }

    public void deactivate () {
        debug ("XML backend deactivated");
    }

    public void start () {
        debug ("XML backend starting...");
        var model = service.get_model ();
        var net = model.@get ("net");
        var subscribers = net.get_descendants (typeof (Dcs.Net.Subscriber));
        debug (net.to_string ());
        if (subscribers == null || subscribers.size == 0) {
            warning ("Couldn't find any subscribers");
            return;
        }
        subscriber = (Dcs.Net.Subscriber) subscribers.@get (1);
        if (subscriber == null) {
            debug ("Couldn't get subscriber");
            running = false;
        } else {
            running = true;
            /* TODO Create message filters using configuration? */
            watch.begin ((obj, res) => {
                try {
                    watch.end (res);
                } catch (ThreadError e) {
                    error (e.message);
                }
            });
        }
    }

    public void pause () {
        debug ("XML backend pausing...");
    }

    public void stop () {
        debug ("XML backend stopping...");
        subscriber = null;
        running = false;
    }

    private async void watch () throws ThreadError {
        SourceFunc callback = watch.callback;

        ThreadFunc<void*> run = () => {
            try {
                while (running) {
                    if (subscriber.is_connected ()) {
                        var message = subscriber.recv_message ();
                        debug (message.to_string ());
                    } else {
                        Posix.sleep (5);
                    }
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
