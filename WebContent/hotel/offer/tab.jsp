<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
%>

<div class="subTab animated fadeInUp delay02">
	<ul>
		<li<%if(Depth_1 == 5 && Depth_2 == 6 && Depth_3 == 1){ %> class="on"<%} %>><a href="/hotel/offer/list.jsp">Weekly특가</a></li>
		<li<%if(Depth_1 == 5 && Depth_2 == 6 && Depth_3 == 2){ %> class="on"<%} %>><a href="/hotel/offer/list.jsp?gubun=P">패키지</a></li>
		<li<%if(Depth_1 == 5 && Depth_2 == 6 && Depth_3 == 3){ %> class="on"<%} %>><a href="/hotel/village/promotion/list.jsp">프로모션</a></li>
	</ul>
</div>
		