<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.product.*" %>
<%
	Param param = new Param(request);
	ExpProductService svc = (new ExpProductService()).toProxyInstance();
	FrontSession fs = FrontSession.getInstance(request, response);

	if(fs.isLogin()) {
		param.set("grade_code", fs.getGradeCode());
		param.set("userid", fs.getUserId());
	} else {
		param.set("grade_code", "001");
	}
	
	List<Param> list = svc.getExpListByDate(param);

	for(Param row : list) {
%>
						<li><a href="#none" alt="<%= row.get("exp_type") %>" onclick="selectExpType(this)"><%= row.get("exp_type_name") %></a></li>
<%
	}
%>
