<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sanghafarm.utils.*,
				 com.sanghafarm.common.*"%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
// 	String strUserId = SanghafarmUtils.getCookie(request, "saveid"); //저장된 아이디
	String strUserId = fs.getUserId();
	String memLeave2Url = request.getScheme() + "://" + request.getServerName() + "/mobile/member/memLeave2.jsp"; //비밀번호확인 URL
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
$(document).ready(function(){
	var userId = "<%=strUserId%>";
	$("#userId").val(userId);
});

//비밀번호 확인
function pwdChk(){
	if($("#pwd").val() == ""){
		alert("비밀번호를 입력해주세요.");
	}else{
		/*
        var param = {
            	pwd : $('#pwd').val(),
            	userId : "<%=strUserId %>",
                screenType : "modify"
            }
        
       	$.ajax({
           type : "POST",
           url : '/mobile/member/isSamePwdProc.jsp',
           dataType : "json",
           data : param,
           success : function(data) {
	           	if(data.result == "true") {
					location.href = "<%=memLeave2Url%>";
	            }else{
	            	alert(data.message);
	            }
           }
       	});
		*/
		$("#input_form").submit();
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
		<strong>회원탈퇴</strong>
		<jsp:include page="/mobile/member/memberClose.jsp" />
	</div>
	
	<div class="mmwrap joininner">
		<strong class="lg_resting_St">상하농원 회원탈퇴</strong>
		<p class="lg_resting_P">상하농원 탈퇴를 위해서 비밀번호를 입력해주세요.</p>
	</div>
	<form name="input_form" id="input_form" method="post" action="<%= Env.getSSLPath() %>/mobile/member/isSamePwdProc.jsp">
		<table class="joinForm">
			<caption>회원탈퇴를 위한 내용</caption>
			<tbody>
				<tr>
					<td class="focusing fix">
						<strong>아이디</strong>
						<label class="focusingIn" style="width:100%;">
							<input type="text" name ="userId" id="userId" maxlength="11" value="" readonly>
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
		<input type="hidden" id="screenType" name="screenType" value="leave">
	</form>
	
	<div class="btnWarp">
		<a href="javascript:void(0)" class="btnCheck Large" onclick="pwdChk();">확인</a>				
	</div>	
		
	<!-- //내용영역 -->
	</div><!-- //container -->
</div><!-- //wrapper -->
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
</html>
