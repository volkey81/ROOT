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
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("빌리지 소개"));
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
$(function() {
	
	//타이틀
	var floor02Top;
	var floor03Top;
	$(window).load( function(){
		$(".floorArea>div.floor01").addClass("on");
		floor02Top = $(".floor02").offset().top;
		floor03Top = $(".floor03").offset().top;
	});
	$(window).scroll(function(){
		var scrollTop = $(this).scrollTop();
		var gap = $(window).height() - 100;
		console.log(floor02Top)
		if(scrollTop > floor02Top - gap) {
			$(".floor02").addClass("on")
		}
		if(scrollTop > floor03Top - gap) {
			$(".floor03").addClass("on")
		}
	});
});	
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel village">
		<!-- 내용영역 -->		
		<jsp:include page="/hotel/village/villageTab.jsp" />
		<div class="villageTop floorWrap">
			<p class="animated fadeInUp delay02">파머스빌리지의 층별 정보를<br>안내해 드립니다.</p>
		</div>
		<div class="floorArea">
			<div class="floor01">
				<img src="/images/hotel/village/floor01.jpg" alt="">
				<div class="txtArea">
					<strong>1F</strong>
					<span class="line"></span>
					<p>웰컴라운지 WELCOME LOUNGE<br>
					강당 SEMINA HALL<br>
					파머스테이블 FARMERS TABLE<br>
					화장실 REST ROOM
					</p>
				</div>
			</div>
			<div class="floor02">
				<img src="/images/hotel/village/floor02.jpg" alt="">
				<div class="txtArea">
					<strong>2F</strong>
					<span class="line"></span>
					<p>객실 201~219 GUEST ROOM. TERRACE<br>
					정원 GARDEN. GLASS HOUSE<br>
					연회상담실 MEETING ROOM<br>
					서비스룸 SERVICE ROOM. PC.<br>
					 <span>VENDING MACHINE</span>
					</p>
				</div>
			</div>
			<div class="floor03">
				<img src="/images/hotel/village/floor03.jpg" alt="">
				<div class="txtArea">
					<strong>3F</strong>
					<span class="line"></span>
					<p>객실 301~323 GUEST ROOM, DUPLEX<br>
					중정 COURTYARD. PLANT WORK SPACE<br>
					서비스룸 SERVICE ROOM. LAUNDRY.<br>
					<span>VENDING MACHINE</span>
					</p>
				</div>
			</div>
			
		</div>

		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
