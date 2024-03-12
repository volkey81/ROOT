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
<jsp:include page="/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/customer/snb.jsp" />
		<div id="contArea" class="customerPayment">
			<h1 class="typeA"><%=MENU_TITLE %><span>※ 개인 결제 문의는 고객센터  1522-3698로 연락 부탁드립니다</span></h1>
			<!-- 내용영역 -->	
			
			<table class="bbsList typeD">
				<caption>개인 결제 목록</caption>
				<colgroup>
					<col width="10%">
					<col width="12%">
					<col width="*">
					<col width="15%">
					<col width="15%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">구분</th>
						<th scope="col">결제 정보</th>
						<th scope="col">아이디</th>
						<th scope="col">상태</th>
					</tr>
				</thead>
				<tbody>
<%
	if (CollectionUtils.isNotEmpty(list)) {
		for(Param row : list) {
%>
					<tr>
						<th scope="row"><%= totalCount - ((nPage - 1) * PAGE_SIZE) - row.getInt("rnum") + 1 %></th>
						<td><%= row.get("div_name") %></td>
						<td class="tit"><a href="view.jsp?orderid=<%= row.get("orderid") %>"><%= SanghafarmUtils.maskingName(row.get("mmb_nm")) %>님 <%= row.get("regist_date") %>에 등록된 개인결제</a></td>
						<td><%= row.get("mmb_id") %></td>
						<td><%= row.get("status_name") %></td>
					</tr>
<%
		}
	} else {
%>
					<tr><td colspan="3">+++ 등록된 개인 결제가 없습니다 +++</td></tr>
<% } %>
				</tbody>
			</table>
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
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