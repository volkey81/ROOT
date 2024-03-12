<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.hotel.*" %>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%
	Param param = new Param(request);
	HotelOfferService svc = new HotelOfferService();

	String ym = param.get("year") + (param.getInt("month") < 10 ? "0" : "") + param.get("month");

	Param dates = svc.getRdateListForCalendar(param.get("pid"));
	Calendar today = Calendar.getInstance();
	Calendar cal = Calendar.getInstance();
	cal.set(param.getInt("year"), param.getInt("month") - 1, 1);
%>
<%	
	for(int i = 0; i < 2; i++) {
		Calendar c = (Calendar) cal.clone();
		Calendar nextC = (Calendar) cal.clone();

		c.add(Calendar.MONTH, i);
		c.set(Calendar.DATE, 1);
		String year = c.get(Calendar.YEAR) + "";
		String month = (c.get(Calendar.MONTH) + 1) < 10 ? "0" + (c.get(Calendar.MONTH) + 1) : "" + (c.get(Calendar.MONTH) + 1);
%>
							<div class="monthArea">
								<h2><span class="year"><%= year %></span>.<span class="monthNum"><%= month %></span></h2>
								<ol class="week">
									<li class="sunday">일</li>
									<li>월</li>
									<li>화</li>
									<li>수</li>
									<li>목</li>
									<li>금</li>
									<li>토</li>
								</ol>		
								<ol class="day">
<%
		for(int j = 1; j < c.get(Calendar.DAY_OF_WEEK) ; j++) {
%>
									<li class="empty"></li>
<%
		}

		for(int m = 1; m <= c.getActualMaximum(Calendar.DAY_OF_MONTH); m++) {
			c.set(Calendar.DATE, m);
			nextC.set(Calendar.DATE, m);
			nextC.add(Calendar.DATE, 1);
			String d = Utils.getTimeStampString(c.getTime(), "yyyyMMdd");
			String d2 = Utils.getTimeStampString(c.getTime(), "yyyy.MM.dd");
			String nextD = Utils.getTimeStampString(nextC.getTime(), "yyyyMMdd");
			if(c.compareTo(today) < 0) {
%>
									<li class="disable" today="<%=d%>" next="<%=nextD %>"><%= m %></li>
<%
			} else if(dates.getInt(d2, 0) > 0) {
%>
									<li today="<%=d%>" next="<%=nextD %>"><a href="#"><%= m %></a></li>
<%
			} else {
%>
									<li class="disable" today="<%=d%>" next="<%=nextD %>"><a href="#"><%= m %></a></li>
<%
			}
		}
%>
								</ol>
							</div>
<%
	}
%>
<%
	Calendar cal1 = Calendar.getInstance();
	cal1.set(param.getInt("year"), param.getInt("month") - 1, 1);
	
	if(ym.compareTo(Utils.getTimeStampString(today.getTime(), "yyyyMM")) > 0) {
		Calendar c = (Calendar) cal1.clone();
		c.add(Calendar.MONTH, -1);
%>
						<a href="javascript:getCalendar(<%= c.get(Calendar.YEAR) %>, <%= c.get(Calendar.MONTH) + 1 %>)"><img src="/images/btn/btn_prev13.png" alt="이전달" class="prev"></a>
<%
	}
	
	Calendar cal2 = Calendar.getInstance();
	cal2.add(Calendar.MONTH, 120);
	if(ym.compareTo(Utils.getTimeStampString(cal2.getTime(), "yyyyMM")) < 0) {
		Calendar c = (Calendar) cal1.clone();
		c.add(Calendar.MONTH, 1);
%>
						<a href="javascript:getCalendar(<%= c.get(Calendar.YEAR) %>, <%= c.get(Calendar.MONTH) + 1 %>)"><img src="/images/btn/btn_next13.png" alt="다음달" class="next"></a>
<%
	}
%>