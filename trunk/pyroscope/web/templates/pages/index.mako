<%inherit file="/common/pageframe.mako"/>
<%!
    from pprint import pformat
    from pyroscope.web.lib import helpers as h
    page_title = "Main Index"
%>
<h1>Welcome to PyroScope</h1>

For the moment, the 1st rule is <em>functionality over eye candy</em>, 
so expect the latter after there's actually some data to please the eye.

<h1>Sandbox</h1>
${"info_red"|h.icon}
${"refresh"|h.icon}

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

