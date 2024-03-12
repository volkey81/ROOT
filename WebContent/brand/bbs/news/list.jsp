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
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("농원소식"));
	
	Param param = new Param(request);
	FarmerMenuService menu = (new FarmerMenuService()).toProxyInstance();

	//검색파라미터 쿠키 저장
	param.keepQuery(response);
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 12);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("cate", "003");
	
	//게시물 리스트
	List<Param> list = menu.getList(param);
	//게시물 갯수
	int totalCount = menu.getListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
</head>  
<body class="bgTypeA">
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<ul class="newsList">
<%
	if (CollectionUtils.isNotEmpty(list)) {
		for(Param row : list) {
%>
			<li><a href="view.jsp?seq=<%= row.get("seq") %>">
				<p class="thumb"><img src="<%= row.get("list_img") %>" alt=""></p>
				<p class="tit"><%= row.get("title") %></p>
				<p class="cont"><%= row.get("summary") %> </p>
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
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					