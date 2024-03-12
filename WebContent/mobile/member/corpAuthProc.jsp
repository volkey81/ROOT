<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.sanghafarm.common.*"%>
<%@ page import="com.sanghafarm.service.member.*"%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	Param param = new Param(request);
	
	MemberService svc = (new MemberService()).toProxyInstance();
	int count = svc.getNaverEmpnoCount(param.get("empno"));
	
	if(count >= 5) {
		Utils.sendMessage(out, "이미 사용중인 사번입니다.");
	} else {
		boolean auth = svc.naverEmpAuth(param.get("empno"));
		
		if(auth) {
			Param p = new Param("userid", fs.getUserId(), "naver_empno", param.get("empno"));
			svc.mergeNaverEmpno(p);
			
			SanghafarmUtils.setCookie(response, "GRADE_CODE", "005", fs.getDomain(), -1);
%>
	<script>
		alert("임직원 인증이 완료되었습니다.");
		if(parent.opener != null ) {
	        opener.location.reload();
	        window.close();
	    } else {
	    	location.href = "/";
	    } 
	</script>
<%
		} else {
			Utils.sendMessage(out, "임직원 인증이 실패하였습니다.");
		}
	}
%>
