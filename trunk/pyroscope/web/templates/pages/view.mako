<%inherit file="/common/pageframe.mako"/>
<%!
    from pylons import tmpl_context as c
    from pyroscope.web.lib import helpers as h

    echo = lambda url: h.echo(url, ("refresh", "filter"))

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
        <a href="${h.url_for(action='list', id=view.action)|echo}">
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
    <div class="filter">
        <form method="GET" action="${'' | h.echo}">
            <input type="image" src="/img/png/16/filter.png" width="16" height="16"
                 title="Enter filter glob pattern; syntax: * ? [seq] [!seq]" />
            <input type="text" id="search" name="filter" 
                 onfocus="if (this.value == 'Filter...') this.value='';" 
                 onblur="if (this.value == '') this.value='Filter...';" 
                 value="${c.filter or 'Filter...'}" size="25" autocomplete="off" />
% if c.filter:
            <a href="?">
                <img src="/img/png/16/filter-off.png" width="16" height="16" title="Clear filter" />
            </a>
% endif
        </form>
    </div>
    <h3>
        ${len(c.torrents)} ${c.view.title} Torrent(s)
        ${'[filtered by "%s" out of %d]' % (c.filter, c.torrents_unfiltered) if c.filter else ''}
    </h3>
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
    <tr class="header">
        <th>${"torrent.16"|h.icon} TORRENT</th>
        <th>${"message.16"|h.icon} MESSAGE</th>
        <th>${"tracker"|h.icon} TRACKER</th>
    </tr>
% for idx, item in enumerate(c.messages):
    <tr class="${'odd' if idx&1 else 'even'}">
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

