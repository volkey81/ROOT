<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.order.*" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("예약 내역 조회"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
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
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/mypage/snb.jsp" />
		<div id="contArea">
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<!-- 내용영역 -->			
			<p class="orderDetailHead">예약번호: <strong><%= info.get("orderid") %></strong></p>
			<table class="bbsForm typeB">
				<caption>예약자 상세 정보</caption>
				<colgroup>
					<col width="130"><col width=""><col width="130"><col width="">
				</colgroup>
				<tr>
					<th scope="row">예약자</th>
					<td><%= info.get("name") %></td>
					<th scope="row">휴대전화</th>
					<td><%= info.get("mobile1") %>-<%= info.get("mobile2") %>-<%= info.get("mobile3") %></td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td><%= info.get("email") %></td>
					<th scope="row"></th>
					<td></td>
				</tr>
				<tr>
					<th scope="row">결제수단</th>
					<td><%= info.getInt("pay_amt", 0) == 0 ? "없음(전액할인)" : info.get("pay_type_name") %></td>
					<th scope="row">상태</th>
					<td><%= info.get("status_name") %></td>
				</tr>
			</table>
			
			<h2 class="typeB">예약상품</h2>
			<table class="bbsList">
				<caption>예약상품 목록</caption>
				<colgroup>
					<col width="130"><col width="130"><col width=""><col width=""><col width="80">
				</colgroup>
				<tbody>
<%
	for(Param row : list) {
%>
					<tr>
						<td><%= info.get("reserve_date") %><br><span class="fontTypeC"><%= !"".equals(row.get("time")) ? row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) : "" %></span></td>
						<td><%= info.get("ticket_name") %></td>
						<td class="tit">
<%
		if("02".equals(info.get("ticket_div"))) {
%>
							<%= info.get("place_name") %> <%= info.get("time").substring(0, 2) %>:<%= info.get("time").substring(2) %>
<%
		}
%>
						</td>
						<td class="tit"><%= row.get("ticket_nm") %> </td>
						<td><%= Utils.formatMoney(row.get("qty")) %>개</td>
					</tr>
<%
	}
%>
				</tbody>
			</table>

			<div class="totalPrice typeB">
				<span>예약 소계 <em><strong><%= Utils.formatMoney(info.get("tot_amt")) %></strong>원</em></span>
				<span class="math">-</span>
				<span>할인 소계 <em class="fontTypeA"><strong><%= Utils.formatMoney(info.getInt("coupon_amt") + info.getInt("point_amt")) %></strong>원</em></span>
				<span class="math">=</span>
				<span class="total">총 결제 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(info.get("pay_amt")) %></strong>원</em></span>
			</div>
			<div class="btnArea">
				<a href="javascript:history.back()" class="btnTypeA">목록보기</a>
			</div>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>