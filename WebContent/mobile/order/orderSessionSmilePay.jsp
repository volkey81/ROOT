<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.efusioni.stone.common.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.order.*" %>
<%
	Param param = new Param(request);
	OrderService svc = (new OrderService()).toProxyInstance();
	
	// Smilepay의 INBOUND 전문 URL SETTING
	String msgName = "/smilepay/requestDealApprove.htm";
	String webPath = "https://pg.cnspay.co.kr"; //PG사의 인증 서버 주소

	Enumeration _enum = request.getParameterNames();
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<script src="<%= webPath %>/dlp/scripts/smilepay.js" charset="utf-8"></script>
<script type="text/javascript">

	//인증 시 발급된 txnid를 받아옵니다.
	function getTxnId(){
		// form에 iframe 주소 세팅
		document.orderForm.target = "txnIdGetterFrame";
		document.orderForm.acceptCharset = "utf-8";
		if (document.orderForm.canHaveHTML) { // detect IE
			document.charset = orderForm.acceptCharset;
		}
		document.orderForm.action = "/order/smilepay/getTxnId.jsp";
		// post로 iframe 페이지 호출
		document.orderForm.submit();
	}

	//인증 후 SmilePay 결제창을 호출
	function smilepay(){
// 		if(document.getElementById("smilepay").checked){
			// 결과코드가 00(정상처리되었습니다.)
			if(document.orderForm.resultCode.value == "00"){
				//스마일페이 결제창을 호출하는 부분
				smilepay_L.movePage(document.orderForm.txnId.value);
			}else{
				alert("[RESULT_CODE] : " + document.orderForm.resultCode.value + "\n[RESULT_MSG] : " + document.orderForm.resultMsg.value);
			}
// 		}
	}
</script>
</head>
<body onload="getTxnId()">
<form name="orderForm" id="orderForm" method="POST">
<%
// 	Param payReqMap = new Param();
	StringBuffer buf = new StringBuffer();
	
	while (_enum.hasMoreElements()) {
	
		String key = (String) _enum.nextElement();
	
		// 일반적인 파라미터를 셋팅
		if(request.getParameterValues(key).length == 1){
			buf.append("<input type='hidden' name='" + key + "' id='" + key + "' value='" + Utils.safeHTML(Utils.nvl(request.getParameter(key), "")) + "'>\n" );
		}
		//}
		
		// checkbox 같은 배열 파라미터 셋팅
		String[] pv = null;
		if (request.getParameterValues(key) != null) {
			pv = request.getParameterValues(key);
	
			if (pv.length > 1){
				for(int i=0; i<pv.length; i++){
					buf.append("<input type='hidden' name='" + key + "' id='" + key + "' value='" + Utils.safeHTML(pv[i]) + "'>\n" );	
				}
			}
		}
	}

	
	out.println(buf.toString());
	
	Param info = svc.getOrderFormInfo(param.get("orderid"));
	if(info == null || "".equals(info.get("orderid"))) {
		svc.createOrderForm(new Param("orderid", param.get("orderid"), "form", buf.toString()));
	} else {
		svc.modifyOrderForm(new Param("orderid", param.get("orderid"), "form", buf.toString()));
	}
%>
</form>
<iframe name="txnIdGetterFrame" id="txnIdGetterFrame" src="" width="0" height="0"></iframe>
</body>
</html>