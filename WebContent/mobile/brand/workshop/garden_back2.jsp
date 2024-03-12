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
	request.setAttribute("Depth_3", new Integer(5));
	request.setAttribute("MENU_TITLE", new String("농부체험"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	CraftSchService svc = (new CraftSchService()).toProxyInstance();
	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	Param info = svc.getInfo("014");
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "014");
	List<Param> imageBoardList = imageBoard.getList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
</head>  
<body class="workshopWrapper">
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="workshopArea">
			<img src="/mobile/images/brand/workshop/new_workshop01.jpg" alt="">
			<p class="brantTopTxt">농부체험<span>마늘은<br />어디서 자랄까요?</span></p>
			<img src="/mobile/images/brand/workshop/new_workshop02.jpg" alt="">
			<div class="scheduleArea">
				<div class="txtArea">
					<p>
						<img src="/mobile/images/brand/workshop/new_workshop03.png" alt="">
						<span>마늘은<br>어디서 자랄까요?<br>농부체험으로 마늘이 자라는 곳을<br>직접 견학 해보세요!</span>
					</p>
				</div>
				

				<div class="orderInfo">
					<p>가족 농부 체험 (3~4인)</p>
					<strong>84,000원</strong>
					<ul>
						<li><span>ㆍ</span>상하농원 입장료는 체험비와는 별도입니다.</li>
						<li><span>ㆍ</span>농부체험은 농부 체험 및 식사가 포함 된 가격입니다.</li>
						<li><span>ㆍ</span>체험 입장 30분전까지는 농원에 도착하셔야 예약 확인 후, 체험이 가능합니다.</li>
						<li><span>ㆍ</span>체험 3일전까지 취소한 경우에 한해 100% 환불이 가능합니다. (이후 취소수수료 발생)</li>
					</ul>
					<p class="btn">
						<a href="/mobile/brand/play/reservation/experience.jsp">
							<img src="/mobile/images/brand/workshop/btn_orderInfo.jpg" alt="" />
						</a>
					</p>
				</div>
				
				
			</div>
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					