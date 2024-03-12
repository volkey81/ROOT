<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.hotel.*,
			com.sanghafarm.utils.*,
			org.json.simple.*" %>
<%
	Param param = new Param(request);
	HotelOfferService svc = new HotelOfferService();
	
	Param info = svc.getReserveInfo(param.get("orderid"));
	boolean result = false;
	String msg = "";
	
	if(!"Y".equals(info.get("sms_yn"))) {
		try {
			Param p = new Param();
			String content = "[상하농원] 객실예약 완료 안내\n";
			content += "예약번호 : " + info.get("orderid") + "\n";
			content += info.get("name") + "님의 [" + info.get("chki_date") + "~" + info.get("chot_date") + "] 파머스빌리지 객실 예약이 완료되었습니다.\n";
			content += "- 예약은 투숙예정일 8일전 까지 무료 취소 가능합니다.(이후 위약금 부과)\n";
			content += "- 투숙예정일 7일 이내 취소 건은 고객센터 문의주세요.\n";
			content += "- 체크인은 투숙예정일 15시부터 가능합니다.\n\n";
			content += "▶ 찾아오시는 길\n전라북도 고창군 상하면 상하농원길 11-23\n\n";
			content += "▶ 마이페이지에서 확인하기\nhttps://bit.ly/2OTd8cs\n\n";
			content += "온라인예약 문의☎ 고객센터1522-3698\n기타 문의☎ 파머스빌리지 063-563-6611";
			
			p.set("content", content);
			p.set("phone", info.get("mobile1") + info.get("mobile2") + info.get("mobile3"));
			p.set("sms_id", TmsUtil.SMS_ID_02);
			TmsUtil tms = new TmsUtil();
			tms.sendSms(p);
			
			svc.modifySmsyn(info.get("orderid"));

			result = true;
			msg = "문자가 발송되었습니다.";
		} catch(Exception e) {
			e.printStackTrace();
			msg = "문자발송중 오류가 발생했습니다.";
		}
	} else {
		msg = "이미 예약번호를 SMS로 발송하였습니다. 예약번호는 1회만 발송 가능합니다.";
	}
%>
{
	"result" : <%= result %>,
	"msg" : "<%= msg %>"
}
