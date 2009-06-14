<%doc>
    VIEW: Torrent listing
    
    Expects the torents in c.torrents, and optionally the summary fields
    c.refresh_rate, c.up_total and c.down_total.
    
    XXX Maybe pass name of a footer include as a parameter.
</%doc>
<%!
    from pyroscope.web.lib import helpers as h

    valclass = lambda val: 'monoval' if int(val) else 'zeroval'
    harmless = [
        "Tried all trackers",
        "Timeout was reached",
    ]
%>

<table class="grid">
## Active torrents header
    <tr class="header">
        <th>${"info_green.16 STATUS"|h.icon}</th>
        <th>${"torrent.16 NAME"|h.icon} TORRENT</th>
        <th>${"green_up_double.16 UP"|h.icon} RATE</th>
        <th>${"green_down_double.16 DOWN"|h.icon} RATE</th>
        <th>${"green_up_doc.16 UP"|h.icon} XFER</th>
        <th>${"green_down_doc.16 DOWN"|h.icon} XFER</th>
        <th>${"ying_yang_rg.16 RATIO"|h.icon}</th>
        <th>${"tracker.16 DOMAIN"|h.icon} TRACKER</th>
    </tr>
## Active torrents body
% for idx, item in enumerate(c.torrents):
    <tr class="${'odd' if idx&1 else 'even'}">
        <td>
            ${"started.12 STARTED" if item.is_open else "stopped.12 STOPPED"|h.icon}
            ${"box-check.12 COMPLETE" if item.complete else "box-cross.12 INCOMPLETE"|h.icon}
            ${"nuked.12 ACTIVE" if item.up_rate or item.down_rate else "empty.12 IDLE"|h.icon}
% if item.message:
% if any(h in item.message for h in harmless):
            ${"info_green.12 %s" % item.message|h.icon}
% elif item.is_open:
            ${"info_red.12 %s" % item.message|h.icon}
% else:
            ${"info_blue.12 %s" % item.message|h.icon}
% endif
% endif
        </td>
        <td><a class="tlink" href="${h.url_for(controller='torrent', id=item.hash)}" title="${item.tooltip}">
            ${item.name|h.nostrip,h.obfuscate}
        </a></td>
        <td class="${item.up_rate|valclass}">${item.up_rate|h.bibyte}</td>
        <td class="${item.down_rate|valclass}">${item.down_rate|h.bibyte}</td>
        <td class="${item.up_total|valclass}">${item.up_total|h.bibyte}</td>
        <td class="${item.down_total|valclass}">${item.down_total|h.bibyte}</td>
        <td class="monoval">${"%6.3f" % item.ratio_not0}</td>
        <td>
% for domain in item.tracker_domains:
            <a href="/view/list/name?filter=${domain|u}" title="Click for list of torrents on ${domain}">
                ${domain|h.obfuscate}
            </a> &nbsp;
% endfor        
        </td>
    </tr>
% endfor
## Torrents list footer
% if c.up_total != "" or c.down_total != "":
    <tr class="footer">
        <td></td>
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
% endif
</table>

