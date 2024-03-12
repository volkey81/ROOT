<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.hotel.*,
			com.sanghafarm.service.code.*,
			com.sanghafarm.utils.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("빌리지 소개"));
	
	Param param = new Param(request);
	HotelNoticeService svc = new HotelNoticeService();
	CodeService code = new CodeService();
	
	//검색파라미터 쿠키 저장
	param.keepQuery(response);
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	//게시물 리스트
	List<Param> list = svc.getList(param);
	//게시물 갯수
	int totalCount = svc.getListCount(param);

	List<Param> cateList = code.getList2("035");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />

</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel village">
		<!-- 내용영역 -->		
		<jsp:include page="/hotel/village/villageTab.jsp" />
		<div class="villageTop villageList">
			<p class="animated fadeInUp delay02">파머스빌리지의 새로운 소식과<br>문의사항을 알려드립니다.</p>
			<div class="search animated fadeInUp delay02">
				<form name="noticeForm" id="noticeForm" action="list.jsp" method="get">
				<select name="cate">
					<option value="">전체</option>
<%
	for(Param row : cateList) {
%>
					<option value="<%= row.get("code2") %>" <%= row.get("code2").equals(param.get("cate")) ? "selected" : "" %>><%= row.get("name2") %></option>
<%
	}
%>
				</select>
				<input type="text" name="keyword" value="<%= Utils.safeHTML2(param.get("keyword")) %>">
				<a href="javascript:$('#noticeForm').submit()" class="searchBtn">검색</a>
				</form>
			</div>
		</div>		
		<div class="noticeArea">
			<table>
				<colgroup>
					<col width="7%">
					<col width="*">
					<col width="15%">
				</colgroup>
				<tbody>
<% 
	if(list.size() > 0){
		for(Param row : list) {
%>
				<tr class="animated fadeIn">
					<td><%= totalCount - ((nPage - 1) * PAGE_SIZE) - row.getInt("rnum") + 1 %></td>
					<td class="al"><span class="<%= "001".equals(row.get("cate")) ? "norice" : "pr" %>Icon"><%= row.get("cate_name") %></span><a href="view.jsp?seq=<%= row.get("seq") %>&cate=<%= param.get("cate") %>&keyword=<%= param.get("keyword") %>"><%= row.get("title") %></a></td>
					<td><%= row.get("wdate").substring(0, 10) %></td>
				</tr>
<%
		}
	} else {
%>
				<tr>
					<td colspan="3" class="none">** 게시물이 없습니다. **</td>
				</tr>
<%
	}
%>
			</tbody>
			</table>
			<ul class="paging animated fadeIn delay10">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(Utils.safeHTML2(param.toQueryString("list.jsp")), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
			</ul>
		</div>

		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
