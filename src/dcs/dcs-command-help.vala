private class Dcs.Commands.Help : Dcs.Command {

    public override string name {
        get { return "help"; }
    }

    public override string description {
        get {
            return "Get help on using the program.";
        }
    }

    public override string help {
        get {
            /* TODO write a Util method to format help strings */
            return "help                   Describe all the available " +
                   "commands.\n" +
                   "help [command name]    Give more detailed help on the " +
                   "specified command.";
        }
    }

    public Help (Dcs.Client client) {
        base (client);
    }

  	public override async int run (string? command_string) {
        if (command_string == null) {
            /* Help index */
            Dcs.Utils.print_line ("Type `help <command>' for more " +
                                  "information about a particular command.");

            Gee.MapIterator<string, Dcs.Command> iter =
                client.commands.map_iterator ();

            Dcs.Utils.indent ();
            while (iter.next () == true) {
                Dcs.Utils.print_line ("%-20s  %s",
                                      iter.get_key (),
                                      iter.get_value ().description);
            }
            Dcs.Utils.unindent ();
        } else {
            /* Help for a given command */
            Dcs.Command command = client.commands.get (command_string);
            if (command == null) {
                Dcs.Utils.print_line ("Unrecognized command '%s'.",
                                      command_string);
                return 1;
            } else {
                Dcs.Utils.print_line ("%s", command.help);
            }
        }

        return 0;
    }

    public override string[]? complete_subcommand (string subcommand) {
        /* @subcommand should be a command name */
        return Readline.completion_matches (subcommand,
            Dcs.Utils.command_name_completion_cb);
    }
}
