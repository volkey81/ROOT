<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
	Param param = new Param(request);
	String userId = Utils.safeHTML(param.get("userId"));
	String strUnfyMmbNo = Utils.safeHTML(param.get("unfyMmbNo"));
	String inactiveUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/memInactive2.jsp?unfyMmbNo=" + strUnfyMmbNo;
	String cancelUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/login.jsp";
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
$( document ).ready(function() {
	$("#id").text("<%=userId%>");
});

</script>
</head>  
<body>
<div id="wrapper" class="login">
	<%-- <jsp:include page="/mobile/include/header.jsp" /> --%>
	<div class="loginHead">
		<img src="/mobile/images/member/head.jpg" alt="" />
	</div>  	
	<div id="container" class="join">
	<!-- 내용영역 -->
	<div class="mmwrap joininner">
		<a href="#" class="popClose"><img src="/mobile/images/btn/btn_close3.png" alt=""></a>		
		<strong class="lg_resting_St" >접속하신 아이디 <span id="id">ASDASD</span>은 <br />휴면계정입니다.</strong>	
		<p class="lg_resting_P" style="padding-bottom:0;">상하농원에서는 고객의 개인정보보호를 위하여 1년동안 사이트를<br />로그인하지 않으면 휴면상태로 전환하며,<br />개인저보를 분리보관하여 소중히 관리하고 있습니다.</p>
		<p class="lg_resting_P">휴면회원 처리 관련하여 궁금하신 사항은 고객센터 1522-3698로 문의바랍니다.</p>
	</div>

	<div class="btnWarp double">
		<a href="<%=inactiveUrl%>" class="btnCheck Large">휴면해제</a>
		<a href="<%=cancelUrl%>" class="btnCheck Large white">취소</a>					
	</div>	
		
	<!-- //내용영역 -->
	</div><!-- //container -->
</div><!-- //wrapper -->
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
</html>
