<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.common.*,
			com.efusioni.stone.utils.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);

	if("A".equals(fs.getDeviceType())) {
		response.sendRedirect("/mobile/main.jsp?" + request.getQueryString());
	} else {
		String landing = SanghafarmUtils.getCookie(request, "LANDING_PAGE", "BRAND");
		
		if("BRAND".equals(landing)) {
			response.sendRedirect("/mobile/brand/?" + request.getQueryString());
		} else if("HOTEL".equals(landing)) {
			response.sendRedirect("/mobile/hotel/?" + request.getQueryString());
		} else {
			response.sendRedirect("/mobile/main.jsp?" + request.getQueryString());
		}
	}
%>
