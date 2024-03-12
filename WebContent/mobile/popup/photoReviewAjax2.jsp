<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.board.*" %>
<%
	Param param = new Param(request);
	ReviewService review = (new ReviewService()).toProxyInstance();

	Param info = review.getInfo(param);
%>
<p class="user"><strong><%= Utils.maskString(info.get("userid")) %></strong></p>
<p class="thumb"><span><img src="<%= info.get(param.get("imgno")) %>" alt=""></span></p>
<!-- <p class="pname">제품이름111</p> -->
<p class="tit"><%= Utils.safeHTML(info.get("title")) %></p>
<div class="cont">
	<%= Utils.safeHTML(info.get("contents"), true) %>
</div>
