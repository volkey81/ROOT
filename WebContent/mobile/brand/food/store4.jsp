<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.sanghafarm.service.brand.ImageBoardService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("농원상회"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "010");
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
		<div class="foodArea store4">
			<div class="foodHead">
				<p>상하농원 공방 장인의 손길을<br>우리집 식탁으로, 농원상회</p>
			</div>
			<div class="timeInfo">
				<img src="/mobile/images/brand/food/food0402.jpg" alt="">
				<p class="txt">상하농원 여러 공방에서 솜씨 좋은 장인들이 만들어 낸<br>먹거리를 직접 구입할 수 있는 상점입니다.<br>빵, 잼, 된장, 햄, 소시지와 상하농원 기념품을 구매하여<br>집에서도 건강한 자연을 느껴보세요.</p>
				<div class="time">
					<strong class="timeTit fl">운영시간</strong>
					<strong class="timeTxt fr">10:00~18:00<br>(공휴일을 제외한 월요일 휴무)</strong>		
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
					