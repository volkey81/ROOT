<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.service.board.EventService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("이벤트/기획전"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	FrontSession fs = FrontSession.getInstance(request, response);
	
	Param param = new Param(request);
	
	if(StringUtils.isEmpty(param.get("seq"))) {
		Utils.sendMessage(out, "잘못된 경로로 접근하였습니다.");
		return;
	}
	
	EventService event = (new EventService()).toProxyInstance();
	Param info = event.getInfo(param);
	event.modifyHit(param);

	List<Param> relationProduct = event.getEventRelationProductList(param.getInt("seq"), fs.getGradeCode());
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	function goProduct(pid) {
		document.location.href="/mobile/product/detail.jsp?pid=" + pid;
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="viewArea">
			<div class="head">
<%
	String today = Utils.getTimeStampString("yyyy.MM.dd");
	if (StringUtils.equals("E", info.get("event_type"))) {
		if(info.get("start_date").compareTo(today) <= 0 && info.get("end_date").compareTo(today) >= 0) {
%>
				<p class="ico ico1">진행중</p>
<%
		} else if(info.get("end_date").compareTo(today) < 0) {
%>
				<p class="ico ico2">종료</p>
<%
		}
	} else {
%>
				<p class="ico ico3">기획전 </p>	
<% 				
	} 
%>
				<p class="tit"><%= info.get("title") %></p>
				<p class="date"><%= info.get("start_date") %> ~ <%= info.get("end_date") %></p>
<%
	if(!"".equals(info.get("announce_date"))) {
%>
				<p class="date">결과 발표일 : <%= info.get("announce_date") %></p>
<%
	}
%>
			</div>
			<div class="content">
				<% if (StringUtils.equals("view", param.get("type"))) { %>
				<%= info.get("mobile_contents") %>
				<% } else {%>
				<%= info.get("result") %>
				<%} %>
			</div>
		</div>
		
<%
	if (StringUtils.equals("P", info.get("event_type"))) {
		if (CollectionUtils.isNotEmpty(relationProduct)) {
		
%>
		<!-- 기획전일때 노출 -->
		<div class="pdtListHead">
			<p class="text">총 <span class="fontTypeA"><%=relationProduct.size() %></span>개의 상품 판매중</p>
		</div>
		<ul class="pdtList">
<%
		for (Param product : relationProduct) {
%>
			<li><div class="wrap">				
				<div class="thumb">
					<a href="/mobile/product/detail.jsp?pid=<%= product.get("pid") %>"><img src="<%= product.get("image1") %>" alt=""></a>
					<p class="btn">
						<a href="#" onclick="showPopupLayer('/mobile/popup/cart.jsp?pid=<%= product.get("pid") %>'); return false"><img src="/mobile/images/btn/btn_cart.png" alt="장바구니에 담기"></a>
					</p>
				</div>
				<a href="/mobile/product/detail.jsp?pid=<%= product.get("pid") %>">
					<p class="tit"><%=product.get("pnm") %></p>
					<p class="discount">
<%
			if(product.getInt("default_price") > product.getInt("sale_price")) {
%>
						<span><strong><%= (product.getInt("default_price") - product.getInt("sale_price")) * 100 / product.getInt("default_price") %></strong>%</span>
						<strike><%= Utils.formatMoney(product.get("default_price")) %>원</strike>
<%
			}
%>
					</p>
					<p class="price"><strong><%=Utils.formatMoney(product.get("sale_price")) %></strong>원</p>
					<p class="icon">
						<span><%= product.get("icon") %></span>
					</p>					
				</a>
			</div></li>
<%
			}
%>
		</ul>
		<!-- //기획전일때 노출 -->
<%			
			
		}
	}
%>	
		<div class="btnArea">
			<a href="list.jsp" class="btnTypeB">이벤트/기획전 홈</a>
		</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
setListHeight($(".pdtList")); //제품리스트 행간 높이 통일
</script>
</body>
</html>