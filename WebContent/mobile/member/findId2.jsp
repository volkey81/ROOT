<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<% 
	request.setAttribute("Depth_1", new Integer(2));
    Param param =new Param(request);
    String loginUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/login.jsp?type=" + param.get("type"); //로그인URL
    String pwsFindUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/findPwd1.jsp?type=" + param.get("type"); //비밀번호찾기URL
    String userId = Utils.safeHTML(param.get("reqId","ID")); //아이디
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

$( document ).ready(function() {
	$("#id").text("<%=userId%>");
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
		<strong>아이디찾기</strong>
<% 
	if(!"web".equals(param.get("type"))){
%>		
		<jsp:include page="/mobile/member/memberClose.jsp" />
<%
	}
%>
	</div>
	
	<div class="logMessege">
		<p>회원님의 상하농원 아이디는<br /><span id="id">farmlover</span>입니다.</p>
	</div>

	<div class="btnWarp">
		<a href="<%=loginUrl %>" class="btnCheck Large">로그인</a>	
		<a href="<%=pwsFindUrl %>" style="margin-top:5px;"class="btnCheck Large white">비밀번호 찾기</a>				
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
