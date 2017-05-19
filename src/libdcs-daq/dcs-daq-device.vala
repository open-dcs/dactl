public class Dcs.DAQ.Device : Dcs.Node {

    public string module { get; set; }

    public bool enable { get; set; }

    public string? configuration { get; set; default = null; }
}
