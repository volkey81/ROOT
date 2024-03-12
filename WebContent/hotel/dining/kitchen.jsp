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
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("다이닝"));
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
$(function() {
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
		<div class="diningSlideWrap slideTypeB animated fadeInUp delay04">
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea">
				<div class="diningSlide">
					<img src="/images/hotel/dining/kitchenSlide05.jpg" alt="">
				</div>
				<div class="diningSlide">
					<img src="/images/hotel/dining/kitchenSlide01.jpg" alt="">
				</div>
				<div class="diningSlide">
					<img src="/images/hotel/dining/kitchenSlide02.jpg" alt="">
				</div>
			</div>
			<div class="slideAreaNav">
				<div class="thum"><img src="/images/hotel/dining/kitchenSlide05.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/dining/kitchenSlide01.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/dining/kitchenSlide02.jpg" alt=""></div>
			</div>
			<div class="topTxt">
				<p class="contTit">
					<span class="tit">상하키친</span>상하농원의 신선한 식재와 정통 이탈리안 레스토랑<br>‘더 키친 일 뽀르노’의 레시피로 탄생한 나폴리 피자 & 파스타를 만나보세요.
				</p>
			</div>
		</div>
		<!-- //diningSlide -->
		
		<div class="restaurantCont">
			<h2>INFORMATION</h2>
			<dl>
				<dt>이용시간</dt>
				<dd>월요일 11:00 ~ 21:00ㅣ화요일 ~ 일요일 11:00 ~ 18:00</dd>
				<dt>총 좌석 수</dt>
				<dd>실내 98석 ｜ 실외 24석</dd>
				<dt>예약 및 문의</dt>
				<dd>1522-3698 [연중 09:30 ~ 18:00]</dd>
			</dl>
			<ul class="caution">
				<li>단체 예약은 최소 1주일 전 유선으로 문의 바랍니다.</li>
				<li>돌잔치 등 연회 단체 예약 접수는 2개월 전 문의 바랍니다.</li>
				<li>상하키친 LAST ORDER는 월요일 20:30, 화~일 17:30까지이며, 포장 주문은 LAST ORDER 시간까지 결제가 완료 되어야합니다.</li>
			</ul>
			<p class="thumb"><img src="/images/hotel/dining/kitchen01_3.jpg" alt=""></p>
			<div class="btnArea">
				<a href="/images/brand/food/sanghaKitchen.pdf" target="_blank" class="btnStyle03 sizeL">메뉴보기</a>
				<a href="/customer/hotelCounsel.jsp" class="btnStyle01 sizeL">문의하기</a>
			</div>
		</div><!-- //restaurantCont -->
			
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
