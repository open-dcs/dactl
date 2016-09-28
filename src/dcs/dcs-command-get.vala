private class Dcs.Commands.Get : Dcs.Command {

    public override string name {
        get { return "get"; }
    }

    public override string description {
        get {
            return "Get a property value given for a provided key.";
        }
    }

    public override string help {
        get {
            return "get                        Retrieve a property value.\n" +
                   "get [property name]        Display the current value " +
                   "of a configured property.";
        }
    }

    public Get (Dcs.Client client) {
        base (client);
    }

  	public override async int run (string? command_string) {
        if (command_string == null) {
            Dcs.Utils.print_line ("Type `get <property>` to print the " +
                "current value of the property.");
        }

        return 0;
    }
}
