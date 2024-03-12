<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.sanghafarm.common.*" %>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	

	FrontSession fs = FrontSession.getInstance(request, response);
%>
<div id="skipNav">
	<a href="#container">본문 바로가기</a>
	<a href="#gnb">메뉴 바로가기</a>
</div>
<div id="header">
	<p class="btnCate"><a href="#" onclick="showCate(); return false"><span>카테고리열기</span></a></p>
	<p class="logo"><a href="/mobile/index.jsp"><img src="/mobile/images/layout/logo.png" alt="상하농원"></a></p>
	<div class="fr">
<% if(Depth_1 == 1){ //브랜드 %>
		<p class="btnReser"><a href="/mobile/brand/play/reservation/admission.jsp"><img src="/mobile/images/layout/btn_reser.png" alt="예약하기"></a></p>
<% } else { //쇼핑 %>
		<p class="btnCart"><a href="/mobile/order/cart.jsp"><img src="/mobile/images/layout/btn_cart.png" alt="장바구니"></a></p>
		<p class="btnSrch"><a href="#" onclick="showSrch(); return false"><img src="/mobile/images/layout/btn_search.png" alt="검색"></a></p>
		<fieldset class="quickSrch">
			<legend>통합검색</legend>
			<input type="text" name="">
			<button title="검색"><img src="/mobile/images/layout/btn_search.png" alt="검색"></button>
		</fieldset>
<% } %>	
	</div>
</div><!-- //header -->
