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
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}

	Param param = new Param(request);
	param.set("userid", fs.getUserId());
	param.set("status_type", "1");
	
	// 주문/배송 현황
	TicketOrderService order = (new TicketOrderService()).toProxyInstance();
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
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
<jsp:include page="/include/head.jsp" />
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
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/mypage/snb.jsp" />
		<div id="contArea">
		<form name="orderForm" id="orderForm" method="POST" action="orderProc.jsp">
			<input type="hidden" name="mode" id="mode" />
			<input type="hidden" name="morderid" id="morderid" />
		</form>
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<!-- 내용영역 -->
			<div class="reserHead">
				<ul class="caution">
					<li>모든 예약은 당사의 사정에 의해 변경될 수 있습니다.</li>
					<li>이용예정일정 3일전까지 온라인 예약 취소 가능합니다. 2일전부터는 고객센터를 통하여 예약 취소할 수 있습니다. (취소수수료 부과)</li>
					<li>예약 취소수수료는 예매 금액의 2일전 50%, 당일 100% 입니다.</li>
				</ul>
			</div>
			
			<table class="bbsList">
				<caption>예약 내역 목록</caption>
				<colgroup>
					<col width="180"><col width=""><col width="130"><col width="130"><col width="130">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">예약일시 / 예약번호</th>
						<th scope="col">예약 내역</th>
						<th scope="col">일정</th>
						<th scope="col">상태</th>
						<th scope="col">관리</th>
					</tr>
				</thead>
				<tbody>
<%
	if(totalCount > 0) {
		for(Param row : list) {
%>
					<tr>
						<th scope="row"><%= row.get("order_date") %><p class="fs"><a href="view.jsp?orderid=<%= row.get("orderid") %>" class="fontTypeC">(<%= row.get("orderid") %>)</th>
						<td class="tit pName"><%= row.get("ticket_name") %>
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
						</td>
						<td><%= row.get("reserve_date") %>
							<p class="fontTypeC"><%= !"".equals(row.get("time")) ? row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) : "" %></p>
						</td>
						<td><%= row.get("status_name") %></td>
						<td>
<%
			if("Y".equals(row.get("is_cancelable"))) {
%>
							<p class="btn"><a href="javascript:cancelOrder('<%= row.get("morderid") %>')" class="btnTypeA sizeS">예약취소</a></p>
<%
			}
%>
						</td>
					</tr>
<%
		}
	} else {
%>
					<tr><td colspan="5">+++ 예약내역이 없습니다 +++</td></tr>
<%
	}
%>
				</tbody>
			</table>
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
			</ul>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>