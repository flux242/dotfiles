#!/usr/bin/env python3

import os, sys, socket
import configparser
from os.path import expanduser
import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk, GdkPixbuf
from gi.repository.GdkPixbuf import Pixbuf
from gi.repository import GObject

class SingleInstance:
    def __init__(self):
      global lock_socket   # Without this our lock gets garbage collected
      process_name = "Interface thoughput icon"
      lock_socket = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
      try:
        lock_socket.bind('\0' + process_name)
        #print 'I got the lock'
      except socket.error:
        #print 'lock exists'
        sys.exit()


class MyStatusIcon:
    def __init__(self, name, rx_color, tx_color, max_throughput, refresh_time):
        self.iface = name
        self.refresh_time = refresh_time # ms
        self.max_tput =  max_throughput
        self.rx_fill_color = rx_color
        self.tx_fill_color = tx_color
        self.statusicon = Gtk.StatusIcon()
        has_alpha = True
        bits_per_sample = 8
        width = 50; height = 50
        self.pixBuf = GdkPixbuf.Pixbuf.new(GdkPixbuf.Colorspace.RGB, has_alpha, bits_per_sample, width, height)
        self.pixBuf.fill(0x00000000)
        self.statusicon.set_from_pixbuf(self.pixBuf)
        self.statusicon.connect("popup-menu", self.right_click_event)
        #self.statusicon.connect("query-tooltip", self.query_tooltip)
        #self.statusicon.set_has_tooltip(True)
        self.rx = 0
        self.tx = 0
        self.tooltip = None
        GObject.timeout_add(self.refresh_time, self.update_icon)
        self.firstUpdate = True
        self.update_icon()
        #window = Gtk.Window()
        #window.connect("destroy", lambda w: Gtk.main_quit())
        #window.show_all()

    """
    this doesn't help to dynamically update the tooltip
    it will only update if a mouse moves over it
    def query_tooltip(self, widget, x, y, keyboard_tip, tooltip):
        self.tooltip = tooltip
        self.tooltip.set_markup("RX: %d\nTX: %d"% (self.rxdiff,self.txdiff))
        return True
    """

    def update_icon(self):
        try:
            result = self.get_net_bytes(self.iface)
            self.statusicon.set_visible(True)
        except:
            self.statusicon.set_visible(False)
            return True

        rxdiff = ((result['rx'] - self.rx)*1000)/self.refresh_time
        txdiff = ((result['tx'] - self.tx)*1000)/self.refresh_time

        if True == self.firstUpdate:
            rxdiff = txdiff = 0
            self.firstUpdate = False

        self.statusicon.set_tooltip_markup("<b><i><u>%s</u></i></b>\n"
                                           "<span foreground='%s'><b>RX: </b></span>%d\n"
                                           "<span foreground='%s'><b>TX: </b></span>%d"
                                            % (self.iface, "#%08X" % self.rx_fill_color, rxdiff, "#%08X" % self.tx_fill_color, txdiff))
#        print ("%d %d %d" % (rxdiff,txdiff, self.refresh_time))
        self.pixBuf.fill(0x00000000)
        self.fill_left (rxdiff/self.max_tput)
        self.fill_right(txdiff/self.max_tput)
        self.rx = result['rx']
        self.tx = result['tx']
        self.statusicon.set_from_pixbuf(self.pixBuf)
#        if self.tooltip:
#          self.tooltip.trigger_tooltip_query(self.statusicon.get_screen().get_display())
        return True

    def fill_left(self, percent):
        if percent > 1.0:
            percent = 1.0
        if percent < 0.0:
            percent = 0.0
        y = int(50*(1-percent))
        if y == 50:
            return
        subbuf = self.pixBuf.new_subpixbuf(0,y,24,50-y)
        subbuf.fill(self.rx_fill_color)

    def fill_right(self, percent):
        if percent > 1.0:
            percent = 1.0
        if percent < 0.0:
            percent = 0.0
        y = int(50*(1-percent))
        if y == 50:
            return
        subbuf = self.pixBuf.new_subpixbuf(27,y,23,50-y)
        subbuf.fill(self.tx_fill_color)
    
    def get_net_bytes(self, dev='eth0'):
        """Read network interface traffic counters"""
        if 'up' != open('/sys/class/net/%s/operstate' % dev,'r').read().strip():
            raise Exception('Interface is not up')
        else:
            return {
                'rx': float(open('/sys/class/net/%s/statistics/rx_bytes' % dev,'r').read().strip()),
                'tx': float(open('/sys/class/net/%s/statistics/tx_bytes' % dev,'r').read().strip())
        }

    def right_click_event(self, icon, button, time):
        self.menu = Gtk.Menu()

        about = Gtk.MenuItem()
        about.set_label("About")
        quit = Gtk.MenuItem()
        quit.set_label("Quit")

        about.connect("activate", self.show_about_dialog)
        quit.connect("activate", Gtk.main_quit)

        self.menu.append(about)
        self.menu.append(quit)
        self.menu.show_all()

        def pos(menu, icon):
            return (Gtk.StatusIcon.position_menu(menu, icon))

        self.menu.popup(None, None, None, self.statusicon, button, time)

    def show_about_dialog(self, widget):
        about_dialog = Gtk.AboutDialog()
        about_dialog.set_destroy_with_parent(True)
        about_dialog.set_name("Network interface thoughput systray icon")
        about_dialog.set_version("1.0")
        about_dialog.set_authors(["Alexander K"])
        about_dialog.run()
        about_dialog.destroy()

def human2bytes(s):
    """ convert human readable size string to int """
    symbols = ('B', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y')
    letter = s[-1:].strip().upper()
    num = s[:-1]
    assert num.isdigit() and letter in symbols
    num = float(num)
    prefix = {symbols[0]:1}
    for i, s in enumerate(symbols[1:]):
        prefix[s] = 1 << (i+1)*10
    return int(num * prefix[letter])

def color2rgba(colorstring):
    """ convert #RRGGBB[AA] to an (R, G, B, [A]) tuple """
    colorstring = colorstring.strip()
    if colorstring[0] == '#': colorstring = colorstring[1:]
    if len(colorstring) != 8:
        raise ValueError( "input #%s is not in #RRGGBBAA format" % colorstring)
    r, g, b, a = colorstring[:2], colorstring[2:4], colorstring[4:6], colorstring[6:]
    r, g, b, a = [int(n, 16) for n in (r, g, b, a)]
    return ( (r << 24) + (g << 16) + (b << 8) + a)

def main(argv):
  me = SingleInstance()
  newpid = os.fork()
  if newpid != 0:
    sys.exit()

  icons = []
  config = configparser.ConfigParser()
  config.read([expanduser('~/.nticon.conf')]) # add more places separated by comma
  for section in config.sections():
      icons.append(MyStatusIcon(config[section].get('name'),
                                color2rgba(config[section].get('color_rx', '#ff0000ff')),
                                color2rgba(config[section].get('color_tx', '#0000ffff')),
                                human2bytes(config[section].get('max_throughput', '100k')),
                                int(config[section].get('refresh_time', '1000'))
                                ))
  Gtk.main()

if __name__ == "__main__":
  main(sys.argv)
