<%@page import="com.sanghafarm.common.Env"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String retUrl = "&returnUrl=" + request.getScheme() + "://" + request.getServerName() + "/integration/ssologin.jsp?endType=R";//결과 수신 URL
	String updateInfoUrl = Env.getMaeildoUrl() + "/co/mp/comp01t2.do?chnlCd=3&coopcoCd=7040" + retUrl;
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
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
		<strong class="lg_resting_St">상하농원에 돌아와주셔서 감사합니다.</strong>	
		<p class="lg_resting_P" style="padding-bottom:0;">사이트를 정상적으로 이용하실 수 있으며,<br />동의하신 마케팅 정보를 받아보실 수 있습니다.</p>
		<p class="lg_resting_P">개인정보보호를 위하여 오래된 비밀번호는 변경해주시고,<br />이메일, 주소 등을 업데이트 해주시면 더욱 편리하게 서비스를 <br />이용하실 수 있습니다.</p>
	</div>

	<div class="btnWarp double">
		<a href="/mobile/member/login.jsp" class="btnCheck Large">로그인으로 이동</a>
		<a href="<%=updateInfoUrl %>" class="btnCheck Large white">회원정보 수정</a>					
	</div>	
		
	<!-- //내용영역 -->
	</div><!-- //container -->
</div><!-- //wrapper -->
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
</html>
