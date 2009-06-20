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
        <th class="wide">${"tracker Tracker Domain"|h.icon} TRACKER</th>
        <th>${"torrent # of LOADED Torrents"|h.icon}</th>
        <th>${"nuked # of ACTIVE Torrents"|h.icon}</th>
        <th>${"box-cross # of INCOMPLETE Torrents"|h.icon}</th>
        <th>${"started # of OPEN Torrents"|h.icon}</th>
        <th>${"stopped # of CLOSED Torrents"|h.icon}</th>
        <th>${"padlock2 # of PRV Torrents"|h.icon}</th>
        <th>${"people # of PUB Torrents"|h.icon}</th>
        <th>${"green_size_doc Total SIZE"|h.icon}</th>
        <th>${"green_up_doc Amount UPLOADED"|h.icon}</th>
        <th>${"green_down_doc Amount DOWNLOADED"|h.icon}</th>
        <th>${"ying_yang_rg Average Real RATIO"|h.icon}</th>
        <th>${"percent Average Total RATIO"|h.icon}</th>
    </tr>
% for idx, (domain, counts) in enumerate(sorted(c.trackers.items())):
    <tr class="${'odd' if idx&1 else 'even'}">
        <td><a href="/view/list/name?filter=*${domain.lstrip('*.')|u}" title="Click for list of torrents on ${domain}">
            ${domain|h.obfuscate}
        </a></td>
% for key in ('total', 'active'):
        <td class="${counts[key] | valclass}">${counts[key]}</td>
% endfor
% for key in ('incomplete', 'open', 'closed', 'prv', 'pub'):
        <td class="${counts[key] | valclass}">
        % if counts[key]:
            <a href="/view/list/name?filter=*${domain.lstrip('*.') + ' ' + key | u}&filter_mode=AND" 
                    title="Click for list of ${key.upper()} torrents on ${domain}">
                ${counts[key]}</a>
        % else:
                ${counts[key]}
        % endif
        </td>
% endfor
% for key in ('size', 'up', 'down'):
        <td class="${counts[key] | valclass}">${counts[key]|h.bibyte}</td>
% endfor
        <td class="monoval">${"%6.3f" % (counts['real_ratio'] / counts['down_count']) if counts['down_count'] else ''}</td>
        <td class="monoval">${"%6.3f" % (counts['ratio'] / counts['total'])}</td>
    </tr>
% endfor
</table>

