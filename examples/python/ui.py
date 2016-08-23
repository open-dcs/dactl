#!/usr/bin/env python
#! -*- coding: utf-8 -*-

from gi.repository import Cld
from gi.repository import DcsCore as dc
from gi.repository import DcsUI as du
from gi.repository import Gtk

class DcsExample(Gtk.Window):

    def __init__(self):
        Gtk.Window.__init__(self, title="DCS Example")

        config = Cld.XmlConfig.with_file_name("examples/cld.xml")
        self.context = Cld.Context.from_config(config)
        self.chan = self.context.get_object("ai0")
        self.dev = self.context.get_object("dev0")
        self.dev.open()
        if(not self.dev.is_open):
            print "Open device " + self.dev.id + " failed"

        #self.task = self.context.get_object("tk0")
        #self.task.run()

        self.aictl = du.AIControl("/ai0")
        self.aictl.connect("request_object", self.offer)
        self.add(self.aictl)

    def offer(self, widget):
        widget.offer_cld_object(self.chan)

win = DcsExample()
win.connect("delete-event", Gtk.main_quit)
win.show_all()
Gtk.main()
