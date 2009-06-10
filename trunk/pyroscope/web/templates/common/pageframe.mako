## This is the default HTML page layout
<%!
    page_title = "*** PAGE TITLE NOT SET ***"
    page_head = ""
%>

<html>
  <head>
    <title>${self.attr.page_title} - PyroScope</title>
    <link rel="stylesheet" type="text/css" charset="utf-8" media="all" href="/css/default.css">
    ${self.attr.page_head|n}
  </head>
  <body>
    <img src="/img/logo-alpha-red.png"/>
    <span class="topstats">${g.engine_id|h}</span>
##  Top-level menu
    <ul class="topmenu">
        <li class="topmenu"><a class="topmenu" href="${h.url_for(controller="index")}">Home</a></li>
        <li class="topmenu"><a class="topmenu" href="${h.url_for(controller="view", action="active")}">Torrents</a></li>
    </ul>
##  Insert body of derived page
    ${self.body()}
##  ${dir(g)}
  </body>
</html>
