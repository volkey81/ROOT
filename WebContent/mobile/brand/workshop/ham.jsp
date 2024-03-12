<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.brand.ImageBoardService"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.service.brand.CraftSchService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("햄공방"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	CraftSchService svc = (new CraftSchService()).toProxyInstance();
	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	Param info = svc.getInfo("002");
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "002");
	List<Param> imageBoardList = imageBoard.getList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
$(function(){
	//주요 제품
	var pSwiper = new Swiper($(".productSlide"), {
		slidesPerView: 'auto',
		slidesPerGroup: 2,
		onSlideChangeEnd: function(swiper){	
			var idx = swiper.activeIndex;
		}
	});

/* 	//금주 생산일정
	$(".schedule ul li a").click(function() {		
		if(!$(this).hasClass("on")) {
			$(this).addClass("on");
		} else {
			$(this).removeClass("on");
		}
		return false;
	});	 */
});	
</script>
</head>  
<body class="workshopWrapper">
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="workshopArea">
			<img src="/mobile/images/brand/workshop/workshop0101.jpg" alt="">
			<div class="topBanner">
				 <p>제7회 베스트<br>육가공품 선발대회<span>소시지 부문 우수상 ‘상하농원 스모크 프랑크’</span></p>
				 <span>한국육가공협회 주관의 베스트 육가공품 선발대회에서 상하농원 프랑크 소시지의 우수한 맛과 품질을 인정받아 우수상을 받았습니다.</span>
			</div>
			<p class="brantTopTxt">깨끗한 원재료 그대로 햄공방<span>냉장 순돈육과 12시간 정성들인 염지로 만든 햄</span></p>
			<img src="/mobile/images/brand/workshop/workshop0102.jpg" alt="">
			<div class="scheduleArea">
				<div class="txtArea">
					<p>
						<img src="/mobile/images/brand/workshop/workshop0103.png" alt="">
						<span>천연케이싱으로 육즙이 풍부한<br>소시지와 12시간 이상 염지하여<br>깊은 맛을 내는 베이컨으로<br>고기보다 더 맛있는 햄을 경험해보세요</span>
					</p>
				</div>
				<div class="schedule">
					<p>금주 생산일정</p>
					<ul>
						<li><span>일</span><a <%=StringUtils.equals("Y", info.get("SUN")) ? "class='on'" : "" %>></a></li>
						<li><span>월</span><a <%=StringUtils.equals("Y", info.get("MON")) ? "class='on'" : "" %>></a></li>
						<li><span>화</span><a <%=StringUtils.equals("Y", info.get("TUE")) ? "class='on'" : "" %>></a></li>
						<li><span>수</span><a <%=StringUtils.equals("Y", info.get("WED")) ? "class='on'" : "" %>></a></li>
						<li><span>목</span><a <%=StringUtils.equals("Y", info.get("THU")) ? "class='on'" : "" %>></a></li>
						<li><span>금</span><a <%=StringUtils.equals("Y", info.get("FRI")) ? "class='on'" : "" %>></a></li>
						<li><span>토</span><a <%=StringUtils.equals("Y", info.get("SAT")) ? "class='on'" : "" %>></a></li>
					</ul>
					<span>시설 견학은 농원운영 시간 내 상시 가능하고 <br>시즌 및 공휴일의 경우 시설이 운휴될 수 있습니다.</span>
				</div>
			</div>
		
			<div class="productSlide">
				<p>주요 제품</p>						
				<ul class="swiper-wrapper">
<%
					if (CollectionUtils.isNotEmpty(imageBoardList)) {
						for (Param row : imageBoardList) {
%>
					<li class="swiper-slide"><a href="<%= "".equals(row.get("url")) ? "#none" : "/mobile" + row.get("url") %>"><img src="<%=row.get("THUMB") %>" alt=""></a>
						<span class="tit"><%=row.get("TITLE") %></span>
					</li>
<%
						}
					}							
%>
				</ul>
			</div><!-- //productSlide -->
			<div class="movieArea">
				<p>공방영상</p>
				<div class="mvArea"><iframe src="https://www.youtube.com/embed/DzLJF08clzo" frameborder="0" allowfullscreen></iframe></div>
			</div>
		
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					