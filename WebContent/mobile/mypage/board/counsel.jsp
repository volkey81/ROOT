<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.board.CounselService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("1:1 문의내역"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	CounselService counsel = (new CounselService()).toProxyInstance();
	param.set("userid", fs.getUserId());
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	//게시물 리스트
	List<Param> list = counsel.getList(param);
	//게시물 갯수
	int totalCount = counsel.getListCount(param);
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
		<ol class="myQnaList">
<%
	int i = 0;
	for(Param row : list) {
%>	
			<li>
				<div class="head">
					<a href="#counselCont<%=i %>" onclick="showTab2(this, 'counselCont');return false">
						<p class="cate">[<%= row.get("cate_name") %>]</p>
						<p class="tit"><%= Utils.safeHTML(row.get("title")) %></p>
						<p class="date"><%= row.get("regist_date") %><span class="status<%= StringUtils.isEmpty(row.get("answer")) ? "" : " fontTypeA" %>"><%= StringUtils.isEmpty(row.get("answer")) ? "답변대기" : "답변완료" %></span></p>
					</a>
				</div>
				<div class="counselCont" id="counselCont<%=i++ %>" style="display:none">
					<div class="qa">
						<div class="question">
							<%= Utils.safeHTML(row.get("question"), true) %><br/><br/>
<%
		if (StringUtils.isNotEmpty(row.get("image"))) {
%>
							<img alt="" src="<%= row.get("image") %>">
<%
		} 
		if (StringUtils.isNotEmpty(row.get("image2"))) {
%>
							<img alt="" src="<%= row.get("image2") %>">
<%
		} 
		if (StringUtils.isNotEmpty(row.get("image3"))) {
%>
							<img alt="" src="<%= row.get("image3") %>">
<%
		}
%> 
						</div>
<%
		if(StringUtils.isNotEmpty(row.get("answer"))) {
%>
						<div class="answer">
							<%= Utils.safeHTML(row.get("answer"), true) %>
						</div>
<%
		}
%>
					</div>
				</div>
			</li>
<%
	}

	if(totalCount == 0) {
%>
			<li class="none">+++ 1:1 문의내역이 없습니다 +++</li>
<%
	}
%>
		</ol>
		<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("counsel.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
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