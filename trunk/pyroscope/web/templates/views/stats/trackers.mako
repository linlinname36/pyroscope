<%doc>
    VIEW: Tracker Statistics
</%doc>
<%!
    #from pylons import tmpl_context as c
    from pyroscope.web.lib import helpers as h

    valclass = lambda val: 'monoval' if int(val) else 'zeroval'
%>

<h3>${len(c.trackers)} Tracker(s)</h3>

<table class="grid">
    <tr class="header">
        <th>${"tracker Tracker Domain"|h.icon} TRACKER</th>
        <th>${"torrent # of LOADED Torrents"|h.icon}</th>
        <th>${"nuked # of ACTIVE Torrents"|h.icon}</th>
        <th>${"box-cross # of INCOMPLETE Torrents"|h.icon}</th>
        <th>${"started # of OPEN Torrents"|h.icon}</th>
        <th>${"stopped # of CLOSED Torrents"|h.icon}</th>
    </tr>
% for idx, (domain, counts) in enumerate(sorted(c.trackers.items())):
    <tr class="${'odd' if idx&1 else 'even'}">
        <td><a href="/view/list/name?filter=*${domain|u}" title="Click for list of torrents on ${domain}">
            ${domain|h.obfuscate}
        </a></td>
% for key in ('total', 'active', 'incomplete', 'open', 'closed'):
        <td class="${counts[key] | valclass}">${counts[key]}</td>
% endfor
    </tr>
% endfor
</table>

