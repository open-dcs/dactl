/**
 * The application controller in a MVC design is responsible for responding to
 * events from the view and updating the model.
 */
public abstract class Dcs.Controller : GLib.Object {

    /**
     * Application model to use.
     */
    protected Dcs.Model model;

    /**
     * Application view to update.
     */
    protected Dcs.View view;

    /* Control administrative functionality */
    public bool admin { get; set; default = false; }

    /**
     * Emitted whenever the data acquisition state is changed.
     */
    public signal void acquisition_state_changed (bool state);

    /**
     * Default construction.
     */
    public Controller (Dcs.Model model, Dcs.View view) {
        this.model = model;
        this.view = view;

        connect_signals ();
    }

    /**
     * Destruction occurs when object goes out of scope.
     *
     * @deprecated since CLD task addition
     */
    ~Controller () {
        /* Stop hardware threads. */
        stop_acquisition ();
    }

    /**
     * The controller receives requests to update the view if there have been
     * changes to the model.
     *
     * @param id The ID of the object updated, `null' if entire map was replaced
     */
    public abstract void update_view (string? id);

    /**
     * Add an object to the model and view.
     *
     * @param object The object to add.
     * @param path The path in the object tree to add the object at.
     */
    public abstract void add (owned Dcs.Object object, string path)
                              throws GLib.Error;

    /**
     * Remove an object from the model and view.
     *
     * @param path The path in the object tree to remove the object from.
     */
    public abstract void remove (string path) throws GLib.Error;

    /**
     * Set a property within the model for ...
     *
     * Valid examples:
     *
     * {{{
     *  // set the admin property state from the same application
     *  controller.set ("dcs:///:admin", new Variant.boolean (true));
     *  // set the log rate of "data-log" to 100 on a remote host "node"
     *  controller.set ("dcs://node/logs/data-log:rate", new Variant.int (100));
     * }}}
     *
     * @param uri The uri containing the object and the property to set.
     * @param value A variant containing the value to set the property to.
     */
    public abstract void @set (string uri, Variant value) throws GLib.Error;

    /**
     * Get a property within the model for ...
     *
     * Valid examples:
     *
     * {{{
     *  // get the admin property state from the same application
     *  var value = controller.get ("dcs:///:admin");
     *  // get the log rate of "data-log" on a remote host "node"
     *  var value = controller.get ("dcs://node/logs/data-log:rate");
     * }}}
     *
     * @param uri The uri containing the object and the property to get.
     */
    public abstract Variant @get (string uri) throws GLib.Error;

    /*
     * *** Functionality from old versions and soon to be deprecated ***
     */

    /**
     * Recursively goes through the object map and connects signals from
     * classes that will be requesting data from a higher level.
     */
    private void connect_signals () {
        debug ("Connecting signals in the controller");

        var adapters = model.get_object_map (typeof (Dcs.CldAdapter));
        foreach (var adapter in adapters.values) {
            debug ("Configuring object `%s'", (adapter as Dcs.Object).id);
            (adapter as Dcs.CldAdapter).request_object.connect ((uri) => {
                var object = model.ctx.get_object_from_uri (uri);
                debug ("Offering object `%s' to `%s'", object.id, adapter.id);
                (adapter as Dcs.CldAdapter).offer_cld_object (object);
            });
        }
    }

    /**
     * Callbacks common to all view types.
     * XXX the intention is to use a common interface later on
     *
     * @deprecated since adding controller set/get
     */
    protected void save_requested_cb () {
        debug ("Saving the configuration.");
        try {
            model.config.set_xml_node ("//dcs/cld:objects",
                                       model.xml.get_node ("//cld/cld:objects"));
            model.config.save ();
        } catch (GLib.Error e) {
            critical (e.message);
        }
    }

