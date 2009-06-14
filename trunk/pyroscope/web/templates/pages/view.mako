<%inherit file="/common/pageframe.mako"/>
<%!
    from pylons import tmpl_context as c
    from pyroscope.web.lib import helpers as h

    # Overloaded attributes of pageframe
    page_title = lambda: "Torrents"
    page_head = lambda: '<meta http-equiv="refresh" content="%s" />' % c.refresh_rate
%>
##
## VIEW SELECTION
##
<div class="tab-bar">
<ul>
% for view in c.views:
    <li ${'class="selected"' if view is c.view else "" | n}>
        <a href="${h.url_for(action='list', id=view.action)}">
            ${view.title}
            ## ${"(%d)" % len(c.torrents) if view is c.view else ""}
        </a>
    </li>
% endfor
</ul>
</div>

##
## TORRENT LIST
##
<div class="tab-box">
<h3>${len(c.torrents)} ${c.view.title.replace("Torrents", "Torrent(s)")}</h3>
<%include file="/common/torrents-list.mako"/>
</div>

##            print "  [%d torrents on %d trackers with %.3f total ratio]" % (
##                len(self.torrents), len(domains),
##               sum(ratios) / 1000.0 / len(ratios),
##            )
##            print "  [%d^v / %d^ / %dv, %d open, %d complete, %d initial seeds]" % (
##                len(active_both), len(active_up), len(active_down),
##                counts["is_open"],
##                counts["complete"],
##                len(seeds),
##            )

##
## MESSAGES
##
% if c.messages:
<div class="tab-box">
<h3>${len(c.messages)} Tracker Message(s)</h3>

<table class="grid">
    <tr>
        <th>${"torrent.16"|h.icon} TORRENT</th>
        <th>${"message.16"|h.icon} MESSAGE</th>
        <th>${"tracker"|h.icon} TRACKER</th>
    </tr>
% for item in sorted(c.messages):
    <tr>
        <td><a class="tlink" href="${h.url_for(controller='torrent', id=item.hash)}" title="${item.tooltip}">
            ${item.name|h.nostrip,h.obfuscate}
        </a></td>
        <td>${item.text}</td>
        <td>${item.domains|h.obfuscate}</td>
    </tr>
% endfor
</table>
</div>
% endif

