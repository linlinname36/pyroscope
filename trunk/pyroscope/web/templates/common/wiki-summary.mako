<%doc>
    INCLUDE: Summary for wiki pages right under the header
</%doc>
<%!
    from pyroscope.web.lib import helpers as h
%>

##<h1>${c.page.title}</h1>
% if "summary" in c.page.meta:
<div class="wiki-summary">
    ${c.page.meta["summary"]}
    <a href="http://code.google.com/p/pyroscope/w/list?q=${c.page.meta['summary']|u}">
        ${"g_code.png Find_wiki_page_@_Google_Code 16x16"|h.img}</a>
    <a href="http://code.google.com/p/pyroscope/w/edit/${c.page.name|u}">
        ${"edit.16"|h.icon}</a>
</div>
% endif

