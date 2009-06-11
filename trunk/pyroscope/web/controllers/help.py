""" PyroScope - Controller "help".

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
import re
import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to

from pyroscope.web.lib.base import render, BaseController

LOG = logging.getLogger(__name__)


class HelpController(BaseController):

    def index(self):
        # Redirect to help index page
        return redirect_to(action="wiki", id="HelpIndex")


    def wiki(self, id):
        # Get basic data
        wiki_root = os.path.join(os.path.dirname(os.path.dirname(__file__)), "wiki")
        page_file = os.path.join(wiki_root, id + ".wiki")
        c.title = re.sub(r"([A-Z])", r" \1", id).strip()

        # Open page file and read it
        handle = open(page_file, "r")
        try:
            c.lines = handle.readlines()
        finally:
            handle.close()

        # Parse meta data at the top
        c.meta = {}
        while c.lines and c.lines[0].startswith("#"):
            key, val = c.lines[0][1:].split(None, 1)
            c.meta[key] = val
            c.lines = c.lines[1:]
                
        # Return a rendered template
        return render("pages/help.mako")

