<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(6));
	request.setAttribute("Depth_4", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("오시는 길"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=aac914a149713573a41e8d4cc725b63c "></script>
<script>
function showPop(){
	showPopupLayer('/popup/rentAcar.jsp', '860');
}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
	<div class="locationWrap">
		<div class="addrArea">
			<address>전라북도 고창군 상하면 상하농원길 11-23</address><br>
			<b>지번</b><address class="addr2">전라북도 고창군 상하면 자룡리 산1-2</address>
		</div>
		<div></div>
		<div class="mapAreea"  id="map" style="width:1100px;height:600px;">
		</div><!-- mapAreea -->
		<div class="trafficInfo">
			<div class="section section1">
				<strong>자가용</strong>
				<div>
					<p>네비게이션 ‘상하농원 주차장’ 검색(매일유업 상하공장 200m 인근)</p>
				</div>
				<p class="rentAcarBtn"><a href="#none" onclick="showPop(); return false">렌터카</a></p>
				
			</div><!-- //section -->
			<div class="section section2" style="padding:30px 0;">
				<strong>기차</strong>
				<div>
					<p>출발지 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 정읍역 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 렌터카 이용 50km(50분 소요)</p>
					<p>출발지 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 정읍역 <img src="/images/brand/introduce/location/arrow1.png" alt="→">정읍버스터미널(도보 5분거리) <img src="/images/brand/introduce/location/arrow1.png" alt="→">구시포행 직행버스<img src="/images/brand/introduce/location/arrow1.png" alt="→"> 상하농원(도보 10분거리)</p>
					<ul class="schedule">
						<li>
							<b>직행버스 시간</b>
							08:40 / 09:30 / 11:25 / 14:40 / 16:00
						</li>
					</ul>
				</div>
			</div><!-- //section -->
			<div class="section section3" style="padding:30px 0;">
				<strong>고속버스</strong>
				<div>
					<p>출발지 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 고창공용버스터미널 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 렌터카로 이동 26km(30분 소요)</p>
					<p>출발지 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 고창공용버스터미널 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 구시포행 직행버스 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 상하농원 도착(도보 10분거리)</p>
					<ul class="schedule">
						<li>
							<b>직행버스 시간</b>
							09:25 / 10:11 / 12:10 / 15:30 / 16:45 / 19:30
						</li>
					</ul>
					<p>출발지 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 광주종합버스터미널 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 렌터카로 이동 70km(60분 소요)</p>
					<p>출발지 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 정읍종합버스터미널 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 렌터카로 이동 50km(50분 소요)</p>
					<p>출발지 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 정읍공용버스터미널 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 구시포행 직행버스 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 상하농원 도착(도보 10분거리)</p>
					<ul class="schedule">
						<li>
							<b>직행버스 시간</b>
							08:40 / 09:30 / 11:25 / 14:40 / 16:00
						</li>
					</ul>
				</div>
			</div><!-- //section -->
			<div class="section section4">
				<strong>시내버스</strong>
				<div>
					<p>고창터미널 [ 고창 <img src="/images/brand/introduce/location/arrow1.png" alt="→"> 구시포 ] 행 버스 승차  신자룡 정류장 하차하여 매일유업 상하공장 방향으로 도보이동(10분 소요)</p>
					<ul class="schedule">
						<li>
							<b>고창터미널 <img src="/images/brand/introduce/location/arrow2.png" alt="→"> 구시포</b>
							시내버스<br/>06:10(첫차) / 07:40 / 09:20 / 10:55 / 12:40 / 13:50 /15:30 / 16:30 / 17:50 / 19:10(막차)<br/>
							직행버스<br/>09:25 / 10:11 / 12:10 / 15:30 / 16:45 / 19:30
						</li>
						<li>
							<b>구시포 <img src="/images/brand/introduce/location/arrow2.png" alt="→"> 고창터미널</b>
							시내버스<br/> 07:10(첫차) / 08:45 / 10:20 / 11:55 / 14:15 / 14:50 / 16:35 / 17:30 / 16:30 / 18:40 / 20:00(막차)<br/>
							직행버스<br/>07:10 / 10:50 / 12:10 / 14:05 / 17:00 / 18:30
						</li>
					</ul>
					
					<ul class="infoTxt">
						<li>2018년 1월 기준 시간표로 수시 변경될 수 있습니다.</li>
						<li>정확한 시간표는 대한고속 고창영업소(063-564-3943~4)를 통해 확인이 가능합니다.</li>
					</ul>
				</div>
			</div><!-- //section -->
			
		</div><!-- //trafficInfo -->
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
					