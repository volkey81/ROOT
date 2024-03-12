<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.order.*" %>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
	int	Depth_4	=	(Integer)request.getAttribute("Depth_4") == null ? 0 : (Integer)request.getAttribute("Depth_4");
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	

	FrontSession fs = FrontSession.getInstance(request, response);
	CartService cart = (new CartService()).toProxyInstance();

	String userid = "";
	
	if(fs.isLogin()) userid = fs.getUserId();
	else userid = fs.getTempUserId();
%>
<div id="skipNav">
	<a href="#container">본문 바로가기</a>
	<a href="#gnb">메뉴 바로가기</a>
</div>
<div id="header">
	<p class="btnCate"><a href="#" onclick="showCate(); return false"><span>카테고리열기</span></a></p>

<% if(Depth_1 == 1){ //브랜드 %>	
	<p class="logo new"><a href="/mobile/brand/index.jsp" class="logoImg"><img src="/mobile/images/layout/logo_new.png" alt="상하농원"></a>
<% } else if(Depth_1 == 5) { //파머스빌리지 %>	
	<p class="logo hotel"><a href="/mobile/hotel/index.jsp" class="logoImg"><img src="/mobile/images/hotel/common/logo.png" alt="상하농원"></a>
<% } else { //쇼핑 %>	
	<p class="logo"><a href="/mobile/main.jsp" class="logoImg"><img src="/mobile/images/layout/logo2.png" alt="파머스마켓"></a>
<% } 
%>
		<a href="" class="meunBtn"><img src="/mobile/images/layout/ico_menu.png"></a>
	</p>
	
	<ul class="topMenu">
		<% if(Depth_1 == 1 || Depth_1 == 5){ //상하농원,파머스빌리지 일때 노출 %>
		<li><a href="/mobile/main.jsp"><img src="/mobile/images/hotel/common/topMenu01.png" alt="파머스마켓"></a></li>
		<% } if(Depth_1 != 1){ //상하농원 아닐때 노출 %>
			<li><a href="/mobile/brand/index.jsp"><img src="/mobile/images/hotel/common/topMenu02.png" alt="상하농원"></a></li>
		<% } if(Depth_1 != 5){ //파머스빌리지 아닐때 노출 %>
		<li><a href="/mobile/hotel/index.jsp"><img src="/mobile/images/hotel/common/topMenu03.png" alt="파머스빌리지"></a></li>
		<% } %>
		<li><a href="/mobile/hotel/room/reservation/date.jsp"><img src="/mobile/images/hotel/common/topMenu04.png" alt="파머스빌리지예약"></a></li>
	</ul>
	<div class="fr">
<% if(Depth_1 == 1){ //브랜드 %>
		<p class="btnReser"><a href="/mobile/brand/play/reservation/admission.jsp"><img src="/mobile/images/layout/btn_reser2.png" alt="체험예약"></a></p>
<% } else if(Depth_1 == 5) { //파머스빌리지 %>	
		<p class="btnReservation"><a href="/mobile/hotel/room/reservation/date.jsp"><img src="/mobile/images/layout/btn_reser3.png" alt="객실예약"></a></p>
<% } else { //쇼핑 %>
		<p class="btnSrch"><a href="#" onclick="showSrch(); return false"><img src="/mobile/images/layout/btn_search.png?ver=1" alt="검색"></a></p>
		<fieldset class="quickSrch">
			<legend>통합검색</legend>
			<input type="text" name="">
			<button title="검색"><img src="/mobile/images/layout/btn_search.png?ver=1" alt="검색"></button>
		</fieldset>
		<p class="btnCart"><a href="/mobile/order/cart.jsp"><img src="/mobile/images/layout/btn_cart.png?ver=1" alt="장바구니"><span class="num" id="cartCount">0</span></a></p>
<% } %>	
	</div>
</div><!-- //header -->
<script>
	$(function() {
		getCartCount();
	});

	function getCartCount() {
		$.getJSON("/ajax/cartCount.jsp", function(data) {
			$("#cartCount").html(data.count);
		});
	}
</script>
<jsp:include page="/mobile/include/cate.jsp" />
<jsp:include page="/mobile/include/srch.jsp" />