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
<jsp:include page="/mobile/include/head.jsp" /> 
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
		productUrl: location.origin + "/mobile/product/detail.jsp?pid=<%= row.get("pid") %>",
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
		productUrl: location.origin + "/mobile/product/detail.jsp?pid=<%= row.get("pid") %>",
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
	<jsp:include page="/mobile/include/header.jsp" /> 
	<div id="container">
	<!-- 내용영역 -->
		<div class="orderTit">
			<h1>주문완료</h1>
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
				<col width="75"><col width="">
			</colgroup>
			<tr>
				<th scope="row">성명</th>
				<td><%= info.get("name") %></td>
			</tr>
			<tr>
				<th scope="row">휴대전화</th>
				<td><%= info.get("mobile1") %>-<%= info.get("mobile2") %>-<%= info.get("mobile3") %></td>
			</tr>
			<tr>
				<th scope="row">이메일</th>
				<td><%= info.get("email") %></td>
			</tr>
			<tr>
				<th scope="row">일반전화</th>
				<td><%= info.get("tel1") %>-<%= info.get("tel2") %>-<%= info.get("tel3") %></td>
			</tr>
		</table><!-- //주문자정보 -->
		
		<h2 class="typeA">배송지 정보</h2>
		<table class="bbsForm typeB">
			<caption>배송지 정보 확인</caption>
			<colgroup>
				<col width="75"><col width="">
			</colgroup>
			<tr>
				<th scope="row">성명</th>
				<td><%= shipInfo.get("ship_name") %></td>
			</tr>
			<tr>
				<th scope="row">휴대전화</th>
				<td><%= shipInfo.get("ship_mobile1") %>-<%= shipInfo.get("ship_mobile2") %>-<%= shipInfo.get("ship_mobile3") %></td>
			</tr>
			<tr>
				<th scope="row">이메일</th>
				<td><%= shipInfo.get("ship_email") %></td>
			</tr>
			<tr>
				<th scope="row">일반전화</th>
				<td><%= shipInfo.get("ship_tel1") %>-<%= shipInfo.get("ship_tel2") %>-<%= shipInfo.get("ship_tel3") %></td>
			</tr>
			<tr>
				<th scope="row">배송지</th>
				<td><%= shipInfo.get("ship_post_no") %>) <%= shipInfo.get("ship_addr1") %> <%= shipInfo.get("ship_addr2") %></td>
			</tr>
			<tr>
				<th scope="row">배송 요청사항</th>
				<td><%= shipInfo.get("ship_memo") %></td>
			</tr>
		</table><!-- //배송지정보 -->
		
		<h2 class="typeA">주문상품</h2>
		<div class="orderPdtList typeB">
			<ul>
<%
	for(Param row : list1) {
%>
				<li>
					<p class="thumb"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt=""></a></p>
					<div class="content">
						<div class="tit"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
							<%= row.get("pnm") %>
							<p class="opt"><%= row.get("sub_pnm") %></p>
						</a></div>
						<p class="cnt"><strong><%= Utils.formatMoney(row.get("qty")) %></strong>개</p>	
					</div>
				</li>
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
				<li class="regular">
					<p class="thumb"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt=""></a></p>
					<div class="content">
						<div class="tit"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
							<%= row.get("pnm") %>
							<p class="opt"><%= row.get("sub_pnm") %></p>
						</a></div>
						<p class="cnt"><strong><%= Utils.formatMoney(row.get("qty")) %></strong>개</p>
					</div>
					<div class="foot">
						<p class="cycle"><strong>정기배송상품</strong><%= row.get("routine_period") %>주마다 / <%= routineDay %> / <%= row.get("routine_cnt") %>회 / <%= firstDeliveryDate %> 부터</p>
					</div>					
				</li>
<%
	}
%>
			</ul>
		</div><!-- //주문상품 확인 -->
		
		<div class="totalPrice">
			<p>상품 소계 <em><strong><%= Utils.formatMoney(info.getInt("tot_amt") - info.getInt("routine_sale_amt")) %></strong>원</em></p>
			<p>총 배송비 <em><strong><%= Utils.formatMoney(info.get("ship_amt")) %></strong>원</em></p>
			<p>총 할인 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(info.getInt("coupon_sale_amt") + info.getInt("coupon_cart_amt") + info.getInt("coupon_ship_amt") + info.getInt("point_amt") + info.getInt("giftcard_amt")) %></strong>원</em></p>
			<p class="total">총 결제 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(info.get("pay_amt")) %></strong>원</em></p>
		</div>
	 	
		<div class="btnArea">
			<span><a href="/mobile/" class="btnTypeA sizeL">쇼핑홈 이동</a></span>
<%
	if(fs.isLogin()) {
%>
			<span><a href="/mobile/mypage/order/list.jsp" class="btnTypeB sizeL">주문배송조회</a></span>
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

	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
