<%inherit file="/common/pageframe.mako"/>
<%!
    from pylons import tmpl_context as c
    from pyroscope.web.lib import helpers as h
    page_title = lambda: c.page.title
%>
<%include file="/common/wiki-summary.mako"/>

${c.page.html|n}
##<hr />${repr(c.page.html)}

