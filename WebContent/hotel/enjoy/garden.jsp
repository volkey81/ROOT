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
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("즐길거리"));
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
$(function() {
	//슬라이드 갯수	
	var allLength = $(".slideArea .enjoySlide").length;
	$('.slideNum .allNum').html("0"+allLength);
	$('.enjoySlideWrap .slideArea').on('afterChange', function(event, slick, currentSlide){   
		$('.slideNum .nowNum').html("0"+ (currentSlide + 1));
	});
	
	//terrace room
	$('.enjoySlideWrap .slideArea').slick({
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
		asNavFor: '.enjoySlideWrap .slideArea',
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
	<div id="container" class="hotel hotelSlide enjoy">
		<!-- 내용영역 -->		
		<jsp:include page="/hotel/enjoy/enjoyTab.jsp" />
		<!-- diningSlide -->
		<div class="enjoySlideWrap animated fadeInUp delay04">
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea">
				<div class="enjoySlide">
					<img src="/images/hotel/enjoy/gardenSlide01.jpg" alt="">
				</div>
				<div class="enjoySlide">
					<img src="/images/hotel/enjoy/gardenSlide02.jpg" alt="">
				</div>
				<div class="enjoySlide">
					<img src="/images/hotel/enjoy/gardenSlide03.jpg" alt="">
				</div>
				<div class="enjoySlide">
					<img src="/images/hotel/enjoy/gardenSlide04.jpg" alt="">
				</div>
			</div>
			<div class="slideAreaNav">
				<div class="thum"><img src="/images/hotel/enjoy/gardenSlide01.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/enjoy/gardenSlide02.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/enjoy/gardenSlide03.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/enjoy/gardenSlide04.jpg" alt=""></div>
			</div>
			<div class="topTxt">
				<span class="sTxt">VILLAGE, 3F</span>
				<p class="contTit">
					중앙정원은 따뜻한 다음 봄을 기다리며 <br>준비하고 있습니다.
				</p>
			</div>
		</div>
		<!-- //diningSlide -->
		
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
