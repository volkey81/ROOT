<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("세미나"));
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
	<div id="container" class="hotelCont styleA seminar">
		<!-- 내용영역 -->
		<!-- slideWrap -->
		<div class="slideWrap animated fadeInUp delay02">
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea"> 
				<div class="slide">
					<img src="/mobile/images/hotel/wedding/seminarSlide01.jpg" alt="">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/wedding/seminarSlide02.jpg" alt="">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/wedding/seminarSlide03.jpg" alt="">
				</div>
			</div>
		</div>
		<!-- //slideWrap -->
		
		<div class="hotelContTop animated fadeInUp delay04">
			<span class="sTxt">VILLAGE, 1F</span>
			<h2>세미나<span>답답한 도심을 벗어나 자연속에서<br>편안한 세미나를 진행할 수 있도록<br>정성을 다해 준비하겠습니다.</span></h2>
		</div>
		<div class="section section01 animated fadeInUp delay06">
			<h3><img src="/mobile/images/hotel/wedding/seminar01Tit.png" alt="SEMINAR"></h3>
			<p class="thumArea"><img src="/mobile/images/hotel/wedding/seminar01.jpg" alt=""></p>
			<div class="txtArea">
				<h4>세미나</h4>
				<p class="sectionTxt">행사 규모에 따라 변화 가능한 구조로 빔 프로젝터, 스피커 등 중요한 모임에 필요시설을 갖추었습니다.</p>
				<div class="info">
					<p><span>장소</span>1층 강당</p>
					<p><span>수용인원</span>최대 150
						<img src="/mobile/images/hotel/wedding/seminar01Cont.jpg" alt="Reception 150, Theater 150, Classroom 108, Round Table 120">
					</p>
				</div>
			</div>
		</div>
		<div class="section section02 animated fadeInUp delay08">
			<h3><img src="/mobile/images/hotel/wedding/seminar02Tit.png" alt="GROUP EVENT"></h3>
			<p class="thumArea"><img src="/mobile/images/hotel/wedding/seminar02.jpg" alt=""></p>
			<div class="txtArea">
				<h4>단체행사 (파머스테이블)</h4>
				<p class="sectionTxt">탁 트인 통창을 통해 들어오는 채광과 함께, 컨퍼런스, 소규모 공연, 단체행사를 연회와 함께 진행가능하며, 연단, 빔프로젝터, 스피커 등의 부대시설을 사용하여 중요한 행사를 더욱 빛나게 준비해 드립니다.</p>
				<div class="info">
					<p><span>장소</span>파머스테이블</p>
					<p><span>수용인원</span>최대 250명</p>
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
					