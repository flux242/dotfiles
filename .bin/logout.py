#!/usr/bin/env python3

import sys,os,tempfile
import cairo
import getpass
from gi.repository import Gtk, Gdk
import dbus,subprocess

class SingleInstance:
    """
    If you want to prevent your script from running in parallel just instantiate
    SingleInstance() class. If is there another instance already running it will
    exist the application with the message "Another instance is already running,
    quitting.", returning -1 error code.

    >>> me = SingleInstance()
    """
    def __init__(self):
        self.lockfile = os.path.normpath(tempfile.gettempdir() + '/' +
          os.path.splitext(os.path.abspath(__file__))[0].replace("/","-").replace(":","").replace("\\","-")  + '.lock')
        import fcntl, sys
        self.fp = open(self.lockfile, 'w')
        try:
          fcntl.lockf(self.fp, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except IOError:
          sys.exit(-1)

class EventHandler (object):
    _bus = dbus.SystemBus()

    def __init__(self):
      pass
    def logout_clicked(self, button):
      subprocess.Popen(['/usr/bin/i3-msg', 'exit'])
      Gtk.main_quit()
    def reboot_clicked(self, button):
      proxy = self._bus.get_object("org.freedesktop.login1","/org/freedesktop/login1")
      lm = dbus.Interface(proxy,"org.freedesktop.login1.Manager")
      lm.Reboot(True)
    def poweroff_clicked(self, button):
      proxy = self._bus.get_object("org.freedesktop.login1","/org/freedesktop/login1")
      lm = dbus.Interface(proxy,"org.freedesktop.login1.Manager")
      lm.PowerOff(True)
    def suspend_clicked(self, button):
      proxy = self._bus.get_object("org.freedesktop.login1","/org/freedesktop/login1")
      lm = dbus.Interface(proxy,"org.freedesktop.login1.Manager")
      lm.Suspend(True)
      self.lock()
    def hibernate_clicked(self, button):
      proxy = self._bus.get_object("org.freedesktop.login1","/org/freedesktop/login1")
      lm = dbus.Interface(proxy,"org.freedesktop.login1.Manager")
      lm.Hibernate(True)
    def cancel_clicked(self, button):
      Gtk.main_quit()
    def lock_clicked(self, button):
      self.lock()
    def lock(self):
      #subprocess.Popen(['/usr/bin/slock'])
      subprocess.Popen(['xflock4'])
      Gtk.main_quit()
    def key_pressed(self, widget, event):
      #print("key: ", event.keyval, "; state: ", int(event.state))
      if event.keyval == 65307: # Esc
        Gtk.main_quit()
      return False

class MyWin (Gtk.Window):
    _handler = EventHandler()

    def __init__(self, ui_file):
      super(MyWin, self).__init__()
      self.create_screenshot()
      self.set_app_paintable(True)
      builder = Gtk.Builder()
      builder.set_translation_domain('xfce4-session')
      builder.add_from_file(ui_file)
      widget = builder.get_object("main_widget")
      self.add(widget)
      handlers = {
        "logout_clicked"    : self._handler.logout_clicked,
        "reboot_clicked"    : self._handler.reboot_clicked,
        "poweroff_clicked"  : self._handler.poweroff_clicked,
        "suspend_clicked"   : self._handler.suspend_clicked,
        "hibernate_clicked" : self._handler.hibernate_clicked,
        "cancel_clicked"    : self._handler.cancel_clicked,
        "lock_clicked"      : self._handler.lock_clicked,
      }
      self.connect("draw", self.area_draw)
      self.connect("delete-event", Gtk.main_quit)
      self.connect("key-press-event", self._handler.key_pressed)
      builder.connect_signals(handlers)

      eb = builder.get_object("eventbox")
      eb.connect("draw", self.ebox_draw)
      eb.override_background_color(Gtk.StateFlags.NORMAL, Gdk.RGBA(1.0, 1.0, 1.0, 0.0))
      lh = builder.get_object("label_head")
      lh.set_text("Logout: " + getpass.getuser())

      self.set_keep_above(True)
      self.set_skip_taskbar_hint(True)
      self.stick()
      self.fullscreen()
      self.show_all()

    def create_screenshot(self):
      root_win = Gdk.get_default_root_window()
      width = root_win.get_width()
      height = root_win.get_height()
      self.ims = cairo.ImageSurface(cairo.FORMAT_ARGB32, width, height)
      pb = Gdk.pixbuf_get_from_window(root_win, 0, 0, width, height)
      cr = cairo.Context(self.ims)
      Gdk.cairo_set_source_pixbuf(cr, pb, 0, 0)
      cr.paint()
      cr.set_source_rgba(.0, .0, .0, 0.6)
      cr.set_operator(cairo.OPERATOR_OVER)
      cr.paint()

    def area_draw(self, widget, cr):
      (x,y) = self.get_window().get_position()
      cr.set_source_surface(self.ims, -x, -y)
      cr.paint()
      cr.set_operator(cairo.OPERATOR_OVER)
      return False

    def ebox_draw(self, widget, cr):
      from math import pi
      radius = 15
      x = 0; y = 0
      w = widget.get_window().get_width()
      h = widget.get_window().get_height()

      cr.arc(x + w - radius, y + radius, radius, -pi/2, 0);
      cr.arc(x + w - radius, y + h - radius, radius, 0, pi/2);
      cr.arc(x + radius, y + h - radius, radius, pi/2, pi);
      cr.arc(x + radius, y + radius, radius, pi, 3/2*pi);
      cr.close_path();

      cr.set_line_width(1.0)
      cr.set_source_rgba(1.0, 1.0, 1.0, 0.5)
      cr.stroke_preserve()
      cr.fill()

      return False

def main(argv):
  me = SingleInstance()
  MyWin(os.path.abspath(os.path.dirname(sys.argv[0]))+"/logout.ui");
  Gtk.main()

if __name__ == "__main__":
  main(sys.argv)

