<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
	if(!"".equals(param.get("r"))) {	// 추천인이 있는 경우
		SanghafarmUtils.setCookie(response, "RECOMMENDER2", param.get("r"), fs.getDomain(), 60*60*24*300);
	}
%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("상하가족 가입안내"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
	function showGift() {
<%
	if(fs.isLogin()) {
%>
		showPopupLayer('/popup/gift.jsp', '580');
<%
	} else {
%>
		alert("<%= FrontSession.LOGIN_MSG %>");
		fnt_login();
<%
	}
%>
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<ul id="location">
		<li><a href="/">홈</a></li>
		<li>상하가족</li>
	</ul>
	<div id="container">
	<!-- 내용영역 -->
	<!-- <div class="familyJoin">
		<div class="bannerArea">
			<img src="/images/familyJoin/banner.jpg" alt="프리미엄 서비스 상하가족 가입안내.상하와 가족이 되다">
			<div class="txt">
				<p>상하가족 혜택 리뉴얼로 인해 웹사이트/방문현장가입은 일시 중단 됩니다.<br>기존 상하가족 회원은 마이페이지를 통하여 혜택 및 사용내역 확인하실 수 있습니다.</p>
				<a href="/mypage/index.jsp" class="btnTypeA sizeL">마이페이지 이동</a>
			</div>
		</div>
	</div> -->
	
	 <div class="familyJoin familyJoinIndex">
	 	<div class="top">
	 		<img src="/images/familyJoin/familyJoin01_1.jpg" alt="프리미엄 서비스 상하가족 가입안내.상하와 가족이 되다">
	 		<ul>
	 			<li class="on"><a href="#cont01">상하가족이란?</a></li>
	 			<li><a href="#cont02"><span>혜택 1</span>체험&amp;이벤트</a></li>
	 			<li><a href="#cont03"><span>혜택 2</span>Welcome Gift</a></li>
	 			<li><a href="#cont04"><span>혜택 3</span>쿠폰&amp;적립</a></li>
	 		</ul>
	 	</div>
		<img src="/images/familyJoin/familyJoin02_1.jpg" alt="상하가족이란? 01.가입하기, 02.선물선택, 03.사입비 결제, 04혜택누려~" id="cont01">
		<img src="/images/familyJoin/familyJoin03_1.jpg" alt="상하가족의 다양한 혜택. 상하 가족이 된다면 즐길 수 있는 다양한 혜택! 이 모든 것을 가입 즉시 바로 누릴 수 있습니다!" id="cont02">
		<img src="/images/familyJoin/familyJoin04_1.jpg" alt="상하가족 가입선물 증정. 상하농원 오프라인 파머스마켓 1만원 쿠폰, 상하농원 온라인 파머스마켓 2만원 쿠폰" id="cont03">
		<img src="/images/familyJoin/familyJoin05_1.jpg" alt="잠깐만요! 회원제 서비스입니다. 탈퇴 및 가입비 환불 규정" id="cont04">
		<a href="/familyJoin2018/agree.jsp" class="joinBtn"><img src="/images/familyJoin/btn_familyJoin01.jpg" alt="상하가족 가입하기"></a>
		<!-- <a href="#" class="joinBtn" onclick="showGift(); return false"><img src="/images/familyJoin/btn_familyJoin02.jpg" alt="상하가족 가입하기"></a> -->
	</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>

</html>