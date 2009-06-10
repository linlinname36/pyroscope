<%inherit file="/common/pageframe.mako"/>
<%!
    from pyroscope.util import fmt
    # from pyroscope.web.lib import helpers as h
    refresh_rate = 10
    page_title = "Torrents"
    page_head = '<meta http-equiv="refresh" content="%d" />' % refresh_rate
%>
<h1>Active torrents</h1>
<table class="grid">
<tr>
<th>NAME</th>
<th>RATE UP</th>
<th>RATE DN</th>
<th>XFER UP</th>
<th>XFER DN</th>
<th>RATIO</th>
<th>TRACKER</th>
</tr>
% for _, _, item in sorted(c.ordered, reverse=1):
<tr>
<td>${item.name}</td>
<td class="monoval">${item.up_rate_h}</td>
<td class="monoval">${item.down_rate_h}</td>
<td class="monoval">${item.up_total_h}</td>
<td class="monoval">${item.down_total_h}</td>
<td class="monoval">${"%6.3f" % item.ratio_1}</td>
<td>${item.domains}</td>
</tr>
% endfor
</table>

<br />
<div>
<strong>TOTAL:</strong> UP ${fmt.human_size(c.up_total)} / DOWN ${fmt.human_size(c.down_total)}
</div>

<div><small><em>Refreshed every ${self.attr.refresh_rate} seconds.</em></small></div>

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
% endif

% for msg in sorted(c.messages):
<strong>${msg.name|h}</strong> <em>${msg.text|h}</em> @ <tt>${msg.domains|h}</tt><br />
% endfor

