public class Dcs.PidControllerServiceAddin : GLib.Object, Dcs.Net.ServiceProvider {

    public Dcs.Net.Service service { get; construct set; }

    private Dcs.Net.Publisher publisher;

    private Dcs.Net.Subscriber subscriber;

    private bool running = false;

    /**
     * Executed when the plugin is loaded by the manager class.
     */
    public void activate () {
        debug ("PID controller activated");
    }

    public void deactivate () {
        debug ("PID controller deactivated");
    }

    public void start () {
        debug ("PID controller starting...");
        var model = service.get_model ();
        var net = model.@get ("net");

        var publishers = net.get_children (typeof (Dcs.Net.Publisher));
        if (publishers == null) {
            warning ("Couldn't find any publishers");
            return;
        } else if (publishers.size == 0) {
            warning ("Couldn't find any publishers");
            return;
        }

        var subscribers = net.get_children (typeof (Dcs.Net.Subscriber));
        if (subscribers == null) {
            warning ("Couldn't find any subscribers");
            return;
        } else if (subscribers.size == 0) {
            warning ("Couldn't find any subscribers");
            return;
        }

        publisher = (Dcs.Net.Publisher) publishers.@get (0);
        subscriber = (Dcs.Net.Subscriber) subscribers.@get (0);
        if (publisher == null || subscriber == null) {
            warning ("Couldn't get network PUB/SUB pair");
            running = false;
        } else {
            running = true;
            send_messages.begin ((obj, res) => {
                try {
                    send_messages.end (res);
                } catch (ThreadError e) {
                    error (e.message);
                }
            });
            recv_messages.begin ((obj, res) => {
                try {
                    recv_messages.end (res);
                } catch (ThreadError e) {
                    error (e.message);
                }
            });
        }
    }

    public void pause () {
        debug ("PID controller pausing...");
    }

    public void stop () {
        debug ("PID controller stopping...");
        running = false;
    }

    private async void send_messages () throws ThreadError {
        SourceFunc callback = send_messages.callback;

        /* TODO If messages received perform the calculation and send */

        ThreadFunc<void*> run = () => {
            try {
                while (running) {
                    debug ("PID controller wants to send a message");
                    Posix.sleep (600);
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

    private async void recv_messages () throws ThreadError {
        SourceFunc callback = recv_messages.callback;

        ThreadFunc<void*> run = () => {
            try {
                while (running) {
                    if (subscriber.is_connected ()) {
                        var message = subscriber.recv_message ();
                        debug (message.to_string ());
                    } else {
                        Posix.sleep (10);
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

