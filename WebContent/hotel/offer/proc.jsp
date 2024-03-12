<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.code.*,
			com.sanghafarm.service.member.*,
			com.sanghafarm.service.order.*,				 
			com.sanghafarm.service.hotel.*,
			com.sanghafarm.utils.*,
			org.json.simple.*,
			lgdacom.XPayClient.XPayClient" %>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="javax.xml.ws.Response"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="com.fasterxml.jackson.core.type.TypeReference" %>
<%@page import="com.fasterxml.jackson.databind.node.ArrayNode"%>
<%@page import="com.fasterxml.jackson.databind.JsonNode"%>
<%@ include file="/order/payco/common_include.jsp" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);

	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	HotelOfferService svc = (new HotelOfferService()).toProxyInstance();
	MemberService member = (new MemberService()).toProxyInstance();
	ImMemberService immem = (new ImMemberService()).toProxyInstance();
	OrderService order = (new OrderService()).toProxyInstance();

	String orderid = param.get("orderid");
	String deviceType = param.get("device_type", "P");

	Param info = svc.getInfo(param.get("pid"));
	if(info == null || "".equals(info.get("pid")) || !"S".equals(info.get("status"))) {
		Utils.sendMessage(out, "현재 판매중인 상품이 아닙니다.", (!"P".equals(deviceType) ? "/mobile" : "") + "/hotel/offer/list.jsp");
		return;
	}

	Param priceInfo = svc.getPriceInfo(param);
	if(param.getInt("qty") > priceInfo.getInt("qty", 0)) {
		Utils.sendMessage(out, "죄송합니다. 선택하신 객실 중 판매가 완료 된 객실이 있습니다.", (!"P".equals(deviceType) ? "/mobile" : "") + "/hotel/offer/detail.jsp?pid=" + param.get("pid") + "&gubun=" + param.get("gubun"));
		return;
	}

	String backUrl = Env.getURLPath() + ("P".equals(deviceType) ? "" : "/mobile") + "/hotel/offer/list.jsp";

	Param memInfo = member.getInfo(fs.getUserId());
	System.out.println("-------------------------- " + orderid + " : " + memInfo.get("orderid"));
	if("".equals(memInfo.get("orderid")) || !orderid.equals(memInfo.get("orderid"))) {
		System.out.println(orderid + "----------------- invalid order 유효하지 않은 주문서입니다.(1) orderid");
		Utils.sendMessage(out, "유효하지 않은 주문서입니다.(1)", backUrl);
		return;
	}
	
	int qty = param.getInt("qty");
	int night = SanghafarmUtils.getDateDiff(param.get("chki_date"), param.get("chot_date"));
	int defaultPrice = param.getInt("default_price") * qty;
	int price = param.getInt("price") * qty;
	
	// 추가요금 계산
	for(int i = 1; i <= param.getInt("qty"); i++) {
		int adult = param.getInt("adult" + i);
		int child = param.getInt("child" + i);
		int person = adult + child;
		
		if(person > info.getInt("capa")) {
			if(adult > info.getInt("capa")) {	
				// 성인 추가요금
				defaultPrice += (adult - info.getInt("capa")) * param.getInt("default_adult_price");
				price += (adult - info.getInt("capa")) * param.getInt("adult_price");

				// 어린이 추가요금
				defaultPrice += child * param.getInt("default_child_price");
				price += child * param.getInt("child_price");
			} else {	
				// 어린이 추가요금
				defaultPrice += (person - info.getInt("capa")) * param.getInt("default_child_price");
				price += (person - info.getInt("capa")) * param.getInt("child_price");
			}
		}
	}

	int totAmt = price;
	int couponAmt = 0;
	int promocdAmt = 0;
	int pointAmt = 0;
	
	// 금액 검증
	if(param.getInt("tot_amt") != totAmt) {
		System.out.println(orderid + "- invalid order 유효하지 않은 주문서입니다.(2) totAmt " + totAmt + " : " + param.getInt("tot_amt"));
		Utils.sendMessage(out, "유효하지 않은 주문서입니다.(2)", backUrl);
		return;
	}
	
	// 쿠폰 검증
	if(!"".equals(param.get("mem_couponid"))) {
		CouponService coupon = (new CouponService()).toProxyInstance();
		
		Param p = new Param();
		p.set("userid", fs.getUserId());
		p.set("device_type", fs.getDeviceType());
		p.set("grade_code", fs.getGradeCode());
		p.set("coupon_type", "007");
		List<Param> couponList = coupon.getApplyableList2(p);
		
		for(Param c : couponList) {
			if(param.get("mem_couponid").equals(c.get("mem_couponid"))) {
				if("A".equals(c.get("sale_type"))) {	//  정량
					couponAmt = c.getInt("sale_amt");
				} else {	// 정률
					couponAmt = (c.getInt("max_sale") <= (totAmt * c.getInt("sale_amt") / 100)) ? 
							c.getInt("max_sale") : (totAmt * c.getInt("sale_amt") / 100);
				}
				
				if(couponAmt > totAmt) couponAmt = totAmt;
				
				if(param.getInt("coupon_amt") != couponAmt) {
					System.out.println(orderid + "- invalid order 유효하지 않은 주문서입니다.(3) couponAmt " + couponAmt + " : " + param.getInt("coupon_amt"));
					Utils.sendMessage(out, "유효하지 않은 주문서입니다.(3)", backUrl);
					return;
				}

				break;
			}
		}
	}
	
	// 프로모션 코드
	if(!"".equals("promocd")) {
		HotelPromocdService promocd = new HotelPromocdService();
		Param p = new Param();
		p.set("promocd", param.get("promocd"));
		p.set("grade_code", fs.getGradeCode());
		p.set("userid", fs.getUserId());
		p.set("chki_date", param.get("chki_date"));
		p.set("chot_date", param.get("chot_date"));
		Param promocdInfo = promocd.getInfo(p);
		String today = Utils.getTimeStampString("yyyy.MM.dd HH:mm:ss");

		if(promocdInfo != null) {
			if(!"Y".equals(promocdInfo.get("avail_yn"))) {
				System.out.println(orderid + "- 프로모션 대상이 아닙니다. " + promocdInfo.get("promocdid"));
				Utils.sendMessage(out, "프로모션 대상이 아닙니다.", backUrl);
				return;
			} else if(promocdInfo.get("start_date").compareTo(today) > 0 || promocdInfo.get("end_date").compareTo(today) < 0) {
				System.out.println(orderid + "- 프로모션 기간이 종료되었습니다. " + promocdInfo.get("promocdid"));
				Utils.sendMessage(out, "프로모션 기간이 종료되었습니다.", backUrl);
				return;
			} else if(promocdInfo.get("in_start_date").compareTo(param.get("chot_date")) > 0 || promocdInfo.get("in_end_date").compareTo(param.get("chki_date")) < 0) {
				System.out.println(orderid + "- 프로모션 기간이 종료되었습니다. " + promocdInfo.get("promocdid"));
				Utils.sendMessage(out, "프로모션 기간이 종료되었습니다.", backUrl);
				return;
			} else if(promocdInfo.getInt("max_issue") != 0 && promocdInfo.getInt("max_issue") <= promocdInfo.getInt("tot_cnt")) {
				System.out.println(orderid + "- 선착순 " + Utils.formatMoney(promocdInfo.get("max_issue")) + "명을 초과하였습니다. " + promocdInfo.get("promocdid"));
				Utils.sendMessage(out, "선착순 " + Utils.formatMoney(promocdInfo.get("max_issue")) + "명을 초과하였습니다.", backUrl);
				return;
			} else if(promocdInfo.getInt("max_use") != 0 && promocdInfo.getInt("max_use") <= promocdInfo.getInt("cnt")) {
				System.out.println(orderid + "- ID당 프로모션코드는 최대 " + Utils.formatMoney(promocdInfo.get("max_use")) + " 사용 가능합니다. 사용 횟수를 초과하였습니다. " + promocdInfo.get("promocdid"));
				Utils.sendMessage(out, "ID당 프로모션코드는 최대 " + Utils.formatMoney(promocdInfo.get("max_use")) + " 사용 가능합니다. 사용 횟수를 초과하였습니다.", backUrl);
				return;
			} else {
				if("A".equals(promocdInfo.get("sale_type"))) {	//  정량
					promocdAmt = promocdInfo.getInt("sale_amt");
				} else {	// 정률
					promocdAmt = (promocdInfo.getInt("max_sale") <= ((totAmt - couponAmt) * promocdInfo.getInt("sale_amt") / 100)) ? 
							promocdInfo.getInt("max_sale") : ((totAmt - couponAmt) * promocdInfo.getInt("sale_amt") / 100);
				}
				
				if(promocdAmt > (totAmt - couponAmt)) promocdAmt = totAmt - couponAmt;
				
				if(param.getInt("promocd_amt") != promocdAmt) {
					System.out.println(orderid + "- invalid order 유효하지 않은 주문서입니다.(4) promocdAmt " + promocdAmt + " : " + param.getInt("promocd_amt"));
					Utils.sendMessage(out, "유효하지 않은 주문서입니다.(4)", backUrl);
					return;
				}
			}
		}

	}
	
	// 포인트
	pointAmt = Integer.parseInt(param.get("point_amt", "0").replaceAll(",", ""));
	if(pointAmt > 0) {	
		int point = immem.getMemberPoint(fs.getUserNo());
		if(point < pointAmt) {
			System.out.println(orderid + "- invalid order 유효하지 않은 주문서입니다.(5) pointAmt " + point + " : " + pointAmt);
			Utils.sendMessage(out, "유효하지 않은 주문서입니다.(5)", backUrl);
			return;
		}
	}
	
	// 기프트카드
	int giftcardAmt = Integer.parseInt(param.get("giftcard_amt", "0").replaceAll(",", ""));
	if(giftcardAmt > 0 && "".equals(param.get("giftcard_id"))) {
		System.out.println("----------------- invalid order 유효하지 않은 주문서입니다.(7)");
		Utils.sendMessage(out, "유효하지 않은 주문서입니다.(7)", Env.getURLPath() + "/");
		return;
	}
	
	System.out.println("PAY_AMT : " + (totAmt - couponAmt - promocdAmt - pointAmt - giftcardAmt) + " : " + param.get("LGD_AMOUNT"));
	if((totAmt - couponAmt - promocdAmt - pointAmt - giftcardAmt) != param.getInt("LGD_AMOUNT")) {
		System.out.println(orderid + "- invalid order 유효하지 않은 주문서입니다.(6) payAmt");
		Utils.sendMessage(out, "유효하지 않은 주문서입니다.(6)", backUrl);
		return;
	}
	
