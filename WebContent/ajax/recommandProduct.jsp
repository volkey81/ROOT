<%@page import="java.text.DecimalFormat"%>
<%@page import="com.sanghafarm.service.board.ReviewService"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="com.sanghafarm.service.code.*"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 

	FrontSession fs = FrontSession.getInstance(request, response);

	ProductService product = (new ProductService()).toProxyInstance();
	CodeService code = new CodeService();
	Param param = new Param(request);
	
	// 상품평 건수
	ReviewService review = (new ReviewService()).toProxyInstance();

	param.set("cate1", "023");
	param.set("POS_STA", "0");
	param.set("POS_END", "4");
	param.set("grade_code", fs.getGradeCode());
	List<Param> list = product.getRefProductList(param);

	for (Param row : list) {
		boolean isSoldOut = ("N".equals(row.get("sale_status")) || (row.getInt("opt_cnt") == 0 && row.getInt("stock") == 0));
		row.set("isSoldOut", ""+ isSoldOut);
	}
%>
<div class="slideCont">
	<ul class="pdtList recommendProductList">
<%
	for(Param row : list) {
// 		int reviewCount = review.getListCount(new Param("pid", row.get("pid")));
// 		int sumPidScore = review.getProductScore(row.get("pid"));
		Param reviewInfo = review.getReviewSummary(row.get("pid"));
 		int reviewCount = reviewInfo.getInt("cnt");
 		int sumPidScore = reviewInfo.getInt("score");
%>
		<li><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
			<div class="thumb">
<%
			if (StringUtils.equals("true", row.get("isSoldOut"))) {
%>
				<div class="soldOut"><div><%= code.getCode2Name("028", row.get("soldout_msg", "001")) %></div></div>
<%
			}
%>
				<img src="<%= row.get("image1") %>" alt="<%= row.get("pnm") %>">
			</div>
			<p class="tit"><%= row.get("pnm") %></p>
			<p class="cont"><%= row.get("summary") %></p>			
<%
		if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
			<p class="discount">
				<span><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %>%</span>
				<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
			</p>
<%
		}
%>
			<p class="price"><strong><%= Utils.formatMoney(row.get("sale_price")) %></strong>원</p>
			<%-- <div class="maker">
				<div class="fl">
					<p class="photo"><img src="<%= row.get("producer_img") %>" alt=""></p>
					<p class="assess"><span style="width:<%= sumPidScore > 0 && reviewCount > 0 ? (sumPidScore * 20 / reviewCount) : 0 %>%"><img src="/images/common/ico_assess.png" alt="평점"></span></p>
					<p class="num"><%=reviewCount %>건</p>
				</div>
				<p class="name"><%=row.get("producer_name") %></p>
			</div> --%>
			<p class="icon">
				<span><%= row.get("icon") %></span>
			</p>
<%-- <%
		if (StringUtils.equals("true", row.get("isSoldOut"))) {
%>
			<p class="btn"><a href="#" onclick="showPopupLayer('/popup/restock.jsp?pid=<%= row.get("pid") %>', '580'); return false"><img src="/images/btn/btn_noti.png" alt="재입고 알림"></a></p>
<%
		} else if("Y".equals(row.get("adult_auth")) && !fs.isLogin()) {
%>
			<p class="btn"><a href="#" onclick="showPopupLayer('/popup/noMinors.jsp', '450'); return false"><img src="/images/btn/btn_cart.png" alt="장바구니에 담기"></a></p>
<%
		} else if("Y".equals(row.get("adult_auth")) && !fs.isAdult()) {
%>
			<p class="btn"><a href="#" onclick="showPopupLayer('/mobile/member/adultCertification.jsp', '450'); return false"><img src="/images/btn/btn_cart.png" alt="장바구니에 담기"></a></p>
<%
		} else { 
%>
			<p class="btn"><a href="#" onclick="showPopupLayer('/popup/cart.jsp?pid=<%= row.get("pid") %>', '460'); return false"><img src="/images/btn/btn_cart.png" alt="장바구니에 담기"></a></p>
<%
		} 
%> --%>
		</a></li>
<% 
	} 
%>
	</ul>
</div>
<script>
setListHeight(".recommendProductList", 4);
</script>