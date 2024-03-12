<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	int	Depth_4	=	(Integer)request.getAttribute("Depth_4") == null ? 0 : (Integer)request.getAttribute("Depth_4");
%>
<ul class="reserTab">
	<li<%if(Depth_4 == 1){ %> class="on"<%} %>><a href="/brand/play/reservation/admission.jsp">개인 예약<br><span>(20인 미만)</span></a></li>
	<%-- <li<%if(Depth_4 == 2){ %> class="on"<%} %>><a href="/brand/play/reservation/experience.jsp">식음</a></li> --%>
	<li<%if(Depth_4 == 2){ %> class="on"<%} %>><a href="/customer/counsel.jsp?cate=011">식당 예약</a></li>
	<li<%if(Depth_4 == 3){ %> class="on"<%} %>><a href="/brand/play/reservation/group.jsp">단체 예약<br><span>(20인 이상)</span></a></li>
</ul>