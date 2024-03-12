<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.security.*,
			com.sanghafarm.utils.*,
			org.json.simple.*" %>
<%
	Param param = new Param(request);
	KakaopayUtil kakao = new KakaopayUtil();
	
	JSONObject json = kakao.ready(param);
	int responseCode = (Integer) json.get("response_code");
	
	if(responseCode == 200) {
		String tid = (String) json.get("tid");
		tid = SecurityUtils.encodeAES(tid);
		json.put("tid", tid);
	}
	
	out.println(json);
%>
