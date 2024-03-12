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
	final int PAGE_SIZE = param.getInt("page_size", 9);
	final int BLOCK_SIZE = 5;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	
	//게시물 리스트
	List<Param> list = svc.getList(param);
	int totalCount = svc.getListCount(param);
%>
<div class="tabArea">
	<a href="" class="on" onclick=""><div class="thum" style="background-image:url(/images/brand/play/experience_tab0.png);"></div>전체</a>
	<a href=""><div class="thum" style="background-image:url(/images/brand/play/experience_tab1.png);"></div>농부체험</a>
	<a href=""><div class="thum" style="background-image:url(/images/brand/play/experience_tab2.png);"></div>먹거리<br>체험</a>
</div>
<ul class="programList">
<%
	for(Param row : list) {
%>
		<li>
			<a href="view.jsp?seq=<%= row.get("seq")%>">
				<div class="thum"><img src="<%= row.get("thumb") %>" alt=""></div>
				<div class="cont">
					<div class="cate"><img src="/images/brand/play/img_tag01.jpg" alt="카테고리"></div>
					<strong><%= row.get("title") %></strong>
					<p>컨텐츠 내용</p>
				</div>
			</a>
		</li>
	<% } %>
	<li>
		<a href=""><!--  마감된건 링크도 빼주셔야 하 -->
			<div class="thum"><img src="/sanghafarm_Data/upload/shop/board/201704/thumb_1491295074850.JPG" alt=""></div>
			<div class="cont">
				<div class="cate"><img src="/images/brand/main/news_cate_001.jpg" alt="카테고리"></div>
				<strong>소시지 만들기</strong>
				<p>컨텐츠 내용</p>
			</div>
		</a>
		<div class="end">
			<p>
				<strong>마감</strong>
				다음에 또 만나요!
			</p>
		</div>
	</li><!--마감 예시 -->
</ul>
<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging("javascript:paging('[page]',1)", totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeToShop(out);
	}
%>
</ul>