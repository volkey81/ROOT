<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sanghafarm.utils.*,
				 com.sanghafarm.common.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.utils.*" %>
<% 
	FrontSession fs = FrontSession.getInstance(request, response);

	String failUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/login.jsp"; //로그인 URL	
	if(!fs.isLogin()) {
		Utils.sendMessage(out, "잘못된 접근입니다.", failUrl);
		return;
	}
	
	String strUserId = fs.getUserId();
    String pwdChkUrl = Env.getSSLPath() + "/mobile/member/isSamePwdProc.jsp"; //비밀번호확인 URL
    String memModify2Url = Env.getSSLPath() + "/mobile/member/memModify2.jsp"; //비밀번호확인 URL    
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>

var doubleSubmitFlag = false;


//비밀번호 확인
function pwdChk(){
	if ($("#pwd").val() != ""){
		$("#input_form").submit();
	}else {
		alert("비밀번호를 입력해주세요.");
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
		<strong>회원 정보 수정</strong>
		<jsp:include page="/mobile/member/memberClose.jsp" />
	</div>
	
	<div class="mmwrap joininner">
		<strong class="lg_resting_St">비밀번호를 입력해주세요</strong>
		<p class="lg_resting_P">회원정보수정을 위해서 현재 비밀번호를 입력해주세요.</p>
	</div>
	<form id="input_form" method="post" action="<%=pwdChkUrl%>">
		<table class="joinForm">
			<caption>회원정보 수정을 위한 내용</caption>
			<tbody>
				<tr>
					<td class="focusing fix">
						<strong>아이디</strong>
						<label class="focusingIn" style="width:100%;">
							<input type="text" id="userId" name="userId" value="<%=strUserId%>" readonly>
						</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="password" name="pwd" id="pwd" value="" style="width:100%" placeholder="비밀번호" maxlength="32">
						<p class="warn">소문자, 대문자, 숫자 특수문자 중 최소 2가지 이상, 10자리 이상 입력</p>
					</td>
				</tr>				
			</tbody>
		</table>
	</form>
	
	<div class="btnWarp">
		<a href="javascript:void(0)" class="btnCheck Large" onclick="return pwdChk();">확인</a>				
	</div>	
		
	</div>
</div>
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
</html>
