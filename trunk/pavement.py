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

import os

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
            "lstor = pyroscope.scripts.lstor:run",
        ],
        "paste.app_factory": [
            "main = pyroscope.web.config.middleware:make_app",
        ],
        "paste.app_install": [
            "main = pylons.util:PylonsInstaller",
        ],
    },
    include_package_data = True,
    zip_safe = False,
    data_files = [
        ("EGG-INFO", [
            "README", "LICENSE", "debian/changelog", 
            "pyroscope/web/config/paste_deploy_config.ini_tmpl",
        ]),
    ],
    paster_plugins = ["PasteScript", "Pylons"],

    #package_data={"pyroscope.web": ["i18n/*/LC_MESSAGES/*.mo"]},
    #message_extractors={"pyroscope.web": [
    #        ("**.py", "python", None),
    #        ("templates/**.mako", "mako", {"input_encoding": "utf-8"}),
    #        ("public/**", "ignore", None)]},

    # dependencies
    install_requires = [
        "Pylons==0.9.7",
    ],
    setup_requires = [
        "PasteScript>=1.7.3",
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
        "Framework :: Paste",
        "Framework :: Pylons",
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
@needs(["setuptools.command.egg_info", "svg2png"])
def bootstrap():
    links = []
    for egg_info in (i[1] for i in project["data_files"] if i[0] == "EGG-INFO").next():
        links.append((
            "../" + egg_info, 
            "%s.egg-info/%s" % (project["name"], os.path.basename(egg_info))
        ))

    for link_pair in links:
        if not os.path.exists(link_pair[1]):
            print "%s <- %s" % link_pair
            os.symlink(*link_pair)


@task
def svg2png():
    """ Convert SVG icons to PNG icons.
    """
    sizes = (16, 24, 32, 48)
    img_path = path("pyroscope/web/public/img")
    svg_path = img_path / "svg"
    svg_files = svg_path.files("*.svg")
    
    def make_png(svg_file, size):
        png_path = img_path / "png" / str(size)
        png_path.exists() or png_path.makedirs()
        png_file = png_path / svg_file.namebase + ".png"
        if not png_file.exists() or png_file.mtime < svg_file.mtime:
            sh("inkscape -z -e %(png_file)s -w %(size)d -h %(size)d %(svg_file)s" % locals())

    for size in sizes:
        for svg_file in svg_files:
            make_png(svg_file, size)

    # Project logo for Google Code & the UI
    make_png(svg_path / "logo.svg", 55)
    make_png(svg_path / "logo.svg", 150)


@task
@consume_args
def controller(args):
    links = [
        ("web/controllers", "%s/controllers" % project["name"]),
        ("../tests/web", "%s/tests" % project["name"]),
    ]
    for link_pair in links:
        if not os.path.exists(link_pair[1]):
            #print "%s <- %s" % link_pair
            os.symlink(*link_pair)
    try:
        sh("paster controller %s" % " ".join(args))
    finally:
        for _, link in links:
            os.remove(link)


@task
@needs("setuptools.command.build")
def serve():
    """ Start the web server in DEVELOPMENT mode.
    """
    sh("bin/paster setup-app development.ini")
    sh("bin/paster serve --reload --monitor-restart development.ini")


@task
@needs("setuptools.command.build")
def functest():
    """ Functional test of the command line tools.
    """
    sh("bin/mktor -o build/pavement.torrent pavement.py http://example.com/")
    sh("bin/mktor -o build/tests.torrent -x '*.pyc' -r 'pyroscope tests' --private tests/ http://example.com/")
    sh("bin/lstor build/*.torrent")


#
# Web Server Control
#
PASTER_CMD =  " ".join([
    "paster serve %s",
    "--pid-file ~/.pyroscope/web.pid",
    "--log-file ~/.pyroscope/log/web.log",
    "~/.pyroscope/web.ini",
])

@task
def start():
    """ Start the PRODUCTION web server.
    """
    sh("paster setup-app ~/.pyroscope/web.ini")
    sh(PASTER_CMD % ("--daemon")) # --monitor-restart makes --stop-daemon fail


@task
def stop():
    """ Start the PRODUCTION web server.
    """
    sh(PASTER_CMD % ("--stop-daemon"))


@task
def status():
    """ Check status of the PRODUCTION web server.
    """
    sh(PASTER_CMD % ("--status"))


setup(**project)

