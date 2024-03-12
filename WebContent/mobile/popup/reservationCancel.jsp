<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.product.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("예약 취소"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script src="/mobile/js/clipboard.min.js"></script>

</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<div class="resCancelNotice">
			<p>투숙예정일로부터 7일 이내 예약 건은<br>온라인 취소가 불가능합니다.<br>취소를 원하시는 경우 <span>고객센터 : 1522-3698</span>로<br>연락 주시어 취소하시기 바랍니다.</p>
			<div class="btnArea">
				<button class="btnTypeB sizeL" onclick="hidePopupLayer();">확인</button>
			</div>
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

