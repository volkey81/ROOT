<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.member.*" %>
<%
	if(!SystemChecker.isReal()) {
		Param param = new Param(request);
		FrontSession fs = FrontSession.getInstance(request, response);
		MemberService svc = (new MemberService()).toProxyInstance();
		
		Param info = svc.getImInfo(param.getInt("unfy_mmb_no"));
		fs.login(info);
	}
	
	response.sendRedirect("/");
%>
