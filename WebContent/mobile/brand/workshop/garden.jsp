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
<script>
	$(function(){
		$('.workshopArea').hide();
		$('.workshopArea').eq(0).show();	
		
		$('.farmerEx.tabArea li').on('click', function(){
			$('.farmerEx.tabArea li').removeClass('on');
			$(this).addClass('on');
			$('.workshopArea').hide();
			$('.workshopArea').eq($(this).index()).show();			
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
		<ul class="farmerEx tabArea">
			<li class="on"><span>농부의 밥상</span></li>
			<li><span>농부의 아침</span></li>
		</ul>
		<div class="workshopArea workshopArea_1">
			<!-- <p class="brantTopTxt">농부체험<span>마늘은<br />어디서 자랄까요?</span></p> -->
			<img src="/mobile/images/brand/workshop/new_workshop02.jpg" alt="">
			<div class="scheduleArea">
				<div class="txtArea">
					<p>
						<img src="/mobile/images/brand/workshop/new_workshop03.png" alt="">
						<span>농부의 밥상은 어떻게 차려질까요?</span>
					</p>
				</div>
				<div class="orderInfo">
					<div class="title">
						농부의 밥상, 이달의 작물
						<strong>&lt; 고구마순 &gt;</strong>
					</div>
					<dl>
						<dt>개별 준비물</dt>
						<dd>모자, 긴 팔, 긴 바지, 운동화(면장갑 제공)</dd>
						<dt>체험일정</dt>
						<dd>매주 수, 목, 금 오후 4시</dd>
					</dl>
					<strong>가족 농부 체험 (1인) 10,000원</strong>
					<ul>
						<li><span>-</span>상하농원 입장료는 체험비와는 별도입니다.</li>
						<li><span>-</span>우천시, 자동 취소 처리 됩니다.</li>
						<li><span>-</span>개인 준비물을 반드시 확인하고 지참하셔야 합니다.</li>
						<li><span>-</span>체험 입장 30분전까지는 농원에 도착하셔야 예약 확인 후, 체험이 가능합니다.</li>
						<li><span>-</span>체험 3일전까지 취소한 경우에 한해 100% 환불이 가능합니다. (이후 취소수수료 발생)</li>			
					</ul>
					<p class="btn">
						<a href="/mobile/brand/play/reservation/experience.jsp">
							<img src="/mobile/images/brand/workshop/btn_orderInfo.jpg" alt="" />
						</a>
					</p>
				</div>
			</div>
		</div>
		<div class="workshopArea workshopArea_2">
			 <p class="brantTopTxt">준비 중입니다.<span>재미있는 체험으로 곧 찾아뵙겠습니다.</span></p>
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					