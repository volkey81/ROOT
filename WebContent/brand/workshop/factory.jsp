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
	request.setAttribute("Depth_3", new Integer(6));
	request.setAttribute("MENU_TITLE", new String("상하공장"));
	
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
</head>  
<body class="workshopWrapper">
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="workshopArea factoryArea">
			<p class="brantTopTxt">상하공장<span>우유와 치즈가 만들어지는 과정을 직접 견학 해보세요!</span></p>
			<div class="type01Cont01">
				<div class="txtArea">
					<img src="/images/brand/workshop/workshop0601.jpg" alt="">
					<p>
						<img src="/images/brand/workshop/workshop0603.png" alt="">
						<span>유기농 우유와 자연 치즈는<br>어떻게 만들어질까요?<br>우유와 치즈가 만들어지는 과정을<br>직접 견학 해보세요!</span>
					</p>
				</div>
				<div class="scheduleArea">
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
					
						<!-- <ul class="txt">
							<li>· 견학 시간: 10:30 , 14:00 (동절기 일2회 운영)</li>
							<li>· 예약 방법: 온라인 or 현장접수(선착순)<br> (매표소 발권 티켓 필참)</li>
							<li>· 이동 안내: 탑승 10분전까지 탑승장 대기 - 셔틀버스 이동</li>
							<li>· 주말에는 동영상으로 대체운영 됩니다.</li>
						</ul> -->
						<span style="margin-top:-15px;">* 공장견학 시간 9:30, 10:30, 14:00, 16:00<br>
					 온라인 예약 우선, 잔여좌석에 한해 매표소 앞 선착순 현장 접수 가능합니다.<br>
					 견학 시, 매표소에서 발권한 티켓을 반드시 소지하셔야 합니다.<br>
						<span style="display:block; margin-top:5px;"></span>* 공장이동 안내 : 10:30 / 14:00 (셔틀버스운행) 09:30 / 16:00 (자차이동)<br>
						10분전까지 탑승장 대기 - (공용 주차장 화장실 앞)<br>
						* 일요일 모든 견학은 자차이동 입니다.(10분전까지 공장주차장 도착)<br>
						* 주말에는 공장견학이 동영상으로 대체운영 됩니다.</span>
						<!-- <p class="btn"><a href="/brand/play/reservation/admission.jsp " class="icoGo">견학 예약하러가기</a></p> -->
					</div>
					<img src="/images/brand/workshop/workshop0602.jpg" alt="">
				</div>
			</div>
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					