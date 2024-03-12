<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<% 
	request.setAttribute("Depth_1", new Integer(2));
    Param param =new Param(request);
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
	<%-- <jsp:include page="/mobile/include/header.jsp" /> --%>
	<div class="loginHead">
		<img src="/mobile/images/member/head.jpg" alt="" />
	</div> 	
	<div id="container" class="join">
	<!-- 내용영역 -->
	<div class="logInTop lgPop">
		<strong>아이디 찾기</strong>
<% 
	if(!"web".equals(param.get("type"))){
%>		
		<jsp:include page="/mobile/member/memberClose.jsp" />
<%
	}
%>
	</div>
	<div class="mmwrap joininner">
		<strong class="lg_resting_St">아이디 찾기에 실패하였습니다.</strong>	
		<p class="lg_resting_P" style="padding-bottom:0;">입력하신 정보와 일치하는 회원을 찾지 못하였거나<br />찾는 도중에 문제가 발생하였습니다.</p>
		<p class="lg_resting_P">상하농원 고객센터 1522-3698 또는<br />매일Do 고객센터 1588-1539로 문의주세요.</p>
	</div>

	<div class="btnWarp">
		<a href="/mobile/main.jsp" class="btnCheck Large">메인으로 이동</a>			
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
