<%@ page contentType="text/html; charset=utf-8" errorPage="/error/error.jsp"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.exception.*,
				 com.sanghafarm.service.hotel.*,
				 org.json.simple.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	HotelOfferService svc = (new HotelOfferService()).toProxyInstance();
	
	boolean result = false;
	String msg = "";
	String mode = param.get("mode");
	
	if(!fs.isLogin()) {
		msg = FrontSession.LOGIN_MSG;
	} else if("CANCEL".equals(mode)) {
		Param info = svc.getReserveInfo(param.get("orderid"));
		
		if(!info.get("userid").equals(fs.getUserId())) {
			msg = "잘못된 접근입니다.";
		} else {
			try {
				param.set("userid", fs.getUserId());
				svc.cancelOrder(param);
				msg = "취소되었습니다.";
				result = true;

				try {
					Param p = new Param();
					String content = "[상하농원] 객실예약 취소 안내\n";
					content += "예약번호 : " + info.get("orderid") + "\n";
					content += info.get("name") + "님의 [" + info.get("chki_date");
					content += "~" + info.get("chot_date") + "] 파머스빌리지 객실 예약이 취소되었습니다.\n";
					content += "- 신용카드 환불은 카드사 사정에 따라 3~7일 소요될 수 있습니다.\n\n";
					content += "▶ 예약취소내역 확인하기\nhttps://bit.ly/2Od3QmC\n\n";
					content += "온라인예약 문의☎ 고객센터1522-3698\n기타 문의☎ 파머스빌리지 063-563-6611";
					
					p.set("content", content);
					p.set("phone", info.get("mobile1") + info.get("mobile2") + info.get("mobile3"));
					p.set("sms_id", TmsUtil.SMS_ID_02);
					TmsUtil tms = new TmsUtil();
					tms.sendSms(p);
				} catch(Exception e) {
					e.printStackTrace();
				}
			} catch(OrderError oe) {
				msg = oe.getMessage();
			} catch(Exception e) {
				msg = e.getMessage();
			}
		}
	}
%>
{
	"result" : <%= result %>,
	"msg" : "<%= msg %>"
}
