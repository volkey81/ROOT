<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("전시관"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
	
</script>
</head>  
<body class="playWrapper">
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="playArea">
			<div class="galleryCont">
				<p class="galleryTopTxt">상하농원이 어떻게 시작되었는지 궁금하시다면,
					<span>상하농원이 함께하고 있는 유기농과 6차 산업에 대한 설명부터 건물을 짓고,<br>농원을 만든 사람들까지 상하농원의 모든 것을 알 수 있는 공간으로 여행을 시작하세요!</span>
				</p>
				<!-- <div class="cont2017 yearCont">
					<strong>2017</strong>
					<div class="cont cont01">
						<p class="tit">상하농원 1주년 특별 기념 전시<span>2016.04.22</span></p>
						<div class="txtArea">
							<p class="bg01"><img src="/images/brand/play/gallery01.jpg" alt=""></p>
							<p class="bg02"><img src="/images/brand/play/gallery02.png" alt=""></p>
							<p class="txt">“상하농원, 새로운 출발!”<span>자연의 건강함을 전하는 '짓다-놀다-먹다'를 콘셉트로<br>내세운 농어촌 테마파크 '상하농원'이 문을 열었습니다.<br>지난 2008년부터 야심차게 추진해 온 상하농원에서<br>새로운 출발에 함께하세요.</span></p>
						</div>
					</div>
					
					<div class="cont cont02">
						<p class="tit">상하농원 그랜드 오픈 특별전<span>2016.04.22</span></p>
						<div class="txtArea">
							<p class="bg01"><img src="/images/brand/play/gallery03.jpg" alt=""></p>
							<p class="bg02"><img src="/images/brand/play/gallery04.png" alt=""></p>
							<p class="txt">“상하농원, 새로운 출발!”<span>자연의 건강함을 전하는 '짓다-놀다-먹다'를 콘셉트로<br>내세운 농어촌 테마파크 '상하농원'이 문을 열었습니다.<br>지난 2008년부터 야심차게 추진해 온 상하농원에서<br>새로운 출발에 함께하세요.</span></p>
						</div>
					</div>
				</div> -->
				
				<div class="cont2016 yearCont">
					<strong>2016</strong>
					<div class="cont">
						<p class="tit">상하농원 그랜드 오픈 기념 전시 <span>2016.04.22</span></p>
						<div class="txtArea">
							<p class="bg01"><img src="/images/brand/play/gallery05.png" alt=""></p>
							<p class="txt">“상하농원, 새로운 출발!”<span>자연의 건강함을 전하는 '짓다-놀다-먹다'를 콘셉트로<br>내세운 농어촌 테마파크 '상하농원'이 문을 열었습니다.<br>지난 2008년부터 야심차게 추진해 온 상하농원에서<br>새로운 출발에 함께하세요.</span></p>
						</div>
					</div>
				</div>
				
				
				
			</div>
			
			
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					