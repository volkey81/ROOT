<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.api.*" %>
<%
	Param param = new Param(request);
	TmsapiService svc = new TmsapiService();
%>
<%= svc.searchDeliveryArea(param.get("addr")) %>
