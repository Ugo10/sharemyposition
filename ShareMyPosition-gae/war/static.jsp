<%@page import="net.sylvek.sharemyposition.server.UpdatePositionServletImpl.Cache"%>
<%@page import="com.google.appengine.api.memcache.MemcacheService"%>
<%@page import="java.util.logging.Level"%>
<%@page import="com.google.appengine.api.memcache.ErrorHandlers"%>
<%@page import="com.google.appengine.api.memcache.MemcacheServiceFactory"%>
<%@page import="net.sylvek.sharemyposition.server.UpdatePositionServletImpl"%>
<%@page import="java.lang.Boolean"%>
<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
<meta name="apple-mobile-web-app-capable" content="no" />
<link rel="icon" type="image/png" href="icon.png" />
<link rel="apple-touch-icon" href="icon.png" />
<link rel="shortcut icon" href="icon.png">
<link type="text/css" rel="stylesheet" href="client.css">
<title>my position (static)</title>
<%
    String pos = request.getParameter(UpdatePositionServletImpl.PARAMETER_POSITION);
	final String isTracked = request.getParameter(UpdatePositionServletImpl.PARAMETER_TRACKED);
	final String uuid = request.getParameter(UpdatePositionServletImpl.PARAMETER_UUID);
	long lastTime = -1L;
	String unit = "seconds";
	
	if(Boolean.parseBoolean(isTracked)) {
	    final MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
	    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
	    final Cache cache = Cache.from(syncCache.get(uuid));
	    if(cache.position != null) {
	        pos = cache.position;
	        lastTime = (System.currentTimeMillis() - cache.uptime) / 1000L;
	        if (lastTime > 60) {
	            lastTime = lastTime / 60;
	            unit = "minutes";
	        }
	    }
	}
%>
<% if (Boolean.parseBoolean(isTracked)) { 
    // redirect to dynamic page
	response.sendRedirect("dynamic.jsp?uuid=" + uuid + "&pos=" + pos);
%>
	<meta http-equiv="refresh" content="10;URL=/static.jsp?pos=<%=pos%>&tracked=true&uuid=<%=uuid%>">
<% } %>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-46087713-3', 'smp-next.appspot.com');
  ga('require', 'linkid', 'linkid.js');
  ga('send', 'pageview');

</script>
</head>
<body onload="window.scrollTo(0, 1)">
<script type="text/javascript"><!--
google_ad_client = "ca-pub-7256263753683362";
/* ma position */
google_ad_slot = "6102448287";
google_ad_width = 320;
google_ad_height = 50;
//-->
</script>
<script type="text/javascript" src="//pagead2.googlesyndication.com/pagead/show_ads.js"></script>
<div class="title"><span>My position</span><br />
<button onclick="window.location='index.html'" class="button">click here to share your own position</button>
<br />
<img src="http://staticmap.openstreetmap.de/staticmap.php?center=<%=pos%>&zoom=15&size=320x240&markers=<%=pos%>,ol-marker-blue" alt="i am here" />
<br />	
<a href="http://www.openstreetmap.org/?mlat=<%=pos.substring(0, pos.indexOf(",")) %>&mlon=<%=pos.substring(pos.indexOf(",") + 1) %>#map=15/<%=pos.replace(",", "/")%>">click here to open OpenStreetMap</a>
<% if (Boolean.parseBoolean(isTracked) && lastTime > 0) { %>
	<br />refresh every 10 seconds<br />(last update from <%=lastTime %> <%=unit %>)
<% } %>
</div>
</body>
</html>

