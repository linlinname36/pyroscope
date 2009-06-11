<%inherit file="/common/pageframe.mako"/>
<%!
    from pprint import pformat
    from pyroscope.web.lib import helpers as h
    page_title = "Laboratory"
%>
<h1>PyroScope Labs</h1>

<div><em>Testing area, enter at your own risk!</em></div>

<h2>Globals</h2>
<dl>
% for k in dir(g):
  % if not k.startswith('_'):
    ##.replace('\n', "<br />")
    <dt>${k}</dt>
    <dd><code>${getattr(h, k, "N/A")|n}</code></dd>
  % endif
% endfor
</dl>


<h2>Helpers</h2>
<dl>
% for k in dir(h):
  %if not k.startswith('_'):
    <dt>${k}</dt><dd><code>${getattr(h, k).__doc__.replace('\n', "<br />")|n}</code></dd>
  % endif
% endfor
</dl>

