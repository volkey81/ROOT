<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.common.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	SanghafarmUtils.setCookie(response, "APP_YN", "Y", fs.getDomain(), -1);

	String strToken = SanghafarmUtils.getCookie(request, "autoToken");    //토큰
	String strLoginUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/autoLoginProc.jsp"; //URL(일반로그인)
	String device_Type = fs.getDeviceType();

// 	if (device_Type.equals("A") && !strToken.equals("")){
	if (!strToken.equals("")){
		response.sendRedirect(strLoginUrl);
	}else{
		response.sendRedirect("/mobile/");
	}
	
%>
