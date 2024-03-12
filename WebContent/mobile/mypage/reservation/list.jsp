<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.order.*" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("예약현황"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}

	Param param = new Param(request);
	param.set("userid", fs.getUserId());
	param.set("status_type", "1");
	
	// 주문/배송 현황
	TicketOrderService order = (new TicketOrderService()).toProxyInstance();
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", Integer.MAX_VALUE);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	
	// 주문 리스트
	List<Param> list = order.getOrderList(param);
	
	// 주문 갯수
	int totalCount = order.getOrderListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
	function cancelOrder(morderid) {
		if(confirm("취소하시겠습니까?")) {
			$("#morderid").val(morderid);
			$("#mode").val("CANCEL");
	
			ajaxSubmit($("#orderForm"), function(json) {
				alert(json.msg);
				document.location.reload();
			});
		}
	}
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<form name="orderForm" id="orderForm" method="POST" action="/mypage/reservation/orderProc.jsp">
		<input type="hidden" name="mode" id="mode" />
		<input type="hidden" name="morderid" id="morderid" />
	</form>
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->
		<div class="cautionBox">
			<ul class="caution">
				<li>모든 예약은 당사의 사정에 의해 변경될 수 있습니다.</li>
				<li>예약 취소수수료는 예매 금액의 2일전 50%, 당일 100% 입니다.</li>
			</ul>
		</div>
		
		<h2 class="typeB">예약내역</h2>
		<ul class="myOrderList">
<%
	if(totalCount > 0) {
		for(Param row : list) {
%>		
			<li>
				<div class="head">
					<p class="num"><strong><a href="view.jsp?orderid=<%= row.get("orderid") %>"><%= row.get("orderid") %></a></strong><br>예약일시 : <%= row.get("order_date") %></p>
					<p class="status"><%= row.get("status_name") %></p>
				</div>
				<div class="content">
					<div class="tit"><%= row.get("ticket_name") %>
						<p class="opt">
<%
			String[] items = row.get("items").split(",");
			for(String item : items) {
				String[] it = item.split("::");
%>
							<%= it[0] %> <%= it.length == 2 ? it[1] : "" %><br>
<%
			}
%>						
						</p>
					</div>
					<p class="date">일정 : <%= row.get("reserve_date") %> / <%= !"".equals(row.get("time")) ? row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) : "" %></p>
					<p class="btn">
<%
			if("Y".equals(row.get("is_cancelable"))) {
%>
						<a href="javascript:cancelOrder('<%= row.get("morderid") %>')" class="btnTypeA sizeS">예약취소</a>
<%
			}
%>						
					</p>
				</div>
<%
			String barcodeImg = order.getBarcode(row.get("orderid"));
			if (StringUtils.isNotEmpty(barcodeImg)) {
%>
				<div class="foot">
					<img src="<%=barcodeImg %>" alt="">
<%
				if("007".equals(row.get("exp_type"))) {
%>				
					<p class="expTxt">견학 10분전, 제1주차장 공용화장실 앞으로 모여주세요.</p>
<%
				}
%>
				</div>
<%
			}
%>
			</li>
<%
		}
	} else {
%>
			<li class="none">+++ 예약내역이 없습니다 +++</li>
<%
	}
%>
		</ul>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>