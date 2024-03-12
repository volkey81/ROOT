<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(0));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("인스타그램"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
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
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<!-- 내용영역 -->	
			<p class="visual"><img src="/mobile/images/customer/visual_insta_170818.jpg" alt="상하농원 인스타그램"></p>
			<div class="instaList">
				<div class="attractt-container" data-idx="0" data-code="c00GqlLzWpp5uwx" data-board="waterfall"></div>
			</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>