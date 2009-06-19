""" PyroScope - Controller "sandbox".

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

import os
import logging
from collections import defaultdict

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to

from pyroscope.web.lib.base import render, BaseController
from pyroscope.engines import rtorrent

LOG = logging.getLogger(__name__)


class SandboxController(BaseController):

    VIEWS = {
        "yui": "YUI Tests",
        "ohloh": "ohloh.net",
        "icons": "Icons",
        "globals": "Globals",
        "helpers": "Helpers",
        "sandbox": "Sandbox",
        "rtorrent": "rTorrent",
    }

    rt_globals = (
        'dht_statistics', 'view_list',
        'get_max_downloads_div',
        'get_max_downloads_global',
        'get_max_file_size',
        'get_max_memory_usage',
        'get_max_open_files',
        'get_max_open_http',
        'get_max_open_sockets',
        'get_max_peers',
        'get_max_peers_seed',
        'get_max_uploads',
        'get_max_uploads_div',
        'get_max_uploads_global',
        'get_memory_usage',
        'get_min_peers',
        'get_min_peers_seed',
        'get_name',
        'get_peer_exchange',
        'get_port_open',
        'get_port_random',
        'get_port_range',
    )
    
    
    def data(self, id):
        if id == "timeline.xml":
            response.headers['Content-Type'] = 'application/xml; charset="utf-8"'
            return u"""<?xml version="1.0" encoding="utf-8"?>
<data>
    <event 
            start="Jun 04 2009 00:00:00 GMT"
            title="PyroScope project created on Google Code"
            image="http://code.google.com/p/pyroscope/logo?logo_id=1245201363"
        ><![CDATA[
            Initial directory structure for project 
            <a href="http://pyroscope.googlecode.com/">PyroScope</a> 
            created in SVN.
        ]]>
    </event>
    
    <event 
            start="Jun 13 2009 00:00:00 GMT"
            title="Started rTorrent 0.8.2/0.12.2"
        >
        Started rTorrent 0.8.2/0.12.2
    </event>
    
    <event 
            start="Jun 14 2009 22:00:00 GMT"
            end="Jun 16 2009 01:00:00 GMT"
            isDuration="true"
            title="Downloading Debian.ISO"
        >
        Debian.ISO [3333MiB, Ratio 1.234]
        </event>
        
    <event 
            start="Jun 16 2009 01:00:00 GMT"
            end="Jun 20 2009 14:00:00 GMT"
            isDuration="true"
            title="Seeding Debian.ISO"
        >
        Debian.ISO [3333MiB, Ratio 2.674]
        </event>
        
    <!--    
    <event link="...">
    -->
</data>
"""


    def index(self, id=None):
        c.views = self.VIEWS
        c.view = id if id in c.views else sorted(c.views)[0]
        c.title = c.views[c.view]
        c.rt_globals = self.rt_globals
     
        if c.view == "icons":
            c.icons = sorted(os.path.splitext(name)[0]
                for name in os.listdir(os.path.join(os.path.dirname(__file__), "../public/img/svg/icons"))
                if name.endswith(".svg")
            )
        elif c.view == "rtorrent":
            c.proxy = rtorrent.Proxy()
            if request.params.get("methods"):
                c.methods = defaultdict(list)
                for method in c.proxy.rpc.system.listMethods():
                    c.methods[method[0].upper()].append((method, (
                        c.proxy.rpc.system.methodSignature(method), 
                        c.proxy.rpc.system.methodHelp(method),
                    )))

        # Return a rendered template
        return render("pages/sandbox.mako")

