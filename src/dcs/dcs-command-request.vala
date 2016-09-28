private class Dcs.Commands.Request : Dcs.Command {

    public override string name {
        get { return "request"; }
    }

    public override string description {
        get {
            return ".";
        }
    }

    public override string help {
        get {
            return ".";
        }
    }

    public Request (Dcs.Client client) {
        base (client);
    }

  	public override async int run (string? command_string) {
        return 0;
    }
}
