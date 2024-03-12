<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.board.*" %>
<%
	Param param = new Param(request);
	ReviewService review = (new ReviewService()).toProxyInstance();

	Param info = review.getInfo(param);
%>
<p class="user"><strong><%= Utils.maskString(info.get("userid")) %></strong> <%= Utils.getTimeStampString(info.get("regist_date")) %></p>
<p class="close"><a href="#" onclick="hideContent(this); return false"><img src="/images/btn/btn_close2.png" alt="닫기"></a></p>
<div class="thumbArea">
	<p class="thumb"><img src="<%= info.get(param.get("imgno")) %>" alt=""></p>
	<!-- 
	<p class="prev"><a href=""><img src="/images/btn/btn_prev.png" alt=""></a></p>
	<p class="next"><a href=""><img src="/images/btn/btn_next.png" alt=""></a></p>
	 -->
</div>
<!-- 
<ul class="list">
<%
	if(!"".equals(info.get("img1"))) {
%>
	<li "class="on"><a href=""><img src="<%= info.get("img1") %>" alt=""></a></li>
<%
	} 
	if(!"".equals(info.get("img2"))) {
%>
	<li><a href=""><img src="<%= info.get("img2") %>" alt=""></a></li>
<%
	}
%>
</ul>
 -->
<p class="tit"><%= Utils.safeHTML(info.get("title")) %></p>
<div class="cont"><%= Utils.safeHTML(info.get("contents"), true) %></div>
