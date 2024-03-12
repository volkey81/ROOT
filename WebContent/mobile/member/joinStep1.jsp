<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	Param param = new Param(request);
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
	
	<div class="joinImg">
		<img src="/mobile/images/member/join_Step.jpg" alt="" />
	</div>

	<div class="btnWarp">
		<a href="/mobile/member/joinStep2.jsp?type=<%=param.get("type") %>" class="btnCheck Large">가입</a>				
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
