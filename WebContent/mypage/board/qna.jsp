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
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
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
				<caption>상품 Q&A내역 목록</caption>
				<colgroup>
					<col width="70"><col width="210"><col width=""><col width="120">
				</colgroup>
				<thead>
					<tr>
						<th scope="col" colspan="2">상품명</th>
						<th scope="col">문의내용</th>
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
						<th scope="row" class="vt"><p class="thumb"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="/images/upload/pdt.jpg" alt="" width="39" height="43"></a></p></th>
						<td class="vt al pName"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>"><%= row.get("pnm") %><br><span class="fs fontTypeC">(<%= row.get("pid") %>)</span></a></td>
						<td class="tit"><a href="#myQnaCont<%= i %>" onclick="showTab2(this, 'myQnaCont'); return false"><%= Utils.safeHTML(row.get("title")) %></a></td>
						<td <%= StringUtils.isEmpty(row.get("answer")) ? "" : "class='fontTypeA'" %>><%= StringUtils.isEmpty(row.get("answer")) ? "답변대기" : "답변완료" %></td><!-- 답변완료 : class="fontTypeA" -->
						<td><%= row.get("regist_date") %></td>
					</tr>
					<tr class="myQnaCont" id="myQnaCont<%= i++ %>" style="display:none"><td colspan="4" style="display:none">
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
							<tr><td colspan="5">+++ 상품 Q&A내역이 없습니다 +++</td></tr>
<%
	}
%>
				</tbody>
			</table>
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("myQna.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
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