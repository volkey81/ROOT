<%@page import="com.sanghafarm.service.brand.ImageBoardService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(8));
	request.setAttribute("MENU_TITLE", new String("스마트팜"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");

	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "004");
	List<Param> imageBoardList = imageBoard.getList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
$(function(){
	//주요 제품
	var fSwiper = new Swiper($(".playSlide .slideCont"), {
		slidesPerView: 1,
        spaceBetween: 15,		
		prevButton: $(".playSlide .prev"),
		nextButton: $(".playSlide .next")
	});
});	
</script>
</head>  
<body class="playWrapper">
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="playArea farm">
			<p class="brantTopTxt">지구를 지키는, 상하 스마트팜 단지<span>더 나은 내일을 위한 상하농원의 미래형 농업</span></p>
			<div class="txtArea">
				<img src="/mobile/images/brand/play/farm02.jpg" alt="">
				<p>자원을 아끼는, &lt;베리굿팜&gt;<br>순환농업을 실천하는 , &lt;아쿠아팜&gt;<br>수직농장 형태로 재구성한  &lt;큐브팜&gt;<br>지속가능한 미래를 만들기위해 함께해주세요!</p>	
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					