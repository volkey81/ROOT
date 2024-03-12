<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.product.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	param.set("grade_code", fs.getGradeCode());
	param.set("userid", fs.getUserId());
	
	ExpProductService svc = (new ExpProductService()).toProxyInstance();
	List<Param> list = svc.getExpListByDate(param);

	for(Param row : list) {
%>
	<option value="<%= row.get("exp_type") %>" <%= row.get("exp_type").equals(param.get("exp_type")) ? "selected" : "" %>><%= row.get("exp_type_name") %></option>
<%
	}
%>
