<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.*" %>
<%@ page import="javax.xml.ws.Response"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="com.fasterxml.jackson.core.type.TypeReference" %>
<%@page import="com.fasterxml.jackson.databind.node.ArrayNode"%>
<%@page import="com.fasterxml.jackson.databind.JsonNode"%>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.sanghafarm.utils.*, com.sanghafarm.service.order.*" %>
<%@ page import="com.efusioni.stone.utils.*" %>
<%@ include file="/order/payco/common_include.jsp" %>
<% 
/**-----------------------------------------------------------------------
 * 재고수량 및 금액 정합성 검사(ver. Pay2)
 *------------------------------------------------------------------------
 * @Class payco_return.jsp
 * @author PAYCO기술지원<dl_payco_ts@nhnent.com>
 * @since 
 * @version
 * @Description 
 * - 구매예약페이지에서 재고수량 및 금액 정합성 검사를 하기위해 통신하는 API
 * - payco 결제 인증 후 호출되어 재고 및 금액 정합성 검사를 수행한다.
 * - 재고 및 금액에 이상이 없을 시 payco 결제승인 API 를 호출하여
 * - 응답에 따라 결제완료 여부를 판단한다.
 * params : response=JSON
 * return : 
 */
%>
<% 
	Param param = new Param(request);
	//	String orderid = SanghafarmUtils.getCookie(request, "ORDERID");
	String orderid = param.get("orderid");
	
	if(orderid == null || "".equals(orderid)) {
		System.out.println("++++++++++++ parameter orderid is null !!!");
		Utils.sendMessage(out, "세션이 만료 되었거나 유효하지 않은 요청 입니다.", "/");
		return;
	}
	
	OrderService svc = (new OrderService()).toProxyInstance();
	Param info = svc.getOrderFormInfo(orderid);
	
	if(info == null || "".equals(info.get("orderid"))) {
		System.out.println("++++++++++++ order form is null !!!");
		Utils.sendMessage(out, "세션이 만료 되었거나 유효하지 않은 요청 입니다.", "/");
		return;
	}

	ObjectMapper mapper = new ObjectMapper();		  	//jackson json object
	PaycoUtil    util   = new PaycoUtil(serverType);	//CommonUtil	

	Boolean doCancel    = false;						// 승인 후 오류발생시 결제취소 여부
	Boolean doApproval  = true; 					  	// 요청금액과 결제 금액 일치여부(true : 일치)
	String	returnUrl	= "";
	
	/* 인증 데이타 변수선언 */
	String reserveOrderNo 	   	   = request.getParameter("reserveOrderNo");			//주문예약번호
	String sellerOrderReferenceKey = request.getParameter("sellerOrderReferenceKey");	//가맹점주문연동키
	String paymentCertifyToken 	   = request.getParameter("paymentCertifyToken");		//결제인증토큰(결제승인시필요)
	
	int totalPaymentAmt = 0;
	if(request.getParameter("totalPaymentAmt") == null){								//총 결제금액
		totalPaymentAmt = 0;
	}else{
		totalPaymentAmt = (int)Float.parseFloat(request.getParameter("totalPaymentAmt").toString()); 
	}
	
	String code      	   	       = request.getParameter("code");						//결과코드(성공 : 0)
	String message				   = request.getParameter("message");					//결과 메시지
	
	/* 주문예약시 전달한 returnUrlparams */
	String taxationType = request.getParameter("taxationType");
	String taxfreeAmt 	= request.getParameter("totalTaxfreeAmt");
	String taxableAmt 	= request.getParameter("totalTaxableAmt");
	String vatAmt 	  	= request.getParameter("totalVatAmt");
	
	System.out.println("payco return : " + code + " : " + message);
	
	/* 결제 인증 성공시 */
	if(code.equals("0")){
%>
<html>
<head>
<script src="/js/jquery-1.10.2.min.js"></script>
<script>
	function goOrder() {
		$("input[name=reserveOrderNo]").val("<%= reserveOrderNo %>");
		$("input[name=sellerOrderReferenceKey]").val("<%= sellerOrderReferenceKey %>");
		$("input[name=paymentCertifyToken]").val("<%= paymentCertifyToken %>");
		$("#orderForm").submit();
	}
</script>
</head>
<body onload="goOrder()">
	<form name="orderForm" id="orderForm" method="POST" action="<%= Env.getSSLPath() %>/brand/play/reservation/orderProc2.jsp">
		<%= info.get("form") %>
	</form>
</body>
</html>
<%
	}else{
		Utils.sendMessage(out, message + "(" + code + ")", "/mobile/brand/play/reservation/admission.jsp");
	} 
%>					
