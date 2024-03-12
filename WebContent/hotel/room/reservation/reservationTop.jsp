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
<div class="reservationTop">
	<p class="topTxt">파머스빌리지에서 청정한 자연 속<br> 소박한 휴식을 누리세요</p>
	<div class="reservationTab">
		<ul>
			<li<%if(Depth_1 == 5 && Depth_2 == 2 && Depth_3 == 4 && Depth_4 == 1){ %> class="on"<%} %>>01. 날짜 선택</li>
			<li<%if(Depth_1 == 5 && Depth_2 == 2 && Depth_3 == 4 && Depth_4 == 2){ %> class="on"<%} %>>02. 객실 선택</li>
			<li<%if(Depth_1 == 5 && Depth_2 == 2 && Depth_3 == 4 && Depth_4 == 3){ %> class="on"<%} %>>03. 고객정보 입력</li>
			<li<%if(Depth_1 == 5 && Depth_2 == 2 && Depth_3 == 4 && Depth_4 == 4){ %> class="on"<%} %>>04. 결제하기</li>
		</ul>
	</div>
</div>
			
