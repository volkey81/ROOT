<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
$(function(){

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
	<div class="logInTop lgPop">
		<strong>매일 Do와 상하농원 재가입</strong>
		<jsp:include page="/mobile/member/memberClose.jsp" />
	</div>
	
	<div class="mmwrap joininner">
		<p class="lg_resting_P" style="padding-bottom:0;">매일Do 회원 탈퇴 30일이내에는 재가입이 가능하며,<br />이전 가입된 회원정보로 그 동안 받으신 서비스 및 이용정보 모두 복원이 됩니다.</p>
	</div>

	<div class="btnWarp">
		<a href="/mobile/member/joinStep2.jsp?reJoin=Y" class="btnCheck Large">회원 재가입</a>			
	</div>	
		
	<!-- //내용영역 -->
	</div><!-- //container -->
</div><!-- //wrapper -->
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
</html>
