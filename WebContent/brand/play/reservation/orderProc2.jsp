<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.io.*,
				 com.efusioni.stone.utils.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.security.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.order.*,
				 com.sanghafarm.service.product.*,
				 com.sanghafarm.service.member.*,
				 com.sanghafarm.utils.*,
				 org.json.simple.*,
				 lgdacom.XPayClient.XPayClient,
				 kr.co.lgcns.module.lite.*" %>
<%@ page import="javax.xml.ws.Response"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="com.fasterxml.jackson.core.type.TypeReference" %>
<%@page import="com.fasterxml.jackson.databind.node.ArrayNode"%>
<%@page import="com.fasterxml.jackson.databind.JsonNode"%>
<%@ include file="/order/payco/common_include.jsp" %>
<%
	request.setCharacterEncoding("utf-8"); 
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	TicketOrderService order = (new TicketOrderService()).toProxyInstance();
	OrderService order2 = (new OrderService()).toProxyInstance();
	MemberService member = (new MemberService()).toProxyInstance();
	ImMemberService immem = (new ImMemberService()).toProxyInstance();
	CouponService coupon = (new CouponService()).toProxyInstance();
	ExpProductService exp = (new ExpProductService()).toProxyInstance();
	
	String orderid = param.get("orderid");
	String deviceType = param.get("device_type", "P");
	
	String backUrl = Env.getURLPath() + (!"P".equals(deviceType) ? "/mobile" : "") + "/brand/play/reservation/admission.jsp";
	
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
	
	int totAmt = 0;
	int couponAmt = 0;
	int giftcardAmt = 0;
	int pointAmt = 0;

	String[] expPids = param.getValues("exp_pid");
	for(String expPid : expPids) {
		String[] ticketTypes = param.getValues("ticket_type_" + expPid);
		int _reservedNum = 0;
		for(String ticketType : ticketTypes) {
			int _amt = 0;
			if("0".equals(expPid)) {
				_amt = Integer.parseInt(Config.get("admission.fee." + ticketType));
			} else {
				_amt = exp.getPriceInfo(new Param("exp_pid", expPid, "ticket_type", ticketType));
			}
// 			totAmt += param.getInt("price_" + expPid + "_" + ticketType, 0) * param.getInt("qty_" + expPid + "_" + ticketType, 0);
			totAmt += _amt * param.getInt("qty_" + expPid + "_" + ticketType, 0);
			_reservedNum += param.getInt("occu_num_" + expPid + "_" + ticketType) * param.getInt("qty_" + expPid + "_" + ticketType, 0);
		}

		if(!"0".equals(expPid) && _reservedNum > 0) {
			Param info = exp.getInfo(expPid);
			if(info.getInt("seat_num", 0) - info.getInt("reserved_num", 0) < _reservedNum) {
				Utils.sendMessage(out, "예약 가능 인원이 초과되었습니다.", backUrl);
				return;
			}
			
			// 시작 5분전 체크
// 			System.out.println(String.format("============ dtime : %f", info.getDouble("dtime")));
			if(info.getDouble("dtime") <= 5) {
				Utils.sendMessage(out, "체험 시작 5분전 상품은 예약할 수 없습니다.", backUrl);
				return;
			}
			
		}
	}
	
