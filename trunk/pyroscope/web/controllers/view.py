""" PyroScope - Controller "view".

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

from pyroscope.web.lib.base import render, BaseController
from pyroscope.util import fmt
from pyroscope.util.types import Bunch
from pyroscope.engines import rtorrent

LOG = logging.getLogger(__name__)


class ViewController(BaseController):

    IGNORE_MESSAGES = [
        "Timeout was reached",
        "Tried all trackers",
        "Could not parse bencoded data",
        "Couldn't connect to server",
    ]


    def __init__(self):
        self.proxy = rtorrent.Proxy()


    def _get_active(self):
        """ Get active torrents.
        """
        view = rtorrent.View(self.proxy, "main")
        torrents = list(view.items())
        active = [item 
            for item in torrents
            if item.down_rate or item.up_rate
        ]

        c.ordered = [(item.up_rate, item.down_rate, item) for item in active
                if item.down_rate or item.up_rate]

        c.up_total, c.down_total = 0, 0
        for _, _, item in c.ordered:
            c.up_total += item.up_rate
            c.down_total += item.down_rate

            item.ratio_1 = item.ratio / 1000.0 or 1E-12
            item.domains = ", ".join(item.tracker_domains)
            if item.down_total < 0 and item.up_total > 0:
                # Fix bug in XMLRPC (using 32bit integers?)
                item.down_total = item.up_total / item.ratio_1
            for attr in ("up_rate", "up_total", "down_rate", "down_total"):
                val = getattr(item, attr)
                setattr(item, attr + "_h", fmt.human_size(val) if val >= 0 else "  >4.0 GiB")

        domains = set(domain for item in torrents for domain in item.tracker_domains)
        active_up = [item for item in active if item.up_rate and not item.down_rate]
        active_down = [item for item in active if not item.up_rate and item.down_rate]
        active_both = [item for item in active if item.up_rate and item.down_rate]
        ratios = [item.ratio for item in torrents if item.down_total or item.up_total]
        #queued = [item for item in torrents if not (item.down_total or item.up_total)]
        seeds = [item for item in torrents if not item.down_total and item.up_total]

        counts = {}
        for attr in ("is_open", "complete"):
            counts[attr] = sum(getattr(item, attr) for item in torrents)

        c.messages = [Bunch(name=item.name, text=item.message, domains=", ".join(sorted(item.tracker_domains)))
            for item in torrents 
            if item.is_open and item.message and not any(ignore in item.message
                for ignore in self.IGNORE_MESSAGES
            )
        ]


    def active(self):
        # Build view model
        self._get_active()
        
        # Return a rendered template
        return render("pages/view.mako")

    index = active

