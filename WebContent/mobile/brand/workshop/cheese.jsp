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
	request.setAttribute("Depth_3", new Integer(8));
	request.setAttribute("MENU_TITLE", new String("치즈공방"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	CraftSchService svc = (new CraftSchService()).toProxyInstance();
	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	Param info = svc.getInfo("016");
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "016");
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
			<img src="/mobile/images/brand/workshop/workshop0801.jpg" alt="">
			<p class="brantTopTxt">자연 그대로, 건강하고 풍부한 맛을 선사하는 치즈 공방<span>1989년부터 쌓아온 장인의 노하우를 담은 최고급 치즈</span></p>
			<img src="/mobile/images/brand/workshop/workshop0802.jpg" alt="">
			<div class="scheduleArea">
				<div class="txtArea">
					<p>
						<img src="/mobile/images/brand/workshop/workshop0803.png" alt="">
						<span>보존료와 인공첨가물 없이<br>깨끗하게 선별된<br>국내산 1A등급 원유만을 사용해<br>더 건강한 치즈를 맛보세요!</span>
					</p>
				</div>
				<div class="schedule">
					<p>매일유업 상하공장 견학 가능일정</p>
					<ul>
						<li><span>일</span><a <%=StringUtils.equals("Y", info.get("SUN")) ? "class='on'" : "" %>></a></li>
						<li><span>월</span><a <%=StringUtils.equals("Y", info.get("MON")) ? "class='on'" : "" %>></a></li>
						<li><span>화</span><a <%=StringUtils.equals("Y", info.get("TUE")) ? "class='on'" : "" %>></a></li>
						<li><span>수</span><a <%=StringUtils.equals("Y", info.get("WED")) ? "class='on'" : "" %>></a></li>
						<li><span>목</span><a <%=StringUtils.equals("Y", info.get("THU")) ? "class='on'" : "" %>></a></li>
						<li><span>금</span><a <%=StringUtils.equals("Y", info.get("FRI")) ? "class='on'" : "" %>></a></li>
						<li><span>토</span><a <%=StringUtils.equals("Y", info.get("SAT")) ? "class='on'" : "" %>></a></li>
					</ul>
					<span>상하농원의 자연 치즈가 만들어지는 과정을 직접 견학 해보세요!</span>
				</div>
				<a href="/mobile/brand/play/reservation/admission.jsp" class="btn">견학 예약하기</a>
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
					