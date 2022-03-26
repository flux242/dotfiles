#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Matrix-Curses
# See how deep the rabbit hole goes.
# Copyright (c) 2012 Tom Wallroth
#
# Sources on github:
#   http://github.com/devsnd/matrix-curses/
#
# licensed under GNU GPL version 3 (or later)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>
#

# Original code is refactored to make it appear more matrix style

from __future__ import unicode_literals
import locale
import time
import curses
import random
import sys
PYTHON2 = sys.version_info.major < 3
locale.setlocale(locale.LC_ALL, '')
encoding = locale.getpreferredencoding()

########################################################################
# TUNABLES

DROPPING_CHARS = 70
MIN_SPEED = 1
MAX_SPEED = 5
RANDOM_CLEANUP = 100
FPS = 25
SLEEP_MILLIS = 1.0/FPS
#USE_COLORS = False
USE_COLORS = True
SCREENSAVER_MODE = True
#MATRIX_CODE_CHARS = "ɀɁɂŧϢϣϤϥϦϧϨϫϬϭϮϯϰϱϢϣϤϥϦϧϨϩϪϫϬϭϮϯϰ߃߄༣༤༥༦༧༩༪༫༬༭༮༯༰༱༲༳༶"
MATRIX_CODE_CHARS = "𐌰𐌱𐌲𐌳𐌴𐌵𐌶𐌷𐌸𐌹𐌺𐌻𐌼𐌽𐌾𐌿𐍀𐍁𐍂𐍃𐍄𐍅𐍆𐍇𐍈𐍉𐍊"
COLOR_NORMAL = curses.COLOR_GREEN
COLOR_HIGHLIGHTED = curses.COLOR_CYAN

########################################################################
# CODE

COLOR_CHAR_NORMAL = 1
COLOR_CHAR_HIGHLIGHT = 2

class FallingChar(object):
    """ Here goes the docstring - pylint is happy """
    matrixchr = list(MATRIX_CODE_CHARS)
    normal_attr = curses.A_NORMAL
    highlight_attr = curses.A_REVERSE

    def __init__(self, width, min_speed, max_speed):
        self.x = 0
        self.y = 0
        self.speed = 1
        self.char = ' '
        self.reset(width, min_speed, max_speed)

    def reset(self, width, min_speed, max_speed):
        """ Here goes the docstring - pylint is happy """
        self.char = random.choice(FallingChar.matrixchr).encode(encoding)
        self.x = randint(1, width - 1)
        self.y = 0
        self.speed = randint(min_speed, max_speed)
        # offset makes sure that chars with same speed don't move all in same frame
        self.offset = randint(0, self.speed)

    def tick(self, scr, steps):
        """ Here goes the docstring - pylint is happy """
        height, width = scr.getmaxyx()
        if self.advances(steps):
            # if window was resized and char is out of bounds, reset
            self.out_of_bounds_reset(width, height)
            # make previous char curses.A_NORMAL
            if USE_COLORS:
                scr.addstr(self.y, self.x, self.char, curses.color_pair(COLOR_CHAR_NORMAL))
            else:
                scr.addstr(self.y, self.x, self.char, curses.A_NORMAL)

            # choose new char and draw it A_REVERSE if not out of bounds
            self.char = random.choice(FallingChar.matrixchr).encode(encoding)
            self.y += 1
            if not self.out_of_bounds_reset(width, height):
                if USE_COLORS:
                    scr.addstr(self.y, self.x, self.char, curses.color_pair(COLOR_CHAR_HIGHLIGHT)|curses.A_BOLD)
                else:
                    scr.addstr(self.y, self.x, self.char, curses.A_REVERSE)

    def out_of_bounds_reset(self, width, height):
        """ Here goes the docstring - pylint is happy """
        if self.x > width-2:
            self.reset(width, MIN_SPEED, MAX_SPEED)
            return True
        if self.y > height-1:
            self.reset(width, MIN_SPEED, MAX_SPEED)
            return True
        return False

    def advances(self, steps):
        """ Here goes the docstring - pylint is happy """
        if steps % (self.speed + self.offset) == 0:
            return True
        return False


# we don't need a good PRNG, just something that looks a bit random.
def rand():
    """ Here goes the docstring - pylint is happy """
    # ~ 2 x as fast as random.randint
    a = 9328475634
    while True:
        a ^= (a << 21) & 0xffffffffffffffff
        a ^= (a >> 35)
        a ^= (a << 4) & 0xffffffffffffffff
        yield a

r = rand()
def randint(_min, _max):
    """ Here goes the docstring - pylint is happy """
    if PYTHON2:
        n = r.next()
    else:
        n = r.__next__()
    return (n % (_max - _min)) + _min

def main():
    """ Here goes the docstring - pylint is happy """
    steps = 0
    scr = curses.initscr()
    scr.nodelay(1)
    curses.curs_set(0)
    curses.noecho()

    if USE_COLORS:
        curses.start_color()
        curses.use_default_colors()
        curses.init_pair(COLOR_CHAR_NORMAL, COLOR_NORMAL, -1)
        curses.init_pair(COLOR_CHAR_HIGHLIGHT, COLOR_HIGHLIGHTED, -1)

    height, width = scr.getmaxyx()
    lines = []
    for i in range(DROPPING_CHARS):
        l = FallingChar(width, MIN_SPEED, MAX_SPEED)
        l.y = randint(0, height-2)
        lines.append(l)

    scr.refresh()
    while True:
        height, width = scr.getmaxyx()
        for line in lines:
            line.tick(scr, steps)
        for i in range(RANDOM_CLEANUP):
            x = randint(0, width-1)
            y = randint(0, height)
            if (scr.inch(y, x) & curses.A_BOLD) == 0:
                scr.addstr(y, x, ' ')
        scr.refresh()
        time.sleep(SLEEP_MILLIS)
        if SCREENSAVER_MODE:
            key_pressed = scr.getch() != -1
            if key_pressed:
                raise KeyboardInterrupt()
        steps += 1

try:
    main()
except KeyboardInterrupt:
    curses.endwin()
    curses.curs_set(1)
    curses.reset_shell_mode()
    curses.echo()
