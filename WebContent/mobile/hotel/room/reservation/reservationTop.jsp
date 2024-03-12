<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.board.*" %>
<%
int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
int	Depth_4	=	(Integer)request.getAttribute("Depth_4") == null ? 0 : (Integer)request.getAttribute("Depth_4");
	
%>

<div class="reservationTab animated fadeInUp delay04">
	<ul>
		<li<%if(Depth_1 == 5 && Depth_2 == 2 && Depth_3 == 4 && Depth_4 == 1){ %> class="on"<%} %>>날짜 선택</li>
		<li<%if(Depth_1 == 5 && Depth_2 == 2 && Depth_3 == 4 && Depth_4 == 2){ %> class="on"<%} %>>객실 선택</li>
		<li<%if(Depth_1 == 5 && Depth_2 == 2 && Depth_3 == 4 && Depth_4 == 3){ %> class="on"<%} %>>고객정보</li>
		<li<%if(Depth_1 == 5 && Depth_2 == 2 && Depth_3 == 4 && Depth_4 == 4){ %> class="on"<%} %>>결제하기</li>
	</ul>
</div>
