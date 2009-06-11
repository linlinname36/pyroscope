""" PyroScope - Web Helper Functions.

    Consists of functions to typically be used within templates, but also
    available to Controllers. This module is available to templates as 'h'.

    Copyright (c) 2009 The PyroScope Project <pyroscope.project@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
"""

from pylons.controllers.util import url_for
#from webhelpers.html.tags import checkbox, password

def icon(name):
    """ Emit image tag for an icon.
    """
    title = ""
    if ' ' in name:
        name, title = name.split(None, 1)
        title = 'title="%(title)s" alt="%(title)s" ' % locals()

    size = 24
    if '.' in name:
        name, size = name.split('.')
        size = int(size)

    return '<img src="/img/png/%(size)d/%(name)s.png" height="%(size)d" width="%(size)d" %(title)s/>' % locals()


def img(name):
    """ Emit tag for a general image.
    
        "name" is expected to be a string like ImageMagick's "indentify" emits it.
    """
    name, title, size = name.split()
    if title in ("PNG", "GIF", "JPG"):
        title = ""
    else:
        title = title.replace("_", " ")
        title = 'title="%(title)s" alt="%(title)s" ' % locals()
    w, h = size.split("x")
    return '<img src="/img/%(name)s" height="%(h)s" width="%(w)s" %(title)s/>' % locals()


def now():
    """ Return curren time as a string.
    """
    import time
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.time()))

