<%@ page contentType="text/html; charset=euc-kr" errorPage="/error/error.jsp"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.exception.*,
				 com.sanghafarm.service.order.*,
				 com.sanghafarm.service.imc.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	OrderService order = (new OrderService()).toProxyInstance();
	ImcService imc = (new ImcService()).toProxyInstance();
	TmsUtil tms = new TmsUtil();
	
	boolean result = false;
	String msg = "";
	String mode = param.get("mode");
	
	param.set("userid", fs.getUserId());
	
	if(!fs.isLogin()) {
		msg = "�α����� �ʿ��մϴ�.";
	} else if("CANCEL".equals(mode)) {
		try {
			param.set("userid", fs.getUserId());
			order.cancelOrder(param);
			msg = "��ҵǾ����ϴ�.";
			result = true;
			
			try {
				tms.sendOrderSms(param.get("orderid"), 1);
			} catch(Exception e) {
				e.printStackTrace();
			}
			
			try {
				imc.sendOrderTalk(param.get("orderid"), 1);
			} catch(Exception e) {
				e.printStackTrace();
			}
		} catch(OrderError oe) {
			msg = oe.getMessage();
		} catch(Exception e) {
			msg = "��û������ ó���ϴ� �� ������ �߻��߽��ϴ�";
		}
	} else if("CONFIRM".equals(mode)) {
		try {
			param.set("userid", fs.getUserId());
			param.set("userno", fs.getUserNo());
			order.confirmOrder(param);
			msg = "����Ȯ���Ǿ����ϴ�.";
			result = true;
		} catch(OrderError oe) {
			msg = oe.getMessage();
		} catch(Exception e) {
			msg = "��û������ ó���ϴ� �� ������ �߻��߽��ϴ�";
		}
	} else if("DELIVERY_DATE".equals(mode)) {
		param.set("item_seq", "1");
		Param info = order.getOrderItemInfo(param);
		if(info == null || !info.get("userid").equals(fs.getUserId())) {
			msg = "�߸��� �����Դϴ�.";
		} else {
			param.set("regist_user", fs.getUserId());
			order.modifyDeliveryDate(param);
			msg = "����Ǿ����ϴ�.";
			result = true;
		}
	}
%>
{
	"result" : <%= result %>,
	"msg" : "<%= msg %>"
}
