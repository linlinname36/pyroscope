## This is the default HTML page layout
<%!
    page_title = "*** PAGE TITLE NOT SET ***"
    page_head = ""
%>

<html>
  <head>
    <title>${self.attr.page_title} - PyroScope</title>
##    ${h.stylesheet_link_tag( '/style1.css', '/style2.css')}
##    ${h.javascript_include_tag( 'jquery.js', 'jquery.debug.js')}
    <!-- Combo-handled YUI CSS files: --> 
    <link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/combo?2.7.0/build/reset-fonts-grids/reset-fonts-grids.css&2.7.0/build/base/base-min.css&2.7.0/build/assets/skins/sam/skin.css"> 
    <!-- Combo-handled YUI JS files: --> 
    <script type="text/javascript" src="http://yui.yahooapis.com/combo?2.7.0/build/yahoo-dom-event/yahoo-dom-event.js&2.7.0/build/container/container_core-min.js&2.7.0/build/menu/menu-min.js&2.7.0/build/element/element-min.js&2.7.0/build/button/button-min.js&2.7.0/build/calendar/calendar-min.js&2.7.0/build/datasource/datasource-min.js&2.7.0/build/paginator/paginator-min.js&2.7.0/build/datatable/datatable-min.js&2.7.0/build/json/json-min.js&2.7.0/build/layout/layout-min.js&2.7.0/build/stylesheet/stylesheet-min.js&2.7.0/build/tabview/tabview-min.js&2.7.0/build/treeview/treeview-min.js"></script> 

    <link rel="stylesheet" type="text/css" charset="utf-8" media="all" href="/css/default.css">
    ${self.attr.page_head|n}
  </head>

  <body><div id="doc3" class="yui-t5">
  <div class="header" id="hd"><!-- header -->
##  Logo & Stats
    <span class="logo">${"logo.150"|h.icon}</span>
    <div class="topstats">
        ${"console.16"|h.icon} ${g.engine_id}
        &#160; ${"clock.16"|h.icon} ${h.now()}
    </div>
##  Top-level menu
    <ul class="topmenu">
        <li><a id="topmenu-current" href="${h.url_for(controller="index")}">Home</a></li>
        <li><a href="${h.url_for(controller="view", action="active")}">Torrents</a></li>
    </ul>
  </div>
  <div id="bd"><!-- body -->
##  Insert body of derived page
    ${self.body()}
##  ${dir(g)}
  </div>
  <div class="footer" id="ft"><!-- footer -->
  <span><small><strong><em>Powered by:</em></strong></small></span>
  &#160; ${"python.png Python_Powered 42x40"|h.img}
  &#160; ${"pylons.png Pylons_Powered 59x40"|h.img}
  &#160; ${"yui.png YUI_Powered 120x37"|h.img}
  </div>
  </div></body>
</html>
