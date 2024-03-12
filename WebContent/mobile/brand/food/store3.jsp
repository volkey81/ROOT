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
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("파머스카페 상하"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");

	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "009");
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
		<div class="foodArea store3">
			<div class="foodHead">
				<p>신선한 우유와<br>엄선한 원두의 파머스카페 상하</p>
			</div>
			<div class="timeInfo">
				<img src="/mobile/images/brand/food/food0302.jpg" alt="">
				<div class="time">
					<strong class="timeTit fl">운영시간</strong>
					<strong class="timeTxt fr">연중무휴 09:30 ~ 18:00</strong>		
				</div>	
				<p>- 농원 휴관일을 제외한 별도 시설 휴일은 없습니다.<!-- <br>- 하기 메뉴는 상황에 따라 다를 수 있습니다. --></p>
				<p class="thumb"><img src="/mobile/images/brand/food/thumb_store3.jpg" alt=""></p>
			</div>
			<div class="menuList">
				<h2>주요메뉴<span>- 하기 메뉴는 상황에 따라 다를 수 있습니다.</span></h2>
				<ul>
					<!-- <li>
						<p class="thumb"><img src="/mobile/images/brand/food/thumb_menu3_1.jpg" alt=""></p>
						<div class="cont">
							<strong>햄치즈파니니</strong>
							<p class="text">진한 치즈와  짭쪼름한 햄을 넣고 오븐에 구운 파니니</p>
						</div>
					</li> -->
					<li>
						<p class="thumb"><img src="/mobile/images/brand/food/thumb_menu3_2.jpg" alt=""></p>
						<div class="cont">
							<strong>커피음료</strong>
							<p class="text">폴바셋 원두와 상하목장 우유로 더욱 깊은 풍미를 즐길 수 있는 커피 음료</p>
						</div>
					</li>
					<li>
						<p class="thumb"><img src="/mobile/images/brand/food/thumb_menu3_3.jpg" alt=""></p>
						<div class="cont">
							<strong>과일주스</strong>
							<p class="text">고창 지역의 엄선한 과일을 통째로 갈아 만든 신선한 과일 주스</p>
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
			</div> --%>		
		</div>		
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					