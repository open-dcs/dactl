public class Dcs.DAQ.Device : Dcs.PluginExtension {

    public Dcs.Net.Service service { get; construct set; }

    public Device (Dcs.Net.Service service) {
        debug ("Device constructor");
        this.service = service;
    }

    /*
     *public virtual void* run () {
     *    debug ("Device worker function");
     *    return null;
     *}
     */

    public void get_something () {
        stdout.printf ("hi\n");
    }
}
