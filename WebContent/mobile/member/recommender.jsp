<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.efusioni.stone.common.Config"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.efusioni.stone.utils.*"%>
<%@ page import="com.efusioni.stone.common.SystemChecker"%>
<%@ page import="com.sanghafarm.service.member.*"%>
<%
	response.setHeader("Pragma","no-cache");				// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);					// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");				// HTTP1.1 캐쉬 방지
	
	if("HTTP/1.1".equals(request.getProtocol())){
		response.setHeader("Cache-Control", "no-cache");	// HTTP1.1 캐쉬 방지
	}
	
	Param param = new Param(request);
	boolean result = false;
	String msg = "";
	try {
		MemberService svc = (new MemberService()).toProxyInstance();
		svc.modifyRecommender(param);
		result = true;
	} catch(Exception e) {
		msg = "오류가 발생했습니다.";
		e.printStackTrace();
	}
%>

{"result" : <%= result %>, "message" : "<%= msg %>"}
