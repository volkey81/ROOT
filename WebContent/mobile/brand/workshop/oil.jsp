<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.service.brand.ImageBoardService"%>
<%@page import="com.sanghafarm.service.brand.CraftSchService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(7));
	request.setAttribute("MENU_TITLE", new String("참기름공방"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	CraftSchService svc = (new CraftSchService()).toProxyInstance();
	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	Param info = svc.getInfo("015");
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "015");
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
			<img src="/mobile/images/brand/workshop/workshop0701.jpg" alt="">
			<p class="brantTopTxt">느려도 정직한 기름을 공유하는 참기름공방<span>참깨 본연의 맛과 영양을 지켜낸 저온압착 방식의 참기름</span></p>
			<img src="/mobile/images/brand/workshop/workshop0702.jpg" alt="">
			<div class="scheduleArea">
				<div class="txtArea">
					<p>
						<img src="/mobile/images/brand/workshop/workshop0703.png" alt="">
						<span>낮은 온도에서 볶은 참깨로<br>갓 짜낸 참기름을 한 눈에 볼 수 있어요.<br>느리지만 올바른 건강을 선사하는<br>참기름을 맛보세요!</span>
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
					} else {						
%>
					<li><img src="/mobile/images/brand/workshop/workshop0704.jpg" alt=""></li>
<%
					}
%>
				</ul>
			</div><!-- //productSlide -->
			<!-- <div class="movieArea">
				<p>공방영상</p>
				<div class="mvArea"><iframe src="https://www.youtube.com/embed/H5YvbVoLjbc" frameborder="0" allowfullscreen></iframe></div>
			</div> -->
		
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					