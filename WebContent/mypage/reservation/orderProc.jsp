<%@ page contentType="text/html; charset=euc-kr" errorPage="/error/error.jsp"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.exception.*,
				 com.sanghafarm.service.order.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	TicketOrderService order = (new TicketOrderService()).toProxyInstance();
	
	boolean result = false;
	String msg = "";
	String mode = param.get("mode");
	
	param.set("userid", fs.getUserId());
	
	if(!fs.isLogin()) {
		msg = FrontSession.LOGIN_MSG;
	} else if("CANCEL".equals(mode)) {
		try {
			if("".equals(param.get("morderid"))) {
				msg = "잘못된 접근입니다.";
			} else {
				param.set("userid", fs.getUserId());
				order.cancelOrder2(param);
				msg = "취소되었습니다.";
				result = true;
				
				try {
					TmsUtil tms = new TmsUtil();
					tms.sendReserveSms(param.get("morderid") + "0");
				} catch(Exception e) {
					e.printStackTrace();
				}
			}
		} catch(OrderError oe) {
			msg = oe.getMessage();
		} catch(Exception e) {
			msg = e.getMessage();
		}
	} else if("CONFIRM".equals(mode)) {
		try {
			param.set("userid", fs.getUserId());
// 			order.confirmOrder(param);
			msg = "구매확정되었습니다.";
			result = true;
		} catch(OrderError oe) {
			msg = oe.getMessage();
		} catch(Exception e) {
			msg = e.getMessage();
		}
	}
%>
{
	"result" : <%= result %>,
	"msg" : "<%= msg %>"
}
