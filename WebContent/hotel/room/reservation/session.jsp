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
	
	Param param = (Param) session.getAttribute("HOTEL_ROOM_FORM");
	String device = (String) session.getAttribute("HOTEL_ROOM_DEVICE");
	
 	session.removeAttribute("HOTEL_ROOM_FORM");
 	session.removeAttribute("HOTEL_ROOM_DEVICE");

 	if(param == null || StringUtils.isEmpty(param.get("chki_date"))) {
		response.sendRedirect("/");
		return;
	}
%>
	<form name="orderForm" id="orderForm" method="post" action="<%= "P".equals(device) ? "info.jsp" : "/mobile/hotel/room/reservaion/info.jsp" %>">
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
		document.orderForm.submit();
	</script>