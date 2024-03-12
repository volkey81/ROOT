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
	int	Depth_4	=	(Integer)request.getAttribute("Depth_4") == null ? 0 : (Integer)request.getAttribute("Depth_4");

%>
<!--<div class="subTab animated fadeInUp delay02">-->
<div class="subTab">
	<ul>
		<li<%if(Depth_1 == 5 && Depth_2 == 5 && Depth_3 == 7){ %> class="on"<%} %>><a href="/hotel/enjoy/farm.jsp">상하농원</a></li>
		<%--<li<%if(Depth_1 == 5 && Depth_2 == 5 && Depth_3 == 3){ %> class="on"<%} %>><a href="/hotel/enjoy/experience.jsp">시즌체험</a></li>--%>
		<li<%if(Depth_1 == 5 && Depth_2 == 5 && Depth_3 == 6){ %> class="on"<%} %>><a href="/hotel/enjoy/spa.jsp">노천스파</a></li>
		<li<%if(Depth_1 == 5 && Depth_2 == 5 && Depth_3 == 1){ %> class="on"<%} %>><a href="/hotel/enjoy/pool.jsp">수영장</a></li>
		<li<%if(Depth_1 == 5 && Depth_2 == 5 && Depth_3 == 5){ %> class="on"<%} %>><a href="/hotel/enjoy/healthcare.jsp">셀렉스헬스케어</a></li>
		<li<%if(Depth_1 == 5 && Depth_2 == 5 && Depth_3 == 4){ %> class="on"<%} %>><a href="/hotel/enjoy/campaign.jsp">에코기부참여</a></li>
	</ul>
</div>
		