<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("웨딩&amp;연회"));
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
	<div id="container" class="hotelCont styleA wedding">
		<!-- 내용영역 -->
		<!-- slideWrap -->
		<div class="slideWrap animated fadeInUp delay02">
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea"> 
				<div class="slide">
					<img src="/mobile/images/hotel/wedding/weddingSlide01.jpg" alt="">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/wedding/weddingSlide02.jpg" alt="">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/wedding/weddingSlide03.jpg" alt="">
				</div>
			</div>
		</div>
		<!-- //slideWrap -->
		
		<div class="hotelContTop animated fadeInUp delay04">
			<span class="sTxt">VILLAGE, 1F</span>
			<h2>웨딩&amp;연회<span>새출발을 축복하는 결혼식, 가족의<br>특별한 모임 소중한 순간을 함께하겠습니다.</span></h2>
		</div>
		<div class="section section01 animated fadeInUp delay06">
			<h3><img src="/mobile/images/hotel/wedding/wedding01Tit.png" alt="FARM WEDDING"></h3>
			<p class="thumArea"><img src="/mobile/images/hotel/wedding/wedding01.jpg?ver=1" alt=""></p>
			<div class="txtArea">
				<h4>팜웨딩</h4>
				<p class="sectionTxt">상하의 아름다운 사계절 속 네추럴 컨셉의 특별한 결혼식을 선사합니다</p>
				<div class="info">
					<p><span>장소</span>파머스테이블</p>
					<p><span>수용인원</span>100명~350명</p>
					<p><span>메뉴</span>한식, 양식, 뷔페</p>
				</div>
				<ul>
					<li>컨셉과 메뉴는 상담을 통해 확정됩니다.</li>
				</ul>
			</div>
		</div>
		<div class="section section02 animated fadeInUp delay08">
			<h3><img src="/mobile/images/hotel/wedding/wedding02Tit.png?ver=1" alt="WEDDING PHOTO"></h3>
			<p class="thumArea"><img src="/mobile/images/hotel/wedding/wedding02.jpg" alt=""></p>
			<div class="txtArea">
				<h4>웨딩포토</h4>
				<p class="sectionTxt">상하의 따사로움이 두 분의 시작에 추억이 될 수 있도록 기억을 담아내는 스냅 촬영</p>
				<div class="info">
					<p><span>장소</span>상하농원</p>
				</div>
				<ul>
					<li>상하농원에서 예식을 준비하시는 고객분들에게만 주어지는 특별한 혜택</li>
				</ul>
			</div>
		</div>
		<div class="section section01 left animated fadeInUp delay10">
			<h3><img src="/mobile/images/hotel/wedding/wedding03Tit.png" alt="FAMILY EVENT"></h3>
			<p class="thumArea"><img src="/mobile/images/hotel/wedding/wedding03.jpg" alt=""></p>
			<div class="txtArea">
				<h4>가족행사</h4>
				<p class="sectionTxt">소중한 아가의 첫 생일, 사랑하는 부모님의 생신,<br>가족의 소중한 순간을 파머스빌리지와 함께 하세요.</p>
				<div class="info">
					<p><span>장소</span>파머스테이블, 중앙정원</p>
					<p><span>수용인원</span>50명~150명</p>
					<p><span>메뉴</span>한식, 양식</p>
				</div>
				<ul>
					<li>컨셉과 메뉴는 상담을 통해 확정됩니다.</li>
				</ul>
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
					