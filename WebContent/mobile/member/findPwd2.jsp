<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.sanghafarm.common.*"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	Param param = new Param(request);
	String closeUrl = SanghafarmUtils.getCookie(request, "retUrl");
    String id = Utils.safeHTML(param.get("reqId")); //아이디
    String updPwdUrl = Env.getSSLPath() + "/mobile/member/pwdProc.jsp"; //비밀번호변경URL
    
    FrontSession fs = FrontSession.getInstance(request, response);
    
    if(fs.isLogin()){
//     	id = Utils.getCookie(request, "saveid");
    	id = fs.getUserId();
    } else {
    	String s = (String) session.getAttribute("SCI_AUTH");
    	if(s == null || "".equals(s)) {
    		Utils.sendMessage(out, "잘못된 접근입니다.", "/mobile/member/findPwd1.jsp");
    		return;
    	}
    	
    	session.removeAttribute("SCI_AUTH");
    }

%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<% 
	if("web".equals(param.get("type"))){
%>
	<link rel="stylesheet" href="/css/common.css?t=<%=System.currentTimeMillis()%>">
	<link rel="stylesheet" href="/css/layout.css?t=<%=System.currentTimeMillis()%>">
	<script src="/js/jquery-ui.js?t=<%=System.currentTimeMillis()%>"></script>
<%
	} 
%>
<script>
var v;

$(document).ready(function(){
	if(parent.opener != null ) {	
		$("#closeScreen").hide();
	}else{
		$("#closeScreen").show();
		$("#closeScreen").attr("href", "<%=closeUrl%>");
	} 
});

$(function(){
	v = new ef.utils.Validator($("#input_form"));
	v.add("userPwd1", {
		empty : "비밀번호를 입력해주세요."
	}); 
});

//비밀번호변경
function pwdUpdate (){
	if ( pwdValidation() ) {
		$("#reqPwd1").val($("#userPwd1").val());
		$("#reqPwd2").val($("#userPwd2").val());
		$("#updPwdForm").submit();
	}
}

//비밀번호 체크
function pwdValidation() {
	var passwd = $("#userPwd1").val(); 	// 비밀번호
	
	if (v.validate()) {
		if (!chkValidPasswd(passwd)) {
			$("#userPwd2").focus();
			return false;
		}
		if ( $("#userPwd2").val() == '' ) {
		    alert("입력한 비밀번호를 다시 입력해 주세요.");
			$("#userPwd2").focus();
			return false;
		}
		
		if ( $("#userPwd1").val() != $("#userPwd2").val() ) {
		    alert("비밀번호 확인이 입력하신 비밀번호와 다릅니다.");
			$("#userPwd2").focus();
			return false;
		}
		return true;
	}else{
		return false;
	}	
}
</script>
</head>  
<body>
<div id="wrapper" class="login<%= "web".equals(param.get("type")) ? " webType" : "" %>">
<% 
	if("web".equals(param.get("type"))){
%>
	<jsp:include page="/include/header.jsp" />
<%
	}
%>	
	<%-- <jsp:include page="/mobile/include/header.jsp" /> --%>
	<div class="loginHead">
		<img src="/mobile/images/member/head.jpg" alt="" />
	</div> 	
	<div id="container" class="join">
	<!-- 내용영역 -->
	<div class="logInTop lgPop">
		<strong>비밀번호 재설정</strong>
<% 
	if(!"web".equals(param.get("type"))){
%>		
		<jsp:include page="/mobile/member/memberClose.jsp" />
<%
	}
%>
	</div>
	
	<div class="mmwrap joininner">
		<strong class="lg_resting_St">새 비밀번호를 입력해주세요</strong>
		<p class="lg_resting_P">등록하신 비밀번호는 암호화가 되어 관리자도 알 수 없습니다.<br>새로운 비밀번호를 등록해주세요.</p>
	</div>
	<form name="input_form" id="input_form">
		<table class="joinForm">
			<caption>비밀번호 재설정에 대한 내용</caption>
			<tbody>
				<tr>
					<td>
						<input type="password" name="userPwd1" id="userPwd1" style="width:100%" placeholder="새 비밀번호" maxlength="32"> 
					</td>
				</tr>
				<tr>
					<td>
						<input type="password" name="userPwd2" id="userPwd2" style="width:100%" placeholder="새 비밀번호 확인" maxlength="32">
						<p class="warn">소문자, 대문자, 숫자 특수문자 중 최소 2가지 이상, 10자리 이상 입력</p>
					</td>
				</tr>				
			</tbody>
		</table>
	</form>
	
	<div class="btnWarp">
		<a href="javascript:void(0)" class="btnCheck Large" onclick="pwdUpdate();">비밀번호 변경</a>				
	</div>	
		
	<!-- //내용영역 -->
	</div><!-- //container -->
<% 
	if("web".equals(param.get("type"))){
%>
	<jsp:include page="/include/footer.jsp" />
<%
	}
%>	
</div><!-- //wrapper -->
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
    <form name="updPwdForm" id="updPwdForm" method="post" action="<%=updPwdUrl%>">
        <input type="hidden" name="reqId" id="reqId" value="<%=id%>">
        <input type="hidden" name="reqPwd1" id="reqPwd1" value="">
        <input type="hidden" name="reqPwd2" id="reqPwd2" value="">
    </form>
</html>
