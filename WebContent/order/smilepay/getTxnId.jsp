<%@page import="com.lgcns.kmpay.dto.DealApproveDto"%>
<%@page import="com.lgcns.kmpay.service.CallWebService"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.sanghafarm.utils.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
	request.setCharacterEncoding("utf-8");

    // 서버로부터 받은 결과값 저장 JSONObject
    JSONObject resultJSONObject = new JSONObject();

    // TXN_ID를 요청하기 위한 PARAMETER
    String merchantId = request.getParameter("MID");
    String merchantTxnNum = request.getParameter("merchantTxnNum");
    byte[] productName = (""+request.getParameter("GoodsName")).getBytes("UTF-8");
    String amount = request.getParameter("Amt");
    String supplyAmt = request.getParameter("SupplyAmt");
    String goodsVat = request.getParameter("GoodsVat");
    String serviceAmt = request.getParameter("ServiceAmt");
	String taxationAmt = request.getParameter("TaxationAmt");
	String currency = request.getParameter("currency");
	String pointUseYn = request.getParameter("pointUseYn");
	String possiCard = request.getParameter("possiCard");
    String offerPeriodFlag = request.getParameter("offerPeriodFlag");
	String offerPeriod = request.getParameter("offerPeriod");
	String etc1 = request.getParameter("etc1");
    String etc2 = request.getParameter("etc2");
    String etc3 = request.getParameter("etc3");
    String userKey = request.getParameter("userKey");
    String smileCash = request.getParameter("smileCash");
	String isSmileAppInstalled = request.getParameter("isSmileAppInstalled");
	String calledFromAppOrElse = request.getParameter("calledFromAppOrElse");
	String shopAppIosScheme = request.getParameter("shopAppIosScheme");
    String returnUrl2 = request.getParameter("returnUrl2");
    String itemType = request.getParameter("itemType");
    String encKey = request.getParameter("merchantEncKey");
    String hashKey = request.getParameter("merchantHashKey");
    String requestDealApproveUrl = request.getParameter("requestDealApproveUrl");
    
    String pname = new String(productName, "UTF-8");
    if(pname.length() > 40) pname = pname.substring(0, 40);
    		
    // 결과값을 담는 부분
    String resultString = "";
    String resultCode = "";
    String resultMsg = "";
    String txnId = "";
    String prDt = "";
    
    // 가맹점에서 전문을 송신하기 위한 객체 생성
    CallWebService webService = new CallWebService();
    
	// 로그 디렉토리 생성
	webService.setLogHome(SmilepayUtil.LOG_HOME);
	// 프로퍼티 위치지정
	webService.setKMPayHome(SmilepayUtil.CNSPAY_HONE);
	
	// 전문 Parameter DTO 객체 생성
    DealApproveDto approveDto = new DealApproveDto();
    
    // DTO 객체에 인증 PARAMETER 세팅
    // 기타 approveDto에 추가로 세팅해야하는 값은 문서(Manual) 참고하여 setter로 추가
    approveDto.setMerchantID(merchantId);
    approveDto.setMerchantTxnNum(merchantTxnNum);
    approveDto.setProductName(pname);
    approveDto.setAmount(amount);
    approveDto.setSupplyAmt(supplyAmt);
    approveDto.setGoodsVat(goodsVat);
    approveDto.setServiceAmt(serviceAmt);
	approveDto.setTaxationAmount(taxationAmt);
    approveDto.setCurrency(currency);
    approveDto.setPointUseYN(pointUseYn);
    approveDto.setPossiCard(possiCard);
    approveDto.setOfferPeriodFlag(offerPeriodFlag);
    approveDto.setOfferPeriod(offerPeriod);
    approveDto.setEtc1(etc1);
    approveDto.setEtc2(etc2);
    approveDto.setEtc3(etc3);
    approveDto.setUserKey(userKey);
    approveDto.setSmileCash(smileCash);
	approveDto.setIsSmileAppInstalled(isSmileAppInstalled);
    approveDto.setCalledFromAppOrElse(calledFromAppOrElse);
    approveDto.setShopAppIosScheme(shopAppIosScheme);
    approveDto.setReturnUrl2(returnUrl2);
    approveDto.setItemType(itemType);
    approveDto.setMerchantEncKey(encKey);
    approveDto.setMerchantHashKey(hashKey);
    approveDto.setRequestDealApproveUrl(requestDealApproveUrl);
    
    resultJSONObject = webService.requestDealApprove(approveDto);
    resultString = resultJSONObject.toString();

    if( !resultString.equals("{}") ) {
        resultCode = resultJSONObject.getString("RESULT_CODE");
        resultMsg = resultJSONObject.getString("RESULT_MSG");
        
        if( resultCode.equals("00") ) {
            txnId = resultJSONObject.getString("TXN_ID");
            merchantTxnNum = resultJSONObject.getString("MERCHANT_TXN_NUM");
            prDt = resultJSONObject.optString("PR_DT");
        }
    }
    
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="euc-kr" lang="euc-kr">
<head>

<script>
    function setTxnId() {
        var resultCode = "<%=resultCode%>";
        var resultMsg = "<%=resultMsg%>";
        var txnId = "<%=txnId%>";
        var prDt = "<%=prDt%>";
        
        // 가져온 결과를 payForm에 세팅
        parent.document.getElementById('resultCode').value = resultCode;
        parent.document.getElementById('resultMsg').value = resultMsg;
        parent.document.getElementById('txnId').value = txnId;
        parent.document.getElementById('prDt').value = prDt;
        parent.smilepay();
    }
</script>

</head>
<body onload="setTxnId()">
TXN ID 획득을 위한 페이지
</body>
</html>