## This is the default HTML page layout
<%!
    page_title = lambda: "*** PAGE TITLE NOT SET ***"
    page_head = lambda: ""
    page_help = lambda: ""
%>
<html>
##  HTML head
    <head>
        <title>${self.attr.page_title()} - PyroScope</title>
        <%include file="/common/yui.mako"/>
        <link rel="stylesheet" type="text/css" charset="utf-8" media="all" href="/css/default.css">
        ${self.attr.page_head()|n}
    </head>

    <body><div id="doc3" class="yui-skin-sam yui-t5">
    <div id="hd" class="rounded"><!-- header -->
##  Logo
        <div class="logo"><a href="http://pyroscope.googlecode.com/">${"logo.150"|h.icon}</a></div>
##  Search box & stats
        <div class="topstats">
            <span>
                <form method="GET" action="${h.url_for(controller='search')}">
                  <input type="image" src="/img/png/16/search.png" width="16" height="16" />
                  <input type="text" id="search" name="query" 
                         onfocus="if (this.value == 'Search...') this.value='';" 
                         onblur="if (this.value == '') this.value='Search...';" 
                         value="Search..." size="25" autocomplete="off" />
                </form>
            </span>
            <span>
                ${"console.16 ENGINE ID"|h.icon} ${g.engine_id}
            </span>
            <span>
                ${"clock.16 TIME"|h.icon} ${h.now()}
            </span>
        </div>
##  Top-level menu
        <div class="topmenu">
            <ul>
                <li>${"home.24"|h.icon}<a id="topmenu-current" href="/index">Home</a></li>
                <li>${"torrent.24"|h.icon}<a href="/view">Torrents</a></li>
                <li>${"chart2.24"|h.icon}<a href="/stats">Stats</a></li>
                <li>${"flask.24"|h.icon}<a href="/sandbox">Lab</a></li>
% if self.attr.page_help():
                <li>${"help.24"|h.icon}<a href="/help/wiki/${self.attr.page_help()|u}">Help</a></li>
% else:
                <li>${"help.24"|h.icon}<a href="/help">Index</a></li>
% endif
            </ul>
        </div>
    </div>
##
% for line in c._debug:
    ${line}<br />
% endfor
##
##  Body of derived page
    <div id="bd"><!-- body -->
        ${self.body()}
    </div>
##  Footer
    <div id="ft" class="rounded"><!-- footer -->

% if 0: # XXX disable until pages are AJAXified to avoid contant reload
        <span class="ohloh">
            <script type="text/javascript" src="http://www.ohloh.net/p/346666/widgets/project_users_logo.js"></script>
            <small><strong><em>ohloh.net</em></strong></small><br />
            <script type="text/javascript" src="http://www.ohloh.net/p/346666/widgets/project_thin_badge.js"></script>
       </span>
% endif

        <small><strong><em>Powered by</em></strong></small>
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

    ## end of YUI body
    </div></body>
</html>
