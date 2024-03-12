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

	// 뉴 메인 비주얼 롤링 (019)
	// 뉴 이벤트 기획전 비주얼 롤링(024)
	if (StringUtils.equals("019", param.get("position"))
			|| StringUtils.equals("024", param.get("position"))) {
%>
		<div class="mainVisual">
			<ul class="list">
<%
		int i = 1;
		for (Param visual : bannerList) {				
%>
				<li id="visual<%= i++%>" style="background-image:url(<%=visual.get("banner_img") %>);">
<%
			if("".equals(visual.get("link"))) {
%>
					<img src="/images/common/sp.gif" alt="">
<%
			} else {
%>
					<a href="<%=visual.get("link") %>" target="<%=visual.get("target") %>"><img src="/images/common/sp.gif" alt=""></a>
<%
			}
%>
				</li>
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
		//뉴 메인 이벤트바 롤링
	} else if (StringUtils.equals("020", param.get("position"))) {
%>
			<div class="specialSrmy">
				<ul class="list">
<%
		int i = 1;
		for (Param event : bannerList) {				
%>
					<li class="on" id="special<%= i++%>"><a href="<%= event.get("link")%>" target="<%=event.get("target") %>"><img src="<%=event.get("banner_img") %>" alt=""></a></li>
<%
		}					
%>
				</ul>
<%
		if (bannerList.size() > 1) {				
%>
				<ul class="nav">
					<!-- cycle.js -->
				</ul>
<%
		}				
%>
			</div><!-- //specialSrmy(기획전) -->
<%
			// 뉴 메인 바 중간 첫째 (021)
			// 뉴 메인 바 중간 둘째 (022)
			// 뉴 이벤트 기획전 바 중간 첫째 (024)
	} else if (StringUtils.equals("021", param.get("position"))
			|| StringUtils.equals("022", param.get("position"))
			|| StringUtils.equals("025", param.get("position"))) {
		if (CollectionUtils.isNotEmpty(bannerList)) {
%>
		<div class="mainBanner">
			<a href="<%= bannerList.get(0).get("link")%>" target="<%= bannerList.get(0).get("target")%>"><img src="<%=bannerList.get(0).get("banner_img") %>" alt=""></a>
		</div><!-- //mainBanner -->
<%
		}
			// 뉴 메인 특산품 바로가기
	} else if (StringUtils.equals("023", param.get("position"))) {
%>
		<div class="mainSecA"><div class="wrap">
			<h2 class="typeA">젊은농부가 추천하는<br><strong>지역 특산물</strong></h2>
			<ul class="regionalSrmy">
<%
		int i = 1;
		for (Param special : bannerList) {
%>
				<li><a href="<%= special.get("link")%>" target="<%= special.get("target")%>"><img src="<%= special.get("banner_img")%>" alt="" width="<%= i == 1 ? 540 : 260%>" height="<%= i == 1 ? 570 : 274%>"></a></li>
<%
			i++;
		}
%>
			</ul>
		</div></div><!-- //mainSecB(내고장특산물) -->
<%
		// 뉴 메인 GNB 우측
	} else if (StringUtils.equals("018", param.get("position"))) {
		if (CollectionUtils.isNotEmpty(bannerList)) {
%>
		<p class="banner"><a href="<%= bannerList.get(0).get("link")%>" target="<%= bannerList.get(0).get("target")%>"><img src="<%=bannerList.get(0).get("banner_img") %>" alt=""></a></p>
<%
		}
		// 뉴 메인 바 탑
	} else if (StringUtils.equals("017", param.get("position"))) {
		if (CollectionUtils.isNotEmpty(bannerList)) {
%>
		<div class="bandBanner" style="display:none">
			<p class="thumb"><a href="<%= bannerList.get(0).get("link")%>" target="<%= bannerList.get(0).get("target")%>"><img src="<%=bannerList.get(0).get("banner_img") %>" alt=""></a></p>
			<p class="btn"><a href="#" onclick="hideBand('bandBanner'); return false">닫기</a></p>
		</div>

<%
		}
	}
%>