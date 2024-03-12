<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("MENU_TITLE", new String("장바구니 담기 완료"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<div class="cartComplete">
			<p>선택하신 상품을<br>장바구니에 담았습니다.</p>
		</div>
		<div class="btnArea">
			<span><a href="#" onclick="hidePopupLayer(); return false" class="btnTypeA sizeL">계속쇼핑</a></span>
			<span><a href="/mobile/order/cart.jsp" target="_parent" class="btnTypeB sizeL">장바구니 이동</a></span>
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