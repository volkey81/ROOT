<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="com.sanghafarm.service.code.*"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="com.sanghafarm.service.board.KeywordService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", "검색결과");
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	ProductService product = (new ProductService()).toProxyInstance();
	CodeService code = new CodeService();
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 8);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("sort", param.get("sort", "pop"));
	param.set("grade_code", fs.getGradeCode());
	
	List<Param> list = product.getList(param);
	int totalCount = product.getListCount(param);
	
	// 최근 검색어 저장
	if(fs.isLogin() && !"".equals(param.get("pnm")) && nPage == 1) {
		KeywordService keyword = (new KeywordService()).toProxyInstance();
		keyword.createMemKeyword(new Param("unfy_mmb_no", fs.getUserNo(), "keyword", param.get("pnm")));
	}
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
	<form name="searchForm" id="searchForm">
		<fieldset class="pdtSrch">
			<legend>상품검색</legend>
			<label for="pName">검색어</label>
			<input type="text" name="pnm" id="pnm" value="<%= Utils.safeHTML(param.get("pnm")) %>" onKeyPress="if (event.keyCode==13){ javascript:$('#searchForm').submit()}">
			<button title="검색"><img src="/mobile/images/btn/btn_search.png" alt="검색"></button>
		</fieldset>
		</form>
		<div class="pdtListHead">
			<p class="text">총 <span class="fontTypeA"><%=totalCount %></span>개의 상품이 판매중입니다.</p>
		</div>
		<ul class="pdtList">
<%
		if (CollectionUtils.isNotEmpty(list)) {
			for(Param row : list){
				boolean isSoldOut = ("N".equals(row.get("sale_status")) || (row.getInt("opt_cnt") == 0 && row.getInt("stock") == 0));
%>					
			<li><div class="wrap">
				<div class="thumb">
<%
			if (isSoldOut) {
%>
			<div class="soldOut"><div><%= code.getCode2Name("028", row.get("soldout_msg", "001")) %></div></div>
<%
			}
%>
					<a href="detail.jsp?pid=<%= row.get("pid")%>"><img src="<%= row.get("image1") %>" alt="<%= row.get("pnm") %>"></a>
				</div>
				<a href="detail.jsp?pid=<%= row.get("pid")%>">
					<p class="tit"><%= row.get("pnm") %></p>
<%
		if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
					<p class="discount">
						<span><strong><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %></strong>%</span>
						<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
					</p>
<%
		}
%>
					<p class="price"><strong><%= Utils.formatMoney(row.get("sale_price")) %></strong>원</p>
					<p class="icon">
						<span><%= row.get("icon") %></span>
					</p>
				</a>				
			</div></li>
<%
			}
		} else {		
%>
			<li class="none">+++ 검색된 상품이 없습니다 +++</li>
<%
		}			
%>
		</ul>
		<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("search.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeToShop(out);
	}
%>
		</ul>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
setListHeight($(".pdtList")); //제품리스트 행간 높이 통일
</script>
</body>
</html>