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
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("농원식당"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "008");
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
		<div class="foodArea store2">
			<div class="foodHead">
				<p>지리산이 키운 우리 흑돼지 <br>'버크셔 K'로 즐기는 <br>푸짐한 바비큐 구이<br>간장게장까지 건강한 농원식당</p>
			</div>
			<div class="timeInfo">
				<img src="/mobile/images/brand/food/food0102_1.jpg" alt="">
				<div class="time">
					<strong class="timeTit fl">운영시간</strong>
					<strong class="timeTxt fr">화 ~ 일요일 : 11:00 ~ 21:00<br>(월요일 휴점)</strong>
				</div>	
				<p>- 개인/단체 예약은 최소 1주일 전 유선으로 문의 바랍니다.<br>- 돌잔치 등 연회 단체 예약 가능</p>
				<p class="thumb"><img src="/mobile/images/brand/food/thumb_store2.jpg" alt=""></p>
			</div>
			<div class="menuList">
				<h2>주요메뉴</h2>
				<ul>
					<li>
						<p class="thumb"><img src="/mobile/images/brand/food/thumb_menu2_1.jpg" alt=""></p>
						<div class="cont">
							<strong>바베큐 메뉴</strong>
							<p class="text">고창산 돼지고기와 신선한 텃밭야채를 모두 즐길 수 있는 대표 메뉴</p>
						</div>
					</li>
					<!-- <li>
						<p class="thumb"><img src="/mobile/images/brand/food/thumb_menu2_2.jpg" alt=""></p>
						<div class="cont">
							<strong>바지락칼국수</strong>
							<p class="text">신선한 고창 바지락을 사용해 시원한 국물을 내서 만든 바지락칼국수</p>
						</div>
					</li>
					<li>
						<p class="thumb"><img src="/mobile/images/brand/food/thumb_menu2_3.jpg" alt=""></p>
						<div class="cont">
							<strong>고등어구이정식</strong>
							<p class="text">고등어를 숯불에 구워 더욱 깊은 맛이 나며 신선한 반찬들과 함께 제공되는 정식 </p>
						</div>
					</li> -->
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
					