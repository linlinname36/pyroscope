""" PyroScope - Metafile Creator.

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

from pyroscope.scripts.base import ScriptBase

LOG = logging.getLogger(__name__)


class MetafileCreator(ScriptBase):
    """ Create a bittorrent metafile.
    """

    # argument description for the usage information
    ARGS_HELP = "<dir-or-file>"


    def add_options(self):
        """ Add program options.
        """
        self.add_bool_option("-p", "--private",
            help="Disallow DHT and PEX")
        self.add_value_option("-o", "--output-filename", "PATH",
            help="Optional file name for the metafile")
        self.add_value_option("--comment", "TEXT",
            help="Optional human-readable comment")


    def mainloop(self):
        """ The main loop.
        """
        if not self.args:
            self.parser.print_help()
            self.parser.exit()
        elif len(self.args) != 1:
            self.parser.error("Expected exactly one argument, got: %s" % (' '.join(self.args),))


def run(): #pragma: no cover
    """ The entry point.
    """
    ScriptBase.setup()
    MetafileCreator().run()

