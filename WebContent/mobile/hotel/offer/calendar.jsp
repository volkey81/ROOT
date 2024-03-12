<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.hotel.*" %>
<%
	Param param = new Param(request);
	HotelOfferService svc = new HotelOfferService();
	
	String ym = param.get("year") + (param.getInt("month") < 10 ? "0" : "") + param.get("month");
	
	Param dates = svc.getRdateListForCalendar(param.get("pid"));
	Calendar today = Calendar.getInstance();
	Calendar cal = Calendar.getInstance();
	cal.set(param.getInt("year"), param.getInt("month") - 1, 1);
%>
			<ul>
				<li class="monthArea">
					<h2 class="month"><span class="year"><%= param.get("year") %></span>.<span class="monthNum"><%= (param.getInt("month") < 10 ? "0" : "") + param.get("month") %></span></h2>
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
		for(int j = 1; j < cal.get(Calendar.DAY_OF_WEEK) ; j++) {
			
%>
						<li class="empty"></li>
<%
		}

		for(int m = 0; m <= 42 - cal.get(Calendar.DAY_OF_WEEK); m++) {	// 6 weeks
			Calendar c = (Calendar) cal.clone();
			Calendar nextC = (Calendar) cal.clone();
			c.add(Calendar.DATE, m);
			nextC.add(Calendar.DATE, m + 1);
			
			String d = Utils.getTimeStampString(c.getTime(), "yyyyMMdd");
			String d2 = Utils.getTimeStampString(c.getTime(), "yyyy.MM.dd");
			String nextD = Utils.getTimeStampString(nextC.getTime(), "yyyyMMdd");
			if(c.compareTo(today) < 0) {
%>
						<li class="disable" today="<%=d%>" next="<%=nextD %>"><%= c.get(Calendar.DATE) %></li>
<%
			} else if(dates.getInt(d2, 0) > 0) {
%>
						<li today="<%=d%>" next="<%=nextD %>"><a href="#"><%= c.get(Calendar.DATE) %></a></li>
<%
			} else {
%>
						<li class="disable" today="<%=d%>" next="<%=nextD %>"><a href="#"><%= c.get(Calendar.DATE) %></a></li>
<%
			}
		}
%>
					</ol>
				</li>
			</ul>
<%
	Calendar cal1 = Calendar.getInstance();
	cal1.set(param.getInt("year"), param.getInt("month") - 1, 1);
	
	if(ym.compareTo(Utils.getTimeStampString(today.getTime(), "yyyyMM")) > 0) {
		Calendar c = (Calendar) cal1.clone();
		c.add(Calendar.MONTH, -1);
%>
		<input type="image" src="/mobile/images/btn/btn_prev9.png" alt="이전달" class="prev" onclick="getCalendar(<%= c.get(Calendar.YEAR) %>, <%= c.get(Calendar.MONTH) + 1 %>); return false;">
<%
	}
	
	Calendar cal2 = Calendar.getInstance();
	cal2.add(Calendar.MONTH, 3);
	if(ym.compareTo(Utils.getTimeStampString(cal2.getTime(), "yyyyMM")) < 0) {
		Calendar c = (Calendar) cal1.clone();
		c.add(Calendar.MONTH, 1);
%>
		<input type="image" src="/mobile/images/btn/btn_next9.png" alt="다음달" class="next" onclick="getCalendar(<%= c.get(Calendar.YEAR) %>, <%= c.get(Calendar.MONTH) + 1 %>); return false;">
<%
	}
%>