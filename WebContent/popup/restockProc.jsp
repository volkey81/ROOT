<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.order.*" %>
<%
	Param param = new Param(request);
	RestockService svc = (new RestockService()).toProxyInstance();
	
	boolean result = false;
	String msg = "";
	
	svc.create(param);
	result = true;
	msg = "등록되었습니다.";
%>
{
	"result" : <%= result %>,
	"msg" : "<%= msg %>"
}
