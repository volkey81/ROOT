<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.security.*,
			com.sanghafarm.service.imc.*,
			com.sanghafarm.utils.*" %>
<%
	Param param = new Param(request);

	// 파라미터 검증
	String enc = SecurityUtils.encodeSHA256(param.get("dt"));
	if(!param.get("p").equals(enc)) {
		out.println("Invalid Request");
		return;
	}
	
	if(!SystemChecker.isReal()) {
		param.set("phone", "01000000000");
	}
	
// 	System.out.println(param);
	
	param.set("phone_number", "82" + param.get("phone").substring(1));
	param.set("resend_mt_to", param.get("phone"));

	ImcService imc = (new ImcService()).toProxyInstance();
	imc.sendTalk(param);
	
	out.println("SUCCESS");
%>
