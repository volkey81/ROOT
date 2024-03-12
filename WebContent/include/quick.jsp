<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="com.sanghafarm.service.order.*"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="java.util.*,
				 com.efusioni.stone.utils.*"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<% 
	FrontSession fs = FrontSession.getInstance(request, response);
	ProductService product = (new ProductService()).toProxyInstance();
	CartService cart = (new CartService()).toProxyInstance();
	List<Param> recentList = (ArrayList<Param>)session.getAttribute("recentList");
	if (fs.isLogin()) {
		if (product.getRecentProductCount(fs.getUserId()) > 0) {
			Param searchParam = new Param();
			searchParam.set("userid", fs.getUserId());
			searchParam.addPaging(1, 30);
			recentList = product.getRecentProduct(searchParam);
		}
	}

	String userid = "";
	
	if(fs.isLogin()) userid = fs.getUserId();
	else userid = fs.getTempUserId();
%>
<div id="quick">
	<ul class="nav">
		<li class="nav1"><a href="/mypage/order/list.jsp">주문배송</a></li>
		<li class="nav2"><a href="/order/cart.jsp">장바구니 <strong class="fontTypeA"><%= Utils.formatMoney(cart.getListCount(userid)) %></strong></a></li>
		<li class="nav3"><a href="/review/best.jsp">베스트후기</a></li>
		<li class="nav4"><a href="/product/list.jsp?sort=date&mode=quick&cate_name=신상품">신상품</a></li>
		<li class="nav5"><a href="/mypage/order/wish.jsp">단골상품</a></li>
		<li class="nav6"><a href="/customer/notice/list.jsp">공지사항</a></li>
	</ul>
<% 
	if (CollectionUtils.isNotEmpty(recentList)) {
%>
	<div class="recent">
		<div class="slideCont"> 
			<ul>
<% 
		for (Param row : recentList){
%>
				<li><a href="/product/detail.jsp?pid=<%= row.get("pid")%>"><img src="<%= row.get("thumb") %>" alt=""></a></li>
<% 
		} 
%>
			</ul>
		</div>
		<input type="image" src="/images/layout/btn_prev2.gif" alt="이전" class="prev">
		<input type="image" src="/images/layout/btn_next2.gif" alt="다음" class="next">
		<p class="tit">최근 본 상품</p>
	</div>
<%
	}
%>
	<p class="btnTop"><a href="#" onclick="goTop(); return false"><img src="/images/layout/btn_top2.gif" alt=""></a></p>
</div>
<script>
efuSlider('.recent', '2', 150, 'vertical','');
</script>