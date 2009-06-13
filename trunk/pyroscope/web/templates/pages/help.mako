<%inherit file="/common/pageframe.mako"/>
<%!
    from pylons import tmpl_context as c
    from pyroscope.web.lib import helpers as h
    page_title = lambda: c.page.title
%>
##<h1>${c.page.title}</h1>
% if "summary" in c.page.meta:
<div class="wiki-summary">${c.page.meta["summary"]}</div>
% endif

${c.page.html|n}
##<hr />${repr(c.page.html)}

