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
<jsp:include page="/mobile/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->	
		<h2 class="typeB">예약자 정보</h2>		
		<table class="bbsForm typeB">
			<caption>예약자 상세 정보</caption>
			<colgroup>
				<col width="90"><col width="">
			</colgroup>
			<tr>
				<th scope="row">예약번호</th>
				<td><%= info.get("orderid") %></td>
			</tr>
			<tr>
				<th scope="row">예약자</th>
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
				<th scope="row">결제수단</th>
				<td><%= info.getInt("pay_amt", 0) == 0 ? "없음(전액할인)" : info.get("pay_type_name") %></td>
			</tr>
			<tr>
				<th scope="row">상태</th>
				<td><%= info.get("status_name") %></td>
			</tr>
		</table>
			
		<h2 class="typeB">예약상품</h2>
		<ul class="myOrderList">
<%
	for(Param row : list) {
%>		
			<li>
				<div class="head">
					일정 : <%= info.get("reserve_date") %> / <%= !"".equals(row.get("time")) ? row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) : "" %>
				</div>
				<div class="content">
					<div class="tit"><%= info.get("ticket_name") %>
						<p class="opt"><%= row.get("ticket_nm") %></p>
					</div>					
<%
		if("02".equals(info.get("ticket_div"))) {
%>
					<p class="date"><%= info.get("place_name") %> <%= info.get("time").substring(0, 2) %>:<%= info.get("time").substring(2) %></p>
<%
		}
%>				
					<p class="btn"><%= Utils.formatMoney(row.get("qty")) %>개</p>
				</div>
			</li>	
<%
	}
%>				
		</ul>
		
		<div class="totalPrice">
			<p>예약 소계 <em><strong><%= Utils.formatMoney(info.get("tot_amt")) %></strong>원</em></p>
			<p>할인 소계 <em class="fontTypeA"><strong><%= Utils.formatMoney(info.getInt("coupon_amt") + info.getInt("point_amt")) %></strong>원</em></p>
			<p class="total">총 결제 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(info.get("pay_amt")) %></strong>원</em></p>
		</div>
		<div class="btnArea">
			<span><a href="javascript:history.back()" class="btnTypeB">목록보기</a></span>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>