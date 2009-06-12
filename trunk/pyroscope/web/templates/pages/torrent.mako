<%inherit file="/common/pageframe.mako"/>
<%!
    from pyroscope.web.lib import helpers as h
    from pylons import tmpl_context as c

    page_title = "%s - Torrent View" % h.obfuscate(c.name)
%>

<h1>Torrent ${c.name|h.obfuscate}</h1>

Hash: <code>${c.hash}</code>

