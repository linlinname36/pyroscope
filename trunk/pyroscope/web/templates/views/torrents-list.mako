<%doc>
    INCLUDE: Torrent listing
    
    Expects the torents in c.torrents, and optionally the summary fields
    c.refresh_rate, c.up_total and c.down_total.
    
    XXX Maybe pass name of a footer include as a parameter.
</%doc>
<%!
    from pyroscope.web.lib import helpers as h

    valclass = lambda val: 'monoval' if int(val) else 'zeroval'
%>

<table class="grid">
## Active torrents header
    <tr class="header">
        <th>${"torrent.16"|h.icon} TORRENT</th>
        <th>${"green_up_double.16 UP"|h.icon} RATE</th>
        <th>${"green_down_double.16 DOWN"|h.icon} RATE</th>
        <th>${"green_up_doc.16 UP"|h.icon} XFER</th>
        <th>${"green_down_doc.16 DOWN"|h.icon} XFER</th>
        <th>${"ying_yang_rg RATIO"|h.icon}</th>
        <th>${"tracker"|h.icon} TRACKER</th>
    </tr>
## Active torrents body
% for idx, item in enumerate(c.torrents):
    <tr class="${'odd' if idx&1 else 'even'}">
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
% if c.up_total != "" or c.down_total != "":
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
% endif
</table>

