<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.security.*,
			com.sanghafarm.service.hotel.*,
			com.sanghafarm.service.imc.*" %>
<%
	Param param = new Param(request);

	// 파라미터 검증
	if(!SystemChecker.isLocal()) {
		String enc = SecurityUtils.encodeSHA256(param.get("orderid") + Utils.getTimeStampString("yyyyMMdd"));
		if(!param.get("p").equals(enc)) {
			out.println("Invalid Request");
			return;
		}
	}
	
	HotelReserveService svc = (new HotelReserveService()).toProxyInstance();
	out.println(svc.issuePoint(param.get("orderid")));
%>
