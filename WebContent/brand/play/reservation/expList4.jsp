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
%>
					<li id="exp_row_0">
						<input type="checkbox" name="exp_pid" id="exp_pid_0" value="0" onclick="javascript:step2('0');">
						<input type="hidden" name="exp_type_name_0" id="exp_type_name_0" value="입장권">
						<input type="hidden" name="time_name_0" id="time_name_0" value="종일">
						<strong>종일</strong>
						<p class="tit">입장권</p>
					</li>
<%
	ExpProductService svc = (new ExpProductService()).toProxyInstance();
	List<Param> list = svc.getAllExpListByDate(param);

	for(Param row : list) {
		int remain = row.getInt("seat_num") - row.getInt("reserved_num");
		boolean isSoldout = remain <= 0 ? true : false;
		
		if(param.get("date").equals(Utils.getTimeStampString(new Date(), "yyyy.MM.dd"))) {
			if(row.get("time").compareTo(Utils.getTimeStampString(new Date(), "HHmm")) < 0) {
				isSoldout = true;
			}
		}
%>
					<li id="exp_row_<%= row.get("exp_pid") %>" <%= isSoldout ? "class=\"soldOut\"" : "" %>>
						<input type="checkbox" name="exp_pid" id="exp_pid_<%= row.get("exp_pid") %>" value="<%= row.get("exp_pid") %>" onclick="javascript:step2('<%= row.get("exp_pid") %>');" <%= isSoldout ? "disabled" : "" %>>
						<input type="hidden" name="exp_type_name_<%= row.get("exp_pid") %>" id="exp_type_name_<%= row.get("exp_pid") %>" value="<%= row.get("exp_type_name") %>">
						<input type="hidden" name="time_name_<%= row.get("exp_pid") %>" id="time_name_<%= row.get("exp_pid") %>" value="<%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %>">
						<input type="hidden" name="place_name_<%= row.get("exp_pid") %>" id="place_name_<%= row.get("exp_pid") %>" value="<%= row.get("place_name") %>">
						<input type="hidden" name="remain_<%= row.get("exp_pid") %>" id="remain_<%= row.get("exp_pid") %>" value="<%= remain %>">
						<strong><%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %></strong>
						<p class="tit"><%= row.get("exp_type_name") %> - <%= row.get("place_name") %><%= isSoldout ? "<span class=\"iconSoldout\">매진</span>" : "" %></p>
						<p class="num <%= remain <= 5 ? "numColor" : "" %>">잔여:<span><%= isSoldout ? "0" : remain %></span>명</p>
					</li>
<%
	}
%>
