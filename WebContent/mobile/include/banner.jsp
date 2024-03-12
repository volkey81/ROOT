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
	if (StringUtils.equals("026", param.get("position"))) {
%>
	<div class="mainVisual">
			<ul class="swiper-wrapper">
<%
		for (Param row : bannerList) {
%>
				<li class="swiper-slide">
<%
			if("".equals(row.get("link"))) {
%>
					<img src="<%=row.get("banner_img") %>" alt="">
<%
			} else {
%>
					<a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="<%=row.get("banner_img") %>" alt=""></a>
<%
			}
%>
				</li>
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
	// 뉴 모바일 중간 바
	} else if (StringUtils.equals("027", param.get("position"))) {
		for(Param row : bannerList) {
%>
	<p class="mainBanner"><a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="<%=row.get("banner_img") %>" alt=""></a></p>
<%
		}
	// 뉴 모바일 특산물
	} else if (StringUtils.equals("028", param.get("position"))) {
%>
	<div class="mainSec">
			<h2>상하농원이 찾아다닌 식품 명인들의 상품<br><strong>식품명인&amp;장인</strong></h2>
			<ul class="regionalSrmy">
<%
			for (Param row : bannerList) {
%>
				<li><a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="<%=row.get("banner_img") %>" alt=""></a></li>
<%
			}				
%>
			</ul>
		</div><!-- //지역특산품 -->
<%
	} else if (StringUtils.equals("029", param.get("position"))) {
		if (CollectionUtils.isNotEmpty(bannerList)) {		
%>
		<div class="specialSrmy">
			<ul class="swiper-wrapper">
<%
	for(Param row : bannerList) {
%>
				<li class="swiper-slide"><a href="<%=row.get("link") %>"><img src="<%=row.get("banner_img") %>" alt=""></a></li>
<%
	}
%>
			</ul>
<%
	if (bannerList.size() > 1) {
%>
			<div class="control">
				<input type="image" src="/mobile/images/main/btn_prev.png" alt="이전" class="prev">
				<input type="image" src="/mobile/images/main/btn_next.png" alt="다음" class="next">
			</div>
<%
	}
%>
			<ul class="swiperNav">
			</ul>
		</div><!-- //기획전 -->
<%
		}		
%>
<%
		}
%>