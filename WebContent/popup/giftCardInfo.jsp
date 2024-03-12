<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("MENU_TITLE", new String("기프트 카드 안내"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
</head>
<!-- 580* -->
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<div class="cautionBox">
			<ul class="caution">
				<li>일정 금액을 충전하여 매일유업 제휴 브랜드 매장에서 사용할 수 있는 충전식 선불카드 입니다.</li>
				<li>매장 또는 앱을 통해 언제든지 충전하여 사용할 수 있으나,  Maeil Do 멤버십에 가입하신 후 앱에 카드를 등록하시면 좀더 편리하게 결제 및 충전이 가능하며, Maeil Do 포인트 혜택도 누릴 수 있습니다.</li>
				<li>매일유업 제휴 브랜드 매장 또는 Maeil Do 앱에서 구매 및 선물 할 수 있습니다.</li>
			</ul>
		</div>
		<p class="text textBottom">※ 더 자세한 사항은 Maeil Do 앱에서 확인 하실 수 있습니다. </p> 
		<div class="btnArea">
			<a href="https://www.maeildo.com/co/io/coio01t3.do" target="_blank" class="btnTypeB sizeL">자세히보기</a>
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