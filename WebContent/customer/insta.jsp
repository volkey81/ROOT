<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(0));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", "인스타그램");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script type="text/javascript">
     (function(d, s) {
                var j, e = d.getElementsByTagName(s)[0], h = "https://cdn.attractt.com/embed/js/dist/embed.min.js";
                if (typeof AttracttTower === "function" || e.src === h) { return; }
                j = d.createElement(s);
                j.src = h;
                j.async = true;
                e.parentNode.insertBefore(j, e);
     })(document, "script");
</script>
</head>  
<body>
<div id="wrapper" class="fullpage">
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<p class="instaVisual">상하농원 인스타그램, 상하농원 파머스마켓에서 어떤 고객들이 어떤 상품을 구매하여 어떤 사진을 올렸는지 함께 구경해요</p>
		<div class="instaList">
			<div class="attractt-container" data-idx="0" data-code="c00GqlLzWpp5uwx" data-board="waterfall"></div>
		</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>