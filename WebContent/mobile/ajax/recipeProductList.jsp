<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.board.FarmerMenuService"%>
<%@page import="com.sanghafarm.common.*"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	FarmerMenuService menu = (new FarmerMenuService()).toProxyInstance();
	param.set("grade_code", fs.getGradeCode());
	
	List<Param> recipeProductList = menu.getProductList(param);
%>
<div class="slideCont">
	<ul class="list swiper-wrapper">
<%
		if (CollectionUtils.isNotEmpty(recipeProductList)) {
			for (Param row : recipeProductList) {	
%>
		<li class="swiper-slide"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
			<p class="thumb"><img src="<%= row.get("thumb") %>" alt=""></p>
			<p class="tit">군고구마 양갱으로 쉽게 만드는<span><%= row.get("pnm") %></span></p>
			<p class="tag">
				<a href="/product/detail.jsp"># 청오건강 무농약 찹쌀가루 500g</a><br>
				<a href="/product/detail.jsp"># 상하농원 친환경 고구마 1kg</a><br>
				<a href="/product/detail.jsp"># 상하농원 군고구마 양갱 1개입</a><br>
			</p>
		</a></li>
<%
			}
		}
%>
	</ul>
</div>
<%
	if (recipeProductList.size() > 3) {				
%>
<ul class="swiperNav">
</ul>
<%
	}
%>