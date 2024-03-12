<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.security.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.exception.*,
				 com.sanghafarm.service.order.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	OrderService order = (new OrderService()).toProxyInstance();
	
	boolean result = false;
	if("005".equals(param.get("pay_type"))) {
		Param info = order.getKakaoPayInfo(param.get("orderid"));
		String tid = "";
		if(info != null) {
			result = true;
			tid = info.get("tid");
		}
%>
{
	"result" 	: <%= result %>,
	"tid" 	: "<%= tid %>"
}
<%
	} else if("006".equals(param.get("pay_type"))) {
		Param info = order.getPaycoInfo(param.get("orderid"));
		String orderNo = "";
		if(info != null) {
			result = true;
			orderNo = info.get("order_no");
		}
%>
{
	"result" 	: <%= result %>,
	"order_no" 	: "<%= orderNo %>"
}
<%
	} else {
		String lgdMid = "";
		String lgdTid = "";
		String authdata = "";

		Param info = order.getLGDPaymentInfo(param.get("orderid"));
		if(info != null) {
			result = true;
			lgdMid = info.get("lgd_mid");
			lgdTid = info.get("lgd_tid");
			
			StringBuffer sb = new StringBuffer();
			sb.append(lgdMid);
			sb.append(lgdTid);
			sb.append(Config.get("lgdacom.LGD_MERTKEY"));
	
			byte[] bNoti = sb.toString().getBytes();
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] digest = md.digest(bNoti);
			
			StringBuffer strBuf = new StringBuffer();
			for (int i=0 ; i < digest.length ; i++) {
			    int c = digest[i] & 0xff;
			    if (c <= 15) {
			        strBuf.append("0");
			    }
			    strBuf.append(Integer.toHexString(c));
			}
			
			authdata = strBuf.toString();
		}
%>
{
	"result" 	: <%= result %>,
	"lgd_mid" 	: "<%= lgdMid %>",
	"lgd_tid"	: "<%= lgdTid %>",
	"authdata"	: "<%= authdata %>"
}
<%
	}
%>
