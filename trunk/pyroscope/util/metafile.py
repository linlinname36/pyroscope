""" PyroScope - Metafile Support.

    See http://www.bittorrent.org/beps/bep_0003.html

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

    Code partially adapted from BitTorrent 3.4.2, (c) by Bram Cohen
"""

import os
import re
import time
import math
import fnmatch
import hashlib
import logging

from pyroscope.util import bencode

LOG = logging.getLogger(__name__)
ALLOWED_NAME = re.compile(r"^[^/\\.~][^/\\]*$")


def check_info(info):
    """ Check info dict assertions.
    """
    if not isinstance(info, dict):
        raise ValueError("bad metainfo - not a dictionary")

    pieces = info.get("pieces")
    if not isinstance(pieces, basestring) or len(pieces) % 20 != 0:
        raise ValueError("bad metainfo - bad pieces key")

    piece_size = info.get("piece length")
    if not isinstance(piece_size, (int, long)) or piece_size <= 0:
        raise ValueError("bad metainfo - illegal piece length")

    name = info.get("name")
    if not isinstance(name, basestring):
        raise ValueError("bad metainfo - bad name")
    if not ALLOWED_NAME.match(name):
        raise ValueError("name %s disallowed for security reasons" % name)

    if info.has_key("files") == info.has_key("length"):
        raise ValueError("single/multiple file mix")

    if info.has_key("length"):
        length = info.get("length")
        if not isinstance(length, (int, long)) or length < 0:
            raise ValueError("bad metainfo - bad length")
    else:
        files = info.get("files")
        if not isinstance(files, (list, tuple)):
            raise ValueError("bad metainfo - bad file list")

        for item in files:
            if not isinstance(item, dict):
                raise ValueError("bad metainfo - bad file value")

            length = item.get("length")
            if not isinstance(length, (int, long)) or length < 0:
                raise ValueError("bad metainfo - bad length")

            path = item.get("path")
            if not isinstance(path, (list, tuple)) or not path:
                raise ValueError("bad metainfo - bad path")

            for part in path:
                if not isinstance(part, basestring):
                    raise ValueError("bad metainfo - bad path dir")
                if not ALLOWED_NAME.match(part):
                    raise ValueError("path %s disallowed for security reasons" % part)

        file_paths = [os.sep.join(item["path"]) for item in files]
        if len(set(file_paths)) != len(file_paths):
            raise ValueError("bad metainfo - duplicate path")

    return info


def check_meta(meta):
    """ Check meta dict assertions.
    """
    if not isinstance(meta, dict):
        raise ValueError("bad metadata - not a dictionary")
    if not isinstance(meta.get("announce"), basestring):
        raise ValueError("bad announce URL - not a string")
    check_info(meta.get("info"))

    return meta


class Metafile(object):
    """ A torrent metafile.
    """

    # Patterns of names to ignore
    IGNORE_GLOB = [
        "core", "CVS", ".*", "*~", "*.swp",
        "Thumbs.db", "desktop.ini", "ehthumbs_vista.db",
    ]


    def __init__(self, filename):
        """ Initialize metafile.
        """
        self.filename = filename
        self.progress = None
        self.datapath = None


    def _scan(self):
        """ Generate paths in "self.datapath".
        """
        if os.path.isdir(self.datapath):
            for dirpath, dirnames, filenames in os.walk(self.datapath):
                for bad in dirnames[:]:
                    if any(fnmatch.fnmatch(bad, pattern) for pattern in self.IGNORE_GLOB):
                        dirnames.remove(bad)

                for filename in filenames:
                    if not any(fnmatch.fnmatch(filename, pattern) for pattern in self.IGNORE_GLOB):
                        #yield os.path.join(dirpath[len(self.datapath)+1:], filename)
                        yield os.path.join(dirpath, filename)
        else:
            yield self.datapath


    def _calc_size(self):
        """ Get total size of "self.datapath".
        """
        return sum(os.path.getsize(filename)
            for filename in self._scan()
        )


    def _make_info(self, piece_size, progress):
        """ Create info dict.
        """
        totalsize = self._calc_size()
        totalhashed = 0
        file_list = []
        pieces = []
        sha1 = hashlib.sha1()
        done = 0
 
        for filename in sorted(self._scan()):
            filesize = os.path.getsize(filename)
            file_list.append({
                "length": filesize, 
                "path": filename[len(self.datapath)+1:].replace(os.sep, '/').split('/'),
            })
            pos = 0
            handle = open(filename, "rb")
            try:
                while pos < filesize:
                    chunk = handle.read(min(filesize - pos, piece_size - done))
                    sha1.update(chunk)
                    pos += len(chunk)
                    done += len(chunk)
                    totalhashed += len(chunk)
                    
                    if done == piece_size:
                        pieces.append(sha1.digest())
                        sha1 = hashlib.sha1()
                        done = 0

                    if progress:
                        progress(totalhashed, totalsize)
            finally:
                handle.close()

        if done > 0:
            pieces.append(sha1.digest())

        metainfo = {
            "pieces": "".join(pieces),
            "piece length": piece_size, 
            "name": os.path.basename(self.datapath),
        }
        
        if len(file_list) > 1:
            metainfo["files"] = file_list
        else:
            metainfo["length"] = totalsize

        return check_info(metainfo)


    def _make_meta(self, tracker_url, root_name, private, progress):
        """ Create torrent dict.
        """
        # Calculate piece size
        datasize = self._calc_size()
        piece_size_exp = int(math.log(datasize) / math.log(2)) - 9
        piece_size_exp = min(max(15, piece_size_exp), 22)
        piece_size = 2 ** piece_size_exp

        # Build info hash
        info = self._make_info(piece_size, progress)

        # Enforce unique hash per tracker
        info["x_cross_seed"] = hashlib.md5(tracker_url).hexdigest()

        # Set private flag
        if private:
            info["private"] = 1

        # Freely chosen root name (default is basename of the data path)
        if root_name:
            info["name"] = root_name

        # Torrent metadata
        meta = {
            "info": info, 
            "announce": tracker_url.strip(), 
            "creation date": long(time.time())
        }

        #!!! meta["encoding"] = "UTF-8"

        return check_meta(meta)


    def create(self, datapath, tracker_url, comment=None, root_name=None, created_by=None, private=False, progress=None):
        """ Create a metafile.
        """
        self.datapath = datapath.rstrip(os.sep)
        LOG.info("Creating %r for %r..." % (self.filename, self.datapath))

        meta = self._make_meta(tracker_url, root_name, private, progress)

        # Optional fields
        if comment:
            meta["comment"] = comment
        if created_by:
            meta["created by"] = created_by

        bencode.bwrite(self.filename, meta)
        return meta

