<%inherit file="/common/pageframe.mako"/>
<%!
    from pprint import pformat
    from pylons import tmpl_context as c
    from pyroscope.web.lib import helpers as h

    page_title = lambda: "Laboratory"
    page_help = lambda: "LaboratoryView"
    page_head = lambda: """
        <script src="http://static.simile.mit.edu/timeline/api-2.3.0/timeline-api.js?bundle=true" type="text/javascript"></script>
    """

    sizes = (12, 16, 24, 32, 48)
%>

<h1>PyroScope Labs</h1>
<div><em>Testing area, enter at your own risk!</em></div>

##
## VIEW SELECTION
##
<div class="tab-bar">
<ul>
% for view, title in sorted(c.views.items()):
    <li ${'class="selected"' if view == c.view else "" | n}>
        <a href="${h.url_for(id=view)}">${title}</a>
    </li>
% endfor
</ul>
</div>

<div class="tab-box">
##
## YUI VIEW
##
% if c.view == "yui":
    <div style="background-color: gray">
        <div id="texttipped">Tooltip Test</div>
        <img id="tooltipped" src="/img/png/24/logo.png" /> 

        <span id="mycheckbox" class="yui-button"> 
            <span class="first-child"> 
                <button type="button">Check me!</button> 
            </span> 
        </span> 
        
        <div id="calendar"></div>

        <script type="text/javascript">

            myTooltip = new YAHOO.widget.Tooltip("tt-id", {
                context: "tooltipped",
                text: "You have hovered over Tooltip Test.",
                showDelay: 500
            }); 
            new YAHOO.widget.Tooltip("tt-id2", {
                context: "texttipped",
                text: "You have hovered over a text.",
                showDelay: 500
            }); 

            // A DIV with id "cal1Container" should already exist on the page
            var calendar = new YAHOO.widget.Calendar("calendar");
            calendar.render();

            var oButton = new YAHOO.widget.Button("mycheckbox", { 
                    type: "checkbox", 
                    name: "field1",
                    value: "somevalue"
                }
            );

        </script>
    </div>
% endif

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
% endif

##
## ICONS VIEW
##
% if c.view == "icons":
<h3>Sizes [${", ".join("%dx%d" % (sz, sz) for sz in sizes)}]</h3>
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
    <!-- end icon float -->
    <div style="clear:both;"></div>
</div>
% endif

##
## GLOBALS VIEW
##
% if c.view == "globals":
<dl style="margin-left: 0;">
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
<dl style="margin-left: 0;">
% for k in dir(h):
  %if not k.startswith('_'):
    <dt>${k}</dt><dd><code>${(getattr(h, k).__doc__ or "N/A").replace('\n', "<br />")|n}</code></dd>
  % endif
% endfor
</dl>
% endif

##
## RTORRENT VIEW
##
% if c.view == "rtorrent":
<div>
<a href="?">Default View</a>
| <a href="?methods=1">List Methods</a>
</div>

## ~~~ Methods listing ~~~
% if c.methods:
    <div>
    % for letter, methods in sorted(c.methods.items()):
        <a href="#${letter}">[${letter}]</a>&nbsp;
    % endfor
    </div>

    % for letter, methods in sorted(c.methods.items()):
        <a name="${letter}"><h5>${letter}</h5></a>
        <div>
        % for method, (signatures, help) in sorted(methods):
            % for signature in signatures:
                <code><strong>${method}</strong>(<em>${', '.join(signature[1:])}</em>)
                </code>&#8658;<code> <em>${signature[0]}</em>
<%!
    def typed_result(method):
        result = getattr(c.proxy.rpc, method)()
        return "%r %r" % (type(result), result)
%>
                % if method in c.rt_globals:
                    <strong>${typed_result(method)}</strong>
                % endif
                </code> ${help}<br />
            % endfor
        % endfor
        </div>
    % endfor

## ~~~ Default ~~~
% else:
##view.size('main') = ${c.proxy.rpc.view.size('main')}<br />
##view.size_not_visible('main') = ${c.proxy.rpc.view.size_not_visible('main')}<br />

% for method in (c.rt_globals):
    ${method} = ${getattr(c.proxy.rpc, method)()}<br />
% endfor

##    ${c.proxy.rpc}<br />
## ~~~ End rTorrent ~~~
% endif
% endif

##
## SANDBOX VIEW
##
% if c.view == "sandbox":
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

<%!
    import time
    now = time.strftime("%c", time.localtime(time.time()))
%>
<h2>Metafile Download Timeline</h2>
<div id="timeline" style="height: 500px; border: 1px solid #aaa"></div>
${now}

<script>
 var tl;
 function onLoad() {
   var eventSource = new Timeline.DefaultEventSource();
   var bandInfos = [
     Timeline.createBandInfo({
         eventSource:    eventSource,
         date:           "${now}",
         width:          "90%", 
         intervalUnit:   Timeline.DateTime.DAY, 
         intervalPixels: 500
     }),
     Timeline.createBandInfo({
         overview:       true,
         eventSource:    eventSource,
         date:           "${now}",
         width:          "10%", 
         intervalUnit:   Timeline.DateTime.MONTH, 
         intervalPixels: 100
     })
   ];
   bandInfos[1].syncWith = 0;
   bandInfos[1].highlight = true;
   
   tl = Timeline.create(document.getElementById("timeline"), bandInfos);
   Timeline.loadXML("/sandbox/data/timeline.xml", function(xml, url) { eventSource.loadXML(xml, url); });
 }
 
 onLoad();
</script>

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% endif

## END TAB CONTENT
<div style="clear:both;"></div>
</div>

