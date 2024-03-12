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
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("즐길거리"));
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />

</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel hotelSlide enjoy campaign">
		<!-- 내용영역 -->		
		<jsp:include page="/hotel/enjoy/enjoyTab.jsp" />
		<div class="campaignTop">
			<div class="campaignTxt">
				<div class="topBanner animated fadeInUp delay04">
					<p>상하농원과<br>함께하는<br>환경보호<br>캠페인</p>
				</div>
				<p class="tit animated fadeInUp delay04">우리의 작은 습관이<br>먹거리와 환경을 보호해요!
					<span class="animated fadeInUp delay06">우리가 쓰고 먹는 것들은 자연에서 납니다.<br>너무 많이, 너무 더럽게 쓰면 자연은 더 이상 자연의 모습으로 다가오지 않아요. <br>우리의 작은 습관이 먹거리와 환경을 보호합니다.<br>파머스빌리지에서 같이 작은 변화를 시작해볼까요?</span>
				</p>
				<!-- <div class="ecoCoin">
					<p class="coin animated fadeInUp delay08"><img src="/images/hotel/enjoy/coin.png" alt="sangha eco coin"></p>
					<div>
					</div>
					<img src="/images/hotel/enjoy/coin02.png" alt="상하농원. 에코코인 작은 습관 하나가 더 나은 환경을 만들어요.이 코인을 에코 저금통에 넣어주세요.코인 1개당 100으로 환산하여 환경보호단체나지역사회에 기부합니다.함께 해 주세요." class="animated fadeInUp delay10">
					<div class="coinTxt animated fadeInUp delay10">
						<p><strong>상하에코코인</strong>파머스빌리지를 방문한 고객이 참여하는 환경보호 및 기부활동입니다.<br>파머스테이블/ 웰컴라운지에서 환경보호 미션을 완수하면 에코코인을 드립니다.<br>프런트에 비치된 에코코인 기부함에 넣어주시면 코인 1개당 100원씩<br>환경보호단체 또는 지역사회에 기부됩니다.
						</p>
					</div>
				</div> -->
			</div>
		</div>
		<div class="section section01">
			<img src="/images/hotel/enjoy/campaignTit01.png" alt="MISSION 01">
			<div class="txtArea">
				<p><span>음식을 남기지 않고 싹싹 먹기 (파머스테이블)</span>파머스테이블의 모든 음식은 농부들이 정성껏 짓고 셰프들이 맛과 영양을 생각해서 만든 음식들입니다.<br>음식에 대한 감사함을 느끼고 실천하는 활동을 해볼까요?</p>
				<ul>
					<li>남기지 않고 싹싹 먹기</li>
					<li>접시는 스스로 치우기</li>
				</ul>
				<div class="box">
					<p>에코코인은 파머스테이블 이용 후 ‘접시 반납하는 곳’에서 제공됩니다. <br>지급된 에코코인은 프론트 옆 에코 저금통에 쏙 넣어주세요.</p>
				</div>
			</div>
		</div>
		<div class="section section02">
			<img src="/images/hotel/enjoy/campaignTit02.png" alt="MISSION 02">
			<div class="txtArea">
				<p><span>개인컵 사용하기 (웰컴라운지)</span>일회용 컵 대신 개인컵을 사용하는 것은 플라스틱과 종이 사용을 줄이는 환경보호를 위한 작은 습관입니다.</p>
				<ul>
					<li>개인컵, 텀블러 소지하기</li>
					<li>머그컵 이용하기</li>
				</ul>
				<div class="box">
					<p>에코코인은 웰컴라운지에서 음료를 드실 때 개인컵 사용 시 지급됩니다.<br>지급된 에코코인은 프론트 옆 에코 저금통에 쏙 넣어주세요.</p>
				</div>
			</div>
		</div>
		<div class="section section03">
			<img src="/images/hotel/enjoy/campaignTit03.png" alt="MISSION 03">
			<div class="txtArea">
				<p><span>개인 칫솔 사용하기 (객실)</span>파머스빌리지에는 일회용 칫솔을 비치하지 않습니다. <br>플라스틱 사용을 줄임으로써 쓰레기를 줄이기 위한 환경보호를 위한 작은 습관입니다.</p>
				<ul>
					<li>개인 칫솔 사용하기</li>
					<li>다음 번에 가져오기로<br>약속하기</li>
				</ul>
			</div>
		</div>
		<div class="section section04">
			<img src="/images/hotel/enjoy/campaignTit04.png" alt="MISSION 04">
			<div class="txtArea">
				<p><span>물/페이퍼타올 절약하기 (화장실)</span>올바른 손씻기와 손털기로 건강과 환경보호 두 마리 토끼 잡아봐요.</p>
				<ul>
					<li>수도꼭지 잠그기 &amp; 손털기</li>
					<li>페이퍼 타올은 1장만<br>써도되요</li>
				</ul>
			</div>
		</div>
		<div class="section section05">
			<img src="/images/hotel/enjoy/campaignTit05.png" alt="MISSION 05">
			<div class="txtArea">
				<p><span>에너지 절약하기 (곳곳)</span>에너지 절약은 작은 습관에서 시작됩니다. 작은 실천으로 에너지도 아끼고 건강도 챙기세요.</p>
				<ul>
					<li>사용하지 않는 등은<br>소등하기</li>
					<li>계단 이용하기</li>
				</ul>
			</div>
		</div>
		<div class="bottomTxt"><p>자연과 함께하는 상하농원 파머스빌리지 캠페인에 동참해주셔서 감사합니다.</p></div>
		
		
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
