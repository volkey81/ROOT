<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.board.*" %>
<%@ include file="/include/common.jsp" %>
<%
	request.setAttribute("MENU_TITLE", new String(""));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
%>
<%
	Param param = new Param(request);
	PopupService popup = (new PopupService()).toProxyInstance();
	Param info = popup.getInfo(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script type="text/javascript"> 
	function closeWin(){
		setCookie("popup<%= info.get("seq") %>", "done" , 1);
		self.close();
	}
</script>
</head>
<body>
<div class="popWin">
	<div>
		<%= info.get("contents") %>
	</div>
	<p class="popFoot">
		<a href="#" onclick="self.close();" class="fl">닫기</a>
		<a href="#" onclick="closeWin();" class="fr">오늘하루 열지않기</a>
	</p>
</div>
</body>
</html>