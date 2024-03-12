<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.security.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.order.*,
			org.json.simple.*" %>
<%
	Param param = new Param(request);
	String resultCode = param.get("resultCode");
	String resultMessage = param.get("resultMessage");
	
	System.out.println("-------- naverpay : " + resultCode + ", " + resultMessage);
	
	if("Success".equals(resultCode)) {
		String orderid = param.get("orderid");

		if(orderid == null || "".equals(orderid)) {
			System.out.println("++++++++++++ parameter orderid is null !!!");
			Utils.sendMessage(out, "세션이 만료 되었거나 유효하지 않은 요청 입니다.", "/");
			return;
		}

		OrderService svc = (new OrderService()).toProxyInstance();
		Param info = svc.getOrderFormInfo(orderid);
		
		if(info == null || "".equals(info.get("orderid"))) {
			System.out.println("++++++++++++ order form is null !!!");
			Utils.sendMessage(out, "세션이 만료 되었거나 유효하지 않은 요청 입니다.", "/");
			return;
		}
		
%>
<script src="/js/jquery-1.10.2.min.js"></script>
<script>
	$(function() {
		$("input[name=paymentId]").val("<%= param.get("paymentId") %>");
		$("#orderSessionForm").submit();
	});
</script>
<form method="post" name="orderSessionForm" id="orderSessionForm" action="<%= Env.getSSLPath() %>/hotel/offer/proc.jsp">
	<%= info.get("form") %>
</form>
<%
	} else {
		String msg = "";
		
		if("usercancel".equalsIgnoreCase(resultCode)) {
			msg = "결제를 취소하셨습니다.\\n주문 내용 확인 후 다시 결제해주세요.";
		} else if("ownerauthfail".equalsIgnoreCase(resultCode)) {
			msg = "타인 명의 카드는 결제가 불가능합니다.\\n회원 본인 명의의 카드로 결제해주세요.";
		} else if("paymenttimeexpire".equalsIgnoreCase(resultCode)) {
			msg = "결제 가능한 시간이 지났습니다.\\n주문 내용 확인 후 다시 결제해주세요.";
		}
		Utils.sendMessage(out, msg, "/mobile/hotel/offer/list.jsp");
	}
%>
