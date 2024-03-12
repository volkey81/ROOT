<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("파머스테이블"));
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
	<div id="container" class="hotelCont styleA">
		<!-- 내용영역 -->
		<!-- slideWrap -->
		<div class="slideWrap animated fadeInUp delay02">
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea">
				<div class="slide">
					<img src="/mobile/images/hotel/dining/breakfastSlide01.jpg" alt="">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/dining/breakfastSlide02.jpg" alt="">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/dining/breakfastSlide03.jpg" alt="">
				</div>
			</div>
		</div>
		<!-- //slideWrap -->
		
		<div class="hotelContTop animated fadeInUp delay04">
			<span class="sTxt">VILLAGE, 1F</span>
			<h2>파머스테이블<span>상하에서 자란 식재료를 활용한 <br>건강한 농부의 밥상입니다</span></h2>
		</div>
		<div class="section section01 animated fadeInUp delay06">
			<h3><img src="/mobile/images/hotel/dining/breakfast01Tit.png" alt="BREAKFAST BUFFET"></h3>
			<p class="thumArea"><img src="/mobile/images/hotel/dining/breakfast01.jpg" alt=""></p>
			<div class="txtArea">
				<h4>조식뷔페</h4>
				<p class="sectionTxt">갓 구운 빵, 신선한 목장의 우유, 상하의 제철 채소로 차려진 소박한 아침 식사를 즐길 수 있습니다. </p>
				<div class="info">
					<p><span>연중무휴</span>7:00~9:30</p>
					<p><span>요금</span>대인 18,000원, <br>소인(36개월 ~ 만 12세) 13,500원</p>
				</div>
				<ul>
					<li>조식뷔페 별도 이용시 입장권을 증정합니다.</li>
					<li>체크인 시 확인된 입실인원에 대하여 조식뷔페를 제공합니다.</li>
					<li>09:00시 입장이 마감됩니다.</li>
				</ul>
			</div>
			<p class="btn">
				<a href="/files/hotel/dining-menu01.pdf?target=web" target="_blank">메뉴보기 &gt;</a>
				<a href="/mobile/brand/play/reservation/admission.jsp" class="btn2">예약하기 &gt;</a>
			</p>
		</div>
		<div class="section section02 animated fadeInUp delay08">
			<h3><img src="/mobile/images/hotel/dining/breakfast02Tit.png" alt="EVENT BANQUET WEDDING"></h3>
			<p class="thumArea"><img src="/mobile/images/hotel/dining/breakfast02.jpg" alt=""></p>
			<div class="txtArea">
				<h4>단체행사/연회/웨딩</h4>
				<p class="sectionTxt">행사 목적과 규모에 맞는 메뉴를 정성스럽고 맛있게 제공해드립니다.</p>
				<div class="info">
					<p><span>제공 메뉴</span>한식, 양식, 뷔페, 고객요청 식단 가능</p>
				</div>
				<ul>
					<li>인원 수에 따라 요청된 메뉴는 변경될 수 있으며, 상담 시 사전안내 드립니다.</li>
				</ul>
			</div>
			<p class="btn"><a href="/files/hotel/dining-menu02.pdf?target=web" target="_blank">메뉴보기 &gt;</a></p>
		</div>
		
		<!-- inquiryBtn -->
		<jsp:include page="/mobile/hotel/dining/inquiryBtn.jsp" />
		<!-- inquiryBtn -->
		
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					