<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.brand.ImageBoardService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(5));
	request.setAttribute("MENU_TITLE", new String("파머스마켓"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "011");
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
<body class="foodWrapper">
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="foodArea store5">
			<div class="foodHead">
				<p>상하의 이야기가 시작되는<br>농원회관</p>
			</div>
			<div class="timeInfo">
				<img src="/mobile/images/brand/food/food0502.jpg" alt="">
				<p class="txt">농원회관은 농원 제일 입구에 위치하여<br>매표 공간과 상하농원을 설명하는 전시관이 있어<br>늘 방문객들로 늘 북적거립니다. <br>또한, 지역주민과 방문객을 이어주는 다리 역할을 하는<br>
				파머스마켓이 있어 지역 농민들이<br>직접 농사지은 채소화 과일, 곡식은 물론 고창지역<br>특산품까지 구매할 수 있는 따뜻한 정이 담긴 공간입니다.</p>
				<div class="time">
					<strong class="timeTit fl">운영시간</strong>
					<strong class="timeTxt fr">연중무휴 10:00 ~ 17:00</strong>		
				</div>	
				<p>- 온라인을 통해 더욱 편리하게 구매할 수 있습니다.</p>
			</div>	
			<!-- 		
			<div class="productSlide">
				<p>주요 제품</p>						
				<ul class="swiper-wrapper">
<%
					if (CollectionUtils.isNotEmpty(imageBoardList)) {
						for (Param row : imageBoardList) {
%>
					<li class="swiper-slide"><img src="<%=row.get("THUMB") %>" alt="">
						<span class="tit"><%=row.get("TITLE") %></span>
					</li>
<%
						}
					}							
%>
				</ul>
			</div><!-- //productSlide -->
		</div>	
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					