<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.sanghafarm.common.*,
			com.efusioni.stone.utils.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
			
	session.setAttribute("HOTEL_ROOM_FORM", param);
	session.setAttribute("HOTEL_ROOM_DEVICE", "P");
	String url = "/mobile/member/login.jsp?type=web";
	
	response.sendRedirect(url);
%>
