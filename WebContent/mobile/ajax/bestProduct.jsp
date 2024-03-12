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

	ProductService product = (new ProductService()).toProxyInstance();
	Param param = new Param(request);
	
	// 상품평 건수
	ReviewService review = (new ReviewService()).toProxyInstance();

	param.set("cate1", "022");
	param.set("POS_STA", "0");
	param.set("POS_END", "4");
	param.set("grade_code", fs.getGradeCode());
	List<Param> list = product.getRefProductList(param);
	for (Param row : list) {
		boolean isSoldOut = ("N".equals(row.get("sale_status")) || (row.getInt("opt_cnt") == 0 && row.getInt("stock") == 0));
		row.set("isSoldOut", ""+ isSoldOut);
	}
%>
<ul class="pdtList swiper-wrapper">
<%
	for(Param row : list) {
// 		int reviewCount = review.getListCount(new Param("pid", row.get("pid")));
// 		int sumPidScore = review.getProductScore(row.get("pid"));
		Param reviewInfo = review.getReviewSummary(row.get("pid"));
 		int reviewCount = reviewInfo.getInt("cnt");
 		int sumPidScore = reviewInfo.getInt("score");
%>
		<li class="swiper-slide"><div class="wrap">
			<div class="thumb">
				<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("image1") %>" alt="<%= row.get("pnm") %>">
<%
			if (StringUtils.equals("true", row.get("isSoldOut"))) {
%>
					<div class="soldOut">
						<div>산지에서<br>이동 중입니다.</div>
					</div>
<%
			}
%>
				</a>
<%-- <%
	if (StringUtils.equals("true", row.get("isSoldOut"))) {
%>
				<p class="btn"><a href="#none" onclick="showPopupLayer('/mobile/popup/restock.jsp?pid=<%= row.get("pid") %>'); return false"><img src="/mobile/images/btn/btn_noti.png" alt="재입고 알림"></a></p>
<%
	} else {
		if("Y".equals(row.get("adult_auth")) && !fs.isLogin()) {
%>
				<p class="btn"><a href="#none" onclick="showPopupLayer('/mobile/popup/noMinors.jsp'); return false"><img src="/mobile/images/btn/btn_cart.png" alt="장바구니에 담기"></a></p>
<%
		} else if("Y".equals(row.get("adult_auth")) && !fs.isAdult()) {
%>
				<p class="btn"><a href="#none" onclick="showPopupLayer('/mobile/member/adultCertification.jsp'); return false"><img src="/mobile/images/btn/btn_cart.png" alt="장바구니에 담기"></a></p>
<%
		} else if("Y".equals(row.get("routine_yn"))) {
%>
				<p class="btn"><a href="#none" onclick="showPopupLayer('/popup/regularOption.jsp?pid=<%= row.get("pid")%>', '580'); return false"><img src="/mobile/images/btn/btn_cart.png" alt="장바구니에 담기"></a></p>
<%	
		} else {		
%>
				<p class="btn"><a href="#none" onclick="showPopupLayer('/mobile/popup/cart.jsp?pid=<%= row.get("pid") %>'); return false"><img src="/mobile/images/btn/btn_cart.png" alt="장바구니에 담기"></a></p>
<%
		}
	}
%> --%>
			</div>
			<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
				<p class="tit"><%= row.get("pnm") %></p>
<%
		if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
				<p class="discount">
					<span><strong>15</strong>%</span>
					<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
				</p>
<%
		}
%>
				<p class="price"><strong><%= Utils.formatMoney(row.get("sale_price")) %></strong>원</p>
				<%-- <div class="maker">
					<p class="photo"><img src="<%= row.get("producer_img") %>" alt=""></p>
					<p class="assess"><span style="width:<%= sumPidScore > 0 && reviewCount > 0  ? (sumPidScore * 20 / reviewCount) : 0 %>%"><img src="/mobile/images/common/ico_assess.png" alt="평점"></span></p>
					<p class="info"><%=row.get("producer_name") %> <span class="num"><%=reviewCount %>건</span></p>
				</d --%>iv>
				<p class="icon">
					<span>정기배송</span>
				</p>
			</a>		
	</div></li>
	<% } %>
</ul>