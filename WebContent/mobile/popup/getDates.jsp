<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.utils.*" %>
<%
	Param param = new Param(request);

	String[] days = param.getValues("days[]");
	int period = param.getInt("period");
	int cnt = param.getInt("cnt");
	
	String syear = "";
	String smonth = "";
	String sdate = "";
	String sday = "";
	String eyear = "";
	String emonth = "";
	String edate = "";
	String eday = "";
	
	// 8월 정기배송 특가 상품 코드
	String eventPid = Config.get("evend1.pid." + SystemChecker.getCurrentName());

	if(days.length != 0) {
		List<Date> list = null;
		
		if(eventPid.equals(param.get("pid"))) {
			list = SanghafarmUtils.getDeliveryDates(days, period, cnt, "20170803");
		} else {
			list = SanghafarmUtils.getDeliveryDates(days, period, cnt);
		}

		System.out.println("Date List : " + list);
		syear = Utils.getTimeStampString(list.get(0),  "yyyy");
		smonth = Utils.getTimeStampString(list.get(0),  "MM");
		sdate = Utils.getTimeStampString(list.get(0),  "dd");
		sday = Utils.getTimeStampString(list.get(0),  "E");
		eyear = Utils.getTimeStampString(list.get(cnt - 1),  "yyyy");
		emonth = Utils.getTimeStampString(list.get(cnt - 1),  "MM");
		edate = Utils.getTimeStampString(list.get(cnt - 1),  "dd");
		eday = Utils.getTimeStampString(list.get(cnt - 1),  "E");
	}
%>
{
	"syear" : "<%= syear %>",
	"smonth" : "<%= smonth %>",
	"sdate" : "<%= sdate %>",
	"sday" : "<%= sday %>",
	"eyear" : "<%= eyear %>",
	"emonth" : "<%= emonth %>",
	"edate" : "<%= edate %>",
	"eday" : "<%= eday %>"
}
