<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.io.*,
				 com.efusioni.stone.utils.*,
				 com.efusioni.stone.common.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.order.*,
				 com.sanghafarm.service.product.*,
				 com.sanghafarm.service.member.*,
				 com.sanghafarm.utils.*,
				 lgdacom.XPayClient.XPayClient,
				 kr.co.lgcns.module.lite.*" %>
<%@ page import="javax.xml.ws.Response"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="com.fasterxml.jackson.core.type.TypeReference" %>
<%@page import="com.fasterxml.jackson.databind.node.ArrayNode"%>
<%@page import="com.fasterxml.jackson.databind.JsonNode"%>
<%@ include file="/order/kakaopay/incKakaopayCommon.jsp" %>
<%@ include file="/order/payco/common_include.jsp" %>
<%
	request.setCharacterEncoding("utf-8"); 
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	TicketOrderService order = (new TicketOrderService()).toProxyInstance();
	MemberService member = (new MemberService()).toProxyInstance();
	ImMemberService immem = (new ImMemberService()).toProxyInstance();
	CouponService coupon = (new CouponService()).toProxyInstance();
	
	String orderid = param.get("orderid");
	String deviceType = param.get("device_type", "P");
	
	String backUrl = Env.getURLPath() + "/";
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		// Utils.sendMessage(out, FrontSession.LOGIN_MSG, backUrl);
		return;
	}
	
	Param memInfo = member.getInfo(fs.getUserId());
	System.out.println(orderid + " : " + memInfo.get("orderid"));
	if("".equals(memInfo.get("orderid")) || !orderid.equals(memInfo.get("orderid"))) {
		System.out.println("----------------- invalid order 유효하지 않은 주문서입니다.(1)");
		Utils.sendMessage(out, "유효하지 않은 주문서입니다.(1)", backUrl);
		return;
	}
	
	// 금액검증
	/*
	String DB_AMOUNT = (String) session.getAttribute("DB_AMOUNT");
	if(param.getInt("LGD_AMOUNT") != 0 && !param.get("LGD_AMOUNT").equals(DB_AMOUNT)) {
		Utils.sendMessage(out, "유효하지 않은 주문서입니다.(2)", backUrl);
		return;
	}
	*/

	String userid = fs.getUserId();
	
	int totalPrice = 0;
	int couponAmt = 0;
	int pointAmt = 0;
	int reservedNum = 0;

	String[] ticketType = param.getValues("ticket_type");
	for(String tType : ticketType) {
		if("01".equals(param.get("ticket_div"))) {
			totalPrice += Config.getInt("admission.fee." + tType) * param.getInt("qty_" + tType, 0);
		} else {
			totalPrice += param.getInt("price_" + tType, 0) * param.getInt("qty_" + tType, 0);
			reservedNum += param.getInt("occu_num_" + tType, 0) * param.getInt("qty_" + tType, 0);
		}
	}

	// 예약 가능 인원 체크
	if("02".equals(param.get("ticket_div"))) {
		ExpProductService exp = (new ExpProductService()).toProxyInstance();
		Param info = exp.getInfo(param.get("exp_pid"));
		if(info.getInt("seat_num", 0) - info.getInt("reserved_num", 0) < reservedNum) {
			Utils.sendMessage(out, "예약 가능 인원이 초과되었습니다.");
			return;
		}
	}
	
	// 쿠폰 검증
	if(!"".equals(param.get("mem_couponid"))) {
		Param p = new Param();
		p.set("userid", fs.getUserId());
		p.set("device_type", fs.getDeviceType());
		p.set("grade_code", fs.getGradeCode());
		p.set("mem_couponid", param.get("mem_couponid"));
		p.set("coupon_type", ("01".equals(param.get("ticket_div")) ? "005" : "004"));
			
		List<Param> couponList = coupon.getApplyableList2(p);
		Param couponInfo = null;
		
		for(Param row : couponList) {
			if(row.get("mem_couponid").equals(param.get("mem_couponid"))) {
				couponInfo = row;
				break;
			}
		}
		
		if(couponInfo == null) {
			System.out.println("----------------- invalid order 유효하지 않은 주문서입니다.(3)");
			Utils.sendMessage(out, "유효하지 않은 주문서입니다.(3)", backUrl);
			return;
		} else {
			if(totalPrice < couponInfo.getInt("min_price", 0)) {
				System.out.println("----------------- invalid order 유효하지 않은 주문서입니다.(4)");
				Utils.sendMessage(out, "유효하지 않은 주문서입니다.(4)", backUrl);
				return;
			}
			
			if("A".equals(couponInfo.get("sale_type"))) {	//  정량
				couponAmt = couponInfo.getInt("sale_amt");
			} else {	// 정률
				couponAmt = (couponInfo.getInt("max_sale") <= (totalPrice * couponInfo.getInt("sale_amt") / 100)) ? 
						couponInfo.getInt("max_sale") : (totalPrice * couponInfo.getInt("sale_amt") / 100);
			}
		}
	}

	// 포인트 검증
	pointAmt = Integer.parseInt(param.get("point_amt", "0").replaceAll(",", ""));
	if(pointAmt > 0) {	
		int point = immem.getMemberPoint(fs.getUserNo());
		if(point < pointAmt) {
			System.out.println("----------------- invalid order 유효하지 않은 주문서입니다.(5)");
			Utils.sendMessage(out, "유효하지 않은 주문서입니다.(5)", backUrl);
			return;
		}
	}
	
	System.out.println("PAY_AMT : " + (totalPrice - couponAmt - pointAmt) + " : " + param.get("LGD_AMOUNT"));
	if((totalPrice - couponAmt - pointAmt) != param.getInt("LGD_AMOUNT")) {
		System.out.println("----------------- invalid order 유효하지 않은 주문서입니다.(6)");
		Utils.sendMessage(out, "유효하지 않은 주문서입니다.(6)", backUrl);
		return;
	}

	if(param.getInt("LGD_AMOUNT") == 0 || SystemChecker.isLocal()) {	// 0원 결제
		try {
			order.create(request, response);
		} catch(Exception e) {
			Utils.sendMessage(out, e.getLocalizedMessage(), Env.getURLPath() + "/");
			return;
		}
	} else if("005".equals(param.get("pay_type"))) {	// 카카오페이
	    // 모듈이 설치되어 있는 경로 설정
	    CnsPayWebConnector4NS connector = new CnsPayWebConnector4NS();
	    
	    // 환경설정 및 로그 디렉토리 생성(incKakaopayCommon.jsp에서 설정한 값 사용)
	    connector.setLogHome(logHome);
	    connector.setCnsPayHome(cnsPayHome);
	    
	    // 요청 페이지 파라메터 셋팅
	    connector.setRequestData(request);
	    
	    // 추가 파라메터 셋팅
	    connector.addRequestData("actionType", "PY0");              // actionType : CL0 취소, PY0 승인
	    connector.addRequestData("MallIP", request.getRemoteAddr());// 가맹점 고유 ip
	    
	    //가맹점키 셋팅 (MID 별로 틀림) 

	    connector.addRequestData("EncodeKey", encodeKey);
	    
	    // CNSPAY Lite 서버 접속하여 처리
	    connector.requestAction();

	    // 결과 처리
 	    String resultCode = connector.getResultData("ResultCode");      // 결과코드 (정상 :3001 , 그 외 에러)
	    String resultMsg = connector.getResultData("ResultMsg");        // 결과메시지
	    String tid = connector.getResultData("TID");                    // 거래ID
	    String moid = connector.getResultData("Moid");                  // 주문번호
 	    String payMethod = connector.getResultData("PayMethod");        // 결제수단
	    String amt = connector.getResultData("Amt");                    // 금액
	    String discountAmt = connector.getResultData("DiscountAmt");
	    String authDate = connector.getResultData("AuthDate");          // 승인일시 YYMMDDHH24mmss
	    String authCode = connector.getResultData("AuthCode");          // 승인번호
	    String cardCode = connector.getResultData("CardCode");          // 카드사 코드
	    String acquCardCode = connector.getResultData("AcquCardCode");
	    String cardName = connector.getResultData("CardName");          // 결제카드사명
	    String cardQuota = connector.getResultData("CardQuota");        // 할부개월수 ex) 00:일시불,02:2개월
	    String cardInterest = connector.getResultData("CardInterest");  // 무이자 여부 (0:일반, 1:무이자)
	    String cardCl = connector.getResultData("CardCl");              // 체크카드여부 (0:일반, 1:체크카드)
	    String cardBin = connector.getResultData("CardBin");            // 카드BIN번호
	    String cardPoint = connector.getResultData("CardPoint");        // 카드사포인트사용여부 (0:미사용, 1:포인트사용, 2:세이브포인트사용)
	    String promotionCcPartCl = connector.getResultData("PromotionCcPartCl");
	    String vanCode = connector.getResultData("VanCode");
	    String fnNo = connector.getResultData("FnNo");

	    System.out.println("^^^^^^^^^^^^^^^ kakao result ^^^^^^^^^^^^^^^");
 	    System.out.println("resultCode         : " + resultCode           );
	    System.out.println("resultMsg          : " + resultMsg            );
	    System.out.println("tid                : " + tid                  );
	    System.out.println("moid               : " + moid                 );
 	    System.out.println("payMethod          : " + payMethod            );
	    System.out.println("amt                : " + amt                  );
	    System.out.println("discountAmt        : " + discountAmt          );
	    System.out.println("authDate           : " + authDate             );
	    System.out.println("authCode           : " + authCode             );
	    System.out.println("cardCode           : " + cardCode             );
	    System.out.println("acquCardCode       : " + acquCardCode         );
	    System.out.println("cardName           : " + cardName             );
	    System.out.println("cardQuota          : " + cardQuota            );
	    System.out.println("cardInterest       : " + cardInterest         );
	    System.out.println("cardCl             : " + cardCl               );
	    System.out.println("cardBin            : " + cardBin              );
	    System.out.println("cardPoint          : " + cardPoint            );
	    System.out.println("promotionCcPartCl  : " + promotionCcPartCl    );
	    System.out.println("vanCode            : " + vanCode              );
	    System.out.println("fnNo               : " + fnNo                 );
	    System.out.println("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");

	    Param payInfo = new Param();
		payInfo.set("orderid", orderid);
		payInfo.set("result_code", resultCode);
		payInfo.set("result_msg", resultMsg);
		payInfo.set("tid", tid);
		payInfo.set("moid", moid);
		payInfo.set("pay_method", payMethod);
		payInfo.set("amt", amt);
		payInfo.set("discount_amt", discountAmt);
		payInfo.set("auth_date", authDate);
		payInfo.set("auth_code", authCode);
		payInfo.set("card_code", cardCode);
		payInfo.set("acqu_card_code", acquCardCode);
		payInfo.set("card_name", cardName);
		payInfo.set("card_quota", cardQuota);
		payInfo.set("card_interest", cardInterest);
		payInfo.set("card_cl", cardCl);
		payInfo.set("card_bin", cardBin);
		payInfo.set("card_point", cardPoint);
		payInfo.set("promotion_cc_part_cl", promotionCcPartCl);
		payInfo.set("van_code", vanCode);
		payInfo.set("fn_no", fnNo);
	    
	    //부인방지토큰값
	    String nonRepToken = request.getParameter("NON_REP_TOKEN");
	    
	    boolean paySuccess = false;                                     // 결제 성공 여부
	    
	    /** 위의 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능 */
	    if(payMethod.equals("CARD")){                                   //신용카드
	        if(resultCode.equals("3001")) paySuccess = true;            // 결과코드 (정상 :3001 , 그 외 에러)
	    }
	    
	    if(paySuccess){
	    	try {
	    		order.create(request, response, payInfo);
	    	}
	    	catch (Exception e) {
	    		// DB 입력 실패시 결제 취소
				connector.addRequestData("actionType", "CL0");
				connector.addRequestData("CancelPwd", cancelPwd);
				//가맹점키 셋팅 (MID 별로 틀림) 
				connector.addRequestData("EncodeKey", encodeKey);
				connector.addRequestData("CancelIP", request.getRemoteAddr());
				connector.addRequestData("PartialCancelCode", "0");
				
				connector.addRequestData("CancelAmt", amt);
				connector.addRequestData("CancelMsg", "Transaction rolled back.");
				
				connector.requestAction();
				
				payInfo = new Param();
				resultCode = connector.getResultData("ResultCode");
				
			    payInfo.set("orderid", param.get("orderid"));
			    payInfo.set("result_code", connector.getResultData("ResultCode"));
			    payInfo.set("result_msg", connector.getResultData("ResultMsg"));
			    payInfo.set("error_cd", connector.getResultData("ErrorCD"));
			    payInfo.set("error_msg", connector.getResultData("ErrorMsg"));
			    payInfo.set("cancel_amt", connector.getResultData("CancelAmt"));
			    payInfo.set("cancel_date", connector.getResultData("CancelDate"));
			    payInfo.set("cancel_time", connector.getResultData("CancelTime"));
			    payInfo.set("pay_method", connector.getResultData("PayMethod"));
			    payInfo.set("mid", connector.getResultData("MID"));
			    payInfo.set("tid", connector.getResultData("TID"));
			    payInfo.set("stateCD", connector.getResultData("StateCD"));
			    payInfo.set("cc_part_cl", connector.getResultData("CcPartCl"));
			    payInfo.set("cancel_num", connector.getResultData("CancelNum"));
			    payInfo.set("van_code", connector.getResultData("VanCode"));

			    // 취소 로그
// 			    order.createKakaoPayCancelLog(payInfo);
			    
			    if (!resultCode.equals("2001")) {
                 	System.out.println("kakaopay 2001");
                	Utils.sendMessage(out, "결제중 오류가 발생했지만 승인취소가 정상적으로 처리되지 않았습니다. 관리자에게 문의 하세요.", Env.getURLPath() + "/");
                	return;
			    }
			    System.out.println("kakao 결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"));
            	Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"), Env.getURLPath() + "/");
            	return;
	    	}
	    }
	    else{
        	System.out.println("-------- kakao 결제가 실패하였습니다.(" + payInfo.get("result_code") + " : " + payInfo.get("result_msg"));
        	Utils.sendMessage(out, "결제가 실패하였습니다.(" + payInfo.get("result_code") + " : " + payInfo.get("result_msg"), Env.getURLPath() + "/");
        	return;
	    }
	} else if("006".equals(param.get("pay_type"))) {	// 페이코
		ObjectMapper mapper = new ObjectMapper();
		PaycoUtil    util   = new PaycoUtil(serverType);
		
		Boolean doCancel    = false;
		String cancelMsg	= "";
		String orderCertifyKey = "";
		String orderNo = "";
		
		Map<String,Object> sendMap = new HashMap<String,Object>(); 
		sendMap.put("sellerKey", sellerKey);
		sendMap.put("reserveOrderNo", param.get("reserveOrderNo"));
		sendMap.put("sellerOrderReferenceKey", param.get("sellerOrderReferenceKey"));
		sendMap.put("paymentCertifyToken", param.get("paymentCertifyToken"));
		sendMap.put("totalPaymentAmt", param.get("LGD_AMOUNT"));
		/* payco 결제승인 API 호출 */
		String json = util.payco_approval(sendMap,logYn);
		
		// jackson Tree 이용
		JsonNode node = mapper.readTree(json);
		String msg = node.path("message").textValue();
		String code = node.path("code").toString();
		
		if(code.equals("0")){
			// 예시
			try{
				/* 결제승인 후 리턴된 데이터 중 필요한 정보를 추출하여
				 * 가맹점 에서 필요한 작업을 실시합니다.(예 주문서 작성 등..)
				 * 결제연동시 리턴되는 PAYCO주문번호(orderNo)와 주문인증키(orderCertifyKey)에 대해 
				 * 가맹점 DB 저장이 필요합니다.
				 */
				JsonNode result = mapper.readTree(node.path("result").toString());

				Param payInfo = new Param();
				payInfo.set("seller_order_reference_key",		result.path("sellerOrderReferenceKey").textValue());
				payInfo.set("reserve_order_no",					result.path("reserveOrderNo").textValue());
				payInfo.set("order_no",							result.path("orderNo").textValue());
				payInfo.set("member_name", 						result.path("memberName").textValue());
				payInfo.set("member_email",				 		result.path("memberEmail").textValue());
				payInfo.set("order_channel", 					result.path("orderChannel").textValue());
				payInfo.set("total_order_amt", 					result.path("totalOrderAmt").textValue());
				payInfo.set("total_delivery_fee_amt",			result.path("totalDeliveryFeeAmt").textValue());
				payInfo.set("total_remote_area_delivery_amt", 	result.path("totalRemoteAreaDeliveryAmt").textValue());
				payInfo.set("total_payment_amt", 				result.path("totalPaymentAmt").textValue());
				payInfo.set("payment_completion_yn", 			result.path("paymentCompletionYn").textValue());
				payInfo.set("delivery_place", 					result.path("deliveryPlace").textValue());
				payInfo.set("order_products", 					result.path("orderProducts").toString());
				payInfo.set("payment_details", 					result.path("paymentDetails").toString());
				payInfo.set("order_certify_key", 				result.path("orderCertifyKey").textValue());
				payInfo.set("code", 							code);
				payInfo.set("message", 							msg);

				orderNo = result.path("orderNo").textValue();
				orderCertifyKey = result.path("orderCertifyKey").textValue();

				order.create(request, response, payInfo);
			}catch(Exception e){
				e.printStackTrace();
				doCancel = true;
			}
		}else{
        	Utils.sendMessage(out, "결제가 실패하였습니다.(" + code + " : " + msg, Env.getURLPath() + "/");
			return;
		}
		
		if(doCancel){
			/*★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
			#  PAYCO 결제 승인이 완료되고 아래와 같은 상황이 발생하였을경우 예외 처리가 필요합니다.
			1. 가맹점 DB 처리중 오류 발생시
			2. 통신 장애로 인하여 결과를 리턴받지 못했을 경우
			
			위와 같은 상황이 발생하였을 경우 이미 승인 완료된 주문건에 대하여 주문 취소처리(전체취소)가 필요합니다.
			 - PAYCO에서는 주문승인(결제완료) 처리 되었으나 가맹점은 해당 주문서가 없는 경우가 발생
			 - PAYCO에서는 승인 완료된 상태이므로 주문 상세정보 API를 이용해 결제정보를
			   조회하여 취소요청 파라미터에 셋팅합니다.
			★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★*/
			
			/*
			// 결제상세 조회 필수값 셋팅 
			Map<String, Object> verifyPaymentMap = new HashMap<String, Object>();
			verifyPaymentMap.put("sellerKey", sellerKey);
			verifyPaymentMap.put("reserveOrderNo", orderid);						// 주문예약번호
			verifyPaymentMap.put("sellerOrderReferenceKey", orderid);	// 가맹점주문연동키
			
			// 결제상세 조회 API 호출
			String verifyPaymentResult = util.payco_verifyPayment(verifyPaymentMap, logYn);
			
			// jackson Tree 이용
			JsonNode verifyPayment_node = mapper.readTree(verifyPaymentResult);
			
			String cancel_orderNo		  = verifyPayment_node.path("result").get("orderNo").textValue(); 
			String cancel_orderCertifyKey = verifyPayment_node.path("result").get("orderCertifyKey").textValue();
			String cancel_cancelTotalAmt  = verifyPayment_node.path("result").get("totalPaymentAmt").toString();
			
			// 설정한 주문취소 정보로 Json String 을 작성합니다.
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("sellerKey", sellerKey);										//[필수]가맹점 코드
			params.put("orderNo", cancel_orderNo);									//[필수]주문번호
			params.put("orderCertifyKey", cancel_orderCertifyKey);					//[필수]주문인증 key
			params.put("cancelTotalAmt", Integer.parseInt(cancel_cancelTotalAmt));  	//[필수]취소할 총 금액(전체취소, 부분취소 전부다)
			*/
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("sellerKey", sellerKey);										//[필수]가맹점 코드
			params.put("orderNo", orderNo);									//[필수]주문번호
			params.put("orderCertifyKey", orderCertifyKey);					//[필수]주문인증 key
			params.put("cancelTotalAmt", param.getInt("LGD_AMOUNT"));  	//[필수]취소할 총 금액(전체취소, 부분취소 전부다)

			/* 주문 결제 취소 API 호출 */
			String cancelResult = util.payco_cancel(params,logYn,"Y");
			
			JsonNode cancelNode = mapper.readTree(cancelResult);
			
			if(!cancelNode.path("code").toString().equals("0")){
				Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail)", Env.getURLPath() + "/");
				return;
			}
		}
		
	} else {	// UPLUS
	    /*
	     * [최종결제요청 페이지(STEP2-2)]
	     *
	     * LG유플러스으로 부터 내려받은 LGD_PAYKEY(인증Key)를 가지고 최종 결제요청.(파라미터 전달시 POST를 사용하세요)
	     */
	
		/* ※ 중요
		* 환경설정 파일의 경우 반드시 외부에서 접근이 가능한 경로에 두시면 안됩니다.
		* 해당 환경파일이 외부에 노출이 되는 경우 해킹의 위험이 존재하므로 반드시 외부에서 접근이 불가능한 경로에 두시기 바랍니다. 
		* 예) [Window 계열] C:\inetpub\wwwroot\lgdacom ==> 절대불가(웹 디렉토리)
		*/
		
	//     String configPath = getServletContext().getRealPath(Config.get("lgdacom.config")) + File.separator + SystemChecker.getCurrentName().toLowerCase();  //LG유플러스에서 제공한 환경파일("/conf/lgdacom.conf,/conf/mall.conf") 위치 지정.
		String configPath = Env.getDocRoot() + Config.get("lgdacom.config") + SystemChecker.getCurrentName().toLowerCase();
		System.out.println("============= LGD configPath : " + configPath);
	
	    /*
	     *************************************************
	     * 1.최종결제 요청 - BEGIN
	     *  (단, 최종 금액체크를 원하시는 경우 금액체크 부분 주석을 제거 하시면 됩니다.)
	     *************************************************
	     */
	    
	    String CST_PLATFORM                 = request.getParameter("CST_PLATFORM");
	    String CST_MID                      = request.getParameter("CST_MID");
	    String LGD_MID                      = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;
	    String LGD_PAYKEY                   = request.getParameter("LGD_PAYKEY");
	
	    //해당 API를 사용하기 위해 WEB-INF/lib/XPayClient.jar 를 Classpath 로 등록하셔야 합니다. 
	    XPayClient xpay = new XPayClient();
	   	boolean isInitOK = xpay.Init(configPath, CST_PLATFORM);   	
	
	   	if( !isInitOK ) {
	    	//API 초기화 실패 화면처리
	        System.out.println( "결제요청을 초기화 하는데 실패하였습니다.<br>");
	    	Utils.sendMessage(out, "결제요청이 실패하였습니다. -1", Env.getURLPath() + "/");
	        return;
	   	
	   	}else{      
	   		try{
	   			/*
	   	   	     *************************************************
	   	   	     * 1.최종결제 요청(수정하지 마세요) - END
	   	   	     *************************************************
	   	   	     */
		    	xpay.Init_TX(LGD_MID);
		    	xpay.Set("LGD_TXNAME", "PaymentByKey");
		    	xpay.Set("LGD_PAYKEY", LGD_PAYKEY);
		    
		    	//금액을 체크하시기 원하는 경우 아래 주석을 풀어서 이용하십시요.
		    	//String DB_AMOUNT = "DB나 세션에서 가져온 금액"; //반드시 위변조가 불가능한 곳(DB나 세션)에서 금액을 가져오십시요.
	// 	    	xpay.Set("LGD_AMOUNTCHECKYN", "Y");
	// 	    	xpay.Set("LGD_AMOUNT", DB_AMOUNT);
		    
	    	}catch(Exception e) {
	    		System.out.println("sanghafarmshop ------------- LG유플러스 제공 API를 사용할 수 없습니다. 환경파일 설정을 확인해 주시기 바랍니다. ");
	    		System.out.println(""+e.getMessage());    	
	        	Utils.sendMessage(out, "결제요청이 실패하였습니다. -2", Env.getURLPath() + "/");
	    		return;
	    	}
	   	}
	
	    /*
	     * 2. 최종결제 요청 결과처리
	     *
	     * 최종 결제요청 결과 리턴 파라미터는 연동메뉴얼을 참고하시기 바랍니다.
	     */
	     if ( xpay.TX() ) {
	         //1)결제결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
	         System.out.println( "sanghafarmshop ------------- 결제요청이 완료되었습니다.  <br>");
	         System.out.println( "TX 결제요청 Response_code = " + xpay.m_szResCode + "<br>");
	         System.out.println( "TX 결제요청 Response_msg = " + xpay.m_szResMsg + "<p>");
	         
	         System.out.println("거래번호 : " + xpay.Response("LGD_TID",0) + "<br>");
	         System.out.println("상점아이디 : " + xpay.Response("LGD_MID",0) + "<br>");
	         System.out.println("상점주문번호 : " + xpay.Response("LGD_OID",0) + "<br>");
	         System.out.println("결제금액 : " + xpay.Response("LGD_AMOUNT",0) + "<br>");
	         System.out.println("결과코드 : " + xpay.Response("LGD_RESPCODE",0) + "<br>");
	         System.out.println("결과메세지 : " + xpay.Response("LGD_RESPMSG",0) + "<p>");
	         
	         Param lgdInfo = new Param();
	         for (int i = 0; i < xpay.ResponseNameCount(); i++)
	         {
	             System.out.println(xpay.ResponseName(i) + " = ");
	             for (int j = 0; j < xpay.ResponseCount(); j++)
	             {
	                 System.out.println("\t" + xpay.Response(xpay.ResponseName(i), j) + "<br>");
	                 if(j == 0) {
	                	 lgdInfo.set(xpay.ResponseName(i).toLowerCase(), xpay.Response(xpay.ResponseName(i), j));
	                 }
	             }
	         }
	         System.out.println("<p>");
	         
	         if( "0000".equals( xpay.m_szResCode ) ) {
	         	//최종결제요청 결과 성공 DB처리
	         	System.out.println("sanghafarmshop ------------- 최종결제요청 결과 성공 DB처리하시기 바랍니다.<br>");
	         	//최종결제요청 결과 성공 DB처리 실패시 Rollback 처리
	         	boolean isDBOK = true; //DB처리 실패시 false로 변경해 주세요.
	
	         	try {
	         		order.create(request, response, lgdInfo);
	         	} catch(Exception e) {
	             	System.out.println("sanghafarmshop orderProc.jsp ------------- " + e.toString());
	         		e.printStackTrace();
	         		isDBOK = false;
	         	}
	         	
	         	if( !isDBOK ) {
	         		xpay.Rollback("상점 DB처리 실패로 인하여 Rollback 처리 [TID:" +xpay.Response("LGD_TID",0)+",MID:" + xpay.Response("LGD_MID",0)+",OID:"+xpay.Response("LGD_OID",0)+"]");
	         		
	                 System.out.println( "sanghafarmshop ------------- TX Rollback Response_code = " + xpay.Response("LGD_RESPCODE",0) + "<br>");
	                 System.out.println( "sanghafarmshop ------------- TX Rollback Response_msg = " + xpay.Response("LGD_RESPMSG",0) + "<p>");
	         		
	                 if( "0000".equals( xpay.m_szResCode ) ) {
	                 	System.out.println("sanghafarmshop ------------- 자동취소가 정상적으로 완료 되었습니다.<br>");
	                	Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"), Env.getURLPath() + "/");
	                	return;
	                 }else{
	         			System.out.println("sanghafarmshop ------------- 자동취소가 정상적으로 처리되지 않았습니다.<br>");
	                	Utils.sendMessage(out, "결제중 오류가 발생했지만 승인취소가 정상적으로 처리되지 않았습니다. 관리자에게 문의 하세요.", Env.getURLPath() + "/");
	         	    	return;
	                 }
	         	}
	         	
	         }else{
	         	//최종결제요청 결과 실패 DB처리
	         	System.out.println("sanghafarmshop ------------- 최종결제요청 결과 실패 DB처리하시기 바랍니다.<br>");            	
	        	Utils.sendMessage(out, "결제요청이 실패하였습니다. -5", Env.getURLPath() + "/");
	        	return;
	         }
	     }else {
	         //2)API 요청실패 화면처리
	         System.out.println( "sanghafarmshop ------------- 결제요청이 실패하였습니다.  <br>");
	         System.out.println( "sanghafarmshop ------------- TX 결제요청 Response_code = " + xpay.m_szResCode + "<br>");
	         System.out.println( "sanghafarmshop ------------- TX 결제요청 Response_msg = " + xpay.m_szResMsg + "<p>");
	         
	     	//최종결제요청 결과 실패 DB처리
	     	System.out.println("sanghafarmshop ------------- 최종결제요청 결과 실패 DB처리하시기 바랍니다.<br>");            	            
	    	Utils.sendMessage(out, "결제요청이 실패하였습니다. -6", Env.getURLPath() + "/");
	    	return;
	     }
	}

	try {
		TmsUtil tms = new TmsUtil();
		tms.sendReserveSms(orderid);
	} catch(Exception e) {
		e.printStackTrace();
	}
	
	String nextUrl = Env.getURLPath();
	if(!"P".equals(deviceType)) nextUrl += "/mobile";
	nextUrl += "/brand/play/reservation/complete.jsp";
%>
<form name="orderForm" id="orderForm" action="<%= nextUrl %>" method="POST">
	<input type="hidden" name="orderid" value="<%= param.get("orderid") %>" />
</form>

<script>
document.getElementById("orderForm").submit();
</script>
