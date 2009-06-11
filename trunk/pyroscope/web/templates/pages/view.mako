<%inherit file="/common/pageframe.mako"/>
<%!
    import re
    from pyroscope.util import fmt
    from pyroscope.web.lib import helpers as h

    obfuscate = lambda x: re.sub("[a-z]|[A-Z]+", lambda s: "?" * len(s.group()), x)
    obfuscate = lambda x: x
    refresh_rate = 10
    page_title = "Torrents"
    page_head = '<meta http-equiv="refresh" content="%d" />' % refresh_rate
%>
<h1>Active Torrents</h1>
<table class="grid">
<tr>
<th>${"torrent.16"|h.icon} TORRENT</th>
<th>${"green_up_double.16 UP"|h.icon} RATE</th>
<th>${"green_down_double.16 DOWN"|h.icon} RATE</th>
<th>${"green_up_doc.16 UP"|h.icon} XFER</th>
<th>${"green_down_doc.16 DOWN"|h.icon} XFER</th>
<th>${"ying_yang_rg RATIO"|h.icon}</th>
<th>${"tracker"|h.icon} TRACKER</th>
</tr>
% for _, _, item in sorted(c.ordered, reverse=1):
<tr>
<td>${item.name|obfuscate,h}</td>
<td class="monoval">${item.up_rate_h}</td>
<td class="monoval">${item.down_rate_h}</td>
<td class="monoval">${item.up_total_h}</td>
<td class="monoval">${item.down_total_h}</td>
<td class="monoval">${"%6.3f" % item.ratio_1}</td>
<td>${item.domains|obfuscate}</td>
</tr>
% endfor
<tr>
<td style="border: 0px"><small><em>Refreshed every ${self.attr.refresh_rate} seconds.</em></small></td>
<td class="monoval" style="border: 0px">${"green_sigma.16 SUM UP"|h.icon} ${fmt.human_size(c.up_total)}</td>
<td class="monoval" style="border: 0px">${"green_sigma.16 SUM DOWN"|h.icon} ${fmt.human_size(c.down_total)}</td>
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

% if c.messages:
<h1>${len(c.messages)} Tracker Message(s)</h1>

<table class="grid">
<tr>
<th>${"torrent.16"|h.icon} TORRENT</th>
<th>${"message.16"|h.icon} MESSAGE</th>
<th>${"tracker"|h.icon} TRACKER</th>
</tr>
% for msg in sorted(c.messages):
<tr>
<td>${msg.name|obfuscate}</td>
<td>${msg.text}</td>
<td>${msg.domains|obfuscate}</td>
</tr>
% endfor
</table>
% endif

