<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.order.*" %>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("주문완료"));
%>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	OrderService order = (new OrderService()).toProxyInstance();
	
	Param info = order.getOrderMasterInfo(param.get("orderid"));
	Param shipInfo = order.getOrderShipInfo(new Param("orderid", param.get("orderid"), "ship_seq", "1"));
	
	param.set("routine_yn", "N");
	List<Param> list1 = order.getOrderCartList(param);
	param.set("routine_yn", "Y");
	List<Param> list2 = order.getOrderCartList(param);

	// 8월 정기배송 특가 상품 코드
	String eventPid = Config.get("evend1.pid." + SystemChecker.getCurrentName());
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
	/*
	var arrPnm = [];
<%
	for(Param row : list1) {
%>
	//기존소스
	//arrPnm.push('<%= row.get("pnm") %> - <%= row.get("sub_pnm") %>');
	arrPnm.push({
		productName: '<%= row.get("pnm") %> - <%= row.get("sub_pnm") %>',
		productPrice: '<%= row.get("apply_price") %>',
		productUrl: location.origin + "/product/detail.jsp?pid=<%= row.get("pid") %>",
		productImg: location.origin + "<%= row.get("opt_thumb") %>"
	});
<%
	}
	for(Param row : list2) {
%>
	//기존소스
	//arrPnm.push('<%= row.get("pnm") %> - <%= row.get("sub_pnm") %>');
	arrPnm.push({
		productName: '<%= row.get("pnm") %> - <%= row.get("sub_pnm") %>',
		productPrice: '<%= row.get("apply_price") %>',
		productUrl: location.origin + "/product/detail.jsp?pid=<%= row.get("pid") %>",
		productImg: location.origin + "<%= row.get("opt_thumb") %>"
	});
<%
	}
%>
	ET.exec('purchase', arrPnm, '<%= info.get("pay_amt") %>');
	*/
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" /> 	
	<ul id="location">
		<li><a href="/">홈</a></li>
		<li>주문완료</li>
	</ul>
	<div id="container">
	<!-- 내용영역 -->
		<div class="orderTit">
			<h1 class="typeA step3">주문완료</h1>
			<ul class="step">
				<li><span>장바구니</span></li>
				<li><span>주문/결제</span></li>
				<li class="on"><span>주문완료</span></li>
			</ul>
		</div>
		
		<h2 class="typeA">주문자 정보</h2>
		<table class="bbsForm typeB">
			<caption>주문자 정보 확인</caption>
			<colgroup>
				<col width="130"><col width=""><col width="130"><col width="">
			</colgroup>
			<tr>
				<th scope="row">성명</th>
				<td><%= info.get("name") %></td>
				<th scope="row">휴대전화</th>
				<td><%= info.get("mobile1") %>-<%= info.get("mobile2") %>-<%= info.get("mobile3") %></td>
			</tr>
			<tr>
				<th scope="row">이메일</th>
				<td><%= info.get("email") %></td>
				<th scope="row">일반전화</th>
				<td><%= info.get("tel1") %>-<%= info.get("tel2") %>-<%= info.get("tel3") %></td>
			</tr>
		</table><!-- //주문자정보 -->
		
		<h2 class="typeA">배송지 정보</h2>
		<table class="bbsForm typeB">
			<caption>배송지 정보 확인</caption>
			<colgroup>
				<col width="130"><col width=""><col width="130"><col width="">
			</colgroup>
			<tr>
				<th scope="row">성명</th>
				<td><%= shipInfo.get("ship_name") %></td>
				<th scope="row">휴대전화</th>
				<td><%= shipInfo.get("ship_mobile1") %>-<%= shipInfo.get("ship_mobile2") %>-<%= shipInfo.get("ship_mobile3") %></td>
			</tr>
			<tr>
				<th scope="row">이메일</th>
				<td><%= shipInfo.get("ship_email") %></td>
				<th scope="row">일반전화</th>
				<td><%= shipInfo.get("ship_tel1") %>-<%= shipInfo.get("ship_tel2") %>-<%= shipInfo.get("ship_tel3") %></td>
			</tr>
			<tr>
				<th scope="row">배송지</th>
				<td colspan="3"><%= shipInfo.get("ship_post_no") %>) <%= shipInfo.get("ship_addr1") %> <%= shipInfo.get("ship_addr2") %></td>
			</tr>
			<tr>
				<th scope="row">배송 요청사항</th>
				<td colspan="3"><%= shipInfo.get("ship_memo") %></td>
			</tr>
		</table><!-- //배송지정보 -->
		
		<h2 class="typeA">주문상품</h2>
		<table class="bbsList typeB">
			<caption>주문/결제 상품 목록</caption>
			<colgroup>
				<col width="136"><col width=""><col width="150">
			</colgroup>
			<tbody>
