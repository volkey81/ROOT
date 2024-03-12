<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("캠페인"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="hotelCont styleA campaign">
		<!-- 내용영역 -->
		
		<div class="campaignTxt">
			 <p class="top  animated fadeInUp delay02">상하농원과 함께하는 환경보호 캠페인</p>
			 <p class="tit  animated fadeInUp delay04">우리의 작은 습관이<br>먹거리와<br>환경을 보호해요!</p>
			 <p class="txt animated fadeInUp delay06">우리가 쓰고 먹는 것들은 자연에서 납니다.<br>너무 많이, 너무 더럽게 쓰면 자연은 더 이상<br>자연의 모습으로 다가오지 않아요.<br>
			 우리의 작은 습관이<br>먹거리와 환경을 보호합니다.<br>파머스빌리지에서 같이 작은 변화를<br>시작해볼까요?</p>
			 <!-- <div class="coin animated fadeInUp delay08">
			 	<img src="/mobile/images/hotel/enjoy/campaign01.png" alt="">
			 	<p class="coinTit">상하에코코인</p>
			 	<p class="coinTxt">파머스빌리지를 방문한 고객이 참여하는<br>환경보호 및 기부활동입니다.<br>파머스테이블/ 웰컴라운지에서 환경보호 미션을<br>완수하면 에코코인을 드립니다.<br>
			 	프런트에 비치된 에코코인 기부함에 넣어주시면<br>코인 1개당 100원씩 환경보호단체 또는<br>지역사회에 기부됩니다.</p>
			 </div> -->
		</div>
		
		<div class="section">
			<img src="/mobile/images/hotel/enjoy/campaignTit01.png" alt="01 MISSION">
			<p class="missionTit">음식을 남기지 않고 싹싹 먹기<br>(파머스테이블)</p>
			<p class="missionTxt">파머스테이블의 모든 음식은<br>농부들이 정성껏 짓고 셰프들이 맛과 영양을<br>생각해서 만든 음식들입니다.<br>음식에 대한 감사함을 느끼고 실천하는<br>활동을 해볼까요?</p>
			<ul>
				<li>남기지 않고 싹싹 먹기</li>
				<li class="mission2">접시는 스스로 치우기</li>
			</ul>
			<div class="coinTxtBox">
				<p>에코코인은 파머스테이블 이용 후 ‘접시 반납하는 곳’에서 제공됩니다. 지급된 에코코인은 프론트 옆 에코 저금통에 쏙 넣어주세요.</p>
			</div>
		</div>
		<div class="section">
			<img src="/mobile/images/hotel/enjoy/campaignTit02.png" alt="02 MISSION">
			<p class="missionTit">개인컴 사용하기<br>(웰컴라운지)</p>
			<p class="missionTxt">일회용 컵 대신 개인컵을 사용하는 것은<br>플라스틱과 종이 사용을 줄이는 환경보호를 위한<br>작은 습관입니다.</p>
			<ul>
				<li class="mission3">개인컵, 텀블러 소지하기</li>
				<li class="mission4">머그컵 이용하기</li>
			</ul>
			<div class="coinTxtBox">
				<p>에코코인은 웰컴라운지에서 음료를 드실 때 개인컵 사용 시 지급됩니다. 지급된 에코코인은 프론트 옆 에코 저금통에 쏙 넣어주세요.</p>
			</div>
		</div>
		<div class="section">
			<img src="/mobile/images/hotel/enjoy/campaignTit03.png" alt="03 MISSION">
			<p class="missionTit">개인 칫솔 사용하기<br>(객실)</p>
			<p class="missionTxt">파머스빌리지에는 일회용 칫솔을<br>비치하지 않습니다.<br>플라스틱 사용을 줄임으로써<br>쓰레기를 줄이기 위한<br>환경보호를 위한 작은 습관입니다.</p>
			<ul>
				<li class="mission5">개인 칫솔 사용하기</li>
				<li class="mission6">다음 번에 가져오기로 약속하기</li>
			</ul>
		</div>
		<div class="section">
			<img src="/mobile/images/hotel/enjoy/campaignTit04.png" alt="04 MISSION">
			<p class="missionTit">물/페이퍼타올 절약하기<br>(화장실)</p>
			<p class="missionTxt">올바른 손씻기와 손털기로<br>건강과 환경보호 두 마리 토끼 잡아봐요.</p>
			<ul>
				<li class="mission7">수도꼭지 잠그기 &amp; 손털기</li>
				<li class="mission8">페이퍼 타올은 1장만 써도되요</li>
			</ul>
		</div>
		<div class="section">
			<img src="/mobile/images/hotel/enjoy/campaignTit05.png" alt="05 MISSION">
			<p class="missionTit">에너지 절약하기<br>(곳곳)</p>
			<p class="missionTxt">에너지 절약은 작은 습관에서 시작됩니다.<br>작은 실천으로 에너지도 아끼고 건강도 챙기세요.</p>
			<ul>
				<li class="mission9">사용하지 않는 등은 소등하기</li>
				<li class="mission10">계단 이용하기</li>
			</ul>
		</div>
		<div class="campaignTxt">
			<p class="top bottom">자연과 함께하는<br>상하농원 파머스빌리지 캠페인에<br>동참해주셔서 감사합니다.</p>
		</div>
	
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					