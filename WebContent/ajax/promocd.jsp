<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.hotel.*" %>
<% 
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
	if(!fs.isLogin()) {
%>
{
	"result" : "N"
}
<%
		
		return;
	}
	
	HotelPromocdService promocd = new HotelPromocdService();
	
	param.set("grade_code", fs.getGradeCode());
	param.set("userid", fs.getUserId());
	param.set("device_type", fs.getDeviceType());
	
	Param info = promocd.getInfo(param);
	String result = "N";
	String msg = "유효한 프로모션이 아닙니다.";
	String today = Utils.getTimeStampString("yyyy.MM.dd HH:mm:ss");
	
	if(info != null) {
		if(!"Y".equals(info.get("avail_yn"))) {
			msg = "프로모션 대상이 아닙니다.";
		} else if(info.get("start_date").compareTo(today) > 0 || info.get("end_date").compareTo(today) < 0) {
			msg = "프로모션 기간이 종료되었습니다.";
		} else if(info.get("in_start_date").compareTo(param.get("chot_date")) > 0 || info.get("in_end_date").compareTo(param.get("chki_date")) < 0) {
			msg = "프로모션 기간이 종료되었습니다.";
		} else if(info.getInt("max_issue") != 0 && info.getInt("max_issue") <= info.getInt("tot_cnt")) {
			msg = "선착순 " + Utils.formatMoney(info.get("max_issue")) + "명을 초과하였습니다.";
		} else if(info.getInt("max_use") != 0 && info.getInt("max_use") <= info.getInt("cnt")) {
			msg = "ID당 프로모션코드는 최대 " + Utils.formatMoney(info.get("max_use")) + " 사용 가능합니다. 사용 횟수를 초과하였습니다.";
		} else {
			result = "Y";
		}
	}
	
	if("Y".equals(result)) {
%>
{
	"result" : "Y",
	"promocdid" : "<%= info.get("promocdid") %>",
	"sale_type" : "<%= info.get("sale_type") %>",
	"sale_amt" : "<%= info.get("sale_amt") %>",
	"min_price" : "<%= info.get("min_price") %>",
	"max_sale" : "<%= info.get("max_sale") %>"
}
<%
	} else {
%>
{
	"result" : "<%= result %>",
	"msg" : "<%= msg %>"
}
<%
	}
%>
