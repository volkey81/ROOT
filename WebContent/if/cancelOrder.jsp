<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.security.*,
			com.sanghafarm.service.order.*,
			com.sanghafarm.service.imc.*" %>
<%
	Param param = new Param(request);

	// 파라미터 검증
	String enc = SecurityUtils.encodeSHA256(param.get("orderid") + Utils.getTimeStampString("yyyyMMdd"));
	if(!param.get("p").equals(enc)) {
		out.println("Invalid Request");
		return;
	}
	
	OrderService svc = (new OrderService()).toProxyInstance();
	param.set("userid", "SYSTEM");
	param.set("referer", "SYSTEM_BATCH");
	svc.cancelOrder(param);
	
	
	ImcService imc = (new ImcService()).toProxyInstance();
	Param info = svc.getOrderMasterInfo(param.get("orderid"));
	String message = "[상하농원] 주문취소 안내\n" + info.get("name") + "님의 주문이 입금기한이 경과되어 취소되었습니다.\n\n";
	message += "▶ 마이페이지에서 확인하기\nhttps://goo.gl/vuAs8c\n\n문의☎ 고객센터 1522-3698";

	Param p = new Param();
	p.set("phone_number", "82" + info.get("mobile1").substring(1) + info.get("mobile2") + info.get("mobile3"));
	p.set("template_code", "B_SH_36_02_07546");
	p.set("message", message);
	p.set("resend_mt_to", info.get("mobile1") + info.get("mobile2") + info.get("mobile3"));
	imc.sendTalk(p);
	
	
	out.println("SUCCESS");
%>
