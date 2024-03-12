<%@page import="com.sanghafarm.service.board.*"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*" %>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%
	// 진입페이지 쿠키
	SanghafarmUtils.setCookie(response, "LANDING_PAGE", "BRAND", ".sanghafarm.co.kr", 60*60*24*100);
%>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("빌리지 소개"));
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=aac914a149713573a41e8d4cc725b63c "></script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel village">
		<!-- 내용영역 -->		
		<jsp:include page="/hotel/village/villageTab.jsp" />
		<div class="villageTop">
			<p class="animated fadeInUp delay02">하늘과 땅, 농부의 정성을 담은 <br>소박한 휴식으로 오시는 길</p>
		</div>
		<div class="locationArea">
			<div class="map animated fadeInUp delay04">
				<!-- <div><img src="/images/hotel/village/location.jpg" alt=""></div>		 -->
				<div class="mapAreea"  id="map" style="width:1100px;height:600px;">
				</div><!-- mapAreea -->
				<p class="address">
					<img src="/images/hotel/village/address.png" alt="SANGHA FARMERS VILLAGE">
					전라북도 고창군 상하면 용정리 1399-1
					<!-- <span>지번 : 전라북도 고창군 상하면 자룡리 산1-2</span> -->
				</p>
			</div>
			<div class="method">
				<div class="cont cont01">
					<strong>자가용</strong>
					<div>
						<ul>
							<li>네비게이션 ‘파머스빌리지’ 검색(매일유업 상하공장 200m 인근)</li>
						</ul>
					</div>
				</div>
				<div class="cont cont02">
					<strong>기차</strong>
					<div>
						<ul>
							<li>출발지 → 정읍역 → 렌터카 이용 50km(50분 소요)</li>
							<li>출발지 → 정읍역 → 정읍버스터미널(도보 5분거리) → 구시포행 직행버스 → 상하농원(도보 10분거리)</li>
						</ul>
						<dl>
							<dt>직행버스 시간 </dt>
							<dd>08:40 / 09:30 / 11:25 / 14:40 / 16:00 </dd>
						</dl>
					</div>
				</div>
				<div class="cont cont03">
					<strong>고속버스</strong>
					<div>
						<ul>
							<li>출발지 → 고창공용버스터미널 → 렌터카로 이동 26km(30분 소요)</li>
							<li>출발지 → 고창공용버스터미널 → 구시포행 직행버스 → 상하농원 도착(도보 10분거리)</li>
						</ul>
						<dl class="first">
							<dt>직행버스 시간 </dt>
							<dd>09:25 / 10:11 / 12:10 / 15:30 / 16:45 / 19:30 </dd>
							<dd>출발지 → 광주종합버스터미널 → 렌터카로 이동 70km(60분 소요)</dd>
							<dd>출발지 → 정읍종합버스터미널 → 렌터카로 이동 50km(50분 소요)</dd>
							<dd>출발지 → 정읍공용버스터미널 → 구시포행 직행버스 → 상하농원 도착(도보 10분거리)</dd>
						</dl>
						<dl>
							<dt>직행버스 시간 </dt>
							<dd>8:40 / 09:30 / 11:25 / 14:40 / 16:00 </dd>
						</dl>
					</div>
				</div>
				<div class="cont cont04">
					<strong>시내버스</strong>
					<div>
						<ul>
							<li>고창터미널(고창 → 구시포)행 버스 승차 신자룡 정류장 하차하여 매일유업 상하공장 방향으로 도보이동(10분 소요)</li>
						</ul>
						<dl>
							<dt>고창터미널 → 구시포</dt>
							<dd>- 시내버스<span>06:10(첫차) / 07:40 / 09:20 / 10:55 / 12:40 / 13:50 /15:30 / 16:30 / 17:50 / 19:10(막차)</span></dd>
							<dd>- 직행버스<span>09:25 / 10:11 / 12:10 / 15:30 / 16:45 / 19:30 </span></dd>
							<dt class="second">구시포 → 고창터미널 </dt>
							<dd>- 시내버스<span>07:10(첫차) / 08:45 / 10:20 / 11:55 / 14:15 / 14:50 / 16:35 / 17:30 / 16:30 / 18:40 / 20:00(막차)</span></dd>
							<dd>- 직행버스<span>07:10 / 10:50 / 12:10 / 14:05 / 17:00 / 18:30 </span></dd>
						</dl>
					</div>
					<ul>
						<li>- 2018년 1월 기준 시간표로 수시 변경될 수 있습니다.</li>
						<li>- 정확한 시간표는 대한고속 고창영업소(063-564-3943~4)를 통해 확인이 가능합니다.</li>
					</ul>
				</div>
			</div>
		</div>

		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
var options = { //지도를 생성할 때 필요한 기본 옵션
	center: new daum.maps.LatLng(35.4472416, 126.4522299), //지도의 중심좌표.
	level: 3 //지도의 레벨(확대, 축소 정도)
};

var map = new daum.maps.Map(container, options); //지도 생성 및 객체 리턴
</script> 
</body>
</html>
