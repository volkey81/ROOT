<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("농원식당"));
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
					<img src="/mobile/images/hotel/dining/restaurantSlide01.jpg" alt="">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/dining/restaurantSlide02.jpg" alt="">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/dining/restaurantSlide03.jpg" alt="">
				</div>
			</div>
		</div>
		<!-- //slideWrap -->
		
		<div class="hotelContTop animated fadeInUp delay04">
			<h2>농원식당<span>쫄깃한 식감과 부드러운 육질의 지리산 흑돼지 <br>버크셔K 정식과 지역 제철 식재료로 가득 채운 <br>밥상을 즐겨보세요.</span></h2>
		</div>

		<div class="restaurantCont">
			<h2>INFORMATION</h2>
			<dl>
				<dt>이용시간</dt>
				<dd>화요일~일요일ㅣ11:00~21:00<br>[매주 월요일 휴점]</dd>
				<dt>총 좌석 수</dt>
				<dd>실내 100석 ｜ 실외 44석</dd>
				<dt>예약 및 문의</dt>
				<dd>1522-3698 [연중 09:30 ~ 18:00]</dd>
			</dl>
			<ul class="caution">
				<li>단체 예약은 최소 1주일 전 유선으로 문의 바랍니다.</li>
				<li>돌잔치 등 연회 단체 예약 접수는 2개월 전 문의 바랍니다.</li>
				<li>농원식당 Last Order는 20:30까지이며, 포장 주문은 불가합니다.</li>
			</ul>
			<p class="thumb"><img src="/mobile/images/hotel/dining/restaurant01_2.jpg" alt=""></p>
		</div><!-- //restaurantCont -->
		<div class="btnArea inquiryBtn">
			<a href="/images/brand/food/restaurant.pdf" target="_blank" class="btnStyle03">메뉴보기</a>
			<a href="/mobile/customer/hotelCounsel.jsp" class="btnStyle05">문의하기</a>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					