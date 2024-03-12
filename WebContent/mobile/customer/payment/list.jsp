<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.utils.*"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.order.*"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(4));
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("개인 결제"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	PersonalPayService personal = (new PersonalPayService()).toProxyInstance();
	
	//검색파라미터 쿠키 저장
	param.keepQuery(response);
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	//게시물 리스트
	List<Param> list = personal.getList(param);
	//게시물 갯수
	int totalCount = personal.getListCount();
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
			<li>
				<a href="view.jsp?orderid=<%= row.get("orderid") %>">
				<p class="tit"><%= SanghafarmUtils.maskingName(row.get("mmb_nm")) %>님 <%= row.get("regist_date") %>에 등록된 개인결제</p>
				<p class="state"><%= row.get("status_name") %></p>
				</a>
			</li>
<%
		}
	} else {
%>
			<li>+++ 등록된 개인 결제가 없습니다 +++</li>
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