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
		<li<%if(Depth_1 == 5 && Depth_2 == 2 && Depth_3 == 1){ %> class="on"<%} %>><a href="/hotel/room/index.jsp">전체보기</a></li>
		<li<%if(Depth_1 == 5 && Depth_2 == 2 && Depth_3 == 2){ %> class="on"<%} %>><a href="/hotel/room/suite.jsp">파머스빌리지</a></li>
		<li<%if(Depth_1 == 5 && Depth_2 == 2 && Depth_3 == 3){ %> class="on"<%} %>><a href="/hotel/room/glamping.jsp">파머스글램핑</a></li>
		<li<%if(Depth_1 == 5 && Depth_2 == 2 && Depth_3 == 4){ %> class="on"<%} %>><a href="/hotel/room/reservation/date.jsp">예약하기</a></li>
	</ul>
</div>
		