<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("상하키친"));
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
					<img src="/mobile/images/hotel/dining/kitchenSlide05.jpg" alt="">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/dining/kitchenSlide01.jpg" alt="">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/dining/kitchenSlide02.jpg" alt="">
				</div>
			</div>
		</div>
		<!-- //slideWrap -->
		
		<div class="hotelContTop animated fadeInUp delay04">
			<h2>상하키친<span>상하농원의 신선한 식재와 정통 이탈리안 레스토랑 <br>‘더 키친 일 뽀르노’의 레시피로 탄생한<br>나폴리 피자 & 파스타를 만나보세요.</span></h2>
		</div>

		<div class="restaurantCont">
			<h2>INFORMATION</h2>
			<dl>
				<dt>이용시간</dt>
				<dd>월요일 11:00 ~ 21:00<br>화요일 ~ 일요일 11:00 ~ 18:00</dd>
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
			<p class="thumb"><img src="/mobile/images/hotel/dining/kitchen01_3.jpg" alt=""></p>
		</div><!-- //restaurantCont -->
		<div class="btnArea inquiryBtn">
			<a href="/images/brand/food/sanghaKitchen.pdf" target="_blank" class="btnStyle03">메뉴보기</a>
			<a href="/mobile/customer/hotelCounsel.jsp" class="btnStyle05">문의하기</a>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					