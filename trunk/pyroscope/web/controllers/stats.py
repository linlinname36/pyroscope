""" PyroScope - Controller "stats".

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
from collections import defaultdict

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to

from pyroscope.web.lib.base import render, BaseController
from pyroscope.util.types import Bunch
from pyroscope.engines import rtorrent

LOG = logging.getLogger(__name__)


class StatsController(BaseController):

    VIEWS = (
        Bunch(action="trackers", icon="tracker.12 Torrent Stats per Tracker", title="Trackers"),
    )


    def __init__(self):
        self.proxy = rtorrent.Proxy()
        self.views = dict((view.action, view) for view in self.VIEWS)


    def __before__(self):
        # Set list of views
        c.views = self.VIEWS


    def _render(self):
        return render("/pages/stats.mako")


    def trackers(self):
        # XXX: do this in the __before__, need to find out the action name though
        c.view = self.views['trackers']

        # Get list of torrents
        torrents = list(rtorrent.View(self.proxy, "main").items())

        #c.domains = set(domain for item in torrents for domain in item.tracker_domains)
        #c.active_up = [item for item in torrents if item.up_rate and not item.down_rate]
        #c.active_down = [item for item in torrents if not item.up_rate and item.down_rate]
        #c.active_both = [item for item in torrents if item.up_rate and item.down_rate]
        #c.ratios = [item.ratio for item in torrents if item.down_total or item.up_total]
        #c.seeds = [item for item in torrents if not item.down_total and item.up_total]

        #c.counts = {}
        #for attr in ("is_open", "complete"):
        #    c.counts[attr] = sum(getattr(item, attr) for item in torrents)

        # Sum up different values per tracker, over all torrents
        c.trackers = {}
        for item in torrents:
            domain = ", ".join(i.lstrip(".*") for i in sorted(item.tracker_domains))
            c.trackers.setdefault(domain, defaultdict(int))
            c.trackers[domain]["total"] += 1
            c.trackers[domain]["done" if item.complete else "incomplete"] += 1
            c.trackers[domain]["open" if item.is_open else "closed"] += 1
            c.trackers[domain]["prv" if item.is_private else "pub"] += 1
            if item.down_rate or item.up_rate:
                c.trackers[domain]["active"] += 1
            c.trackers[domain]["up"] += max(0, item.up_total)
            c.trackers[domain]["down"] += max(0, item.down_total)
            c.trackers[domain]["ratio"] += item.ratio / 1000.0
            if item.size_bytes > 0:
                c.trackers[domain]["size"] += item.size_bytes
            if item.down_total:
                c.trackers[domain]["down_count"] += 1
                c.trackers[domain]["real_ratio"] += item.ratio / 1000.0

        # Do totals over all fields
        c.totals = defaultdict(int)
        for values in c.trackers.values():
            for key, val in values.items():
                c.totals[key] += val

        return self._render()


    def index(self):
        # Redirect to list of active torrents
        ##return self._render()
        ##return redirect_to(action="trackers")
        return self.trackers()

