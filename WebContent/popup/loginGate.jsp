<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="com.efusioni.stone.utils.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("로그인"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
	Param param = new Param(request);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
function goLogin() {
	parent.fnt_login("O");
	hidePopupLayer();
	
	//로그인팝업으로 띄울때
	//showPopupLayer('/mobile/mypage/login.jsp', '520');
	//hidePopupLayer(<%=layerId%>, 'reset');
}
	
function goJoin() {
	parent.fnt_join();
	hidePopupLayer();
}
</script>
</head>  
<!-- 520 -->
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<div class="loginGate">
			<p class="text">본 서비스는 <strong class="fontTypeB">통합멤버십 회원에게만 제공</strong>됩니다.<br>로그인 후 이용 부탁드립니다.</p>
			<div class="btnArea">
				<a href="#" onclick="goLogin()" class="btnTypeA">로그인</a>
			</div>	
		</div>
		<div class="goLogin">
			아직 회원이 아니세요? <a href="#" onclick="goJoin()" class="btnTypeC sizeS">회원가입</a>
		</div>
	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->
<script>
//팝업높이조절
setPopup(<%=layerId%>);
</script>
</body>
</html>