// 	if(SystemChecker.isLocal()) return;
	
	boolean nopg = "Y".equals(param.get("nopg"));

	if(param.getInt("LGD_AMOUNT") == 0 || (nopg && SystemChecker.isLocal())) {	// 0원 결제
		try {
			svc.create(request, response);
		} catch(Exception e) {
			e.printStackTrace();
			Utils.sendMessage(out, e.getLocalizedMessage(), backUrl);
			return;
		}
	} else if("009".equals(param.get("pay_type"))) {	// 네이버페이
	    String partnerId = Config.get("npay.noshop.partnerid");
	    String clientId = Config.get("npay.noshop.clientid");
	    String clientSecret = Config.get("npay.noshop.clientsecret");

	    Param p = new Param();
	    p.set("paymentId", param.get("paymentId"));
	    NaverPayUtil npay = new NaverPayUtil();
	    JSONObject j = npay.approve(partnerId, clientId, clientSecret, p);
	    int responseCode = (Integer) j.get("response_code");
	    String code = (String) j.get("code");
	    
	    if(responseCode == 200 && "Success".equals(code)) {	// 결제성공
	    	Param payInfo = new Param();
			payInfo.set("orderid", 				orderid);
			payInfo.set("code", 				code);
			payInfo.set("message",				j.get("message"));
			
			JSONObject body = (JSONObject) j.get("body");
			payInfo.set("payment_id",			body.get("paymentId"));
			
			JSONObject detail = (JSONObject) body.get("detail");
			payInfo.set("pay_hist_id",				detail.get("payHistId"));
			payInfo.set("merchant_id",				detail.get("merchantId"));
			payInfo.set("merchant_name",			detail.get("merchantName"));
			payInfo.set("merchant_pay_key",			detail.get("merchantPayKey"));
			payInfo.set("merchant_user_key",		detail.get("merchantUserKey"));
			payInfo.set("admission_type_code",		detail.get("admissionTypeCode"));
			payInfo.set("admission_ymdt",			detail.get("admissionYmdt"));
			payInfo.set("trade_confirm_ymdt",		detail.get("tradeConfirmYmdt"));
			payInfo.set("admission_state",			detail.get("admissionState"));
			payInfo.set("total_pay_amount",			detail.get("totalPayAmount"));
			payInfo.set("primary_pay_amount",		detail.get("primaryPayAmount"));
			payInfo.set("npoint_pay_amount",		detail.get("npointPayAmount"));
			payInfo.set("primary_pay_means",		detail.get("primaryPayMeans"));
			payInfo.set("card_corp_code",			detail.get("cardCorpCode"));
			payInfo.set("card_no",					detail.get("cardNo"));
			payInfo.set("card_auth_no",				detail.get("cardAuthNo"));
			payInfo.set("card_inst_count",			detail.get("cardInstCount"));
			payInfo.set("bank_corp_code",			detail.get("bankCorpCode"));
			payInfo.set("bank_account_no",			detail.get("bankAccountNo"));
			payInfo.set("product_name",				detail.get("productName"));
			payInfo.set("settle_expected",			detail.get("settleExpected"));
			payInfo.set("settle_expect_amount",		detail.get("settleExpectAmount"));
			payInfo.set("pay_commission_amount",	detail.get("payCommissionAmount"));
			payInfo.set("extra_deduction",			detail.get("extraDeduction"));
			payInfo.set("use_cfm_ymdt",				detail.get("useCfmYmdt"));

			try {
				if(param.getInt("LGD_AMOUNT") != Integer.parseInt(payInfo.get("total_pay_amount"))) {
					throw new Exception("결제금액 상이");
				}
				svc.create(request, response, payInfo);
	    	} catch(Exception e) {
	    		e.printStackTrace();
	    		
	    		// 결제 취소
	    		p = new Param();
	    		p.set("paymentId",				body.get("paymentId"));
	    		p.set("cancelAmount",			param.getInt("LGD_AMOUNT"));
	    		p.set("cancelReason",			"DB ERROR");
	    		p.set("cancelRequester",		"2");
	    		p.set("taxScopeAmount",			param.getInt("LGD_AMOUNT"));
	    		p.set("taxExScopeAmount",		0);
	    		
	    		j = npay.cancel(partnerId, clientId, clientSecret, p);
	    		code = (String) j.get("code");
			    if(!"Success".equals(code)) {
                 	System.out.println(j.toJSONString());
                	Utils.sendMessage(out, "결제중 오류가 발생했지만 승인취소가 정상적으로 처리되지 않았습니다. 관리자에게 문의 하세요.", Env.getURLPath() + "/");
                	return;
			    }

			    System.out.println("네이버 결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"));
            	Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"), Env.getURLPath() + "/");
            	return;
	    		
	    	}
	    } else {
        	System.out.println("-------- 네이버 결제가 실패하였습니다.(" + j.get("code") + " : " + j.get("message"));
        	Utils.sendMessage(out, "결제가 실패하였습니다.(" + j.get("code") + " : " + j.get("message"), Env.getURLPath() + "/");
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
		String kjson = util.payco_approval(sendMap,logYn);
		
		// jackson Tree 이용
		JsonNode node = mapper.readTree(kjson);
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
				payInfo.set("total_order_amt", 					result.path("totalOrderAmt").intValue());
				payInfo.set("total_delivery_fee_amt",			result.path("totalDeliveryFeeAmt").intValue());
				payInfo.set("total_remote_area_delivery_amt", 	result.path("totalRemoteAreaDeliveryAmt").intValue());
				payInfo.set("total_payment_amt", 				result.path("totalPaymentAmt").intValue());
				payInfo.set("payment_completion_yn", 			result.path("paymentCompletionYn").textValue());
				payInfo.set("delivery_place", 					result.path("deliveryPlace").textValue());
				payInfo.set("order_products", 					result.path("orderProducts").toString());
				payInfo.set("payment_details", 					result.path("paymentDetails").toString());
				payInfo.set("order_certify_key", 				result.path("orderCertifyKey").textValue());
				payInfo.set("code", 							code);
				payInfo.set("message", 							msg);
				
				orderNo = result.path("orderNo").textValue();
				orderCertifyKey = result.path("orderCertifyKey").textValue();
        	
				if(param.getInt("LGD_AMOUNT") != Integer.parseInt(payInfo.get("total_payment_amt"))) {
					throw new Exception("결제금액 상이");
				}

				if(!doCancel) {
					svc.create(request, response, payInfo);
				}
			}catch(Exception e){
				e.printStackTrace();
				doCancel = true;
			}
		}else{
        	Utils.sendMessage(out, "결제가 실패하였습니다.(" + code + " : " + msg, backUrl);
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
			
			if(!"".equals(cancelMsg)) {
				Utils.sendMessage(out, cancelMsg, backUrl);
			} else if(!cancelNode.path("code").toString().equals("0")){
				Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail1)", backUrl);
			} else {
				Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail2)", backUrl);
			}
			return;
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
	    	Utils.sendMessage(out, "결제요청이 실패하였습니다. -1", backUrl);
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
		    	xpay.Set("LGD_AMOUNTCHECKYN", "Y");
		    	xpay.Set("LGD_AMOUNT", param.get("LGD_AMOUNT"));
		    
	    	}catch(Exception e) {
	    		System.out.println("sanghafarmshop ------------- LG유플러스 제공 API를 사용할 수 없습니다. 환경파일 설정을 확인해 주시기 바랍니다. ");
	    		System.out.println(""+e.getMessage());    	
	        	Utils.sendMessage(out, "결제요청이 실패하였습니다. -2", backUrl);
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
					if(param.getInt("LGD_AMOUNT") != Integer.parseInt(lgdInfo.get("lgd_amount"))) {
						throw new Exception("결제금액 상이");
					}

					svc.create(request, response, lgdInfo);
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
	                	Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"), backUrl);
	                	return;
	                 }else{
	         			System.out.println("sanghafarmshop ------------- 자동취소가 정상적으로 처리되지 않았습니다.<br>");
	                	Utils.sendMessage(out, "결제중 오류가 발생했지만 승인취소가 정상적으로 처리되지 않았습니다. 관리자에게 문의 하세요.", backUrl);
	         	    	return;
	                 }
	         	}
	         	
	         }else{
	         	//최종결제요청 결과 실패 DB처리
	         	System.out.println("sanghafarmshop ------------- 최종결제요청 결과 실패 DB처리하시기 바랍니다.");            	
		        System.out.println( "sanghafarmshop ------------- TX 결제요청 Response_code = " + xpay.m_szResCode + "<br>");
		        System.out.println( "sanghafarmshop ------------- TX 결제요청 Response_msg = " + xpay.m_szResMsg + "<p>");
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
	    	Utils.sendMessage(out, "결제요청이 실패하였습니다. -6", backUrl);
	    	return;
	     }
	}

	// 현금영수증 처리
	System.out.println("################################## -------------- cashreceipt");
	if(giftcardAmt > 0 && !"".equals(param.get("LGD_CASHRECEIPTUSE"))) {
		System.out.println("################################## -------------- cashreceipt2");
		try {
			String configPath = Env.getDocRoot() + Config.get("lgdacom.config") + SystemChecker.getCurrentName().toLowerCase();
			String CST_PLATFORM                 = SystemChecker.isReal() ? "service" : "test";
			String CST_MID                      = Config.get("lgdacom.CST_MID2");
			String LGD_MID                      = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;
		    
		    XPayClient xpay = new XPayClient();
		    xpay.Init(configPath, CST_PLATFORM);
		    xpay.Init_TX(LGD_MID);
		    xpay.Set("LGD_TXNAME", "CashReceipt");
		    xpay.Set("LGD_METHOD", "AUTH");
		    xpay.Set("LGD_PAYTYPE", "SC0100");
	    	xpay.Set("LGD_OID", orderid);
	    	xpay.Set("LGD_CUSTOM_MERTNAME", "상하농원");
	     	xpay.Set("LGD_CUSTOM_BUSINESSNUM", "4158600211");
	    	xpay.Set("LGD_CASHCARDNUM", param.get("LGD_CASHCARDNUM"));
			xpay.Set("LGD_AMOUNT", giftcardAmt + "");
	    	xpay.Set("LGD_CASHRECEIPTUSE", param.get("LGD_CASHRECEIPTUSE"));
    		xpay.Set("LGD_PRODUCTINFO", param.get("LGD_PRODUCTINFO"));

    	    if (xpay.TX()) {
    	        //1)현금영수증 발급/취소결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
    	        System.out.println("현금영수증 발급/취소 요청처리가 완료되었습니다.  <br>");
    	        System.out.println( "TX Response_code = " + xpay.m_szResCode + "<br>");
    	        System.out.println( "TX Response_msg = " + xpay.m_szResMsg + "<p>");
    	        
    	        System.out.println("응답코드 : " + xpay.Response("LGD_RESPCODE",0) + "<br>");
    	        System.out.println("응답메세지 : " + xpay.Response("LGD_RESPMSG",0) + "<p>");
    	        System.out.println("주문번호 : " + xpay.Response("LGD_OID",0) + "<br>");
    	        System.out.println("거래번호 : " + xpay.Response("LGD_TID",0) + "<br>");
    	        System.out.println("현금영수증 거래번호 : " + xpay.Response("LGD_CASHRECEIPTNUM",0) + "<br>");
    	        System.out.println("발급일시 : " + xpay.Response("LGD_RESPDATE",0) + "<br>");
    	        
    	        for (int i = 0; i < xpay.ResponseNameCount(); i++) {
    	        	System.out.println(xpay.ResponseName(i) + " = ");
    	            for (int j = 0; j < xpay.ResponseCount(); j++) {
    	            	System.out.println(xpay.Response(xpay.ResponseName(i), j) + "<br>");
    	            }
    	        }
    	        
    	        Param p = new Param();
    	        p.set("lgd_method", "AUTH");
    	        p.set("lgd_respcode", xpay.Response("LGD_RESPCODE",0));
    	        p.set("lgd_respmsg", xpay.Response("LGD_RESPMSG",0));
    	        p.set("lgd_oid", xpay.Response("LGD_OID",0));
    	        p.set("lgd_tid", xpay.Response("LGD_TID",0));
    	        p.set("lgd_cashreceiptnum", xpay.Response("LGD_CASHRECEIPTNUM",0));
    	        p.set("lgd_respdate", xpay.Response("LGD_RESPDATE",0));
    	        p.set("lgd_amount", giftcardAmt);
    	        p.set("lgd_cashcardnum", param.get("LGD_CASHCARDNUM"));
    	       	p.set("lgd_cashreceiptuse", param.get("LGD_CASHRECEIPTUSE"));
	    	        
				order.createLgdCashreceiptLog(p);
    	    } else {
    	        //2)API 요청 실패 화면처리
    	    	System.out.println("현금영수증 발급/취소 요청처리가 실패되었습니다.  <br>");
    	    	System.out.println( "TX Response_code = " + xpay.m_szResCode + "<br>");
    	    	System.out.println( "TX Response_msg = " + xpay.m_szResMsg);
    	    }
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	/*
	try {
		Param p = new Param();
		String content = "[상하농원] 객실예약 완료 안내\n";
		content += "예약번호 : " + param.get("orderid") + "\n";
		content += param.get("name") + "님의 [" + param.get("chki_date") + "~" + param.get("chot_date") + "] 파머스빌리지 객실 예약이 완료되었습니다.\n";
		content += "- 예약은 투숙예정일 8일전 까지 무료 취소 가능합니다.(이후 위약금 부과)\n";
		content += "- 투숙예정일 7일 이내 취소 건은 고객센터 문의주세요.\n";
		content += "- 체크인은 투숙예정일 15시부터 가능합니다.\n\n";
		content += "▶ 찾아오시는 길\n전라북도 고창군 상하면 상하농원길 11-23\n\n";
		content += "▶ 마이페이지에서 확인하기\nhttps://bit.ly/2OTd8cs\n\n";
		content += "온라인예약 문의☎ 고객센터1522-3698\n기타 문의☎ 파머스빌리지 063-563-6611";
		
		p.set("content", content);
		p.set("phone", param.get("mobile1") + param.get("mobile2") + param.get("mobile3"));
		p.set("sms_id", TmsUtil.SMS_ID_02);
		TmsUtil tms = new TmsUtil();
		tms.sendSms(p);
	} catch(Exception e) {
		e.printStackTrace();
	}
	*/

	String nextUrl = Env.getURLPath();
	if(!"P".equals(deviceType)) nextUrl += "/mobile";
	nextUrl += "/hotel/offer/complete.jsp";
%>
<form name="orderForm" id="orderForm" action="<%= nextUrl %>" method="POST">
	<input type="hidden" name="orderid" value="<%= param.get("orderid") %>" />
</form>

<script>
// document.getElementById("orderForm").submit();
document.location.href="<%= nextUrl %>?orderid=<%= param.get("orderid") %>";
</script>
