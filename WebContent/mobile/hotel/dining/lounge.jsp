<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("웰컴라운지"));
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
	<div id="container" class="hotelCont styleA lounge">
		<!-- 내용영역 -->
		<!-- slideWrap -->
		<div class="slideWrap animated fadeInUp delay02">
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea">
				<div class="slide">
					<img src="/mobile/images/hotel/dining/loungeSlide01.jpg" alt="">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/dining/loungeSlide02.jpg" alt="">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/dining/loungeSlide03.jpg" alt="">
				</div>
			</div>
		</div>
		<!-- //slideWrap -->
		
		<div class="hotelContTop animated fadeInUp delay04">
			<span class="sTxt">VILLAGE, 1F</span>
			<h2>웰컴라운지<span>상하농원 제품을 구매할 수 있고<br>폴바셋 커피와 디저트류를 즐길 수 있습니다.</span></h2>
		</div>
		<div class="section section01 animated fadeInUp delay06">
			<h3><img src="/mobile/images/hotel/dining/lounge01Tit.png" alt="WELCOME LOUNGE CAFE"></h3>
			<p class="thumArea"><img src="/mobile/images/hotel/dining/lounge01.jpg" alt=""></p>
			<div class="txtArea">
				<h4>웰컴라운지 카페</h4>
				<p class="sectionTxt">신선한 목장의 우유,<br>엄선된 원두의 커피를 즐길 수 있습니다.</p>
				<div class="info">
					<p><span>연중무휴</span>9:30~21:00</p>
					<p><span>제공메뉴</span>아메리카노 (4,700원) 카페라떼 (5,300원)<br>케이크, 러스크, 식빵 등 베이커리류<br>상하농원 반숙란</p>
				</div>
			</div>
		</div>
		<div class="section section02 animated fadeInUp delay08">
			<h3><img src="/mobile/images/hotel/dining/lounge02Tit.png" alt="FARMERS MARKET POPUPSOTRE"></h3>
			<p class="thumArea"><img src="/mobile/images/hotel/dining/lounge02.jpg" alt=""></p>
			<div class="txtArea">
				<h4>파머스마켓 팝업스토어</h4>
				<p class="sectionTxt">파머스마켓 일부 상품을<br>웰컴라운지에서 만나보실 수 있습니다.</p>
				<div class="info">
					<p><span>연중무휴</span>9:30~21:00</p>
					<p><span>상품</span>상하농원 MD<br>상하농원 공방 제품 (쨈류, 장류) 등</p>
				</div>
			</div>
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
					