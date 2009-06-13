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
from cgi import escape

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to

from pyroscope.web.lib.base import render, BaseController

LOG = logging.getLogger(__name__)


# XXX move to own module in util.wiki later!
class WikiPage(object):
    """ Handle a Google Code wiki page. It's just intended to display the help pages,
        so it has very little error handling and doesn't support complex layout 
        combinations (for example, list items should not span several lines).

        Most problems should be fixed by editing the faulty pages, before changing 
        the code here and making it more complex. See SimpleMarkup in the wiki for
        the exact rules and samples.
    """

    # Directory holding the pages
    WIKI_ROOT = os.path.join(os.path.dirname(os.path.dirname(__file__)), "wiki")

    # URL to create wanted pages
    EDIT_URL = "http://code.google.com/p/pyroscope/w/edit/"

    # Regular expressions
    RE_CAPS = re.compile(r"([A-Z])")
    RE_INLINE = re.compile('|'.join([
        r"\*(?P<strong>.*?)\*",
        r"_(?P<em>.*?)_",
        r"`(?P<code>.*?)`",
        r"{{{(?P<tt>.*?)}}}",
        r"(?P<a>(?:[A-Z][a-z0-9_]+){2,32})",
        #r"",
    ]))


    @classmethod
    def open(cls, name):
        """ Open page from file.
        """
        page_file = os.path.join(cls.WIKI_ROOT, name + ".wiki")
        handle = open(page_file, "r")
        try:
            return cls(name, handle.read())
        finally:
            handle.close()


    def __init__(self, name, raw):
        self.name = name
        self.raw = raw
        self.title = self.RE_CAPS.sub(r" \1", name).strip()

        self._parse()


    def _exists(self, name):
        """ Check if named page exists
        """
        return os.path.isfile(os.path.join(self.WIKI_ROOT, name + ".wiki"))


    def _metadata(self):
        """ Parse meta data at the top
        """
        self.meta = {}
        while self.lines and self.lines[0].startswith("#"):
            key, val = self.lines[0][1:].split(None, 1)
            self.meta[key] = val
            self.lines = self.lines[1:]


    def _inline(self):
        """ Handle inline markup. Markup CAN NOT span several lines, and it cannot be nested!
        """
        def replacer(match):
            "Substitution helper"
            #return repr(match.groupdict())
            text = ''.join("<%s>%s</%s>" % (name, text, name)
                for name, text in match.groupdict().items()
                if text is not None
            )

            # Wikilink?
            if text.startswith("<a>"):
                name = match.group("a")

                if self._exists(name):
                    url_prefix, url_class = ("/help/wiki/", "Local")
                else:
                    url_prefix, url_class = (self.EDIT_URL, "Wanted")

                text = '<a class="wiki-%s" href="%s%s" title="%s page %s">%s' % (
                    url_class.lower(), url_prefix, name, url_class, name, text[3:],
                )

            return text

        self.lines = [self.RE_INLINE.sub(replacer, line)
                if not line.startswith(u"<code class") 
                else line
            for line in self.lines
        ]


    def _headings(self):
        """ Handle headings and paragraphs.
        """
        toc_line = None
        stack = []
        headings = []

        for idx, line in enumerate(self.lines):
            heading = line.rstrip('=')
            if heading is not line:
                level = len(line) - len(heading)
                heading = heading.lstrip(u'=')
                if 0 < level <= 3 and len(line) - len(heading) == 2 * level:
                    stack = (stack + [0]*3)[:level]
                    stack[-1] += 1
                    heading = u"%s %s" % (u'.'.join(str(i) for i in stack), heading)
                    headings.append(heading)
                    self.lines[idx] = u"<h%d>%s</h%d>" % (level, heading, level)

            if line.startswith('&lt;wiki:toc '):
                toc_line = idx

        if toc_line is not None:
            toc = []
            for h in headings:
                num, title = h.split(None, 1)
                level = num.count('.')+1
                toc.append(
                    u'<div><span class="wiki-toc-num-%d">%s</span>'
                    u' <span class="wiki-toc-title-%d">%s</span></div>' % (
                        level, num, level, title,
                    ))

            self.lines[toc_line] = u'<div class="wiki-toc">%s</div>' % '\n'.join(toc)


    def _paragraphs(self):
        """ Handle paragraphs.
        """
        for idx, line in enumerate(self.lines):
            # Empty line that is not the first one and not after/before another empty line or HTML element?
            if (not line.strip() and 0 < idx < len(self.lines)-1 and self.lines[idx-1].strip()
                    and not self.lines[idx-1].endswith('>')
                    and not self.lines[idx+1].startswith('<h') ):
                self.lines[idx] = u"<br /><br />"


    def _tables(self):
        """ Handle tables.
        """
        in_table = False

        for idx, line in enumerate(self.lines):
            if line.startswith(u"|| ") and line.endswith(u" ||"):
                self.lines[idx] = u"<tr><td>%s</td></tr>" % line[3:-3].replace(u"||", u"</td><td>")
                if not in_table:
                    self.lines[idx] = u'<table>' + self.lines[idx]
                in_table = True
            elif in_table:
                self.lines[idx-1] += u"</table>"
                in_table = False


    def _code(self):
        """ Handle code sections.
        """
        in_code = 0
        code_lines = []

        for line in self.lines:
            if in_code:
                if line.strip() == u"{{{":
                    in_code += 1
                    code_lines[-1] += line + u"<br />"
                elif line.strip() == u"}}}":
                    in_code -= 1
                    if in_code:
                        code_lines[-1] += line + u"<br />"
                    else:
                        code_lines[-1] += u"</code>"
                else:
                    code_lines[-1] += line + u"<br />"
            elif line.strip() == u"{{{":
                code_lines.append(u'<code class="wiki-code">')
                in_code = 1
            else:
                code_lines.append(line)

        self.lines = code_lines


    def _lists_and_rules(self):
        """ Handle lists.
        """
        stack = [(0, '')]
        for idx, line in enumerate(self.lines):
            tags = None
            sline = line.lstrip()
            if sline is not line:
                indent = len(line) - len(sline)
                if sline.startswith("* "):
                    tags = ("ul", "li")
                elif sline.startswith("# "):
                    tags = ("ol", "li")

                if tags:
                    self.lines[idx] = repr((tags, sline))
                    sline = "<%s>%s</%s>" % (tags[1], sline.lstrip("*# \t"), tags[1])
                    if indent > stack[-1][0]:
                        sline = "<%s>%s" % (tags[0], sline)
                        stack.append((indent,) + tags)
                    elif indent < stack[-1][0]:
                        sline = "</%s>%s" % (stack[-1][1], sline)
                        stack = stack[:-1]
                    elif tags != stack[-1]:
                        sline = "</%s><%s>%s" % (stack[-1][1], tags[0], sline)
                        stack[-1] = (indent,) + tags

                    self.lines[idx] = sline

            elif len(line) >= 4 and not line.strip("-"):
                self.lines[idx] = "<hr />"
                
            if not tags:
                while len(stack) > 1:
                    self.lines[idx-1] += "</%s>" % stack[-1][1]
                    stack = stack[:-1]


    def _parse(self):
        """ Parse the raw page text.
        """
        self.lines = [escape(line) for line in self.raw.splitlines()] + ['']
        self._metadata()
        self._code()
        self._headings()
        self._lists_and_rules()
        self._tables()
        self._paragraphs()
        self._inline()

        self.lines.insert(0, '<div class="wiki">')
        self.lines.append('</div>')
        self.html = u'\n'.join(self.lines)


class HelpController(BaseController):

    def index(self):
        # Redirect to help index page
        return redirect_to(action="wiki", id="HelpIndex")


    def wiki(self, id):
        # Build model
        c.page = WikiPage.open(id)

        # Return a rendered template
        return render("pages/help.mako")

