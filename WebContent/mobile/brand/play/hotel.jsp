<%@page import="com.sanghafarm.service.brand.ImageBoardService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(7));
	request.setAttribute("MENU_TITLE", new String("파머스 빌리지"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "013");
	List<Param> imageBoardList = imageBoard.getList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>

</script>
</head>  
<body class="playWrapper">
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="playArea hotel">
			<p class="brantTopTxt" style="padding-bottom:30.2%">건강한 휴식이 있는<br>농부의 쉼터, 파머스 빌리지</p>
			<div class="txtArea">
				<img src="/mobile/images/brand/play/hotel02.jpg" alt="">
				<p>농부의 정성까지 담은 객실과 부대시설로 편안하게!</p>	
			</div>
		</div>		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					