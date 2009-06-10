## This is the default HTML page layout
<%!
    page_title = "*** PAGE TITLE NOT SET ***"
%>

<html>
  <head>
    <title>${self.attr.page_title} - PyroScope</title>
    <link rel="stylesheet" type="text/css" charset="utf-8" media="all" href="/css/default.css">
  </head>
  <body>
    <img src="/img/logo-alpha-red.png"/>
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
