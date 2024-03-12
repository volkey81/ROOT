<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*" %>
<%
	request.setAttribute("Depth_1", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("파머스 빌리지 상담"));
	String MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	var v;
	var isProgress = false;

	function passCheck(){
	 	if($("#passwd").val() == '') {
			alert("비밀번호를 입력해 주세요.");
			$("#passwd").focus();
			return;
		} else {
			$("#counselPassForm").submit();
		}
	}	 
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="cautionBox tc">
			비밀번호를 잊어버리신 경우<br>고객센터에 연락주세요.<br><br>1522-3698
		</div>
		<!-- 내용영역 -->			
		<form name="counselPassForm" id="counselPassForm" action="qa.jsp" method="POST">
			<input type="hidden" name="seq" value="<%= param.get("seq") %>" />
			<p>파머스빌리지 상담 시 등록한<br>비밀번호를 입력해 주세요.</p>
			<input type="password" name="passwd" id="passwd">
			<div class="btnArea">
				<span><a href="#" onClick="passCheck();" class="btnTypeF">확인</a></span>
			</div>
		</form>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>