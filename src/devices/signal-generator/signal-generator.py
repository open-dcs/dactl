#
# Sample OpenDCS python plugin.
#
# Taken from: https://github.com/gregier/libpeas/tree/master/peas-demo
#
# For gi to find dcs this needs to be run before starting the application:
#   export GI_TYPELIB_PATH=/usr/local/lib/girepository-1.0/:$GI_TYPELIB_PATH

import gi
gi.require_version('Peas', '1.0')
gi.require_version('DcsCore', '0.2')
gi.require_version('DcsDAQ', '0.2')
gi.require_version('DcsNet', '0.2')
from gi.repository import GObject
from gi.repository import Peas
from gi.repository import DcsCore
from gi.repository import DcsDAQ
from gi.repository import DcsNet

from pprint import pprint

LABEL_STRING="Signal Generator Device"

class SignalGenerator(DcsDAQ.DAQDevice):
    __gtype_name__ = 'SignalGenerator'

    object = GObject.property(type=GObject.Object)

    def do_activate(self):
        # print("SignalGenerator.do_activate")
        self.object.get_something()
        # self.service = self.object.get_service()
        self.variable = 0

    def do_deactivate(self):
        print("SignalGenerator.do_deactivate")

    def do_update_state(self):
        print("SignalGenerator.do_update_state")
