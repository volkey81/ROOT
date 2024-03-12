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
<h3>레시피에 사용된 상품</h3>
<ul class="list">
<%
		if (CollectionUtils.isNotEmpty(recipeProductList)) {
			for (Param row : recipeProductList) {	
%>
	<li><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
		<p class="thumb"><img src="<%= row.get("thumb") %>" alt=""></p>
		<div class="cont">
			<p class="tit"><%= row.get("pnm") %></p>
			<p class="price"><strong><%=Utils.formatMoney(row.get("sale_price")) %></strong>원</p>
		</div>
	</a></li>
<%
			}
		}
%>
</ul>
<%
		if (recipeProductList.size() > 1) {
%>
<input type="image" src="/images/main/btn_prev4.png" alt="이전" class="prev">
<input type="image" src="/images/main/btn_next4.png" alt="다음" class="next">
<%
		}
%>