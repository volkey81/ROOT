<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*" %>
<% 
	Param param = new Param(request);
	
	try {
		Param p = new Param();
		String content = "[상하농원] App 다운로드\n안드로이드 : https://goo.gl/RqWXew\nIOS : https://goo.gl/UTjZoS";
		
		p.set("content", content);
		p.set("phone", "010" + param.get("mobile2") + param.get("mobile3"));
		p.set("sms_id", TmsUtil.SMS_ID_02);
		TmsUtil tms = new TmsUtil();
		tms.sendSms(p);
	} catch(Exception e) {
		e.printStackTrace();
	}
%>
{
	"msg" : "문자가 발송되었습니다."
}
