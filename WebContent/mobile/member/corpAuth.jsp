<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.sanghafarm.common.*"%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
	function goAuth() {
		if($("input[name=empno]").val() == '') {
			alert("사원번호를 입력해주세요.");
		} else {
			$("#authForm").submit();
		}
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
		<strong>협력사 임직원 인증</strong>
		<jsp:include page="/mobile/member/memberClose.jsp" />
	</div>
	
	<div class="mmwrap joininner">
		<strong class="lg_resting_St">사원번호를 입력해주세요.</strong>
		<p class="lg_resting_P">상하농원과 특별한 관계를 맺은<br>감사한 분들을 확인하고 인증합니다.<br><strong>* 매일유업 계열사 임직원인증은 매일DO 사이트 및 앱 에서 가능합니다.</strong></p>
	</div>
	<form name="authForm" id="authForm" action="corpAuthProc.jsp" method="post">
	<table class="joinForm">
		<caption>임직원 인증 폼</caption>
		<tbody>
			<tr>
				<td>
					<input type="text" name="empno" style="width:100%" placeholder="인증번호"> 
				</td>
			</tr>		
		</tbody>
	</table>
	</form>
	
	<div class="btnWarp">
		<a href="javascript:goAuth()" class="btnCheck Large">임직원 인증</a>				
	</div>	
		
	<!-- //내용영역 -->
	</div><!-- //container -->
</div><!-- //wrapper -->
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
</html>
