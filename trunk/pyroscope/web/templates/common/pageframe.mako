## This is the default HTML page layout
<%!
    page_title = "*** PAGE TITLE NOT SET ***"
    page_head = ""
    refresh_rate = "60"
%>

<html>
  <head>
##  HTML head
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
  <div id="hd" class="rounded"><!-- header -->
##  Logo
    <div class="logo"><a href="http://pyroscope.googlecode.com/">${"logo.150"|h.icon}</a></div>
##  Search box & stats
    <div class="topstats">
    <form method="GET" action="${h.url_for(controller='search')}">
      <input type="image" src="/img/png/16/search.png" width="16" height="16" />
      <input type="text" id="search" name="query" 
             onfocus="if (this.value == 'Search...') this.value='';" 
             onblur="if (this.value == '') this.value='Search...';" 
             value="Search..." size="25" autocomplete="off" />
    </form>
    ${"console.16 ENGINE ID"|h.icon} ${g.engine_id}
    &#160; ${"clock.16 TIME"|h.icon} ${h.now()}
    </div>
##  Top-level menu
    <div class="topmenu">
    <ul class="topmenu">
        <li>${"home.24"|h.icon}<a id="topmenu-current" href="${h.url_for(controller='index')}">Home</a></li>
        <li>${"torrent.24"|h.icon}<a href="${h.url_for(controller='view', action='active')}?refresh=${self.attr.refresh_rate}">Torrents</a></li>
        <li>${"flask.24"|h.icon}<a href="${h.url_for(controller='sandbox')}">Lab</a></li>
        <li>${"help.24"|h.icon}<a href="${h.url_for(controller='help')}">Help</a></li>
    </ul>
    </div>
  </div>
  <div id="bd"><!-- body -->
##  Body of derived page
    ${self.body()}
  </div>
##  Footer
  <div id="ft" class="rounded"><!-- footer -->
  <small><strong><em>Powered by:</em></strong></small>
  &#160; <a href="http://www.python.org/">${"python.png Python_Powered 42x40"|h.img}</a>
  &#160; <a href="http://pylonshq.com/">${"pylons.png Pylons_Powered 59x40"|h.img}</a>
  &#160; <a href="http://www.linux.org/">${"tux.png GNU/Linux_Powered 40x40"|h.img}</a>
  &#160; <a href="http://www.blueskyonmars.com/projects/paver/">${"paver.png Paver_Powered 76x40"|h.img}</a>
  &#160; <a href="http://www.w3.org/Graphics/SVG/">${"svg.png SVG_Powered 40x40"|h.img}</a>
  &#160; <a href="http://developer.yahoo.com/yui/">${"yui.png YUI_Powered 120x37"|h.img}</a>
  &#160; <a href="http://en.wikipedia.org/wiki/Caffeine">${"coffee.png Caffeine_Powered 74x40"|h.img}</a>

  &#160; <span class="bugreport">
    ${"bug.24"|h.icon} <a class="hoverline" href="http://code.google.com/p/pyroscope/issues/entry">Report Bug</a>
  </span>
  &#160; <span class="profilingstats">Page rendered in <!-- LATENCY_PROFILING_RESULT -->.</span>
  </div>
  </div></body>
</html>
