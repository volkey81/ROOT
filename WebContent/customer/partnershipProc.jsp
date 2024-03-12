<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.service.board.*" %>
<%
	Param param = new Param(request);
	PartnershipService svc = (new PartnershipService()).toProxyInstance();
	
	svc.create(param);
 	Utils.sendMessage(out, "등록되었습니다.", "/");
%>