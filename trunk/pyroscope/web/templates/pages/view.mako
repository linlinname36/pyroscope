<%inherit file="/common/pageframe.mako"/>
<%!
    from pylons import tmpl_context as c
    from pyroscope.web.lib import helpers as h

    valclass = lambda val: 'monoval' if int(val) else 'zeroval'

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
<table class="grid">
## Active torrents header
    <tr>
        <th>${"torrent.16"|h.icon} TORRENT</th>
        <th>${"green_up_double.16 UP"|h.icon} RATE</th>
        <th>${"green_down_double.16 DOWN"|h.icon} RATE</th>
        <th>${"green_up_doc.16 UP"|h.icon} XFER</th>
        <th>${"green_down_doc.16 DOWN"|h.icon} XFER</th>
        <th>${"ying_yang_rg RATIO"|h.icon}</th>
        <th>${"tracker"|h.icon} TRACKER</th>
    </tr>
## Active torrents body
% for item in c.torrents:
    <tr>
        <td><a class="tlink" href="${h.url_for(controller='torrent', id=item.hash)}" title="${item.tooltip}">
            ${item.name|h.nostrip,h.obfuscate}
        </a></td>
        <td class="${item.up_rate|valclass}">${item.up_rate|h.bibyte}</td>
        <td class="${item.down_rate|valclass}">${item.down_rate|h.bibyte}</td>
        <td class="${item.up_total|valclass}">${item.up_total|h.bibyte}</td>
        <td class="${item.down_total|valclass}">${item.down_total|h.bibyte}</td>
        <td class="monoval">${"%6.3f" % item.ratio_not0}</td>
        <td>${item.domains|h.obfuscate}</td>
    </tr>
% endfor
## Torrents list footer
    <tr class="footer">
        <td>
            <small><em>Refreshes every <strong>${c.refresh_rate}</strong> seconds. 
            [&#160;change to
% for i in (10, 20, 30, 60,):
%   if i != int(c.refresh_rate):
                <a class="hoverline" href="?refresh=${i}">${i}</a>
%   endif
% endfor
            ]</em></small>
        </td>
        <td class="${c.up_total|valclass}">${"green_sigma.16 SUM UP"|h.icon} ${c.up_total|h.bibyte}</td>
        <td class="${c.down_total|valclass}">${"green_sigma.16 SUM DOWN"|h.icon} ${c.down_total|h.bibyte}</td>
        <td></td>
        <td></td>
        <td></td>
    </tr>
</table>
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

