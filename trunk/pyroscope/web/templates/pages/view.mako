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
<h1>Active torrents</h1>
<table class="grid">
<tr>
<th>NAME</th>
<th>${"green_up_double.16"|h.icon} RATE</th>
<th>${"green_down_double.16"|h.icon} RATE</th>
<th>${"green_up_doc.16"|h.icon} XFER</th>
<th>${"green_down_doc.16"|h.icon} XFER</th>
<th>${"ying_yang_rg"|h.icon}</th>
<th>TRACKER</th>
</tr>
% for _, _, item in sorted(c.ordered, reverse=1):
<tr>
<td>${item.name|obfuscate,h}</td>
<td class="monoval">${item.up_rate_h}</td>
<td class="monoval">${item.down_rate_h}</td>
<td class="monoval">${item.up_total_h}</td>
<td class="monoval">${item.down_total_h}</td>
<td class="monoval">${"%6.3f" % item.ratio_1}</td>
##<td>${re.sub(item.domains)}</td>
<td>${item.domains|obfuscate,h}</td>
</tr>
% endfor
<tr>
<td style="border: 0px"><small><em>Refreshed every ${self.attr.refresh_rate} seconds.</em></small></td>
<td class="monoval" style="border: 0px">${"green_sigma.16"|h.icon} ${fmt.human_size(c.up_total)}</td>
<td class="monoval" style="border: 0px">${"green_sigma.16"|h.icon} ${fmt.human_size(c.down_total)}</td>
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

% if c.messages:
<h1>Tracker messages</h1>

<table class="grid">
<tr>
<th>NAME</th>
<th>MESSAGE</th>
<th>TRACKER</th>
</tr>
% for msg in sorted(c.messages):
<tr>
<td>${msg.name|obfuscate,h}</td>
<td>${msg.text|h}</td>
<td>${msg.domains|obfuscate,h}</td>
</tr>
% endfor
</table>
% endif

