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
	<div class="mmwrap joininner">
		<a href="#" class="popClose"><img src="/mobile/images/btn/btn_close3.png" alt="" /></a>			
		<strong class="lg_resting_St">상하농원 회원가입에<br />실패하였습니다.</strong>	
		<p class="lg_resting_P" style="padding-bottom:0;">상하농원 회원가입중에<br />기술적인 문제로 가입에 실패하였습니다.</p>
		<p class="lg_resting_P">잠시 후 다시 시도해주시거나<br />고객센터 1588-1539로 문의주세요.</p>
	</div>

	<div class="btnWarp">
		<a href="/mobile/main.jsp" class="btnCheck Large">메인으로 이동</a>			
	</div>	
	
	<!-- //내용영역 -->
	</div><!-- //container -->
</div><!-- //wrapper -->
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
</html>
