<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("오시는 길"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=aac914a149713573a41e8d4cc725b63c "></script>
<script>

$(function(){
	$(".methodCont").hide();
	$(".tabArea li:first").addClass("on").show();
	$(".methodCont:first").show();
	$(".tabArea li").click(function() {		
		$(".tabArea li").removeClass("on");
		$(this).addClass("on");
		$(".methodCont").hide();
	
		var activeTab = $(this).find("a").attr("href");
		$(activeTab).show();
		return false;
	});	
});
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="styleA">
	<!-- 내용영역 -->
	<div class="locationWrap">
		<h2 class="animated fadeInUp delay02">오시는 길</h2>
		<div class="mapArea animated fadeInUp delay04">
			<div id="map"></div>
			<div class="address">
				<p class="txt01 animated fadeInUp delay06">전라북도 고창군 상하면 용정리 1399-1</p>
				<!-- <p class="txt02 animated fadeInUp delay08"><span>지번</span>전라북도 고창군 상하면 자룡리 산1-2</p> -->
			</div>
		</div><!-- mapAreea -->
		
		<div class="method">
			<ul class="tabArea">
				<li><a href="#method01">자가용</a></li>
				<li><a href="#method02">기차</a></li>
				<li><a href="#method03">고속버스</a></li>
				<li><a href="#method04">시내버스</a></li>
			</ul>
			<div class="methodCont" id="method01">
				<dl>
					<dt class="tit">자가용으로 오시는 길</dt>
					<dd>네비게이션 ‘파머스빌리지’ 검색<br> (매일유업 상하공장 200m 인근)</dd>
				</dl>
			</div>
			<div class="methodCont" id="method02">
				<dl>
					<dt class="tit">기차로 오시는 길</dt>
					<dd>출발지→정읍역→렌터카 이용 50km (50분 소요)</dd>
					<dd>출발지→정읍역→정읍버스터미널 (도보 5분거리)<br>
					→구시포행 직행버스→상하농원 (도보 10분거리)</dd>				
				</dl>
				<dl>
					<dt>직행버스 시간</dt>
					<dd>08:40 / 09:30 / 11:25 / 14:40 / 16:00</dd>
				</dl>
			</div>
			<div class="methodCont" id="method03">
				<dl>
					<dt class="tit">고속버스로 오시는 길</dt>
					<dd>출발지→고창공용버스터미널→렌터카로 이동<br>26km (30분 소요)</dd>
					<dd> 출발지→고창공용버스터미널→구시포행 직행버스<br>→상하농원 도착 (도보 10분거리)</dd>				
				</dl>
				<dl>
					<dt>직행버스 시간</dt>
					<dd>09:25 / 10:11 / 12:10 / 15:30 / 16:45 / 19:30</dd>
					<dd>출발지→광주종합버스터미널→렌터카로 이동<br>70km (60분 소요)</dd>
					<dd>출발지→정읍종합버스터미널→렌터카로 이동<br>50km (50분 소요)</dd>
					<dd>출발지→정읍공용버스터미널→구시포행 직행버스<br>→상하농원 도착 (도보 10분거리)</dd>
				</dl>
				<dl>
					<dt>직행버스 시간</dt>
					<dd>   08:40 / 09:30 / 11:25 / 14:40 / 16:00</dd>
				</dl>
			</div>
			<div class="methodCont" id="method04">
				<dl>
					<dt class="tit">시내버스로 오시는 길</dt>
					<dd>고창터미널 [고창→구시포] 행 버스 승차 신자룡 정류장<br>
					하차하여 매일유업 상하공장 방향으로 도보이동<br>(10분 소요)</dd>				
				</dl>
				<dl>
					<!-- <dt>직행버스 시간</dt> -->
					<dd class="bigTxt">고창터미널 → 구시포
						<ul>
							<li>- 시내버스<br>06:10 (첫차) / 07:40 / 09:20 / 10:55 / 12:40<br>/ 13:50 / 15:30 / 16:30 / 17:50 / 19:10 (막차)</li>
							<li>- 직행버스<br>09:25 / 10:11 / 12:10 / 15:30 / 16:45 / 19:30</li>
						</ul>
					</dd>	
					<dd class="bigTxt">구시포 → 고창터미널
						<ul>
							<li>- 시내버스<br>07:10 (첫차) / 08:45 / 10:20 / 11:55 / 14:15<br>/ 14:50 / 16:35 / 17:30 / 16:30 / 18:40<br>/ 20:00 (막차)</li>
							<li>- 직행버스<br>07:10 / 10:50 / 12:10 / 14:05 / 17:00 / 18:30</li>
						</ul>
					</dd>				
				</dl>
				<ul class="caption">
					<li>2018년 1월 기준 시간표로 수시 변경될 수 있습니다.</li>
					<li>정확한 시간표는 대한고속 고창영업소(063-564-3943~4)를 통해 확인이 가능합니다.</li>
				</ul>
			</div>
		</div>
		
		
	</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
var options = { //지도를 생성할 때 필요한 기본 옵션
	center: new daum.maps.LatLng(35.4473406, 126.4518299), //지도의 중심좌표.
	level: 4 //지도의 레벨(확대, 축소 정도)
};

var map = new daum.maps.Map(container, options); //지도 생성 및 객체 리턴
</script> 
</body>
</html>
					