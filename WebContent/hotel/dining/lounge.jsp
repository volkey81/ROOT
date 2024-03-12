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
	request.setAttribute("Depth_3", new Integer(2));
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
	
	//웰컴라운지
	$('.diningSlideWrap .slideArea').slick({
		slidesToShow: 1,
		slidesToScroll: 1,
		autoplay: true,
		dots: false,
		fade: false,
		arrows: true,
		pauseOnHover:false,
		asNavFor: '.slideAreaNav',	
		cssEase : 'cubic-bezier(0.74, 0.01, 0.21, 0.99)'
	});
	$('.slideAreaNav').slick({
		slidesToShow: 1,
		slidesToScroll: 1,
		asNavFor: '.diningSlideWrap .slideArea',
		dots: false,
		centerMode: false,
		focusOnSelect: false,
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
					<img src="/images/hotel/dining/loungeSlide01.jpg" alt="">
				</div>
				<div class="diningSlide">
					<img src="/images/hotel/dining/loungeSlide02.jpg" alt="">
				</div>
				<div class="diningSlide">
					<img src="/images/hotel/dining/loungeSlide03.jpg" alt="">
				</div>
			</div>
			<div class="slideAreaNav">
				<div class="thum"><img src="/images/hotel/dining/loungeSlide01.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/dining/loungeSlide02.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/dining/loungeSlide03.jpg" alt=""></div>
			</div>
			<div class="topTxt">
				<span class="sTxt">VILLAGE, 1F</span>
				<p class="contTit">
					상하농원 제품을 구매할 수 있고<br>폴바셋 커피와 디저트류를 즐길 수 있습니다			
				</p>
			</div>
		</div>
		<!-- //diningSlide -->
		
		<div class="section section01">
			<div class="thumArea">
				<div class="thum move1" ><img src="/images/hotel/dining/lounge01.jpg" alt=""></div>
			</div>
			<div class="titMove lounge">
				<img src="/images/hotel/dining/lounge01Tit.png" alt="WELCOME LOUNGE CAFE">
				<div>
					<h2>웰컴라운지 카페</h2>
					<p>신선한 목장의 우유,<br>엄선된 원두의 커피를 즐길 수 있습니다.</p>
					<div class="info">
						<p><span>연중무휴</span>9:30~21:00</p>
						<p><span>제공메뉴</span>아메리카노 (4,700원), 카페라떼 (5,300원)<br>케이크, 러스크, 식빵 등 베이커리류<br>상하농원 반숙란</p>
					</div>
				</div>		
			</div>
		</div>
			
		<div class="section section02">
			<div class="thumArea">
				<div class="thum move2" ><img src="/images/hotel/dining/lounge02.jpg" alt=""></div>
			</div>
			<div class="titMove lounge">
				<img src="/images/hotel/dining/lounge02Tit.png" alt="FARMERS MARKET POPUPSTORE">
				<div>
					<h2>파머스마켓 팝업스토어</h2>
					<p>파머스마켓 일부 상품을 웰컴라운지에서 만나보실 수 있습니다.</p>
					<div class="info">
						<p><span>연중무휴</span>9:30~21:00</p>
						<p><span>상품</span>상하농원 MD<br>상하농원 공방 제품 (쨈류, 장류)등</p>
					</div>
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
