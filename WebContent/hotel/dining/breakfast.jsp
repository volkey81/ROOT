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
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("다이닝"));
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
$(function() {
	scrollVMoveNew(".section01", ".move1", 5, 200, 0);
	scrollVMoveNew(".section02", ".move2", 5, 200, 0);
	//슬라이드 갯수	
	var allLength = $(".slideArea .diningSlide").length;
	$('.slideNum .allNum').html("0"+allLength);
	$('.diningSlideWrap .slideArea').on('afterChange', function(event, slick, currentSlide){   
		$('.slideNum .nowNum').html("0"+ (currentSlide + 1));
	});
	
	//terrace room
	$('.diningSlideWrap .slideArea').slick({
		slidesToShow: 1,
		slidesToScroll: 1,
		autoplay: true,
		dots: false,
		fade: false,
		arrows: true,
		pauseOnHover:false,
		initialSlide: 0,
		asNavFor: '.slideAreaNav',
		accessibility : false,
		cssEase : 'cubic-bezier(0.74, 0.01, 0.21, 0.99)'
	});
	$('.slideAreaNav').slick({
		slidesToShow: 1,
		slidesToScroll: 1,
		dots: false,
		centerMode: false,
		focusOnSelect: false,
		swipe: false,
		initialSlide: 0,
		cssEase : 'cubic-bezier(0.74, 0.01, 0.21, 0.99)'
	});
});	
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel hotelSlide">
		<!-- 내용영역 -->		
		<jsp:include page="/hotel/dining/diningTab.jsp" />
		<!-- diningSlide -->
		<div class="diningSlideWrap animated fadeInUp delay04">
			
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea">
				<div class="diningSlide">
					<img src="/images/hotel/dining/breakfastSlide01.jpg" alt="">
				</div>
				<div class="diningSlide">
					<img src="/images/hotel/dining/breakfastSlide02.jpg" alt="">
				</div>
				<div class="diningSlide">
					<img src="/images/hotel/dining/breakfastSlide03.jpg" alt="">
				</div>
			</div>
			<div class="slideAreaNav">
				<div class="thum"><img src="/images/hotel/dining/breakfastSlide01.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/dining/breakfastSlide02.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/dining/breakfastSlide03.jpg" alt=""></div>
			</div>
			<div class="topTxt">
				<span class="sTxt">VILLAGE, 1F</span>
				<p class="contTit">
					상하에서 자란 식재료를 활용한 <br>건강한 농부의 밥상입니다			
				</p>
			</div>
		</div>
		<!-- //diningSlide -->
		
		<div class="section section01">
			<div class="thumArea">
				<div class="thum move1" ><img src="/images/hotel/dining/breakfast01.jpg" alt=""></div>
			</div>
			<div class="titMove">
				<img src="/images/hotel/dining/breakfast01Tit.png" alt="BREAKFAST BUFFET">
				<div>
					<h2>조식뷔페</h2>
					<p>갓 구운 빵, 신선한 목장의 우유, 상하의 제철 채소로 차려진 <br>소박한 아침 식사를 즐길 수 있습니다. </p>
					<div class="info">
						<p><span>연중무휴</span>7:00~9:30</p>
						<p><span>요금</span>대인 18,000원, 소인(36개월 ~ 만 12세) 13,500원</p>
					</div>
					<ul>
						<li>- 조식뷔페 별도 이용시 입장권을 증정합니다.</li>
						<li>- 체크인 시 확인된 입실인원에 대하여 조식뷔페를 제공합니다.</li>
						<li>- 09:00시 입장이 마감됩니다.</li>
					</ul>
					<a  href="/files/hotel/breakfast-menu.pdf" target="_blank" class="btnStyle02">메뉴보기 ></a>
					<a  href="/brand/play/reservation/admission.jsp" class="btnStyle03">예약하기 ></a>
				</div>		
			</div>
		</div>
					
		<div class="section section02">
			<div class="thumArea">
				<div class="thum move2" ><img src="/images/hotel/dining/breakfast02.jpg" alt=""></div>
			</div>
			<div class="titMove">
				<img src="/images/hotel/dining/breakfast02Tit.png" alt="EVENT BANQUET WEDDING">
				<div>
					<h2>단체행사/연회/웨딩</h2>
					<p>행사 목적과 규모에 맞는 메뉴를 정성스럽고 맛있게 제공해드립니다. </p>
					<div class="info">
						<p><span>제공 메뉴</span>한식, 양식, 뷔페, 고객요청 식단 가능</p>
					</div>
					<ul>
						<li>- 인원 수에 따라 요청된 메뉴는 변경될 수 있으며, 상담 시 사전안내 드립니다.</li>
					</ul>
					<a  href="/files/hotel/dining-menu02.pdf" target="_blank" class="btnStyle02">메뉴보기 ></a>
				</div>		
			</div>
		</div>
		<div class="btnArea">
			<a href="/customer/hotelCounsel.jsp" class="btnStyle01 sizeL">문의하기</a>
		</div>
			
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
