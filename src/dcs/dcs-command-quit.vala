private class Dcs.Commands.Quit : Dcs.Command {

    public override string name {
        get { return "quit"; }
    }

    public override string description {
        get {
            return "Quit the program.";
        }
    }

    public override string help {
        get {
            return "quit    Quit the program gracefully.";
        }
    }

    public Quit (Dcs.Client client) {
        base (client);
    }

  	public override async int run (string? command_string) {
        Process.exit (0);
    }
}
