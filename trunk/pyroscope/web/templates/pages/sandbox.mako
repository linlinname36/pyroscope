<%inherit file="/common/pageframe.mako"/>
<%!
    from pprint import pformat
    from pyroscope.web.lib import helpers as h
    page_title = "Laboratory"

    sizes = (16, 24, 32, 48)
%>

<h1>PyroScope Labs</h1>
<div><em>Testing area, enter at your own risk!</em></div>

##
## VIEW SELECTION
##
<div class="submenu">
<ul>
% for view, title in sorted(c.views.items()):
    <li>
        <a ${'class="selected"' if view == c.view else "" | n} 
           href="${h.url_for(id=view)}">${title}</a>
    </li>
% endfor
</ul>
</div>

##
## OHLOH VIEW
##
% if c.view == "ohloh":
    <div class="ohloh-widgets">
        % for stats in ("basic_stats", "factoids", "cocomo", "languages", ):
            <div>
                <script type="text/javascript" src="http://www.ohloh.net/p/346666/widgets/project_${stats}.js"></script>
            </div>
        % endfor
    </div>
    <div style="clear:both;" />
% endif

##
## ICONS VIEW
##
% if c.view == "icons":
<h2>Sizes [${", ".join("%dx%d" % (sz, sz) for sz in sizes)}]</h2>
<div style="clear:both;" clear="all">
% for icon in c.icons:
    <div class="iconbox">
        <div>
            % for size in sizes:
                ${"%s.%d" % (icon, size)|h.icon}
            % endfor
        </div>
        <div>${icon}</div>
    </div>
% endfor
    <div style="clear:both;" />
</div>
% endif

##
## GLOBALS VIEW
##
% if c.view == "globals":
<dl>
% for k in dir(g):
  % if not k.startswith('_'):
    ##.replace('\n', "<br />")
    <dt>${k}</dt>
    <dd><code>${getattr(h, k, "N/A")|n}</code></dd>
  % endif
% endfor
</dl>
% endif

##
## HELPERS VIEW
##
% if c.view == "helpers":
<dl>
% for k in dir(h):
  %if not k.startswith('_'):
    <dt>${k}</dt><dd><code>${(getattr(h, k).__doc__ or "N/A").replace('\n', "<br />")|n}</code></dd>
  % endif
% endfor
</dl>
% endif

