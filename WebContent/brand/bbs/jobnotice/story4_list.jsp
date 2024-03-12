<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.board.BrandNoticeService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("Depth_4", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("입사지원하기"));

	
	Param param = new Param(request);
	BrandNoticeService notice = (new BrandNoticeService()).toProxyInstance();
	
	//검색파라미터 쿠키 저장
	param.keepQuery(response);
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("cate", "003");
	
	//게시물 리스트
	List<Param> list = notice.getList(param);
	//게시물 갯수
	int totalCount = notice.getListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
</head>  
<body class="bgTypeA">
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location_job.jsp" />

<div id="snbBrand">

	<ul class="menu01">
		<!--<li><a href="/brand/introduce/story.jsp">채용공고</a></li>-->
		<li><a href="/brand/bbs/jobnotice/story1.jsp">핵심가치</a></li>
		<li><a href="/brand/bbs/jobnotice/story2.jsp">인재상</a></li>
		<li><a href="/brand/bbs/jobnotice/story3.jsp">복리후생</a></li>
		<li class="on"><a href="/brand/bbs/jobnotice/story4_list.jsp">입사지원하기</a></li>
	</ul>
</div>

	<div id="container" class="bbsNotice">
		<!-- 내용영역 -->
		<div id="contArea">
			<h1 class="typeA">입사지원하기</h1>
			<!-- 내용영역 -->	
			<table class="bbsList typeD">
				<caption>공지사항 목록</caption>
				<colgroup>
					<col width="90"><col width="">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">제목</th>
					</tr>
				</thead>
				<tbody>
<%
	if (CollectionUtils.isNotEmpty(list)) {
		for(Param row : list) {
%>
					<tr>
						<th scope="row"><%= totalCount - ((nPage - 1) * PAGE_SIZE) - row.getInt("rnum") + 1 %></th>
						<td class="tit"><a href="story4_view.jsp?seq=<%= row.get("seq") %>"><%= row.get("title") %></a></td>
<!-- 						<td>채용중</td> -->
<%-- 						<td><%= row.get("wdate").substring(0, 10) %></td> --%>
					</tr>
<%
		}
	} else {
%>
					<tr><td colspan="2">+++ 등록된 채용 공지가 없습니다 +++</td></tr>
<% } %>
				</tbody>
			</table>
			<ul class="paging typeB">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
			</ul>
		</div><!-- //contArea -->
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					