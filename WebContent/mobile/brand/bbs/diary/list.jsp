<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.board.FarmerMenuService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("농부의 일기"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FarmerMenuService menu = (new FarmerMenuService()).toProxyInstance();

	//검색파라미터 쿠키 저장
	param.keepQuery(response);
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 9);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("cate", "002");
	
	//게시물 리스트
	List<Param> list = menu.getList(param);
	//게시물 갯수
	int totalCount = menu.getListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
</head>  
<body class="bgTypeA">
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<ul class="newsList">
<%
	if (CollectionUtils.isNotEmpty(list)) {
		for(Param row : list) {
%>
			<li><a href="view.jsp?seq=<%= row.get("seq") %>" class="wrap">
				<p class="thumb"><img src="<%= row.get("list_img") %>" alt=""></p>
				<p class="tit"><%= row.get("title") %></p>
				<p class="date"><%= row.get("regist_date") %></p>
			</a></li>
<%
		}
	} else {
%>
			<li class="none">+++ 등록된 소식이 없습니다. +++</li>
<%
	}			
%>
		</ul>
		<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeToShop(out);
	}
%>
		</ul>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
setListHeight(".newsList");
</script>
</body>
</html>
					