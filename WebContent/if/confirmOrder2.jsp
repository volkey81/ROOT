<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.security.*,
			com.sanghafarm.service.order.*" %>
<%
	Param param = new Param(request);

	// 파라미터 검증
	String enc = SecurityUtils.encodeSHA256(param.get("orderid"));
	if(!param.get("p").equals(enc)) {
		out.println("Invalid Request");
		return;
	}
	
	TicketOrderService svc = (new TicketOrderService()).toProxyInstance();
	param.set("regist_user", "SYSTEM");
	svc.confirmOrder(param);
	out.println("SUCCESS");
%>
