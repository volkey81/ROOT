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
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("웨딩&amp;이벤트"));
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
	var allLength = $(".slideArea .weddingSlide").length;
	$('.slideNum .allNum').html("0"+allLength);
	$('.weddingSlideWrap .slideArea').on('afterChange', function(event, slick, currentSlide){   
		$('.slideNum .nowNum').html("0"+ (currentSlide + 1));
	});
	
	//terrace room
	$('.weddingSlideWrap .slideArea').slick({
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
		asNavFor: '.weddingSlideWrap .slideArea',
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
		<jsp:include page="/hotel/wedding/weddingTab.jsp" />
		<!-- diningSlide -->
		<div class="weddingSlideWrap animated fadeInUp delay04">
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea">
				<div class="weddingSlide">
					<img src="/images/hotel/wedding/seminarSlide01_1.jpg" alt="">
				</div>
				<div class="weddingSlide">
					<img src="/images/hotel/wedding/seminarSlide02.jpg" alt="">
				</div>
				<div class="weddingSlide">
					<img src="/images/hotel/wedding/seminarSlide03_1.jpg" alt="">
				</div>
			</div>
			<div class="slideAreaNav">
				<div class="thum"><img src="/images/hotel/wedding/seminarSlide01.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/wedding/seminarSlide02.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/wedding/seminarSlide03.jpg" alt=""></div>
			</div>
			<div class="topTxt">
				<span class="sTxt">VILLAGE, 1F</span>
				<p class="contTit">
					답답한 도심을 벗어나 자연속에서 편안한 세미나를<br>진행할 수 있도록 정성을 다해 준비하겠습니다 
				</p>
			</div>
		</div>
		<!-- //diningSlide -->
		
		<div class="section section01">
			<div class="thumArea">
				<div class="thum move1" ><img src="/images/hotel/wedding/seminar01.jpg" alt=""></div>
			</div>
			<div class="titMove seminar">
				<img src="/images/hotel/wedding/seminar01Tit.png" alt="SEMINAR">
				<div>
					<h2>세미나</h2>
					<p>행사 규모에 따라 변화 가능한 구조로<br>빔 프로젝터, 스피커 등 중요한 모임에 필요시설을 갖추었습니다.</p>
					<div class="info">
						<p><span>장소</span>1층 강당</p>
						<p><span>수용인원</span>최대 150명<img src="/images/hotel/wedding/seminar.png" alt=""></p>
					</div>
				</div>		
			</div>
		</div>
			
		<div class="section section02">
			<div class="thumArea">
				<div class="thum move2" ><img src="/images/hotel/wedding/seminar02.jpg" alt=""></div>
			</div>
			<div class="titMove seminar">
				<img src="/images/hotel/wedding/seminar02Tit.png" alt="GROUP EVENT">
				<div>
					<h2>단체행사 (파머스테이블)</h2>
					<p>탁 트인 통창을 통해 들어오는 채광과 함께, 컨퍼런스, 소규모 공연,<br>단체행사를 연회와 함께 진행가능하며,  연단, 빔프로젝터, 스피커 등의<br>부대시설을 사용하여 중요한 행사를 더욱 빛나게 준비해 드립니다.</p>
					<div class="info">
						<p><span>장소</span>파머스테이블</p>
						<p><span>수용인원</span>최대 250명</p>
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
