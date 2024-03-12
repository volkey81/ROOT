<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.product.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
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
		<div class="familyJoin">
			<img src="/images/familyJoin/familyJoin01.jpg" alt="프리미엄 서비스 상하가족 가입안내.상하와 가족이 되다">
			<p class="joinTit">가입 완료</p>
			<div class="joinStep">
				<ul>
					<li><span>약관동의</span>></li>
					<li><span>결제</span>></li>
					<li class="on"><span>가입완료</span></li>
				</ul>
			</div>
			<div class="familyComplete">
<%
	if("4".equals(param.get("path"))) {
%>
				<strong>Success!</strong>
				<p>요청하신 상하가족 선물이 <br>성공적으로 완료되었습니다.</p>
				<div class="agreeChk">
					<div class="btnArea">
						<a href="/index.jsp">상하농원 홈</a>
					</div>
				</div>
<%
	} else {
%>
				<strong>Welcome!</strong>
				<p>상하가족이 되신 것을 환영합니다.<br>지금 바로 혜택을 확인해보세요!</p>
				<div class="agreeChk">
					<div class="btnArea">
						<a href="/mypage/">쿠폰 확인하기</a>
					</div>
				</div>
<%
	}
%>
			</div>
		</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>