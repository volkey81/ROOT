<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="com.sanghafarm.service.brand.ExpClassService"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.sanghafarm.service.board.ReviewService"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 

	FrontSession fs = FrontSession.getInstance(request, response);

	Param param = new Param(request);
	ExpClassService svc = (new ExpClassService()).toProxyInstance();
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 2);
	final int BLOCK_SIZE = 5;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	
	//게시물 리스트
	List<Param> list = svc.getList(param);
	int totalCount = svc.getListCount(param);
%>
<ul class="programList">
<%
	for(Param row : list) {
%>
		<li><a href="view.jsp?seq=<%= row.get("seq")%>">
			<p class="thumb"><img src="<%= row.get("thumb") %>" alt=""></p>
			<p class="tit"><%= row.get("title") %></p>
		</a></li>
	<% } %>
</ul>
<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging("javascript:paging('[page]')", totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeToShop(out);
	}
%>
</ul>