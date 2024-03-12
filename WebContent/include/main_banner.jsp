<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.board.BannerService"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	Param param = new Param(request);

	param.set("POS_STA", 0);
	
	// 주문/배송 현황
	BannerService banner = (new BannerService()).toProxyInstance();
	
	List<Param> bannerList = banner.getList(param);

	if("043".indexOf(param.get("position")) != -1) {
%>
		<div class="mainVisual">
			<ul class="list">
<%
		int i = 1;
		for (Param visual : bannerList) {				
%>
				<li id="visual<%= i++%>" style="background-image:url(<%=visual.get("banner_img") %>);"><a href="<%=visual.get("link") %>" target="<%=visual.get("target") %>"><img src="/images/common/sp.gif" alt=""></a></li>
<%
		}				
%>
			</ul>
<%
		if (bannerList.size() > 1) {			
%>
			<input type="image" src="/images/main/btn_prev.png?ver=1" alt="이전" class="prev">
			<input type="image" src="/images/main/btn_next.png?ver=1" alt="다음" class="next">
			<div class="control">
				<ul class="nav">
					<!-- cycle.js -->
				</ul>
				<input type="image" src="/images/main/btn_pause.png" alt="일시정지" class="pause">
				<input type="image" src="/images/main/btn_play.png" alt="재생" class="play">
			</div>
<%
		}			
%>
		</div><!-- //mainVisual -->
<% 
	} else if("044,045,046".indexOf(param.get("position")) != -1) {
		if (CollectionUtils.isNotEmpty(bannerList)) {
%>
		<div class="mainBanner">
			<a href="<%= bannerList.get(0).get("link")%>" target="<%= bannerList.get(0).get("target")%>"><img src="<%=bannerList.get(0).get("banner_img") %>" alt=""></a>
		</div><!-- //mainBanner -->
<%
		}
	}
%>