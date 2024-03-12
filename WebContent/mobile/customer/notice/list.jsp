<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
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
	
	//검색파라미터 쿠키 저장
	param.keepQuery(response);
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	//게시물 리스트
	List<Param> list = notice.getList(param);
	//게시물 갯수
	int totalCount = notice.getListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->
		<ul class="noticeList">
<%
	if (CollectionUtils.isNotEmpty(list)) {
		for(Param row : list) {
%>		
			<li><a href="view.jsp?seq=<%= row.get("seq") %>">
				<p class="tit"><%= row.get("title") %></p>
				<p class="date"><%= row.get("wdate").substring(0, 10) %></p>
			</a></li>
<%
		}
	} else {
%>
			<li>+++ 등록된 공지사항이 없습니다 +++</li>
<%
	} 
%>			
		</ul>
		<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
		</ul>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>