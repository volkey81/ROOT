<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.service.board.NoticeService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(4));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("공지사항"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	NoticeService notice = (new NoticeService()).toProxyInstance();
	
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
<jsp:include page="/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/customer/snb.jsp" />
		<div id="contArea">
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<!-- 내용영역 -->
			<div class="bbsView">
				<div class="head">
					<h2><%= info.get("title") %></h2>
					<%
					if (StringUtils.isNotEmpty(info.get("wdate"))) {
					%>
					<p class="date"><%= info.get("wdate").substring(0, 10) %></p>
					<% } %>
				</div>
				<div class="content">
					<%= info.get("contents") %>
				</div>
			</div>
			<dl class="pvnt">
						<dt>이전</dt>
<%
	if(prev != null && !"".equals(prev.get("seq"))) {
%>					
						<dd><a href="view.jsp?seq=<%= prev.get("seq") %>"><%= prev.get("title") %></a><span class="date"><%= prev.get("wdate").substring(0, 10) %></span></dd>
<%
	} else {
%>
						<dd>이전글이 없습니다.</dd>
<%	} %>
						<dt>다음</dt>
<%
	if(next != null && !"".equals(next.get("seq"))) {
%>
						<dd><a href="view.jsp?seq=<%= next.get("seq") %>"><%= next.get("title") %></a><span class="date"><%= next.get("wdate").substring(0, 10) %></span></dd>
<%
	} else {
%>
						<dd>다음글이 없습니다.</dd>
<%	} %>
			</dl>
			<div class="btnArea ac">
				<a href="<%= param.backQuery() %>" class="btnTypeB">목록</a>
			</div>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>