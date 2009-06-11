<%inherit file="/common/pageframe.mako"/>
<%!
    from pylons import tmpl_context as c
    from pyroscope.web.lib import helpers as h
    page_title = c.title
%>
##<h1>${c.title}</h1>
% if "summary" in c.meta:
<br /><div><em>${c.meta["summary"]}</em></div>
% endif

<div>
<code>
% for line in c.lines:
${line}<br />
% endfor
</code>
</div>

