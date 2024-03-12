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
	List<Param> list = svc.getExpList(param);

	for(Param row : list) {
		boolean isSoldout = row.getInt("seat_num") - row.getInt("reserved_num") <= 0 ? true : false;
		
		if(param.get("date").equals(Utils.getTimeStampString(new Date(), "yyyy.MM.dd"))) {
			if(row.get("time").compareTo(Utils.getTimeStampString(new Date(), "HHmm")) < 0) {
				isSoldout = true;
			}
		}
%>
	<li>
		<input type="radio" name="exp_pid" value="<%= row.get("exp_pid") %>" id="program_<%= row.get("exp_pid") %>" <%= isSoldout ? "disabled" : "" %> onclick="step3(this.value);">
		<label for="program_<%= row.get("exp_pid") %>"><%= row.get("place_name") %> <%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %> : <%= isSoldout ? "체험마감" : (row.getInt("seat_num") - row.getInt("reserved_num")) + "명" %></label>
		<input type="hidden" name="remain_<%= row.get("exp_pid") %>" id="remain_<%= row.get("exp_pid") %>" value="<%= row.getInt("seat_num") - row.getInt("reserved_num") %>" />
	</li>
<%
	}
%>
