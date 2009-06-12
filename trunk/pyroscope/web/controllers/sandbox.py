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

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to

from pyroscope.web.lib.base import render, BaseController

LOG = logging.getLogger(__name__)


class SandboxController(BaseController):

    def index(self):
        c.icons = sorted(os.path.splitext(name)[0]
            for name in os.listdir(os.path.join(os.path.dirname(__file__), "../public/img/svg"))
            if name.endswith(".svg")
        )

        # Return a rendered template
        return render("pages/sandbox.mako")