<%
	for(Param row : list1) {
%>
				<tr>
					<td class="ar"><p class="thumb"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt="" width="124"></a></p></td>
					<td class="tit pName"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
						<%= row.get("pnm") %>
						<p class="opt"><%= row.get("sub_pnm") %></p>
					</a></td>
					<td class="last"><%= Utils.formatMoney(row.get("qty")) %>개</td>
				</tr>
<%
	}

	for(Param row : list2) {
		String routineDay = row.get("routine_day");
		routineDay = routineDay.replaceAll("1", "일");
		routineDay = routineDay.replaceAll("2", "월");
		routineDay = routineDay.replaceAll("3", "화");
		routineDay = routineDay.replaceAll("4", "수");
		routineDay = routineDay.replaceAll("5", "목");
		routineDay = routineDay.replaceAll("6", "금");
		routineDay = routineDay.replaceAll("7", "토");
		
		String firstDeliveryDate = "";
		if(eventPid.equals(row.get("sub_pid"))) {
			firstDeliveryDate = SanghafarmUtils.getFirstDeliveryDate(row.get("routine_day").split(","), "yyyy-MM-dd", "20170803");
		} else {
			firstDeliveryDate = SanghafarmUtils.getFirstDeliveryDate(row.get("routine_day").split(","), "yyyy-MM-dd");
		}
%>
				<tr class="regular"><!-- 정기배송일때 class="regular" -->
					<td class="ar"><p class="thumb"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt="" width="124"></a></p></td>
					<td class="tit pName"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
						<%= row.get("pnm") %>
						<p class="opt"><%= row.get("sub_pnm") %></p>
						<p class="cycle"><strong>정기배송상품</strong><%= row.get("routine_period") %>주마다 / <%= routineDay %> / <%= row.get("routine_cnt") %>회 / <%= firstDeliveryDate %> 부터</p>
					</a></td>
					<td class="last"><%= Utils.formatMoney(row.get("qty")) %>개</td>
				</tr>
<%
	}
%>
			</tbody>
		</table><!-- //주문상품 확인 -->
		
		<div class="totalPrice">
			<span>상품 소계 <em><strong><%= Utils.formatMoney(info.getInt("tot_amt") - info.getInt("routine_sale_amt")) %></strong>원</em></span>
			<span class="math">+</span>
			<span>총 배송비 <em><strong><%= Utils.formatMoney(info.get("ship_amt")) %></strong>원</em></span>
			<span class="math">-</span>
			<span>총 할인 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(info.getInt("coupon_sale_amt") + info.getInt("coupon_cart_amt") + info.getInt("coupon_ship_amt") + info.getInt("point_amt") + info.getInt("giftcard_amt")) %></strong>원</em></span>
			<span class="math">=</span>
			<span class="total">총 결제 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(info.get("pay_amt")) %></strong>원</em></span>
		</div>
	 	
		<div class="btnArea">
			<a href="/" class="btnTypeA sizeXL">쇼핑홈 이동</a>
<%
	if(fs.isLogin()) {
%>
			<a href="/mypage/order/list.jsp" class="btnTypeB sizeXL">주문배송조회</a>
<%
	}
%>
		</div>
	<!-- //내용영역 -->
	</div><!-- //container -->

<!-- NAVER SCRIPT -->
<script type="text/javascript" src="//wcs.naver.net/wcslog.js"></script>
<script type="text/javascript">
var _nasa={};
_nasa["cnv"] = wcs.cnv("1","<%= Utils.formatMoney(info.get("pay_amt")) %>");
</script>

	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
