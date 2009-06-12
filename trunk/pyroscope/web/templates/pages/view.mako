<%inherit file="/common/pageframe.mako"/>
<%!
    from pyroscope.util import fmt
    from pylons import tmpl_context as c
    from pyroscope.web.lib import helpers as h

    # XXX Pylons seems to cache the header parts, refresh rate doesn't change always
    # But then this is a temp. hack anyway.
    refresh_rate = c.refresh_rate

    # Overloaded attributes
    page_title = "Torrents"
    page_head = '<meta http-equiv="refresh" content="%s" />' % refresh_rate
%>
##
## VIEW SELECTION
##
<div class="submenu">
<ul>
% for view in c.views:
    <li>
        <a ${'class="selected"' if view is c.view else "" | n} 
           href="${h.url_for(action='list', id=view.action)}">${view.title}</a>
    </li>
% endfor
</ul>
</div>

##
## TORRENT LIST
##
<h1>${len(c.torrents)} ${c.view.title.replace("Torrents", "Torrent(s)")}</h1>
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
        <td class="monoval">${item.up_rate_h}</td>
        <td class="monoval">${item.down_rate_h}</td>
        <td class="monoval">${item.up_total_h}</td>
        <td class="monoval">${item.down_total_h}</td>
        <td class="monoval">${"%6.3f" % item.ratio_1}</td>
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
        <td class="monoval">${"green_sigma.16 SUM UP"|h.icon} ${fmt.human_size(c.up_total)}</td>
        <td class="monoval">${"green_sigma.16 SUM DOWN"|h.icon} ${fmt.human_size(c.down_total)}</td>
        <td></td>
        <td></td>
        <td></td>
    </tr>
</table>

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
<h1>${len(c.messages)} Tracker Message(s)</h1>

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
% endif