// 	if(SystemChecker.isLocal()) return;

	// 쿠폰 검증
	if(!"".equals(param.get("mem_couponid"))) {
		Param p = new Param();
		p.set("userid", fs.getUserId());
		p.set("device_type", fs.getDeviceType());
		p.set("grade_code", fs.getGradeCode());
		p.set("mem_couponid", param.get("mem_couponid"));
		p.set("coupon_type", "004");
			
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
			if(totAmt < couponInfo.getInt("min_price", 0)) {
				System.out.println("----------------- invalid order 유효하지 않은 주문서입니다.(4) " + totAmt + ":" + couponInfo.get("min_price"));
				Utils.sendMessage(out, "유효하지 않은 주문서입니다.(4)", backUrl);
				return;
			}
			
			if("A".equals(couponInfo.get("sale_type"))) {	//  정량
				couponAmt = couponInfo.getInt("sale_amt");
			} else {	// 정률
				couponAmt = (couponInfo.getInt("max_sale") <= (totAmt * couponInfo.getInt("sale_amt") / 100)) ? 
						couponInfo.getInt("max_sale") : (totAmt * couponInfo.getInt("sale_amt") / 100);
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
	
	// 기프트카드
	giftcardAmt = Integer.parseInt(param.get("giftcard_amt", "0").replaceAll(",", ""));
	if(giftcardAmt > 0 && "".equals(param.get("giftcard_id"))) {
		System.out.println("----------------- invalid order 유효하지 않은 주문서입니다.(7)");
		Utils.sendMessage(out, "유효하지 않은 주문서입니다.(7)", Env.getURLPath() + "/");
		return;
	}

	System.out.println("PAY_AMT : " + (totAmt - couponAmt - pointAmt - giftcardAmt) + " : " + param.get("LGD_AMOUNT"));
	if((totAmt - couponAmt - pointAmt - giftcardAmt) != param.getInt("LGD_AMOUNT")) {
		System.out.println("----------------- invalid order 유효하지 않은 주문서입니다.(6)");
		Utils.sendMessage(out, "유효하지 않은 주문서입니다.(6)", backUrl);
		return;
	}

// 	if(SystemChecker.isLocal()) return;
	
	boolean nopg = true;
// 	boolean nopg = false;
	if(param.getInt("LGD_AMOUNT") == 0 || (nopg && SystemChecker.isLocal())) {	// 0원 결제
		try {
			order.create2(request, response);
		} catch(Exception e) {
			Utils.sendMessage(out, e.getLocalizedMessage(), backUrl);
			return;
		}
	} else if("009".equals(param.get("pay_type"))) {	// NaverPay
	    String partnerId = Config.get("npay.noshop.partnerid");
	    String clientId = Config.get("npay.noshop.clientid");
	    String clientSecret = Config.get("npay.noshop.clientsecret");

	    Param p = new Param();
	    p.set("paymentId", param.get("paymentId"));
	    NaverPayUtil npay = new NaverPayUtil();
	    JSONObject json = npay.approve(partnerId, clientId, clientSecret, p);
	    int responseCode = (Integer) json.get("response_code");
	    String code = (String) json.get("code");
	    
	    if(responseCode == 200 && "Success".equals(code)) {	// 결제성공
	    	Param payInfo = new Param();
			payInfo.set("orderid", 				orderid);
			payInfo.set("code", 				code);
			payInfo.set("message",				json.get("message"));
			
			JSONObject body = (JSONObject) json.get("body");
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
	    		order.create2(request, response, payInfo);
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
	    		
	    		json = npay.cancel(partnerId, clientId, clientSecret, p);
	    		code = (String) json.get("code");
			    if(!"Success".equals(code)) {
                 	System.out.println(json.toJSONString());
                	Utils.sendMessage(out, "결제중 오류가 발생했지만 승인취소가 정상적으로 처리되지 않았습니다. 관리자에게 문의 하세요.", Env.getURLPath() + "/");
                	return;
			    }

			    System.out.println("네이버 결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"));
            	Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"), Env.getURLPath() + "/");
            	return;
	    		
	    	}
	    } else {
        	System.out.println("-------- 네이버 결제가 실패하였습니다.(" + json.get("code") + " : " + json.get("message"));
        	Utils.sendMessage(out, "결제가 실패하였습니다.(" + json.get("code") + " : " + json.get("message"), Env.getURLPath() + "/");
        	return;
	    }
	} else if("008".equals(param.get("pay_type"))) {	// Smilepay
	    //부인방지토큰값
	    String nonRepToken = param.get("NON_REP_TOKEN");
	    String txnId = param.get("txnId");
	    String binNumber = param.get("BIN_NUMBER");
	    System.out.println("^^^^^^^^^^^^^^^ smilepay nonRepToken : " + nonRepToken);
	    System.out.println("^^^^^^^^^^^^^^^ smilepay txnId : " + txnId);
	    System.out.println("^^^^^^^^^^^^^^^ smilepay binNumber : " + binNumber);

	    // 모듈이 설치되어 있는 경로 설정
	    CnsPayWebConnector connector = new CnsPayWebConnector();
	    
	    // 환경설정 및 로그 디렉토리 생성(incKakaopayCommon.jsp에서 설정한 값 사용)
	    connector.setLogHome(SmilepayUtil.LOG_HOME);
	    connector.setCnsPayHome(SmilepayUtil.CNSPAY_HONE);
	    
	    // 요청 페이지 파라메터 셋팅
	    connector.setRequestData(request);
	    
	    // 추가 파라메터 셋팅
	    connector.addRequestData("actionType", "PY0");              // actionType : CL0 취소, PY0 승인
	    connector.addRequestData("MallIP", request.getRemoteAddr());// 가맹점 고유 ip
	    
	    //가맹점키 셋팅 (MID 별로 틀림) 

	    connector.addRequestData("EncodeKey", SmilepayUtil.ENCODE_KEY);
	    
	    // CNSPAY Lite 서버 접속하여 처리
	    connector.requestAction();

	    // 결과 처리
 	    String resultCode = connector.getResultData("ResultCode");      // 결과코드 (정상 :3001 , 그 외 에러)
	    String resultMsg = connector.getResultData("ResultMsg");        // 결과메시지
	    
	    String errorCD = connector.getResultData("ErrorCD");  			// 원천사 오류코드 (참조용)
	    String errorMsg = connector.getResultData("ErrorMsg");  		// 원천사 오류 메세지 (참조용)
	    
	    String authDate = connector.getResultData("AuthDate");          // 승인일시 YYMMDDHH24mmss
	    String authCode = connector.getResultData("AuthCode");          // 승인번호

	    String buyerName = connector.getResultData("BuyerName");        // 구매자명
	    String goodsName = connector.getResultData("GoodsName");        // 상품명
	    String payMethod = connector.getResultData("PayMethod");        // 결제수단
	    String mid = connector.getResultData("MID");                    // 가맹점ID
	    String tid = connector.getResultData("TID");                    // 거래ID
	    String moid = connector.getResultData("Moid");                  // 주문번호
	    String amt = connector.getResultData("Amt");                    // 금액
	    String cardCode = connector.getResultData("CardCode");          // 카드사 코드
	    String acquCardCode = connector.getResultData("AcquCardCode");
	    String cardName = connector.getResultData("CardName");          // 결제카드사명
	    String cardQuota = connector.getResultData("CardQuota");        // 할부개월수 ex) 00:일시불,02:2개월
	    String cardInterest = connector.getResultData("CardInterest");  // 무이자 여부 (0:일반, 1:무이자)
	    String cardCl = connector.getResultData("CardCl");              // 체크카드여부 (0:일반, 1:체크카드)
	    String cardBin = connector.getResultData("CardBin");            // 카드BIN번호
	    String cardPoint = connector.getResultData("CardPoint");        // 카드사포인트사용여부 (0:미사용, 1:포인트사용, 2:세이브포인트사용)

	    String ccPartCl = connector.getResultData("CcPartCl");  		// 부분취소 가능 여부 (0:부분취소불가, 1:부분취소가능)
	    String promotionCcPartCl = connector.getResultData("PromotionCcPartCl");
	    String vanCode = connector.getResultData("VanCode");
	    String fnNo = connector.getResultData("FnNo");
	    String cardNo = connector.getResultData("CardNo");				// 마스킹된 카드 번호

	    String SmileCash = connector.getResultData("SmileCash");		// CI 연동가맹점 필수 파라미터

	 	// SMILEPAY를 위한 결과 처리
	    String promotionCd = connector.getResultData("PromotionCd");    // 프로모션 코드
	    String discountAmt = connector.getResultData("DiscountAmt");    // 프로모션 할인 금액
	    String possiBin = connector.getResultData("possiBin");    		// 선할인제휴카드 BIN
	    String blockBin = connector.getResultData("blockBin");    		// 특정제한카드 BIN
	    
		Param payInfo = new Param();
		payInfo.set("orderid", orderid);
		payInfo.set("result_code", resultCode);
		payInfo.set("result_msg", resultMsg);
		payInfo.set("error_cd", errorCD);
		payInfo.set("error_msg", errorMsg);
		payInfo.set("auth_date", authDate);
		payInfo.set("auth_code", authCode);
		payInfo.set("buyer_name", buyerName);
		payInfo.set("goods_name", goodsName);
		payInfo.set("pay_method", payMethod);
		payInfo.set("mid", mid);
		payInfo.set("tid", tid);
		payInfo.set("moid", moid);
		payInfo.set("amt", amt);
		payInfo.set("card_code", cardCode);
		payInfo.set("acqu_card_code", acquCardCode);
		payInfo.set("card_name", cardName);
		payInfo.set("card_quota", cardQuota);
		payInfo.set("card_interest", cardInterest);
		payInfo.set("card_cl", cardCl);
		payInfo.set("card_bin", cardBin);
		payInfo.set("card_point", cardPoint);
		payInfo.set("cc_part_cl", ccPartCl);
		payInfo.set("promotion_cc_part_cl", promotionCcPartCl);
		payInfo.set("van_code", vanCode);
		payInfo.set("fn_no", fnNo);
		payInfo.set("card_no", cardNo);
		payInfo.set("smile_cash", SmileCash);
		payInfo.set("promotion_cd", promotionCd);
		payInfo.set("discount_amt", discountAmt);
		payInfo.set("possi_bin", possiBin);
		payInfo.set("block_bin", blockBin);

	    System.out.println("^^^^^^^^^^^^^^^ smilepay result ^^^^^^^^^^^^^^^");
// 	    System.out.println("resultCode         	: " + resultCode           );
// 	    System.out.println("resultMsg          	: " + resultMsg            );
// 	    System.out.println("errorCD         	: " + errorCD           	);
// 	    System.out.println("errorMsg          	: " + errorMsg            );
// 	    System.out.println("authDate           	: " + authDate             );
// 	    System.out.println("authCode           	: " + authCode             );
// 	    System.out.println("buyerName         	: " + buyerName             );
// 	    System.out.println("goodsName          	: " + goodsName             );
// 	    System.out.println("payMethod          	: " + payMethod            );
// 	    System.out.println("mid             	: " + mid                  );
// 	    System.out.println("tid                	: " + tid                  );
// 	    System.out.println("moid               	: " + moid                 );
// 	    System.out.println("amt                	: " + amt                  );
// 	    System.out.println("cardCode           	: " + cardCode             );
// 	    System.out.println("acquCardCode       	: " + acquCardCode         );
// 	    System.out.println("cardName           	: " + cardName             );
// 	    System.out.println("cardQuota          	: " + cardQuota            );
// 	    System.out.println("cardInterest       	: " + cardInterest         );
// 	    System.out.println("cardCl             	: " + cardCl               );
// 	    System.out.println("cardBin            	: " + cardBin              );
// 	    System.out.println("cardPoint          	: " + cardPoint            );
// 	    System.out.println("ccPartCl          	: " + ccPartCl            );
// 	    System.out.println("promotionCcPartCl  	: " + promotionCcPartCl    );
// 	    System.out.println("vanCode            	: " + vanCode              );
// 	    System.out.println("fnNo               	: " + fnNo                 );
// 	    System.out.println("cardNo              : " + cardNo                 );
// 	    System.out.println("SmileCash           : " + SmileCash                 );
// 	    System.out.println("promotionCd         : " + promotionCd                 );
// 	    System.out.println("discountAmt        	: " + discountAmt          );
// 	    System.out.println("possiBin            : " + possiBin                 );
// 	    System.out.println("blockBin            : " + blockBin                 );
		System.out.println(payInfo);
	    System.out.println("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
	    
	    boolean paySuccess = false;                                     // 결제 성공 여부
	    
        if(resultCode.equals("3001")) paySuccess = true;            // 결과코드 (정상 :3001 , 그 외 에러)
	    
	    if(paySuccess){
	    	try {
				if(param.getInt("LGD_AMOUNT") != Integer.parseInt(payInfo.get("amt"))) {
					throw new Exception("결제금액 상이");
				}

				order.create2(request, response, payInfo);
	    	}
	    	catch (Exception e) {
	    		e.printStackTrace();
	    		
	    		// DB 입력 실패시 결제 취소
				connector.addRequestData("actionType", "CL0");
				connector.addRequestData("MID", mid);
				connector.addRequestData("TID", tid);
				connector.addRequestData("CancelAmt", amt);
				connector.addRequestData("CancelMsg", "Transaction rolled back.");
				connector.addRequestData("PartialCancelCode", "0");
				connector.addRequestData("CancelIP", request.getRemoteAddr());
				
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
			    payInfo.set("auth_date", connector.getResultData("AuthDate"));
			    payInfo.set("state_cd", connector.getResultData("StateCD"));
			    payInfo.set("van_code", connector.getResultData("VanCode"));
			    payInfo.set("smile_cash", connector.getResultData("SmileCash"));

			    if (!resultCode.equals("2001")) {
                 	System.out.println("smilepay 2001");
                	Utils.sendMessage(out, "결제중 오류가 발생했지만 승인취소가 정상적으로 처리되지 않았습니다. 관리자에게 문의 하세요.", Env.getURLPath() + "/");
                	return;
			    }
			    System.out.println("smilepay 결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"));
            	Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"), Env.getURLPath() + "/");
            	return;
	    	}
	    }
	    else{
        	System.out.println("-------- smilepay 결제가 실패하였습니다.(" + payInfo.get("result_code") + " : " + payInfo.get("result_msg") + ")");
        	Utils.sendMessage(out, "결제가 실패하였습니다.(" + payInfo.get("result_code") + " : " + payInfo.get("result_msg") + ")", Env.getURLPath() + "/");
        	return;
	    }
	} else if("007".equals(param.get("pay_type"))) {	// 카카오페이2
	    Param p = new Param();
	    p.set("tid", SecurityUtils.decodeAES(param.get("tid")));
	    p.set("partner_order_id", orderid);
	    p.set("partner_user_id", userid);
		p.set("pg_token", param.get("pg_token"));
	    KakaopayUtil kakao = new KakaopayUtil();
	    JSONObject json = kakao.approve(p);
	    int responseCode = (Integer) json.get("response_code");
	    
	    if(responseCode == 200) {	// 결제성공
	    	Param payInfo = new Param();
			payInfo.set("orderid", 				orderid);
			payInfo.set("aid", 					json.get("aid"));
			payInfo.set("tid", 					json.get("tid"));
			payInfo.set("cid", 					json.get("cid"));
			payInfo.set("sid", 					json.get("sid"));
			payInfo.set("partner_order_id", 	json.get("partner_order_id"));
			payInfo.set("partner_user_id", 		json.get("partner_user_id"));
			payInfo.set("payment_method_type",	json.get("payment_method_type"));
			payInfo.set("item_name", 			json.get("item_name"));
			payInfo.set("item_code", 			json.get("item_code"));
			payInfo.set("quantity", 			json.get("quantity"));
			payInfo.set("created_at", 			json.get("created_at"));
			payInfo.set("approved_at", 			json.get("approved_at"));
			payInfo.set("payload", 				json.get("payload"));
			
			JSONObject amt = (JSONObject) json.get("amount");
			payInfo.set("amount", 	amt.toJSONString());
			payInfo.set("total",	amt.get("total"));
			payInfo.set("tax_free",	amt.get("tax_free"));

			JSONObject card = (JSONObject) json.get("card_info");
			payInfo.set("card_info",	(card == null ? null : card.toJSONString()));

			try {
				if(param.getInt("LGD_AMOUNT") != Integer.parseInt(payInfo.get("total"))) {
					throw new Exception("결제금액 상이");
				}
				order.create2(request, response, payInfo);
	    	}
	    	catch(Exception e) {
	    		e.printStackTrace();
	    		
	    		// 결제 취소
	    		p = new Param();
	    		p.set("cid",					json.get("cid"));
	    		p.set("tid",					json.get("tid"));
	    		p.set("cancel_amount",			amt.get("total"));
	    		p.set("cancel_tax_free_amount",	amt.get("tax_free"));
	    		
	    		json = kakao.cancel(p);
	    		responseCode = (Integer) json.get("response_code");
			    if(responseCode != 200) {
                 	System.out.println(json.toJSONString());
                	Utils.sendMessage(out, "결제중 오류가 발생했지만 승인취소가 정상적으로 처리되지 않았습니다. 관리자에게 문의 하세요.", Env.getURLPath() + "/");
                	return;
			    }

			    System.out.println("kakao 결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"));
            	Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"), Env.getURLPath() + "/");
            	return;
	    		
	    	}
	    } else {
        	System.out.println("-------- kakao 결제가 실패하였습니다.(" + json.get("code") + " : " + json.get("msg"));
        	Utils.sendMessage(out, "결제가 실패하였습니다.(" + json.get("result_code") + " : " + json.get("result_msg"), Env.getURLPath() + "/");
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

				order.create2(request, response, payInfo);
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
			
			if(!cancelNode.path("code").toString().equals("0")){
				Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail)", backUrl);
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

					order.create2(request, response, lgdInfo);
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
	         	System.out.println("sanghafarmshop ------------- 최종결제요청 결과 실패 DB처리하시기 바랍니다.<br>");            	
	        	Utils.sendMessage(out, "결제요청이 실패하였습니다. -5", backUrl);
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
			String CST_MID                      = Config.get("lgdacom.CST_MID3");
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
	    	        
				order2.createLgdCashreceiptLog(p);
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

	try {
		TmsUtil tms = new TmsUtil();
		tms.sendReserveSms(orderid + "0");
	} catch(Exception e) {
		e.printStackTrace();
	}
	
	String nextUrl = Env.getURLPath();
	if(!"P".equals(deviceType)) nextUrl += "/mobile";
	nextUrl += "/brand/play/reservation/complete.jsp";
%>
<form name="orderForm" id="orderForm" action="<%= nextUrl %>" method="POST">
	<input type="hidden" name="morderid" value="<%= param.get("orderid") %>" />
</form>

<script>
document.getElementById("orderForm").submit();
</script>
