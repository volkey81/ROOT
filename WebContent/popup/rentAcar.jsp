<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.product.*,
				 com.sanghafarm.service.code.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("렌트카"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=aac914a149713573a41e8d4cc725b63c "></script>
<script>
	
</script>
<style>
.rentAcar h1 {display:none;}
.rentAcar #popCont {padding:0}
.rentAcar .rentAcarPop {position:absolute; right:50px; top:172px;}
</style>
</head>  
<body class="popup">
<div id="popWrap" class="rentAcar">
	<h1><%=MENU_TITLE %></h1>

	<div id="popCont">
	<!-- 내용영역 -->
		<img src="/images/brand/introduce/location/rentAcar.jpg" alt="오리엔탈 렌터카">
		<p class="desc">운영시간 08:00 ~21:00 / 063-535-3883. 대여금액(12시간 기준) LF 소나타 55,000원, 12인 스타렉스 110,000원, 15인승 솔라티 210,000원. 이용안내 
		※ 상하농원 특별 제휴기간: 2018년 9월 17일 ~ 별도 고지 시 ※ 업체 사정에 따라 차종 및 대여금액이 변동 될 수 있습니다. 대여금액 포함 내역 및 이용 관련 문의는 렌터카 업체로 주시기 바랍니다. 
		※ 렌터카 이용내역 및 개언정보는 렌터카 업체에서 관리되며, 상하농원에 일체 제공/공유 되지 않습니다.</p>
		<div class="rentAcarPop"  id="popMap" style="width:380px;height:308px;"></div><!-- mapAreea -->
	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->

<script>
var container = document.getElementById('popMap'); //지도를 담을 영역의 DOM 레퍼런스
var options = { //지도를 생성할 때 필요한 기본 옵션
	center: new daum.maps.LatLng(35.5722205, 126.8441451), //지도의 중심좌표.
	level: 3 //지도의 레벨(확대, 축소 정도)
};

var map = new daum.maps.Map(container, options); //지도 생성 및 객체 리턴

//팝업높이조절
setPopup(<%=layerId%>);

</script>
</body>
</html>