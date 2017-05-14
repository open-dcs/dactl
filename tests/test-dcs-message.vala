public abstract class Dcs.MessageTestsBase : Dcs.TestCase {

    protected Dcs.Message msg;

    public MessageTestsBase (string name) {
        base (name);
    }
}

public class Dcs.MessageTests : Dcs.MessageTestsBase {

    private const string class_name = "DcsMessage";

    public MessageTests () {
        base (class_name);
        add_test (@"[$class_name] Test alert message", test_alert);
        add_test (@"[$class_name] Test error message", test_error);
        add_test (@"[$class_name] Test info message", test_info);
        add_test (@"[$class_name] Test warning message", test_warning);
        add_test (@"[$class_name] Test object message", test_object);
        add_test (@"[$class_name] Test deserializing alert message",
                  test_deserialize_alert);
        add_test (@"[$class_name] Test deserializing error message",
                  test_deserialize_error);
        add_test (@"[$class_name] Test deserializing info message",
                  test_deserialize_info);
        add_test (@"[$class_name] Test deserializing warning message",
                  test_deserialize_warning);
        add_test (@"[$class_name] Test deserializing object message",
                  test_deserialize_object);
    }

    public override void set_up () {
        msg = new Dcs.Message ();
    }

    public override void tear_down () {
        msg = null;
    }

    private void test_alert () {
        msg = null;
        msg = new Dcs.Message.alert ("alert0");
        stdout.printf (@"$msg\n");
        assert (msg.message_type == Dcs.MessageType.ALERT);
    }

    private void test_error () {
        msg = null;
        msg = new Dcs.Message.error ("error0");
        stdout.printf (@"$msg\n");
        assert (msg.message_type == Dcs.MessageType.ERROR);
    }

    private void test_info () {
        msg = null;
        msg = new Dcs.Message.info ("info0");
        stdout.printf (@"$msg\n");
        assert (msg.message_type == Dcs.MessageType.INFO);
    }

    private void test_warning () {
        msg = null;
        msg = new Dcs.Message.warning ("warning0");
        stdout.printf (@"$msg\n");
        assert (msg.message_type == Dcs.MessageType.WARNING);
    }

    private void test_object () {
        msg = null;
        // XXX Would be better if this was the result of serializing a node
        /*
         *var builder = new Json.Builder ();
         *builder.begin_object ();
         *builder.set_member_name ("measurement");
         *builder.begin_array ();
         *builder.begin_object ();
         *builder.set_member_name ("channel");
         *builder.add_string_value ("ai0");
         *builder.set_member_name ("value");
         *builder.add_double_value (0.0);
         *builder.end_object ();
         *builder.begin_object ();
         *builder.set_member_name ("channel");
         *builder.add_string_value ("ai1");
         *builder.set_member_name ("value");
         *builder.add_double_value (1.0);
         *builder.end_object ();
         *builder.end_array ();
         *builder.end_object ();
         *var payload = builder.get_root ();
         *var generator = new Json.Generator ();
         *generator.set_root (payload);
         */
        var json = """
            {'msg0':{
                'type':'object',
                'timestamp':1494733359514526,
                'payload':{
                    'measurement':[
                        {'channel':'ai0','value':0.0},
                        {'channel':'ai1','value':1.0}
                    ]
                }
            }}
        """;
        var payload = Json.from_string (json);
        msg = new Dcs.Message.object ("msg0", payload);
        stdout.printf (@"$msg\n");
        assert (msg.message_type == Dcs.MessageType.OBJECT);
    }

    private void test_deserialize_alert () {
        var json = """
            {'alert0':{
                'type':'alert',
                'timestamp':1494732828669014,
                'message':'[ALERT] code 100'
            }}
        """;
        msg.deserialize (json);
        stdout.printf (@"$msg\n");
        assert (msg.message_type == Dcs.MessageType.ALERT);
    }

    private void test_deserialize_error () {
        var json = """
            {'error0':{
                'type':'error',
                'timestamp':1494733104200499,
                'message':'[ERROR] code 200'
            }}
        """;
        msg.deserialize (json);
        stdout.printf (@"$msg\n");
        assert (msg.message_type == Dcs.MessageType.ERROR);
    }

    private void test_deserialize_info () {
        var json = """
            {'info0':{
                'type':'info',
                'timestamp':1494733359514412,
                'message':'[INFO] code 300'
            }}
        """;
        msg.deserialize (json);
        stdout.printf (@"$msg\n");
        assert (msg.message_type == Dcs.MessageType.INFO);
    }

    private void test_deserialize_warning () {
        var json = """
            {'warning0':{
                'type':'warning',
                'timestamp':1494733359514465,
                'message':'[WARNING] code 400'
            }}
        """;
        msg.deserialize (json);
        stdout.printf (@"$msg\n");
        assert (msg.message_type == Dcs.MessageType.WARNING);
    }

    private void test_deserialize_object () {
        var json = """
            {'msg0':{
                'type':'object',
                'timestamp':1494733359514526,
                'payload':{
                    'measurement':[
                        {'channel':'ai0','value':0.0},
                        {'channel':'ai1','value':1.0}
                    ]
                }
            }}
        """;
        msg.deserialize (json);
        stdout.printf (@"$msg\n");
        assert (msg.message_type == Dcs.MessageType.OBJECT);
    }
}
