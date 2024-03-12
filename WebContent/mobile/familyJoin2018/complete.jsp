<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.board.FarmerMenuService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("상하가족 가입안내"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper" class="familyJoinWrap">
	<jsp:include page="/mobile/include/header.jsp" />
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
				<p>요청하신 상하가족 선물이<br>성공적으로 완료되었습니다.</p>
				<div class="agreeChk">
					<div class="btnArea">
						<a href="/mobile/index.jsp">상하농원 홈</a>
					</div>
				</div>
<%
	} else {
%>
				<strong>Welcome!</strong>
				<p>상하가족이 되신 것을 환영합니다.<br>지금 바로 혜택을 확인해보세요!</p>
				<div class="agreeChk">
					<div class="btnArea">
						<a href="/mobile/mypage/">쿠폰 확인하기</a>
					</div>
				</div>
			</div>
<%
	}
%>
		</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>