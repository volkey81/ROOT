<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.board.FarmerMenuService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("레시피"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FarmerMenuService menu = (new FarmerMenuService()).toProxyInstance();

	//검색파라미터 쿠키 저장
	param.keepQuery(response);
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 6);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("cate", "001");
	
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
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="search">
			<form id="fmenuForm">
			<fieldset>
				<legend>레시피 검색</legend>
				<select name="keytype" title="유형선택">
					<option value="1" <%= "1".equals(param.get("keytype")) ? "selected" : "" %>>전체</option>
					<option value="2" <%= "2".equals(param.get("keytype")) ? "selected" : "" %>>레시피 제목</option>
					<option value="3" <%= "3".equals(param.get("keytype")) ? "selected" : "" %>>식재료 상품</option>
				</select> 
				<input type="text" name="keyword" value="<%= param.get("keyword") %>" title="검색어"> 
				<a href="#" onclick="$('#fmenuForm').submit()" class="btnTypeB sizeS">검색</a>
			</fieldset>
			</form>
		</div>
		<ul class="recipeList">
<%
	if (CollectionUtils.isNotEmpty(list)) {
		for(Param row : list) {
%>
			<li><a href="view.jsp?seq=<%= row.get("seq") %>">
				<p class="thumb"><img src="<%= row.get("banner_img") %>" alt=""></p>
				<div class="cont">
					<p class="tit"><%= row.get("title") %></p>
					<p class="text"><%= row.get("summary") %> </p>
				</div>
			</a></li>
<%  	}
	} else {
%>
			<li class="none">+++ 등록된 레시피가 없습니다 +++</li>
<%  } %>
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
</body>
</html>