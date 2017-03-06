#
# Sample OpenDCS python plugin.
#
# Taken from: https://github.com/gregier/libpeas/tree/master/peas-demo
#
# For gi to find dcs this needs to be run before starting the application:
#   export GI_TYPELIB_PATH=/usr/local/lib/girepository-1.0/:$GI_TYPELIB_PATH

import gi
gi.require_version('Gtk', '3.0')
gi.require_version('Peas', '1.0')
gi.require_version('PeasGtk', '1.0')
gi.require_version('DcsCore', '0.2')
gi.require_version('DcsUI', '0.2')
from gi.repository import GObject
from gi.repository import Gtk
from gi.repository import Peas
from gi.repository import PeasGtk
from gi.repository import DcsCore
from gi.repository import DcsUI

from pprint import pprint

LABEL_STRING="Python Plugin Sample"

class PythonPlugin(Peas.ExtensionBase, Peas.Activatable):
    __gtype_name__ = 'PythonPlugin'

    object = GObject.property(type=GObject.Object)

    def do_activate(self):
        app = self.object.get_app()
        controller = app.get_controller()
        print("PythonPlugin.do_activate")
        window = DcsUI.UIWindow()
        # window.id = "win2"
        window.set_property("id", "win2")
        # win_dump = dir(window)
        # pprint(win_dump)
        page = DcsUI.UIPage()
        page.set_property("id", "pg2")
        box = DcsUI.UIBox()
        box.set_property("id", "plugbox2")
        rc = DcsUI.UIRichContent()
        rc.set_property("id", "rc2")
        rc.set_property("uri", "https://www.google.ca")
        controller.add(window, "/")
        controller.add(page, "/win2")
        controller.add(box, "/win2/pg2")
        controller.add(rc, "/win2/pg2/plugbox2")

    def do_deactivate(self):
        app = self.object.get_app()
        controller = app.get_controller()
        print("PythonPlugin.do_deactivate")
        controller.remove("/win2/pg2/plugbox2/rc2")
        controller.remove("/win2/pg2/plugbox2")
        controller.remove("/win2/pg2")
        controller.remove("/win2")

    def do_update_state(self):
        print("PythonPlugin.do_update_state")

class PythonConfigurable(GObject.Object, PeasGtk.Configurable):
    __gtype_name__ = 'PythonConfigurable'

    def do_create_configure_widget(self):
        return Gtk.Label.new("Python plugin configure widget")
