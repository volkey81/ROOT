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

	// 뉴 모바일 메인 탑비주얼 (026)
	if("047".indexOf(param.get("position")) != -1) {
%>
	<div class="mainVisual">
			<ul class="swiper-wrapper">
<%
			for (Param row : bannerList) {
%>
				<li class="swiper-slide"><a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="<%=row.get("banner_img") %>" alt=""></a></li>
<%
			}				
%>
			</ul>
<%-- <%
			if (bannerList.size() > 1) {			
%>
			<div class="control">
				<input type="image" src="/mobile/images/main/btn_prev.png" alt="이전" class="prev">
				<input type="image" src="/mobile/images/main/btn_next.png" alt="다음" class="next">
			</div>
			<ul class="swiperNav">
			</ul>
<%
			}	
%> --%>
			<p class="page"></p>
		</div>
<%
	} else if("048,049,050,051,052".indexOf(param.get("position")) != -1) {
		for(Param row : bannerList) {
%>
	<p class="mainBanner"><a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="<%=row.get("banner_img") %>" alt=""></a></p>
<%
		}
	}
%>