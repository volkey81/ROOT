<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
    Param param = new Param(request);
    String snsJoinUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/joinSns2.jsp?";//SNS회원가입URL
    snsJoinUrl = snsJoinUrl + "socNm=" +  URLEncoder.encode(Utils.safeHTML((param.get("socNm",""))),"UTF-8")
                            + "&socId=" + Utils.safeHTML(param.get("socId",""));
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
$(function(){

});
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
	<div class="loginHead">
		<img src="/mobile/images/member/head.jpg" alt="" />
	</div> 	
	<div id="container" class="join">
	<!-- 내용영역 -->
<% 
	if(!"web".equals(param.get("type"))){
%>	
	<div class="logInTop lgPop">
		<strong>회원가입</strong>	
		<jsp:include page="/mobile/member/memberClose.jsp" />
	</div>
<%
	}
%>
	
	<div class="mmwrap joininner">
		<strong class="lg_resting_St">SNS회원이 가입되어있지 않습니다.</strong>
		<p class="lg_resting_P" style="padding-bottom:0;">SNS회원은 간편로그인을 위하여 지원하는 기능으로<br />이벤트 및 혜택, 상하가족 가입에 제한이 있을 수 있습니다.</p>
		<p class="lg_resting_P">상하가족 가입을 원하시는 분은<br />일반회원으로 가입해주시기 바랍니다.</p>
	</div>

	<div class="btnWarp">
		<a href="<%=snsJoinUrl%>" class="btnCheck Large">SNS 회원 가입</a>	
		<a href="/mobile/member/joinStep2.jsp" style="margin-top:5px;"class="btnCheck Large white">일반 회원 가입</a>				
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
</html>
