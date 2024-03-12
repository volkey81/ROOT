<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.board.BannerService"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*" %>
<% 

	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);

	param.set("POS_STA", 0);
	
	// 주문/배송 현황
	BannerService banner = (new BannerService()).toProxyInstance();
	
	List<Param> bannerList = banner.getList(param);
	
	// 브랜드 뉴 메인 비주얼 롤링
	if (StringUtils.equals("030", param.get("position"))) {
%>
<div class="mainVisual">
	<ul class="list">
<%
	int i = 1;
	if (CollectionUtils.isNotEmpty(bannerList)) {
		for (Param row : bannerList) {	
%>
		<li id="visual<%= i++ %>" style="background-image:url('<%=row.get("banner_img") %>')"><a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="/images/common/sp.gif" alt=""></a></li>
<%
		}
	}
%>
	</ul>
<%
	if (bannerList.size() > 1) {	
%>
	<ul class="nav">
		<!-- cycle.js -->
	</ul>
	<input type="image" src="/images/main/btn_prev.png" alt="이전" class="prev">
	<input type="image" src="/images/main/btn_next.png" alt="다음" class="next">
<%
	}	
%>
</div>
<%
	// 브랜드 뉴 중간 컨텐츠 1/4 
	} else if (StringUtils.equals("031", param.get("position"))) {
		if (CollectionUtils.isNotEmpty(bannerList)) {
%>	
	<li><a href="<%=bannerList.get(0).get("link") %>" target="<%=bannerList.get(0).get("target") %>"><img src="<%=bannerList.get(0).get("banner_img") %>" alt="" width="274" height="452"></a></li>
<%
		}
	// 브랜드 뉴 중간 컨텐츠 2/4
	} else if (StringUtils.equals("032", param.get("position"))) {
		if (CollectionUtils.isNotEmpty(bannerList)) {
%>
	<li><a href="<%=bannerList.get(0).get("link") %>" target="<%=bannerList.get(0).get("target") %>"><img src="<%=bannerList.get(0).get("banner_img") %>" alt="" width="274" height="452"></a></li>
<%
		}
	// 브랜드 뉴 중간 컨텐츠 3/4
	} else if (StringUtils.equals("033", param.get("position"))) {
		if (CollectionUtils.isNotEmpty(bannerList)) {
%>
	<li><a href="<%=bannerList.get(0).get("link") %>" target="<%=bannerList.get(0).get("target") %>"><img src="<%=bannerList.get(0).get("banner_img") %>" alt="" width="274" height="452"></a></li>
<%
		}
	// 브랜드 뉴 중간 컨텐츠 4/4
	} else if (StringUtils.equals("034", param.get("position"))) {
		if (CollectionUtils.isNotEmpty(bannerList)) {
%>
	<li>
		<a href="<%=bannerList.get(0).get("link") %>" target="<%=bannerList.get(0).get("target") %>"><img src="<%=bannerList.get(0).get("banner_img") %>" alt="" width="274" height="452"></a>
	</li>
<%
		}
	} else if (StringUtils.equals("035", param.get("position"))) {
%>
	<div class="list">
		<h2>농원소식</h2>
		<div class="slideCont">
			<ul>
<%
		if (CollectionUtils.isNotEmpty(bannerList)) {
			for (Param row : bannerList) {
%>
				<li><a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="<%=row.get("banner_img") %>" alt="" width="570" height="137"></a></li>
<%
			}
		}
%>
			</ul>
		</div>
<%
		if (bannerList.size() > 1) {		
%>
		<input type="image" src="/images/brand/main/btn_prev.gif" alt="이전" class="prev">
		<input type="image" src="/images/brand/main/btn_next.gif" alt="다음" class="next">
<%
		}
%>
	</div>
<%
	} else if (StringUtils.equals("036", param.get("position"))) {
		if (CollectionUtils.isNotEmpty(bannerList)) {
%>
	<ul>
<%
		for (Param row : bannerList) {		
%>
		<li><a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="<%=row.get("banner_img") %>" alt="" width="316" height="193"></a></li>
<%
		}
%>
	</ul>
<%
		}
	} else if (StringUtils.equals("039", param.get("position"))) {
%>
	<div class="slideContainer">
		<div class="slideWrap">							
	<%
			int i = 0;
			for (Param row : bannerList) {	 
	%>					
			<div id="news<%= i++ %>" class="swiper-slide">
				<a href="<%=row.get("link") %>" target="<%=row.get("target") %>">
					<img src="<%=row.get("banner_img") %>" alt="타이틀">
					<div class="cate">
<%-- 						<img src="/images/brand/main/news_cate_<%= row.get("icon") %>.jpg" alt="카테고리"> --%>
					</div>
					<div class="cont">
						<strong><%= row.get("title") %></strong>
<%-- 						<p><%= row.get("txt") %></p> --%>
					</div>
				</a>
			</div>
	<%} %>					
		</div>
		<div class="prev slideBtn"></div>
		<div class="next slideBtn"></div>
	</div>
<%
	} else if (StringUtils.equals("040", param.get("position"))) {
%>
				<ul>
<%
		for (Param row : bannerList) { 
%>		
					<li><a href="<%=row.get("link") %>" target="<%=row.get("target") %>">
						<div class="thum"><img src="<%=row.get("banner_img") %>"></div>
						<div class="cont">
							<strong><%= row.get("title") %></strong>
							<p><%= row.get("txt") %></p>
						</div></a>
					</li>
<%
		}
%>
					 <li class="last">
						<div class="tit vt_m">
							<div>
								<img src="/images/brand/main/ico_sns.png">
								<span>다양한 채널에서<br>상하농원을 만나보세요</span>
							</div>
						</div>
						<div class="snsInfo vt_m">
							<div>
								<a title="kakao" href="http://plus.kakao.com/home/@sanghafamily<%=fs.isApp() ? "?target=web" : "" %>" target="_blank"><img src="/images/brand/main/ico_kakao.png"><span>@sanghafamily</span></a>
								<a title="facebook" href="https://www.facebook.com/sanghafarmer<%=fs.isApp() ? "?target=web" : "" %>" target="_blank"><img src="/images/brand/main/ico_fb.png"><span>@sanghafarmer</span></a>
								<a title="instagram" href="https://www.instagram.com/sanghafarm_farmer<%=fs.isApp() ? "?target=web" : "" %>" target="_blank"><img src="/images/brand/main/ico_ins.png"><span>@sanghafarm_farmer</span></a>
							</div>
						</div>
					</li>				 
				</ul>
<%
	} else if (StringUtils.equals("041", param.get("position"))) {
		for(Param row : bannerList) {
%>
		<div class="srmyBanner">
			<a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="<%=row.get("banner_img") %>"></a>
		</div>
<%
		}
	} else if (StringUtils.equals("042", param.get("position"))) {
		for(Param row : bannerList) {
%>
		<div class="srmyBanner">
			<a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="<%=row.get("banner_img") %>"></a>
		</div>
<%
		}
	}
%>