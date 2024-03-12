<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.order.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(6));
	request.setAttribute("MENU_TITLE", new String("예약하기"));
%>
<%
	Param param = new Param(request);
	TicketOrderService svc = (new TicketOrderService()).toProxyInstance();
	Param info = svc.getOrderMasterInfo(param.get("orderid"));
	List<Param> list = svc.getOrderItemList(param.get("orderid"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<p class="reserComplete">예약이 완료되었습니다.</p>
		<div class="reserForm">
			<div class="fl">
				<h2 class="typeA"><strong class="num">01</strong> 예약자 정보</h2>
				<table class="bbsForm">
					<caption>예약자 정보 상세내역</caption>
					<colgroup>
						<col width="90"><col width=""><col width="90"><col width="">
					</colgroup>
					<tr>
						<th scope="row">성명</th>
						<td><%= info.get("name") %></td>
						<th scope="row">휴대전화</th>
						<td><%= info.get("mobile1") %>-<%= info.get("mobile2") %>-<%= info.get("mobile3") %></td>
					</tr>
					<tr>
						<th scope="row">이메일</th>
						<td colspan="3"><%= info.get("email") %></td>
					</tr>
				</table>
				<!-- //step1 예약자정보 -->
				
				<h2 class="typeA"><strong class="num">01</strong> 예약 상품</h2>
				<table class="bbsList">
					<caption>예약상품 상세내역</caption>
					<colgroup>
						<col width=""><col width="200">
					</colgroup>
					<thead>
						<tr>
							<th scope="col">상품명</th>
							<th scope="col">수량</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th scope="row">
								<p class="tit"><%= info.get("ticket_name") %>
<%
	if("02".equals(info.get("ticket_div"))) {
%>
								/ <%= info.get("place_name") %> <%= info.get("time").substring(0, 2) %>:<%= info.get("time").substring(2) %>
<%
	}
%>
								</p>
								<ul class="opt">
<%
	for(Param row : list) {
%>
									<li><%= row.get("ticket_nm") %>(<%= Utils.formatMoney(row.get("unit_price")) %>원)</li>
<%
	}
%>
								</ul>
							</th>
							<td>
								<p class="tit">&nbsp;</p>
								<ul class="opt">
<%
	for(Param row : list) {
%>
									<li><%= row.get("qty") %>개</li>
<%
	}
%>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
				<!-- //step2 예약상품 -->
			</div>
			<div class="fr">
				<h2 class="typeA"><strong class="num">04</strong> 총 결제 금액</h2>
				<div class="totalPrice">
					<dl>
						<dt>상품소계</dt><dd><span><%= Utils.formatMoney(info.get("tot_amt")) %></span>원</dd>
						<dt>총 할인 금액</dt><dd><span class="fontTypeE"><%= Utils.formatMoney(info.getInt("coupon_amt") + info.getInt("point_amt")) %></span>원</dd>
					</dl>
					<p class="lastPrice">최종 결제액 <em><strong class="fontTypeA"><%= Utils.formatMoney(info.get("pay_amt")) %></strong>원</em></p>
				</div>
				<div class="btnArea">
			 		<a href="/brand/index.jsp" class="btnTypeB sizeXL">홈 이동</a>
			 		<a href="/mypage/reservation/list.jsp" class="btnTypeA sizeXL">예약 내역 조회</a>
			 	</div>
			</div>
		</div><!-- //reserForm -->
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					