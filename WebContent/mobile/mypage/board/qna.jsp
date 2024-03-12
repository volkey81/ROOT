<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.board.ProductQnaService"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("상품 Q&A내역"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);

	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	ProductQnaService qna = (new ProductQnaService()).toProxyInstance();
	param.set("userid", fs.getUserId());
	param.set("sort", "userid");
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	//게시물 리스트
	List<Param> list = qna.getList(param);
	//게시물 갯수
	int totalCount = qna.getListCount(param);
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
					<a href="#myQnaCont<%=i %>" onclick="showTab2(this, 'myQnaCont');return false">
						<p class="pdt"><%= row.get("pnm") %> <span class="fontTypeC">(<%= row.get("pid") %>)</span></p>
						<p class="tit"><%= Utils.safeHTML(row.get("title")) %></p>
						<p class="date"><%= row.get("regist_date") %><span class="status <%= StringUtils.isEmpty(row.get("answer")) ? "" : "class='fontTypeA'" %>"><%= StringUtils.isEmpty(row.get("answer")) ? "답변대기" : "답변완료" %></span></p>
					</a>
				</div>
				<div class="myQnaCont" id="myQnaCont<%=i++ %>" style="display:none">
					<div class="qa">
						<div class="question">
							<%= Utils.safeHTML(row.get("question"), true) %>
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
			<li class="none">+++ 상품 Q&A내역이 없습니다 +++</li>
<%
	}
%>			
		</ol>
		<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("myQna.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
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