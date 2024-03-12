<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.sanghafarm.common.*,
			com.efusioni.stone.utils.*,
			org.apache.commons.lang.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		response.sendRedirect("/");
		return;
	}
	
	Param param = (Param) session.getAttribute("HOTEL_OFFER_FORM");
	String device = (String) session.getAttribute("HOTEL_OFFER_DEVICE");
	
 	session.removeAttribute("HOTEL_OFFER_FORM");
 	session.removeAttribute("HOTEL_OFFER_DEVICE");

 	if(param == null || StringUtils.isEmpty(param.get("pid"))) {
		response.sendRedirect("/");
		return;
	}
%>
	<form name="reserveForm" id="reserveForm" method="post" action="<%= "P".equals(device) ? "info.jsp" : "/mobile/hotel/offer/info.jsp" %>">
<%	
	Set set = param.keySet();
	for(Iterator it = set.iterator(); it.hasNext(); ) {
		String key = (String) it.next();
%>
		<input type="hidden" name="<%= key %>" value="<%= param.get(key) %>">
<%
	}
%>
	</form>

	<script>
		document.reserveForm.submit();
	</script>