    /**
     * Start the thread that handles data acquisition.
     *
     * @deprecated since adding controller set/get
     */
    public void start_acquisition () {

        /* XXX probably not necessary to lock, there for legacy reasons only */
        lock (model) {
            var multiplexers = model.ctx.get_object_map (typeof (Cld.Multiplexer));
            bool using_mux = (multiplexers.size > 0);

            /* Manually open all of the devices */
            var devices = model.ctx.get_object_map (typeof (Cld.Device));
            foreach (var device in devices.values) {

                if (!(device as Cld.ComediDevice).is_open) {
                    message ("  Opening Comedi Device: `%s'", device.id);
                    (device as Cld.ComediDevice).open ();
                    if (!(device as Cld.ComediDevice).is_open)
                        error ("Failed to open Comedi device: `%s'", device.id);
                }

                if (!using_mux) {
                    message ("Starting tasks for: `%s'", device.id);
                    var tasks = (device as Cld.Container).get_object_map (typeof (Cld.Task));
                    foreach (var task in tasks.values) {
                        //if ((task as Cld.ComediTask).direction == "read") {
                            message ("  Starting task: `%s'", task.id);
                            (task as Cld.ComediTask).run ();
                        //}
                    }
                }
            }

            if (using_mux) {
                var acq_ctls = model.ctx.get_object_map (typeof (Cld.AcquisitionController));
                foreach (var acq_ctl in acq_ctls.values) {
                    (acq_ctl as Cld.AcquisitionController).run ();
                }
            }
        }

        /* XXX should check that the task started properly */
        acquisition_state_changed (true);
    }

    /**
     * Stops the thread that handles data acquisition.
     *
     * @deprecated since adding controller set/get
     */
    public void stop_acquisition () {

        /* XXX probably not necessary to lock, there for legacy reasons only */
        lock (model) {
            var multiplexers = model.ctx.get_object_map (typeof (Cld.Multiplexer));
            bool using_mux = (multiplexers.size > 0);

            /* Manually close all of the devices */
            var devices = model.ctx.get_object_map (typeof (Cld.Device));
            foreach (var device in devices.values) {

                if (!using_mux) {
                    message ("Stopping tasks for: `%s'", device.id);
                    var tasks = (device as Cld.Container).get_object_map (typeof (Cld.Task));
                    foreach (var task in tasks.values) {
                        if (task is Cld.ComediTask) {
                            //if ((task as Cld.ComediTask).direction == "read") {
                                message ("  Stopping task: `%s` ", task.id);
                                (task as Cld.ComediTask).stop ();
                            //}
                        }
                    }
                }

                if ((device as Cld.ComediDevice).is_open) {
                    message ("Closing Comedi Device: %s", device.id);
                    (device as Cld.ComediDevice).close ();
                    if ((device as Cld.ComediDevice).is_open)
                        error ("Failed to close Comedi device: %s", device.id);
                }
            }
        }

        /* XXX should check that the task stopped properly */
        acquisition_state_changed (false);
    }

    /**
     * Starts the thread that handles output channels.
     *
     * @deprecated since adding controller set/get
     */
    public void start_device_output () {
        /* XXX probably not necessary to lock, there for legacy reasons only */
        lock (model) {
            var devices = model.ctx.get_object_map (typeof (Cld.Device));
            foreach (var device in devices.values) {
                if (!(device as Cld.ComediDevice).is_open) {
                    message ("Opening Comedi Device: %s", device.id);
                    (device as Cld.ComediDevice).open ();
                }

                if (!(device as Cld.ComediDevice).is_open)
                    error ("Failed to open Comedi device: %s", device.id);

                foreach (var task in (device as Cld.Container).get_objects ().values) {
                    if (task is Cld.ComediTask) {
                        if ((task as Cld.ComediTask).direction == "write")
                            (task as Cld.ComediTask).run ();
                    }
                }
            }
        }
    }

    /**
     * Stops the thread that handles output channels.
     *
     * @deprecated since adding controller set/get
     */
    public void stop_device_output () {
        /* XXX probably not necessary to lock, there for legacy reasons only */
        lock (model) {
            var devices = model.ctx.get_object_map (typeof (Cld.Device));
            foreach (var device in devices.values) {
                message ("Stopping tasks for: %s", device.id);
                foreach (var task in (device as Cld.Container).get_objects ().values) {
                    if (task is Cld.ComediTask) {
                        if ((task as Cld.ComediTask).direction == "write") {
                            message ("  Stopping task: %s", task.id);
                            (task as Cld.ComediTask).stop ();
                        }
                    }
                }
            }
        }
    }
}
