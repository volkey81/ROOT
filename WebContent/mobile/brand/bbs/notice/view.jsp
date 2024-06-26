<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.service.board.BrandNoticeService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("공지사항"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	BrandNoticeService notice = (new BrandNoticeService()).toProxyInstance();
	
	if(StringUtils.isEmpty(param.get("seq"))) {
		Utils.sendMessage(out, "잘못된 접근입니다.");
		return;
	}
	
	Param info = notice.getInfo(param);
	Param prev = notice.getPrevInfo(param);
	Param next = notice.getNextInfo(param);
	notice.modifyHit(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
</head>  
<body class="bgTypeA">
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="notice">
		<h1 class="typeA">공지사항</h1>
		<!-- 내용영역 -->
		<div class="bbsView">
			<div class="head">
				<h2><%= info.get("title") %></h2>
				<p class="date"><%= info.get("wdate").substring(0, 10) %></p>
			</div>
			<div class="content">
				<%= info.get("contents") %>
			</div>
		</div>
		<div class="btnArea">
			<a href="<%= param.backQuery() %>" class="btnTypeA sizeL">목록</a>
		</div>
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					