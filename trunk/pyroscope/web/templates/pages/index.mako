<%inherit file="/common/pageframe.mako"/>
<%!
    from pyroscope.web.lib import helpers as h
    page_title = "Main Index"
%>
<h1>Welcome to PyroScope!</h1>

For the moment, the 1st rule is <em>functionality over eye candy</em>, 
so expect the latter after there's actually some data to please the eye.

<h2>Sandbox</h2>
${"info_red"|h.icon}
${"refresh"|h.icon}

