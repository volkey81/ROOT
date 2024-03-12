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
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
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
<jsp:include page="/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/mypage/snb.jsp" />
		<div id="contArea">
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<!-- 내용영역 -->	
			<p class="caution">항상 최선을 다하는 상하농원이 되겠습니다.</p>		
			<table class="bbsList typeD">
				<caption>1:1 문의내역 목록</caption>
				<colgroup>
					<col width="130"><col width=""><col width="100"><col width="130">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">유형</th>
						<th scope="col">제목</th>
						<th scope="col">답변여부</th>
						<th scope="col">등록일</th>
					</tr>
				</thead>
				<tbody>
<%
	int i = 0;
	for(Param row : list) {
%>
					<tr>
						<th scope="row"><%= row.get("cate_name") %></th>
						<td class="tit"><a href="#counselCont<%=i %>" onclick="showTab2(this, 'counselCont'); return false"><%= Utils.safeHTML(row.get("title")) %></a></td>
						<td <%= StringUtils.isEmpty(row.get("answer")) ? "" : "class='fontTypeA'" %>><%= StringUtils.isEmpty(row.get("answer")) ? "답변대기" : "답변완료" %></td><!-- 답변완료 : class="fontTypeA" -->
						<td><%= row.get("regist_date") %></td>
					</tr>
					<tr class="counselCont" id="counselCont<%=i++ %>" style="display:none"><td colspan="4" style="display:none">
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
							<p class="btn"><a href="#" onclick="hideTab2(this); return false">닫기</a></p>
<%
		}
%>
						</div>
					</td></tr>
<%
	}

	if(totalCount == 0) {
%>
							<tr>
								<td colspan="4">+++ 1:1 문의내역이 없습니다 +++</td>
							</tr>
<%
	}
%>
				</tbody>
			</table>
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("counsel.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
			</ul>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>