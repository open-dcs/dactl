public errordomain Dcs.ServiceError {
    PROCESS,
    STARTUP
}

/**
 * Questions:
 * - should there be one queue per configured socket type?
 *   > I think so
 * - should there be an async processor for each queue?
 *   > I think so
 * - should PUB and REQ have different queues and processors?
 *   > I think so
 * - should SUB and REP have different queues and processors?
 *   > I think so
 */

public class Dcs.Net.Service : Dcs.FooApplication {

    /**
     * There needs to be a different message queue for each configured socket
     * type, each is referenced using the id of the node that was configured.
     */
    private Gee.HashMap<string, Gee.ArrayQueue<Dcs.Message>> queue_group;

    protected Dcs.PluginManager plugin_manager;

    construct {
        queue_group = new Gee.HashMap<string, Gee.ArrayQueue<Dcs.Message>> ();
    }

    protected void start () throws Dcs.ServiceError {
        debug ("Starting the service");

        try {
            foreach (var pub in model.get_descendants (typeof (Dcs.Net.Publisher))) {
                var queue = new Gee.ArrayQueue<Dcs.Message> ();
                queue_group.@set (pub.id, queue);
                (pub as Dcs.Net.Publisher).start ();
            }

            foreach (var sub in model.get_descendants (typeof (Dcs.Net.Subscriber))) {
                var queue = new Gee.ArrayQueue<Dcs.Message> ();
                queue_group.@set (sub.id, queue);
                (sub as Dcs.Net.Subscriber).start ();
            }
        } catch (GLib.Error e) {
            if (e is Dcs.Net.ZmqError.INIT) {
                throw new Dcs.ServiceError.STARTUP (
                    "An error occurred while initializing a ZeroMQ socket");
            } else {
                throw new Dcs.ServiceError.STARTUP (
                    "An unknown startup error occurred");
            }
        }

        foreach (var plugin in plugin_manager.loaded_plugins ()) {
            debug ("plugin %s is loaded", plugin);
        }
    }

    protected void pause () throws Dcs.ServiceError {
        debug ("Pausing the service");
    }

    protected void stop () throws Dcs.ServiceError {
        debug ("Stopping the service");
    }

/*
 *    private GLib.Cond send_cond = Cond ();
 *
 *    private GLib.Cond recv_cond = Cond ();
 *
 *    private GLib.Mutex send_mutex = Mutex ();
 *
 *    private GLib.Mutex recv_mutex = Mutex ();
 *
 *    private Gee.ArrayQueue<Dcs.Message> send_queue;
 *
 *    private Gee.ArrayQueue<Dcs.Message> recv_queue;
 *
 *    public void start () throws Dcs.ServiceError {
 *        send_queue = new Gee.ArrayQueue<Dcs.Message> ();
 *        recv_queue = new Gee.ArrayQueue<Dcs.Message> ();
 *
 *        process_send_queue.begin ((obj, res) => {
 *            try {
 *                process_send_queue.end (res);
 *            } catch (ThreadError e) {
 *                throw new Dcs.ServiceError.PROCESS (
 *                    "Thread error: %s", e.message);
 *            }
 *        });
 *
 *        process_recv_queue.begin ((obj, res) => {
 *            try {
 *                process_recv_queue.end (res);
 *            } catch (ThreadError e) {
 *                throw new Dcs.ServiceError.PROCESS (
 *                    "Thread error: %s", e.message);
 *            }
 *        });
 *    }
 *
 *    private async void process_send_queue () throws ThreadError {
 *        SourceFunc callback = process_send_queue.callback;
 *
 *        ThreadFunc<void *> run = () => {
 *            [> Wait for the message queue to contain something <]
 *            while (send_queue.is_empty) {
 *                send_cond.wait (send_mutex);
 *            }
 *
 *            [> Do something with the messages <]
 *            send_mutex.lock ();
 *            send_queue.foreach ((msg) => {
 *                message (@"$msg");
 *                [> Application's node tree should contain a PUB or REQ to use <]
 *                [> ... <]
 *                return true;
 *            });
 *            send_mutex.unlock ();
 *
 *            Idle.add ((owned) callback);
 *            return null;
 *        };
 *
 *        Thread.create<void *> (run, false);
 *        yield;
 *    }
 *
 *    private async void process_recv_queue () throws ThreadError {
 *        SourceFunc callback = process_recv_queue.callback;
 *
 *        ThreadFunc<void *> run = () => {
 *            [> Wait for the message queue to contain something <]
 *            while (recv_queue.is_empty) {
 *                recv_cond.wait (recv_mutex);
 *            }
 *
 *            [> Do something with the messages <]
 *            recv_mutex.lock ();
 *            recv_queue.foreach ((msg) => {
 *                message (@"$msg");
 *                [> Application's node tree should contain a SUB or REP to use <]
 *                [> ... <]
 *                return true;
 *            });
 *            recv_mutex.unlock ();
 *
 *            Idle.add ((owned) callback);
 *            return null;
 *        };
 *
 *        Thread.create<void *> (run, false);
 *        yield;
 *    }
 *
 *    public void send (Dcs.Message msg) {
 *        send_mutex.lock ();
 *        send_queue.add (msg);
 *        send_cond.signal ();
 *        send_mutex.unlock ();
 *    }
 *
 *    public void send_multiple (Dcs.Message[] msgs) {
 *        send_mutex.lock ();
 *        foreach (var msg in msgs) {
 *            send_queue.add (msg);
 *        }
 *        send_cond.signal ();
 *        send_mutex.unlock ();
 *    }
 */
}
