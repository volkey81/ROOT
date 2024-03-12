<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.board.NoticeService"%>
<%@page import="com.efusioni.stone.utils.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
				<div class="search">
					<form name="noticeForm" id="noticeForm">
						<fieldset>
							<legend>공지사항 검색</legend>
							<select name="keytype" id="keytype" title="유형선택"
								style="width: 145px">
								<option value="">전체</option>
								<option value="01"
									<%= param.get("keytype").equals("01") ? "selected" : "" %>>제목</option>
							</select> <input type="text" name="keyword" id="keyword" title="검색어"
								style="width: 290px"
								value="<%= Utils.safeHTML2(param.get("keyword")) %>"> <a
								href="javascript:void(0)" onclick="$('#noticeForm').submit()"
								class="btnTypeA sizeL">검색</a>
						</fieldset>
					</form>
				</div>
				<table class="bbsList typeD">
					<caption>공지사항 목록</caption>
					<colgroup>
						<col width="90">
						<col width="">
						<col width="130">
					</colgroup>
					<thead>
						<tr>
							<th scope="col">번호</th>
							<th scope="col">제목</th>
							<th scope="col">등록일</th>
						</tr>
					</thead>
					<tbody>
						<%
	if (CollectionUtils.isNotEmpty(list)) {
		for(Param row : list) {
%>
						<tr>
							<th scope="row"><%= totalCount - ((nPage - 1) * PAGE_SIZE) - row.getInt("rnum") + 1 %></th>
							<td class="tit"><a href="view.jsp?seq=<%= row.get("seq") %>"><%= row.get("title") %></a></td>
							<td><%= row.get("wdate").substring(0, 10) %></td>
						</tr>
						<%
		}
	} else {
%>
						<tr>
							<td colspan="3">+++ 등록된 공지사항이 없습니다 +++</td>
						</tr>
						<% } %>
					</tbody>
				</table>
				<ul class="paging">
					<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(Utils.safeHTML2(param.toQueryString("list.jsp")), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
				</ul>
				<!-- //내용영역 -->
			</div>
			<!-- //contArea -->
		</div>
		<!-- //container -->
		<jsp:include page="/include/footer.jsp" />
	</div>
	<!-- //wrapper -->
</body>
</html>