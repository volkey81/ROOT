<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("층별 안내"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script type="text/javascript" src="//apis.daum.net/maps/maps3.js?apikey=0a6d7bc4db97be1f2044c808b06c064b"></script>
<script>
$(function() {
	//퀵
	img = new Image();
	img.onload = function(){
		$(window).scroll(function(){
			var floor02 = $(".floorWrap ul li.floor02").offset().top - 600;
			var floor03 = $(".floorWrap ul li.floor03").offset().top - 600;
			var value = $(this).scrollTop() ;
		
			if (value > floor02){
				$(".floorWrap ul li.floor02").addClass("on");
			}if (value > floor03){
				$(".floorWrap ul li.floor03").addClass("on");
			}if (value == 0){
				$(".floorWrap ul li").removeClass("on");
			}
			
		});
	};
	img.src = "/mobile/images/hotel/village/floor02.jpg";
	
});
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="styleA">
	<!-- 내용영역 -->
	<div class="floorWrap">
		<h2 class="animated fadeInUp delay02">층별 안내</h2>
		<ul>
			<li class="floor01">
				<div class="txt animated fadeInUp delay04">
					<span>1F</span>
					<p><span>웰컴라운지</span>WELCOME LOUNGE</p>
					<p><span>강당</span>SEMINA HALL</p>
					<p><span>파머스테이블</span>FARMERS TABLE</p>
					<p><span>화장실</span>REST ROOM</p>
				</div>
				<img src="/mobile/images/hotel/village/floor01.jpg" alt="1F. 웰컴라운지, 강당, 파머스테이블, 화장실" class="animated fadeInUp delay06">
			</li>
			<li class="floor02">
				<div class="txt">
					<span>2F</span>
					<p><span>객실 201~219</span>GUEST ROOM. TERRACE</p>
					<p><span>정원</span>GARDEN. GLASS HOUSE</p>
					<p><span>연회상담실</span>MEETING ROOM</p>
					<p><span>서비스룸</span>SERVICE ROOM. PC.<br>VENDING MACHINE</p>
				</div>
				<img src="/mobile/images/hotel/village/floor02.jpg" alt="2F. 객실 201~219, 정원, 연회상담실, 서비스룸"></li>
			<li class="floor03">
				<div class="txt">
					<span>3F</span>
					<p><span>객실 301~323</span>GUEST ROOM. DUPLEX</p>
					<p><span>중앙정원</span>COURTYARD.<br>PLANT WORK SPACE</p>
					<p><span>서비스룸</span>SERVICE ROOM. LAUNDRY.<br>VENDING MACHINE</p>
				</div>
				<img src="/mobile/images/hotel/village/floor03.jpg" alt="3F.객실 301~323, 중앙정원, 서비스룸">
			</li>
		</ul>
	</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					