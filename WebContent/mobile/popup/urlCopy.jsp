<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.product.*,
				 com.sanghafarm.service.code.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("상하가족 추천하기"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");

	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script src="/js/clipboard.min.js"></script>
<script>
	$(function() {
		var clipboard = new Clipboard('.sizeL');

		clipboard.on('success', function(e) {
			alert("복사되었습니다.");
		});
	});
</script>
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<div class="urlAddressCopy">
			<p>나의 고유주소(URL)를 통해<br>친구가 상하가족이 되시면,<br>추천 보너스로 <br><span>매일Do 3,000포인트</span>가 적립됩니다.</p>
			<div class="btnArea">
				<input type="text" name="myurl" id="myurl" value="http://<%= request.getServerName() %>/mobile/familyJoin/index.jsp?r=<%= fs.getUserNo() %>" readonly>
				<button class="btnTypeB sizeL" data-clipboard-target="#myurl">URL 복사하기</button>
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