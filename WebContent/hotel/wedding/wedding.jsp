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
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("웨딩&amp;이벤트"));

	PopupService popup = (new PopupService()).toProxyInstance();
	List<Param> popupList = popup.getList(new Param("device", "P", "position", "B"));
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
$(function() {
	scrollVMoveNew(".section01", ".move1", 5, 200, 0);
	scrollVMoveNew(".section02", ".move2", 5, 200, 0);
	scrollVMoveNew(".section03", ".move3", 5, 200, 0);
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
					<img src="/images/hotel/wedding/weddingSlide01_1.jpg" alt="">
				</div>
				<div class="weddingSlide">
					<img src="/images/hotel/wedding/weddingSlide02.jpg" alt="">
				</div>
				<div class="weddingSlide">
					<img src="/images/hotel/wedding/weddingSlide03.jpg" alt="">
				</div>
			</div>
			<div class="slideAreaNav">
				<div class="thum"><img src="/images/hotel/wedding/weddingSlide01.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/wedding/weddingSlide02.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/wedding/weddingSlide03.jpg" alt=""></div>
			</div>
			<div class="topTxt">
				<span class="sTxt">VILLAGE, 1F</span>
				<p class="contTit">
					새출발을 축복하는 결혼식, 가족의 특별한 모임<br>소중한 순간을 함께 하겠습니다
				</p>
			</div>
		</div>
		<!-- //diningSlide -->
		
		<div class="section section01">
			<div class="thumArea">
				<div class="thum move1" ><img src="/images/hotel/wedding/wedding01.jpg?ver=1" alt=""></div>
			</div>
			<div class="titMove wedding">
				<img src="/images/hotel/wedding/wedding01Tit.png" alt="FARM WEDDING">
				<div>
					<h2>팜웨딩</h2>
					<p>상하의 아름다운 사계절 속<br>네추럴 컨셉의 특별한 결혼식을 선사합니다.</p>
					<div class="info">
						<p><span>장소</span>파머스테이블</p>
						<p><span>수용인원</span>100명~350명</p>
						<p><span>메뉴</span>한식, 양식, 뷔페</p>
					</div>
					<ul>
						<li>- 컨셉과 메뉴는 상담을 통해 확정됩니다.</li>
					</ul>
				</div>		
			</div>
		</div>
			
		<div class="section section02">
			<div class="thumArea">
				<div class="thum move2" ><img src="/images/hotel/wedding/wedding02.jpg" alt=""></div>
			</div>
			<div class="titMove wedding">
				<img src="/images/hotel/wedding/wedding02Tit.png?ver=1" alt="WEDDING PHOTO">
				<div>
					<h2>웨딩포토</h2>
					<p>상하의 따사로움이<br>두 분의 시작에 추억이 될 수 있도록<br>기억을 담아내는 스냅 촬영</p>
					<div class="info">
						<p><span>장소</span>상하농원</p>
					</div>
					<ul>
						<li>상하농원에서 예식을 준비하시는<br>고객분들에게만 주어지는 특별한 혜택</li>
					</ul>
				</div>		
			</div>
		</div>
		
		<div class="section section03">
			<div class="thumArea">
				<div class="thum move3" ><img src="/images/hotel/wedding/wedding03.jpg" alt=""></div>
			</div>
			<div class="titMove wedding">
				<img src="/images/hotel/wedding/wedding03Tit.png" alt="FAMILY EVENT">
				<div>
					<h2>가족행사</h2>
					<p>소중한 아가의 첫 생일, 사랑하는 부모님의 생신, <br>가족의 소중한 순간을 파머스빌리지와 함께 하세요.</p>
					<div class="info">
						<p><span>장소</span>파머스테이블, 중앙정원</p>
						<p><span>수용인원</span>50명~150명</p>
						<p><span>메뉴</span>한식, 양식</p>
					</div>
					<ul>
						<li>- 컨셉과 메뉴는 상담을 통해 확정됩니다.</li>
					</ul>
				</div>		
			</div>
		</div>
		<div class="btnArea">
			<a href="/customer/hotelCounsel.jsp" class="btnStyle01 sizeL">문의하기</a>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" />
	<p class="btnKakao"><a href="http://pf.kakao.com/_GtCKb/chat" target="_blank"><img src="/images/layout/btn_kakaotalk.png?ver=1" alt=""></a></p> 
</div><!-- //wrapper -->
<script>
$(window).scroll(function(){
	if(moveTop > 0){
		$(".btnKakao").addClass("on");
		if(moveTop + $(window).height() > ($(document).height() - $("#footer").height())){
			$(".btnKakao").addClass("noFix");
		} else {
			$(".btnKakao").removeClass("noFix");
		}
	} else {
		$(".btnKakao").removeClass("on");
	}
});
</script>
</body>
</html>
