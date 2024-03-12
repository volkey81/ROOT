<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
	Param param = new Param(request);
	String strUnfyMmbNo = Utils.safeHTML(param.get("unfyMmbNo"));
	String strAgreeUserUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/agreeUserProc.jsp?unfyMmbNo=" + strUnfyMmbNo; //URL(약관동의)
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
/***************************************
 * 약관동의
 **************************************/
function agreeUser() {	
	location.href= "<%=strAgreeUserUrl%>" 
}

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
	<div class="logInTop lgPop">
		<strong>회원 재가입</strong>
		<jsp:include page="/mobile/member/memberClose.jsp" />
	</div>
	
	<div class="mmwrap joininner">
		<p class="lg_resting_P" style="padding-bottom:0;">상하농원 약관동의를 하시면 상하농원 회원 가입이 되며,<br />온라인 서비스를 이용하실 수 있습니다.</p>
		<p class="lg_resting_P">약관동의를 철회하셨던 회원께서는 약관동의를 하시면<br />기존 활동 및 거래내역이 복구됩니다.</p>
	</div>

	<div class="btnWarp">
		<a href="javascript:void(0);" class="btnCheck Large" onclick="agreeUser();">회원 재가입</a>		
	</div>	
		
	<!-- //내용영역 -->
	</div><!-- //container -->
</div><!-- //wrapper -->
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
</html>
