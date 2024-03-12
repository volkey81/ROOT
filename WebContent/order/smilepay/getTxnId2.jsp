<%@page import="com.lgcns.kmpay.dto.DealApproveDto"%>
<%@page import="com.lgcns.kmpay.service.CallWebService"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.sanghafarm.utils.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
	request.setCharacterEncoding("utf-8");

    // 서버로부터 받은 결과값 저장 JSONObject
    JSONObject  resultJSONObject =  new JSONObject();

    // TXN_ID를 요청하기 위한 PARAMETER
    String PR_TYPE = request.getParameter("prType");
    String MERCHANT_ID = request.getParameter("MID");
    String MERCHANT_TXN_NUM = request.getParameter("merchantTxnNum");
    
    String USER_KEY = request.getParameter("userKey");					  	// (필수) 사용자키 : CI 연동 가맹점 파라미터 (인증요청)
    String SMILE_CASH = request.getParameter("smileCash");					// (옵션) 스마일캐쉬 : CI 연동 가맹점 파라미터 (인증요청)
    
    String channelType = request.getParameter("channelType");
    
    //문자열 인코딩 문제 극복을 위해 상품명은 api에 직접 setting
    byte[] PRODUCT_NAME = (""+request.getParameter("GoodsName")).getBytes("UTF-8");
    String AMOUNT = request.getParameter("Amt");
    String serviceAmt = request.getParameter("ServiceAmt");
    String supplyAmt = request.getParameter("SupplyAmt");
    String goodsVat = request.getParameter("GoodsVat");
    String CURRENCY = request.getParameter("currency");
    String RETURN_URL = request.getParameter("returnUrl");
    String RETURN_URL2 = request.getParameter("returnUrl2");
    
    // ENC KEY와 HASH KEY는 가맹점에서 생성한 KEY 로 SETTING 한다.
    String merchantEncKey = request.getParameter("merchantEncKey");
    String merchantHashKey = request.getParameter("merchantHashKey");
    String requestDealApproveUrl = request.getParameter("requestDealApproveUrl");
    String certifiedFlag = request.getParameter("certifiedFlag");
    
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
    String possiBin = request.getParameter("possiBin");
    
	String OrderCheckYn= request.getParameter("OrderCheckYn");
    String OrderBirthDay= request.getParameter("OrderBirthDay");
    String OrderName= request.getParameter("OrderName");
    String OrderTel= request.getParameter("OrderTel");
   
    String subMallName = request.getParameter("CardSubCoNm");
    String dummyPageFlag = request.getParameter("dummyPageFlag");
    String taxationAmt = request.getParameter("TaxationAmt");	//과세금액
   
    String etc1 = request.getParameter("etc1");
    String etc2 = request.getParameter("etc2");
    String etc3 = request.getParameter("etc3");
    
    String isSmileAppInstalled = request.getParameter("isSmileAppInstalled");
	String calledFromAppOrElse = request.getParameter("calledFromAppOrElse");
	String shopAppIosScheme = request.getParameter("shopAppIosScheme");
    
    String pname = new String(PRODUCT_NAME, "UTF-8");
    if(pname.length() > 40) pname = pname.substring(0, 40);

    // 결과값을 담는 부분
    String resultString = "";
    String resultCode = "";
    String resultMsg = "";
    String txnId = "";
    String merchantTxnNum = "";
    String prDt = "";
    
    // 가맹점에서 MPay로 전문을 날리기 위한 객체 생성
    CallWebService webService = new CallWebService();
    
	// 로그 디렉토리 생성
	webService.setLogHome(SmilepayUtil.LOG_HOME);
	// 프로퍼티 위치지정
	webService.setKMPayHome(SmilepayUtil.CNSPAY_HONE);
	
	// 전문 Parameter DTO 객체 생성
    DealApproveDto approveDto = new DealApproveDto();
    
    // DTO 객체에 인증 PARAMETER 세팅
    // 기타 approveDto에 추가로 세팅해야하는 값은 문서(Manual) 참고하여 setter로 추가
    approveDto.setRequestDealApproveUrl(requestDealApproveUrl); // 결제요청을 위한 URL
    approveDto.setMerchantEncKey(merchantEncKey); // 가맹점의 EncKey
    approveDto.setMerchantHashKey(merchantHashKey); // 가맹점의 HashKey

    approveDto.setCertifiedFlag(certifiedFlag); // WEB결제로 신청할시에 필수 'CN'
    approveDto.setPrType(PR_TYPE);
    approveDto.setChannelType(channelType); // TMS 및 방판 결제시 필수
    
    approveDto.setMerchantID(MERCHANT_ID);
    approveDto.setMerchantTxnNum(MERCHANT_TXN_NUM);
    
    approveDto.setUserKey(USER_KEY);	 				    	// (필수) 사용자키 (발급방법은 3.3 참조)
    approveDto.setSmileCash(SMILE_CASH);  					// (옵션) 사전 조회한 스마일캐시 값

    approveDto.setProductName(pname);	// max 40
    
    approveDto.setAmount(AMOUNT);
    approveDto.setServiceAmt(serviceAmt);
    approveDto.setSupplyAmt(supplyAmt);
    approveDto.setGoodsVat(goodsVat);
    
    approveDto.setCurrency(CURRENCY);
    approveDto.setReturnUrl(RETURN_URL);
    approveDto.setReturnUrl2(RETURN_URL2);
    
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
 
    approveDto.setPossiBin(possiBin);
    approveDto.setEtc1(etc1);
    approveDto.setEtc2(etc2);
    approveDto.setEtc3(etc3);
    approveDto.setSubMallName(subMallName);
    approveDto.setDummyPageFlag(dummyPageFlag);
    
	// SMILEPAY 추가 파라미터 세팅
    approveDto.setTaxationAmount(taxationAmt);
    
    approveDto.setIsSmileAppInstalled(isSmileAppInstalled);
    approveDto.setCalledFromAppOrElse(calledFromAppOrElse);
    approveDto.setShopAppIosScheme(shopAppIosScheme);
    
    resultJSONObject = webService.requestDealApprove(approveDto);
    resultString = resultJSONObject.toString();

    System.out.println(String.format("------- smilepay/getTxnid.jsp resutlString : %s", resultString));
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

<script>
    function setTxnId() {
        var resultCode   = "<%=resultCode%>";
        var resultMsg    = "<%=resultMsg%>";
        var txnId        = "<%=txnId%>";
        var prDt         = "<%=prDt%>";
        
        // 가져온 결과를 payForm에 세팅
        parent.document.getElementById('resultCode').value = resultCode;
        parent.document.getElementById('resultMsg').value = resultMsg;
        parent.document.getElementById('txnId').value = txnId;
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