<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("정원"));
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
	<div id="container" class="hotelCont styleA garden">
		<!-- 내용영역 -->
		<!-- slideWrap -->
		<div class="slideWrap animated fadeInUp delay02">
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea"> 
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/gardenSlide05.jpg" alt="정원5">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/gardenSlide01.jpg" alt="정원1">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/gardenSlide02.jpg" alt="정원2">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/gardenSlide03.jpg" alt="정원3">
				</div>
			</div>
		</div>
		<!-- //slideWrap -->
		
		<div class="hotelContTop animated fadeInUp delay04">
			<span class="sTxt">VILLAGE, 3F</span>
			<h2>정원<span>중앙정원은 따뜻한 다음 봄을 기다리며<br>준비하고 있습니다.</span></h2>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					