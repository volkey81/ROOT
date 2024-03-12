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
<jsp:include page="/include/head.jsp" /> 
<script>
	$(function(){
		$('.gardenArea').hide();
		$('.gardenArea').eq(0).show();	
		
		$('.farmerEx.tabArea li').on('click', function(){
			$('.farmerEx.tabArea li').removeClass('on');
			$(this).addClass('on');
			$('.gardenArea').hide();
			$('.gardenArea').eq($(this).index()).show();			
		});
	});
</script>
</head>  
<body class="workshopWrapper">
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<ul class="farmerEx tabArea">
			<li class="on"><div class="thum"></div><span>농부의 밥상</span></li>
			<li><div class="thum"></div><span>농부의 아침</span></li>
		</ul>
		<div class="workshopArea gardenArea gardenArea_1">
			<div class="type03Cont01">			
				<div class="gardenTxt">
					<p><span>농부의 밥상은<br>어떻게 차려질까요?</span></p>
				</div>
			</div>
			<div class="type01Txt01">
				<strong>
					농부의 밥상체험<br />(1인)<br />
					<span>10,000 원</span>
				</strong>
				<ul>
					<li><span>-</span>상하농원 입장료는 체험비와는 별도입니다.</li>
					<li><span>-</span>우천시, 자동 취소 처리 됩니다.</li>
					<li><span>-</span>개인 준비물을 반드시 확인하고 지참하셔야 합니다.</li>
					<li><span>-</span>체험 입장 30분전까지는 농원에 도착하셔야 예약 확인 후, 체험이 가능합니다.</li>
					<li><span>-</span>체험 3일전까지 취소한 경우에 한해 100% 환불이 가능합니다. (이후 취소수수료 발생)</li>																				
				</ul>
			</div>
			
			<div class="type03Cont02">
				<div class="gardenTxt">
					<p>
						<span>
							<b>농부의 밥상, 이달의 작물</b>
							<strong>&lt; 고구마순 &gt;</strong>
							<i>- 개별 준비물 : 모자, 긴 팔, 긴 바지, 운동화 (면장갑 제공)</i>
							<i>- 시간 : 매주 수, 목, 금  오후 4시</i>
						</span>
					</p>
				</div>				
			</div>
			
			<div class="orderInfo" style="background:#fbf6e3;">
				<strong>체험과정 소개</strong>
				<ul>
					<li class="list01">
						<span>STEP 1</span>
						<p>농부와 인사</p>
					</li>
					<li class="list02">
						<span>STEP 2</span>
						<p>고구마순 따기</p>
					</li>
					<li class="list03">
						<span>STEP 3</span>
						<p>고구마순<br>무침 만들기</p>
					</li>														
				</ul>
			</div>
			
			<div class="orderBtn">
				<a href="/brand/play/reservation/experience.jsp"><img src="/images/brand/workshop/btn_orderInfo.jpg" alt="" /></a>
			</div>
		</div>
		<div class="workshopArea gardenArea gardenArea_2">
			<div class="type03Cont01">
				<p class="brantTopTxt prepare">
					준비 중입니다.
					<span>재미있는 체험으로 곧 찾아뵙겠습니다.</span>
				</p>
			</div> 
		</div>
	</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					