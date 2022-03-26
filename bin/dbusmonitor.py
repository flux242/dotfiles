#!/usr/bin/env python3

import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

def filter_cb(bus, message):
  # the NameAcquired message comes through before match string gets applied
  if message.get_member() != "Notify":
    return

  args = message.get_args_list()

  # args are
  # (app_name, notification_id, icon, summary, body, actions, hints, timeout)
  print("Notification from app '%s'" % args[0])
  print("args[1]=%s" % args[1])
  print("args[2]=%s" % args[2])
  print("Summary: %s" % args[3])
  print("Body: %s" % args[4])


DBusGMainLoop(set_as_default=True)
bus = dbus.SessionBus()
bus.add_match_string_non_blocking("eavesdrop='true', interface='org.freedesktop.Notifications',member='Notify'")
bus.add_message_filter(filter_cb)
GLib.MainLoop().run()

