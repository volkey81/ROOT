<%@page import="com.sanghafarm.service.board.*"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*" %>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%
	// 진입페이지 쿠키
	SanghafarmUtils.setCookie(response, "LANDING_PAGE", "BRAND", ".sanghafarm.co.kr", 60*60*24*100);
%>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("빌리지 소개"));
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel village introductionWrap">
		<!-- 내용영역 -->		
		<jsp:include page="/hotel/village/villageTab.jsp" />
		<div class="introduction">
			<div class="txtArea">
				<img src="/images/hotel/village/introductionTit.png" alt="농원에서 온 편지" class="animated fadeInUp delay02">
				<div class="txtWrap">
					<p class="animated fadeInUp delay04">안녕하세요. 자연의 건강함을 전하는 상하농원입니다.</p>
					<p class="animated fadeInUp delay06">우리 아이들에게 농촌의 가치와 먹거리에 대한 소중함을 알려주고자 <br>
					했던 저희는 농원을 찾아주시는 많은 손님들이 편히 쉬어가실 수 <br>
					있도록 자연에서 얻은 나무와 돌로 농원의 큰 헛간을 개조하여<br>
					작은 텃밭과 테라스가 있는 소박하지만 따뜻한 공간을 만들었습니다.</p>
					<p class="animated fadeInUp delay08">좋은 사람들과 자연속에서 즐기는 건강한 한 끼 식사, <br>
					밤하늘의 별을 볼 수 있는 작은 창이 있는 방.<br>
					푸르른 대지와 농촌의 풍경을 담아 잊지 못할 결혼식을 할 수 있는<br>
					상하농원 농부들의 정성과 손길이 닿은 파머스빌리지에서 <br>
					청정한 자연 속의 팜스테이를 즐겨보세요.</p>
					<p class="animated fadeInUp delay10">바쁘고 지친 일상에서 벗어나 자연을 누릴 수 있는<br>
					파머스빌리지로 여러분을 초대합니다.</p>
				</div>
			</div>
		</div>
		
		
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
