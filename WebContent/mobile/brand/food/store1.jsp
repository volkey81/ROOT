<%@page import="com.sanghafarm.service.brand.ImageBoardService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("상하키친"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "007");
	List<Param> imageBoardList = imageBoard.getList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />  
<script>
$(function(){
	//주요 제품
	/* var fSwiper = new Swiper($(".foodSlide .slideCont"), {
		slidesPerView: 1,
        spaceBetween: 15,		
		prevButton: $(".foodSlide .prev"),
		nextButton: $(".foodSlide .next")
	}); */
});	
</script>
</head>  
<body class="foodWrapper">
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="foodArea store1">
			<img src="/mobile/images/brand/food/food0101.jpg?ver=1" alt="">
			<div class="timeInfo">
				<div class="time">
					<strong class="timeTit fl">운영시간</strong>
					<strong class="timeTxt fr">월요일 11:00 ~ 21:00<br>화요일 ~ 일요일 11:00 ~ 18:00</strong>
				</div>	
				<p>- 개인 단체 예약은 최소 1주일 전 유선으로 문의 바랍니다.</p>
				<p class="thumb"><img src="/mobile/images/brand/food/thumb_store1.jpg?ver=1" alt=""></p>
			</div>
			<div class="menuList">
				<h2>주요메뉴</h2>
				<ul>
					<li>
						<p class="thumb"><img src="/mobile/images/brand/food/thumb_menu1_1.jpg" alt=""></p>
						<div class="cont">
							<strong>바지락파스타</strong>
							<p class="text">고창 심원 앞바다의 싱싱한 바지락으로 깊은 맛을 자랑하는 파스타 대표 메뉴</p>
						</div>
					</li>
					<li>
						<p class="thumb"><img src="/mobile/images/brand/food/thumb_menu1_2.jpg" alt=""></p>
						<div class="cont">
							<strong>샐러드피자</strong>
							<p class="text">담백하고 얇은 도우 위에 신선한 샐러드를 듬뿍 얹어서 만든 상하키친 대표메뉴</p>
						</div>
					</li>
					<li>
						<p class="thumb"><img src="/mobile/images/brand/food/thumb_menu1_3.jpg" alt=""></p>
						<div class="cont">
							<strong>소시지플레이트</strong>
							<p class="text">상하농원 소시지와 감자 튀김이 함께 제공되는 맥주안주로 일품인 플레이트!</p>
						</div>
					</li>
				</ul>
			</div>	
			<%-- <div class="foodSlide">
				<div class="gallerySlide">
<%
	if (CollectionUtils.isNotEmpty(imageBoardList)) {
%>
					<div class="slideCont">
						<ul class="swiper-wrapper">
<%
						
		for (Param row : imageBoardList) {
%>
							<li class="swiper-slide"><img src="<%=row.get("thumb") %>" alt=""></li>
<%
		}
													
%>
						</ul>
					</div>
<%
	}
	if (CollectionUtils.isNotEmpty(imageBoardList)) {
		if (imageBoardList.size() > 2) {
%>
					<div class="control">
						<input type="image" src="/mobile/images/btn/btn_prev3.gif" alt="이전" class="prev">
						<input type="image" src="/mobile/images/btn/btn_next3.gif" alt="다음" class="next">
					</div>		
<%					
		}
	}
%>
				</div><!-- //gallerySlide -->	
			</div>	 --%>	
		</div>		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					