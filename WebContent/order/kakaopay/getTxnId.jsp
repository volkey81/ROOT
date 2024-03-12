<%@page import="com.lgcns.kmpay.dto.DealApproveDto"%>
<%@page import="com.lgcns.kmpay.service.CallWebService4NS"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.sanghafarm.common.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="/order/kakaopay/incKakaopayCommon.jsp" %>
<%
	request.setCharacterEncoding("utf-8");

	// 가맹점에서 MPay로 전문을 보내기 위한 객체 생성
	// 타임아웃 설정
	int timeOut = 20;
	// 모듈이 설치되어 있는 경로 설정
	CallWebService4NS webService = new CallWebService4NS(timeOut);

	// 로그 디렉토리 생성
// 	webService.setLogHome(logHome);
	webService.setLogHome(logHome);
	// 프로퍼티 위치지정
// 	webService.setKMPayHome(cnsPayHome);
	webService.setKMPayHome(cnsPayHome);

    // 서버로부터 받은 결과값 저장 JSONObject
    JSONObject  resultJSONObject =  new JSONObject();

    // TXN_ID를 요청하기 위한 PARAMETER 획득
    String PR_TYPE = request.getParameter("prType");
    String MERCHANT_ID = request.getParameter("MID");
    String MERCHANT_TXN_NUM = request.getParameter("merchantTxnNum");
    String channelType = request.getParameter("channelType");
    //문자열 인코딩 문제 극복을 위해 상품명은 api에 직접 setting
    byte[] PRODUCT_NAME = (""+request.getParameter("GoodsName")).getBytes("UTF-8");
    String AMOUNT = request.getParameter("Amt");
    String serviceAmt = request.getParameter("ServiceAmt");
    String supplyAmt = request.getParameter("SupplyAmt");
    String goodsVat = request.getParameter("GoodsVat");
    
    // 과세, 면세 금액 계산
	int totAmt = Integer.parseInt(AMOUNT);
   	int taxfreeAmt = Integer.parseInt(request.getParameter("LGD_TAXFREEAMOUNT"));
	int taxableAmt = (int) ((totAmt - taxfreeAmt) / 1.1);
	int vatAmt = totAmt - taxfreeAmt - taxableAmt;
	
	supplyAmt = (taxfreeAmt + taxableAmt) + "";
	goodsVat = vatAmt + "";
	serviceAmt = "";
    
	System.out.println("totAmt = " + totAmt + ", taxfreeAmt = " + taxfreeAmt + " taxableAmt = " + taxableAmt + " vatAmt = " + vatAmt);
	System.out.println("totAmt = " + AMOUNT + ", supplyAmt = " + supplyAmt + " goodsVat = " + goodsVat);
    
    String CURRENCY = request.getParameter("currency");
    String RETURN_URL = request.getParameter("returnUrl");
    // ENC KEY와 HASH KEY는 가맹점에서 생성한 KEY 로 SETTING 한다.
    String merchantEncKey = request.getParameter("merchantEncKey");
    String merchantHashKey = request.getParameter("merchantHashKey");
    String requestDealApproveUrl = request.getParameter("requestDealApproveUrl");
    String certifiedFlag = request.getParameter("certifiedFlag");
    
    String requestorName = request.getParameter("requestorName");
    String requestorTel = request.getParameter("requestorTel");
    
    String offerPeriod = request.getParameter("offerPeriod");
    String offerPeriodFlag = request.getParameter("offerPeriodFlag");
    
    
    //무이자옵션
    String possiCard = request.getParameter("possiCard");
    String fixedInt = request.getParameter("fixedInt");
    String maxInt = request.getParameter("maxInt");
    String noIntYN = request.getParameter("noIntYN");
    String noIntOpt = request.getParameter("noIntOpt");
    String pointUseYN = request.getParameter("pointUseYn");
    String blockCard = request.getParameter("blockCard");
    
    String blockBin = request.getParameter("blockBin");
	
	String OrderCheckYn= request.getParameter("OrderCheckYn");
    String OrderBirthDay= request.getParameter("OrderBirthDay");
    String OrderName= request.getParameter("OrderName");
    String OrderTel= request.getParameter("OrderTel");
    
    // 결과값을 담는 부분
    String resultString = "";
    String resultCode = "";
    String resultMsg = "";
    String txnId = "";
    String merchantTxnNum = "";
    String prDt = "";
    
    
    
    // 전문 Parameter DTO 객체 생성
    DealApproveDto approveDto = new DealApproveDto();
    
    
    // DTO 객체에 인증 PARAMETER 세팅 
    // 기타 approveDto에 추가로 셋팅해야하는 값은 문서(kakaopay_MobilePC_Web_Module_Manual) 참고하여 setter로 추가

    approveDto.setRequestDealApproveUrl(requestDealApproveUrl); // 결제요청을 위한 URL
    approveDto.setMerchantEncKey(merchantEncKey); // 가맹점의 EncKey
    approveDto.setMerchantHashKey(merchantHashKey); // 가맹점의 HashKey

    approveDto.setCertifiedFlag(certifiedFlag); // WEB결제로 신청할시에 필수 'CN'
    approveDto.setPrType(PR_TYPE);
    approveDto.setChannelType(channelType); // TMS 및 방판 결제시 필수
    
    approveDto.setRequestorName(requestorName);
    approveDto.setRequestorTel(requestorTel);
    
    approveDto.setMerchantID(MERCHANT_ID);
    approveDto.setMerchantTxnNum(MERCHANT_TXN_NUM);
    
    approveDto.setProductName(new String(PRODUCT_NAME,"UTF-8"));
    
    approveDto.setAmount(AMOUNT);
    approveDto.setServiceAmt(serviceAmt);
    approveDto.setSupplyAmt(supplyAmt);
    approveDto.setGoodsVat(goodsVat);
    
    approveDto.setCurrency(CURRENCY);
    approveDto.setReturnUrl(RETURN_URL);
    
    approveDto.setOfferPeriod(offerPeriod);
    approveDto.setOfferPeriodFlag(offerPeriodFlag);
    
    approveDto.setPossiCard(possiCard);
    approveDto.setFixedInt(fixedInt);
    approveDto.setMaxInt(maxInt);
    approveDto.setNoIntYN(noIntYN);
    approveDto.setNoIntOpt(noIntOpt);
    approveDto.setPointUseYN(pointUseYN);
    approveDto.setBlockCard(blockCard);
    
    approveDto.setBlockBin(blockBin);
	
	approveDto.setOrderCheckYn(OrderCheckYn);
    approveDto.setOrderBirthDay(OrderBirthDay);
    approveDto.setOrderName(OrderName);
    approveDto.setOrderTel(OrderTel);
    
    resultJSONObject = webService.requestDealApprove(approveDto);
    resultString = resultJSONObject.toString();

    if( !resultString.equals("{}") ) {
        resultCode = resultJSONObject.getString("RESULT_CODE");
        resultMsg = resultJSONObject.getString("RESULT_MSG");
        
        if( resultCode.equals("00") ) {
            txnId = resultJSONObject.getString("TXN_ID");
            merchantTxnNum = resultJSONObject.getString("MERCHANT_TXN_NUM");
            prDt = resultJSONObject.getString("PR_DT");
        }
    }
    
%>

<script>
    function setTxnId() {
        var resultCode   = "<%=resultCode%>";
        var resultMsg    = "<%=resultMsg%>";

        var txnId           = "<%=txnId%>";
        var merchantTxnNum  = "<%=merchantTxnNum%>";
        var prDt            = "<%=prDt%>";
        
        
        // 가져온 결과를 payForm에 세팅
        parent.document.getElementById('resultCode').value = resultCode;
        parent.document.getElementById('resultMsg').value = resultMsg;
        parent.document.getElementById('txnId').value = txnId;
        //parent.document.getElementById('merchantTxnNum').value = merchantTxnNum;
        parent.document.getElementById('prDt').value = prDt;
        
        parent.cnspay();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="utf-8" lang="utf-8">
<head></head>
<body onload="setTxnId()">
TXN ID 획득을 위한 페이지
</body>
</html>