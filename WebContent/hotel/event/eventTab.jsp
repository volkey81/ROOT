<%@page import="com.sanghafarm.service.board.*"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*" %>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
%>

<div class="subTab">
	<ul>
		<li<%if(Depth_1 == 5 && Depth_2 == 4 && Depth_3 == 1){ %> class="on"<%} %>><a href="/hotel/dining/breakfast.jsp">웨딩&amp;연회</a></li>
		<li<%if(Depth_1 == 5 && Depth_2 == 4 && Depth_3 == 2){ %> class="on"<%} %>><a href="/hotel/dining/lounge.jsp">세미나</a></li>
	</ul>
</div>
		