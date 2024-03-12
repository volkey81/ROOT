<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.brand.ImageBoardService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(5));
	request.setAttribute("MENU_TITLE", new String("텃밭정원"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "006");
	List<Param> imageBoardList = imageBoard.getList(param);
	
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
$(function(){
	//주요 제품
	var fSwiper = new Swiper($(".workshopSlide .slideCont"), {
		slidesPerView: 1,
        spaceBetween: 15,		
		prevButton: $(".workshopSlide .prev"),
		nextButton: $(".workshopSlide .next")
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
		<div class="workshopArea gardenArea">
			<div class="brantTopTxt"><p>푸른 자연의 힘을 느끼는 텃밭정원<span>무럭무럭 자라는 채소를 직접 관찰하고 체험하며,<br>자연을 느낄 수 있는 공간</span></p></div>
			<div class="txtArea">
				<img src="/mobile/images/brand/workshop/workshop0502.jpg" alt="">
				<p>시즌 별로 진행되는 다양한 심기체험, <br>수확체험을 통해 우리 아이들에게 먹거리가 <br>어떻게 식탁에 오는지 설명하는 <br>교육의 공간입니다.</p>	
			</div>
			<!-- <div class="workshopSlide">
				<div class="gallerySlide">
<%
	if (CollectionUtils.isNotEmpty(imageBoardList)) {
%>
					<div class="slideCont">
						<ul class="swiper-wrapper">
<%
						
		for (Param row : imageBoardList) {
%>
							<li class="swiper-slide"><img src="<%=row.get("IMG") %>" alt=""></li>
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
						<input type="image" src="/mobile/images/btn/btn_prev4.gif" alt="이전" class="prev">
						<input type="image" src="/mobile/images/btn/btn_next4.gif" alt="다음" class="next">
					</div>		
<%					
		}
	}
%>
				</div><!-- //gallerySlide 
			</div> -->
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					