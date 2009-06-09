## This is the default HTML page layout

<%def name="page_title()">*** PAGE TITLE NOT SET ***</%def>
<%def name="icon(name, size=22)"><img src="/img/png/${size}/${name}.png" height="${size}" width="${size}" /></%def>

<html>
  <head>
    <title>${self.page_title()} - PyroScope Web Interface</title>
    <link rel="stylesheet" type="text/css" charset="utf-8" media="all" href="/css/default.css">
  </head>
  <body>
    <img src="/img/logo-alpha-red.png"/>
    ${self.body()}
  </body>
</html>
