""" PyroScope - Controller "torrent".

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

import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to

from pyroscope.lib.base import render, PageController
from pyroscope.engines import rtorrent

log = logging.getLogger(__name__)


class TorrentController(PageController):

    def __init__(self):
        self.proxy = rtorrent.Proxy()


    def index(self):
        # Redirect to view page
        return redirect_to(action="view") #, id="HelpIndex")


    def view(self, id):
        c.hash = id
        c.name = id

        c.torrents = list(rtorrent.View(self.proxy, "incomplete").items())

        # Return a rendered template
        return render("pages/torrent.mako")

