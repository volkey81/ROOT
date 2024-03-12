<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
	request.setAttribute("Depth_1", new Integer(2));
	Param param = new Param(request);
	String retUrl  = request.getScheme() + "://" + request.getServerName();       //URL
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
function retUrl() {

    var retUrlChk = "<%=retUrl%>";
    
    if(parent.opener != null ) {	
        opener.location.href = retUrlChk + "/familyJoin2018/index.jsp";
        window.close();
    }else{
    	location.href = retUrlChk + "/mobile/familyJoin2018/index.jsp";
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
		<img src="/mobile/images/member/join_Complete.jpg" alt="" />
		<div class="btnWarp">
			<a href="/mobile/member/login.jsp?type=<%=param.get("type") %>" class="btnCheck Large">로그인</a>
<!-- 			<a href="/mobile/main.jsp" class="btnCheck Large white">사이트 메인 이동</a>				 -->
		</div>		
	</div>
	
	<div class="joinImg sns">
		<img src="/mobile/images/member/join_sns_1.jpg" alt="" />
		<div class="btnWarp">
			<a class="btnCheck Large pupple" href="javascript:void(0);" onclick="retUrl();">상하가족 가입하기</a>		
		</div>			
	</div>
	<p class="logInfo">※ 일반회원만 가입가능, 소셜회원은 일반회원 가입해주세요.</p>
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

<!-- NAVER SCRIPT 
<script type="text/javascript" src="//wcs.naver.net/wcslog.js"></script>
<script type="text/javascript">
var _nasa={};
_nasa["cnv"] = wcs.cnv("2","1");
</script>
-->

<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
</html>
