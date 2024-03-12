<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.efusioni.stone.common.Config"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.sanghafarm.service.member.*"%>
<%@ page import="com.efusioni.stone.utils.*"%>
<%@ page import="com.efusioni.stone.common.SystemChecker"%>
<%
	response.setHeader("Pragma","no-cache");				// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);					// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");				// HTTP1.1 캐쉬 방지
	
	if("HTTP/1.1".equals(request.getProtocol())){
		response.setHeader("Cache-Control", "no-cache");	// HTTP1.1 캐쉬 방지
	}
	
	Param param = new Param(request);
	MemberService svc = new MemberService();
	
	Param info = svc.getImInfoById(param.get("userId"));
	
	String strResult     = ""; 

	if(info != null && !"".equals(info.get("unfy_mmb_no"))){
 		strResult = "true";
 	}else{
 		strResult = "false";
 	}
%>

{"result" : "<%=strResult %>"}
