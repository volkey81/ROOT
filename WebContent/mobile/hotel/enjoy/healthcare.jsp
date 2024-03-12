<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(5));
	request.setAttribute("MENU_TITLE", new String("피트니스존"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="styleA experience btnFix">
		<!-- 내용영역 -->
		<!-- slideWrap -->
		<div class="slideWrap animated fadeInUp delay02">
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea">
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/healthcareSlide01.jpg" alt="피트니스존1">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/healthcareSlide02.jpg" alt="피트니스존2">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/healthcareSlide03.jpg" alt="피트니스존3">
				</div>
			</div>
		</div>
		<!-- //slideWrap -->
		
		<div class="hotelContTop animated fadeInUp delay04">
			<span class="sTxt">Fitness Zone</span>
			<h2>피트니스존<span>상하의 건강한 식단과 더불어 누리는 운동 밸런스.<br></span></h2><br>
			
				<span>
					신체측정(Inbody), 근력운동(근력기구), 맨손운동(GX room)을 통해
					일상의 지친 몸과 마음에 건강한 영양&운동 밸런스를 선사합니다.<br><br><br>
					운영일자 : 2020년 9월 11일(금) ~<br> 
					운영시간 : 06시~23시
				</span>
		</div>
			
		<div class="hotelCont animated fadeInUp delay06">
			<h3>주의사항</h3>
			<ul class="caption">
				<li>음주 후 운동을 삼가하여 주시기 바랍니다.</li>
				<li>음식물 반입을 삼가하여 주시기 바랍니다.</li>
				<li>다른 이용자와 함께 이용하는 운동공간이므로, 타 이용자에게 불쾌감을 유발하는 행동을 자제해 주시기 바랍니다.</li>
				<li>사전 예약제로 운영되며, 사전 예약을 하지 않은 방문객은 입장이 제한될 수 있으므로, 안내 데스크에 문의해 주시기 바랍니다.</li>
				<li>운동기구를 본래의 용법에 따라 본인의 운동능력을 고려하여 사용하고, 이상 증상을 인지한 경우 즉시 이용을 중단하시기 바랍니다.</li>
				<li>피트니스존은 충분한 운동능력을 보유한 건강한 성인을 대상으로 운영하는 공간입니다. 따라서 건강에 이상이 있거나 만 19세 미만의 미성년자, 노약자의 입장 및 시설이용은 금지되며, 금지사항 위반 시 발생하는 사고 등에 대하여는 이용자 본인 및 보호자에게 책임이 있습니다.</li>
				<li>이용자의 부주의로 인하여 피트니스존 이용 과정 중 발생한 일체의 사고에 대한 책임은 본인에게 있으므로, 피트니스존 및 운동기구 사용법을 반드시 숙지하여 이용해 주시기 바랍니다.</li>
				<li>운동 중 불편사항 또는 피트니스존 이용 관련 궁금한 사항은 안내 데스크에 문의해 주시기 바랍니다.</li>
			</ul>
		</div>
		<!--
		<div class="btnArea">
			<a href="/mobile/brand/play/experience/list.jsp" class="btnStyle04">자세히보기</a><a href="/mobile/brand/play/reservation/admission.jsp" class="btnStyle05">예약하기</a>
		</div>
		-->
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					