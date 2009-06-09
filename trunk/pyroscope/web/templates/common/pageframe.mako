## This is the default HTML page layout

<%def name="page_title()">*** PAGE TITLE NOT SET ***</%def>

<html>
  <head>
    <title>${self.page_title()} - PyroScope Web Interface</title>
  </head>
  <body style="background-color:white">
    <img src="/img/logo-alpha-red.png"/>
    ${self.body()}
  </body>
</html>
