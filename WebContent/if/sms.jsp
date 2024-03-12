<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.security.*,
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
	
	TmsUtil tms = new TmsUtil();
	tms.sendSms(param);
	
	out.println("SUCCESS");
%>
