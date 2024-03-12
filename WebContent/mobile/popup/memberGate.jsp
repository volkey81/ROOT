<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="com.efusioni.stone.utils.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("회원주문/비회원주문 선택"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
	Param param = new Param(request);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
	function goOrder() {
<%
	if("cart".equals(param.get("call"))) {
%>
		parent.submitOrder();
<%
	} else {
%>
		parent.location.href = "/mobile/order/payment.jsp";
<%
	}
%>
	}

	function goLogin() {
<%
	if("cart".equals(param.get("call"))) {
%>
		parent.fnt_login("submitOrder");
<%
	} else {
%>
		parent.fnt_login("O");
<%
	}
%>
		hidePopupLayer();
	}
	
	function goJoin() {
		parent.fnt_join();
		hidePopupLayer();
	}
</script>
</head>
<!-- 580* -->
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<p class="text">로그인 후 회원으로 주문하시면 아래와 같은 혜택을 누리실 수 있습니다.</p>
		<div class="cautionBox">
			<ul class="caution">
				<li>다양한 상품구매와 함께 쿠폰할인 혜택을 받으실 수 있습니다.</li>
				<li>회원전용의 다양한 서비스! 상품평, 이벤트 참여가 가능합니다.</li>
				<li>회원 가입을 하시면, 상하농원을 포함한 매일유업㈜의 매일 family 통합회원 온라인 서비스도 함께 이용하실 수 있습니다.</li>
			</ul>
		</div>
		<div class="btnArea">
			<span><a href="#none" onclick="goOrder();" class="btnTypeA sizeL">비회원 주문</a></span>
			<span><a href="#none" onclick="goLogin();" class="btnTypeB sizeL short">로그인후 회원주문</a></span>
		</div>
		<div class="goLogin">
			아직 회원이 아니세요? <a href="#none" onclick="goJoin()" class="btnTypeC sizeS">회원가입</a>
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