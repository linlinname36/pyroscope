""" PyroScope - Python Torrent Tools.

    PyroScope is a collection of tools for the BitTorrent protocol and especially the rTorrent client.

    It offers the following components:
     * a modern and versatile rTorrent web interface
     * rTorrent extensions like a queue manager and statistics
     * command line tools for automation of common tasks, like metafile creation 

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

from paver.easy import *
from paver.setuputils import setup

from setuptools import find_packages

name, version = open("debian/changelog").readline().split(" (", 1)
version, _ = version.split(")", 1)

project = dict(
    # egg
    name = name,
    version = version,
    packages = find_packages(exclude = ["tests"]),
    entry_points = {
        "console_scripts": [
            "mktor = pyroscope.scripts.mktor:run",
        ],
    },
    include_package_data = True,
    #zip_safe = False,
    data_files=[
        ("EGG-INFO", ["README", "LICENSE", "debian/changelog"]),
    ],

    # dependencies
    install_requires = [
        #"PasteScript>=1.6.2",
    ],
    setup_requires = [
    ],

    # tests
    test_suite = "nose.collector",

    # cheeseshop
    author = "The PyroScope Project",
    author_email = "pyroscope.project@gmail.com",
    description = __doc__.split('.', 1)[0].strip(),
    long_description = __doc__.split('.', 1)[1].strip(),
    license = [line.strip() for line in __doc__.splitlines()
        if line.strip().startswith("Copyright")][0],
    url = "http://code.google.com/p/pyroscope/",
    keywords = "bittorent rtorrent cli webui python",
    classifiers = [
        # see http://pypi.python.org/pypi?:action=list_classifiers
        "Development Status :: 3 - Alpha",
        #"Development Status :: 4 - Beta",
        #"Development Status :: 5 - Production/Stable",
        "Environment :: Console",
        "Environment :: Web Environment",
        #"Framework :: Paste",
        #"Framework :: Pylons",
        "Intended Audience :: End Users/Desktop",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: GNU General Public License (GPL)",
        "Natural Language :: English",
        "Operating System :: POSIX",
        "Programming Language :: Python :: 2.5",
        "Topic :: Communications :: File Sharing",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Topic :: Utilities",
    ],
)


@task
@needs("setuptools.command.build")
def functest():
    """ Integration test of the command line tools.
    """
    sh("bin/mktor -o build/pavement.torrent pavement.py http://example.com/")
    sh("bin/mktor -o build/tests.torrent -r 'pyroscope tests' --private tests/ http://example.com/")


setup(**project)

