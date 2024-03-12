package com.sanghafarm.service.hotel;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import com.efusioni.stone.annotation.Transactionable;
import com.efusioni.stone.common.Config;
import com.efusioni.stone.common.SystemChecker;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;
import com.efusioni.stone.utils.Utils;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sanghafarm.common.Env;
import com.sanghafarm.common.FrontSession;
import com.sanghafarm.exception.OrderError;
import com.sanghafarm.service.member.ImMemberService;
import com.sanghafarm.utils.KakaopayUtil;
import com.sanghafarm.utils.NaverPayUtil;
import com.sanghafarm.utils.PaycoUtil;

import kr.co.lgcns.module.lite.CnsPayWebConnector4NS;
import lgdacom.XPayClient.XPayClient;

public class HotelOfferService extends IbatisService {

	public List<Param> getList(Param param) {
		return super._list("HotelOffer.getList", param);
	}
	
	public Param getInfo(String pid) {
		return super._row("HotelOffer.getInfo", pid);
	}

	public List<Param> getRdateList(String pid){
		return super._list("HotelOffer.getRdateList", pid);
	}

	public Param getRdateListForCalendar(String pid){
		List<Param> list = getRdateList(pid);
		
		Param param = new Param();
		for(Param row : list) {
			param.set(row.get("rdate"), row.getInt("qty"));
		}
		
		return param;
	}
	
	public void increaseViewCnt(String pid) {
		super._update("HotelOffer.updateViewCnt", pid);
	}
	
	public Param getPriceInfo(Param param) {
		return super._row("HotelOffer.getPriceInfo", param);
	}
	
	public String getNewId() {
		return (String) super._scalar("HotelOffer.getNewId");
	}
	
	public void create(HttpServletRequest request, HttpServletResponse response) throws Exception {
		create(request, response, null);
	}

	@Transactionable
	public void create(HttpServletRequest request, HttpServletResponse response, Param payInfo) throws Exception {
		FrontSession fs = FrontSession.getInstance(request, response);
		Param param = new Param(request);
		ImMemberService immem = (new ImMemberService()).toProxyInstance();

		Param info = this.getInfo(param.get("pid"));
		String orderid = param.get("orderid");
		int totAmt = param.getInt("tot_amt");
		int couponAmt = param.getInt("coupon_amt");
		int promocdAmt = param.getInt("promocd_amt");
		int pointAmt = Integer.parseInt(param.get("point_amt", "0").replace(",", ""));
		int giftcardAmt = Integer.parseInt(param.get("giftcard_amt", "0").replace(",", ""));

		param.set("userid", fs.getUserId());
		param.set("regist_user", fs.getUserId());
		param.set("status", "120");
		param.set("pay_amt", param.get("LGD_AMOUNT"));
		param.set("pnm", info.get("pnm"));
		param.set("point_amt", pointAmt);
		param.set("giftcard_amt", giftcardAmt);
		
		try {
			super._insert("HotelOffer.insertReserve", param);
			
			for(int i = 1; i <= param.getInt("qty"); i++) {
				Param room = new Param();
				room.set("orderid", orderid);
				room.set("room_no", i);
				room.set("adult", param.get("adult" + i));
				room.set("child", param.get("child" + i));
				super._insert("HotelOffer.insertReserveRoom", room);
			}
			
			// 상태로그
			param.set("ship_seq", "1");
			super._insert("Order.insertStatusLog", param);

			if(payInfo != null) {	// LGD 로그
				if("005".equals(param.get("pay_type"))) {	// 카카오페이
					super._insert("Order.insertKakaoPayLog", payInfo);
				} else if("006".equals(param.get("pay_type"))) {	// 페이코
					super._insert("Order.insertPaycoLog", payInfo);
				} else if("009".equals(param.get("pay_type"))) {	// 네이버페이
					super._insert("Order.insertNaverPayLog", payInfo);
				} else {
					super._insert("Order.insertLgdPaymentLog", payInfo);
				}
			}
			
			if(pointAmt > 0) {	// 포인트 차감
				Param p = new Param();
				p.set("trsc_biz_dv_cd", 	"31");
				p.set("trsc_orgn_dv_cd", 	"10");
				p.set("mmb_cert_dv_cd", 	"2");
				p.set("mmb_cert_dv_vlu", 	fs.getUserNo());	
				p.set("tot_sel_amt", 		totAmt);
				p.set("tot_dc_amt", 		couponAmt + promocdAmt + pointAmt);
				p.set("mbrsh_dc_amt", 		0);
				p.set("trsc_rsn_cd", 		"CF01");
				p.set("uniq_rcgn_no", 		orderid);
				p.set("org_apv_dt", 		"");
				p.set("org_apv_no", 		"");
				p.set("org_uniq_rcgn_no", 	"");
				p.set("pint_use_typ_cd", 	"11");
				p.set("use_pint", 			pointAmt);
				p.set("rmk", 				"");
				
				JSONObject j = immem.useMemberPoint(p);
				
				if(!"00000".equals((String) j.get("RES_CD"))) {
					System.out.println("use point result : (" + j.get("RES_CD") + ") " + j.get("RES_MSG"));
					throw new OrderError("포인트 사용에 오류가 발생했습니다. (" + j.get("RES_CD") + ") " + j.get("RES_MSG"));
				}

				// 포인트 로그
				p = new Param();
				p.set("orderid", 		orderid);
				p.set("ship_seq", 		"1");
				p.set("trsc_typ_cd", 	j.get("TRSC_TYP_CD"));
				p.set("trsc_biz_dv_cd", j.get("TRSC_BIZ_DV_CD"));
				p.set("coopco_cd", 		j.get("COOPCO_CD"));
				p.set("trsc_dt",		j.get("TRSC_DT"));
				p.set("trsc_hr",		j.get("TRSC_HR"));
				p.set("trc_no",			j.get("TRC_NO"));
				p.set("chnl_typ_cd",	j.get("CHNL_TYP_CD"));
				p.set("apv_dt",			j.get("APV_DT"));
				p.set("apv_no",			j.get("APV_NO"));
				p.set("acml_pint", 		j.get("ACML_PINT"));
				p.set("use_pint", 		j.get("USE_PINT"));
				p.set("rmnd_pint", 		j.get("RMND_PINT"));
				p.set("res_cd", 		j.get("RES_CD"));
				p.set("res_msg", 		j.get("RES_MSG"));
				super._insert("Order.insertPointLog", p);
			}
			
			// 기프트카드 
			if(giftcardAmt > 0) {
				Param p = new Param();
				p.set("trsc_biz_dv_cd", 	"G5");
				p.set("crd_id", 			param.get("giftcard_id"));
				p.set("sale_dv", 			"1");
				p.set("use_amt", 			param.get("giftcard_amt"));
				p.set("tot_sel_amt", 		totAmt);
				p.set("item_nm", 			"파머스빌리지 스페셜오퍼예약");
				p.set("uniq_rcgn_no", 		orderid);
				p.set("trsc_orgn_dv_cd", 	"10");
				
				JSONObject j = immem.useMemberGiftcard(p);
				
				if(!"00000".equals((String) j.get("RES_CD"))) {
					System.out.println("use giftcard result : (" + j.get("RES_CD") + ") " + j.get("RES_MSG"));
					throw new OrderError("기프트카드 사용에 오류가 발생했습니다. (" + j.get("RES_CD") + ") " + j.get("RES_MSG"));
				}

				// 기프트카드 로그
				p = new Param();
				p.set("orderid", 		orderid);
				p.set("ship_seq", 		"1");
				p.set("trsc_typ_cd", 	j.get("TRSC_TYP_CD"));
				p.set("trsc_biz_dv_cd", j.get("TRSC_BIZ_DV_CD"));
				p.set("coopco_cd", 		j.get("COOPCO_CD"));
				p.set("trsc_dt",		j.get("TRSC_DT"));
				p.set("trsc_hr",		j.get("TRSC_HR"));
				p.set("trc_no",			j.get("TRC_NO"));
				p.set("chnl_typ_cd",	j.get("CHNL_TYP_CD"));
				p.set("crd_id",			j.get("CRD_ID"));
				p.set("crd_bal",		j.get("CRD_BAL"));
				p.set("apv_dt",			j.get("APV_DT"));
				p.set("apv_no",			j.get("APV_NO"));
				p.set("res_cd", 		j.get("RES_CD"));
				p.set("res_msg", 		j.get("RES_MSG"));
				super._insert("Order.insertGiftcardLog", p);
			}
			
			// 쿠폰사용 등록
			if(!"".equals(param.get("mem_couponid"))) {
				super._update("Coupon.useMemCoupon", param.get("mem_couponid"));
			}
			
			// 재고 차감
			super._update("HotelOffer.decreaseStock", param);
		} catch(Exception e) {
			e.printStackTrace();
			throw new OrderError("예약중 오류가 발생했습니다.");
		}
	}
	
	public Param getReserveInfo(String orderid) {
		return super._row("HotelOffer.getReserveInfo", orderid);
	}
	
	public List<Param> getReserveRoomList(String orderid) {
		return super._list("HotelOffer.getReserveRoomList", orderid);
	}
	
	public Param getReserveSummary(Param param) {
		return super._row("HotelOffer.getReserveSummary", param);
	}
	
	public List<Param> getReserveList(Param param) {
		return super._list("HotelOffer.getReserveList", param);
	}

	public Integer getReserveListCount(Param param) {
		return (Integer) super._scalar("HotelOffer.getReserveListCount", param);
	}

	public void cancelOrder(Param param) {
		String orderid = param.get("orderid");
		Param info = getReserveInfo(param.get("orderid"));

		param.set("status", "210");
		super._update("HotelOffer.updateStatus", param);
		
		// 상태로그
		param.set("register_user", info.get("userid"));
		param.set("ship_seq", "1");
		super._insert("Order.insertStatusLog", param);


		// 쿠폰 복원
		super._update("Coupon.resetMemCouponByOrderid", info.get("orderid"));

		if(info.getInt("point_amt") > 0) {	// 포인트 복원
			// 회원정보 검색
			Param memInfo = super._row("Member.getImInfoById", info.get("userid"));
			
			// 포인트 사용 내역
			Param pointInfo = super._row("Order.getPointLogInfo", new Param("orderid", orderid, "trsc_typ_cd", "310", "trsc_biz_dv_cd", "31")); 
					
			Param p = new Param();
			p.set("trsc_biz_dv_cd", "32");
			p.set("trsc_orgn_dv_cd", "10");
			p.set("mmb_cert_dv_cd", "2");
			p.set("mmb_cert_dv_vlu", memInfo.get("unfy_mmb_no"));	
			p.set("trsc_rsn_cd", "CF01");
			p.set("uniq_rcgn_no", orderid);
			p.set("org_apv_dt", pointInfo.get("apv_dt"));
			p.set("org_apv_no", pointInfo.get("apv_no"));
			p.set("org_uniq_rcgn_no", orderid);
			p.set("pint_use_typ_cd", "11");
			p.set("use_pint", info.getInt("point_amt"));
			p.set("rmk", "");
			
			ImMemberService immem = (new ImMemberService()).toProxyInstance();
			JSONObject json = immem.useMemberPoint(p);
			
			// 포인트 로그
			p = new Param();
			p.set("orderid", 		orderid);
			p.set("trsc_typ_cd", 	json.get("TRSC_TYP_CD"));
			p.set("trsc_biz_dv_cd", json.get("TRSC_BIZ_DV_CD"));
			p.set("coopco_cd", 		json.get("COOPCO_CD"));
			p.set("trsc_dt",		json.get("TRSC_DT"));
			p.set("trsc_hr",		json.get("TRSC_HR"));
			p.set("trc_no",			json.get("TRC_NO"));
			p.set("chnl_typ_cd",	json.get("CHNL_TYP_CD"));
			p.set("apv_dt",			json.get("APV_DT"));
			p.set("apv_no",			json.get("APV_NO"));
			p.set("acml_pint", 		json.get("ACML_PINT"));
			p.set("use_pint", 		json.get("USE_PINT"));
			p.set("rmnd_pint", 		json.get("RMND_PINT"));
			p.set("res_cd", 		json.get("RES_CD"));
			p.set("res_msg", 		json.get("RES_MSG"));
			super._insert("Order.insertPointLog", p);
			
			if(!"00000".equals((String) json.get("RES_CD"))) {
				System.out.println("use point result : (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
				throw new OrderError("포인트 복원에 오류가 발생했습니다. (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
			}
		}

		if(info.getInt("giftcard_amt") > 0) {	// 기프트카드 복원
			// 기프트카드 사용 내역
			Param giftcardInfo = super._row("Order.getGiftcardLogInfo", new Param("orderid", orderid, "trsc_typ_cd", "G41", "trsc_biz_dv_cd", "G5")); 
			
			Param p = new Param();
			p.set("trsc_biz_dv_cd", 	"G6");
			p.set("crd_id", 			info.get("giftcard_id"));
			p.set("sale_dv", 			"2");
			p.set("use_amt", 			info.getInt("giftcard_amt") * -1);
			p.set("tot_sel_amt", 		info.getInt("tot_amt"));
			p.set("item_nm", 			"파머스빌리지 객실예약");
			p.set("org_apv_dt", 		giftcardInfo.get("apv_dt"));
			p.set("org_apv_no", 		giftcardInfo.get("apv_no"));
			p.set("org_uniq_rcgn_no", 	giftcardInfo.get("orderid"));
			p.set("uniq_rcgn_no", 		giftcardInfo.get("orderid"));
			p.set("trsc_orgn_dv_cd", 	"10");

			ImMemberService immem = (new ImMemberService()).toProxyInstance();
			JSONObject json = immem.useMemberGiftcard(p);
			
			// 기프트카드 로그
			p = new Param();
			p.set("orderid", 		giftcardInfo.get("orderid"));
			p.set("ship_seq", 		"1");
			p.set("trsc_typ_cd", 	json.get("TRSC_TYP_CD"));
			p.set("trsc_biz_dv_cd", json.get("TRSC_BIZ_DV_CD"));
			p.set("coopco_cd", 		json.get("COOPCO_CD"));
			p.set("trsc_dt",		json.get("TRSC_DT"));
			p.set("trsc_hr",		json.get("TRSC_HR"));
			p.set("trc_no",			json.get("TRC_NO"));
			p.set("chnl_typ_cd",	json.get("CHNL_TYP_CD"));
			p.set("crd_id",			json.get("CRD_ID"));
			p.set("crd_bal",		json.get("CRD_BAL"));
			p.set("apv_dt",			json.get("APV_DT"));
			p.set("apv_no",			json.get("APV_NO"));
			p.set("res_cd", 		json.get("RES_CD"));
			p.set("res_msg", 		json.get("RES_MSG"));
			super._insert("Order.insertGiftcardLog", p);
			
			if(!"00000".equals((String) json.get("RES_CD"))) {
				System.out.println("use giftcard result : (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
				throw new OrderError("기프트카드 복원에 오류가 발생했습니다. (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
			}
			
			// 현금영수증 취소
			try {
				Param cashInfo = super._row("Order.getLgdCashreceiptLogInfo", new Param("lgd_oid", orderid, "lgd_method", "AUTH", "lgd_respcode", "0000"));
				if(cashInfo != null && !"".equals(cashInfo.get("lgd_tid"))) {
					String configPath = Env.getDocRoot() + Config.get("lgdacom.config") + SystemChecker.getCurrentName().toLowerCase();
					String CST_PLATFORM = SystemChecker.isReal() ? "service" : "test";
					String CST_MID = Config.get("lgdacom.CST_MID2");
					String LGD_MID = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;
					
					XPayClient xpay = new XPayClient();
					
					xpay.Init(configPath, CST_PLATFORM);
					xpay.Init_TX(LGD_MID);
					xpay.Set("LGD_TXNAME", "CashReceipt");
					xpay.Set("LGD_MID", LGD_MID);
					xpay.Set("LGD_PAYTYPE", "SC0100");
					xpay.Set("LGD_METHOD", "CANCEL");
					xpay.Set("LGD_TID", cashInfo.get("lgd_tid"));
	
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

					    Param pp = new Param();
		    	        pp.set("lgd_method", "CANCEL");
		    	        pp.set("lgd_respcode", xpay.Response("LGD_RESPCODE",0));
		    	        pp.set("lgd_respmsg", xpay.Response("LGD_RESPMSG",0));
		    	        pp.set("lgd_oid", xpay.Response("LGD_OID",0));
		    	        pp.set("lgd_tid", xpay.Response("LGD_TID",0));
		    	        pp.set("lgd_cashreceiptnum", xpay.Response("LGD_CASHRECEIPTNUM",0));
		    	        pp.set("lgd_respdate", xpay.Response("LGD_RESPDATE",0));
		    	        
						super._insert("Order.insertLgdCashreceiptLog", pp);
					} else {
					    //2)API 요청 실패 화면처리
						System.out.println("현금영수증 발급/취소 요청처리가 실패되었습니다.  <br>");
						System.out.println( "TX Response_code = " + xpay.m_szResCode + "<br>");
						System.out.println( "TX Response_msg = " + xpay.m_szResMsg);
					}
				}
			} catch(Exception e) {
				e.printStackTrace();
			}
		}

		if(info.getInt("pay_amt") > 0) {	// 결제 취소
			if("009".equals(info.get("pay_type"))) {	// naverpay 
				System.out.println("------------- naverpay cancel ------------");
				Param payInfo = super._row("Order.getNaverPayInfo", orderid);
				if (payInfo == null) {
					throw new OrderError("결제 정보가 존재하지 않습니다. 관리자에 문의하세요.");
				}
				
	    		Param p = new Param();
	    		p.set("paymentId",				payInfo.get("payment_id"));
	    		p.set("cancelAmount",			payInfo.getInt("total_pay_amount"));
	    		p.set("cancelReason",			"ORDER CANCEL");
	    		p.set("cancelRequester",		"1");
	    		p.set("taxScopeAmount",			payInfo.getInt("total_pay_amount"));
	    		p.set("taxExScopeAmount",		0);

	    	    String partnerId = Config.get("npay.noshop.partnerid");
	    	    String clientId = Config.get("npay.noshop.clientid");
	    	    String clientSecret = Config.get("npay.noshop.clientsecret");
	    		
	    		NaverPayUtil npay = new NaverPayUtil();
	    		JSONObject json = npay.cancel(partnerId, clientId, clientSecret, p);
	    		
	    		int responseCode = (Integer) json.get("response_code");
	    	    String code = (String) json.get("code");

	    	    /*
	    	    int today = Integer.parseInt(Utils.getTimeStampString("yyyyMMdd"));
	    	    if(today >= 20210401) {
		    	    if(responseCode != 200 || (!"Success".equals(code) && !"CancelNotComplete".equals(code))) {
//		    	    	System.out.println(json.toJSONString());
						throw new OrderError("결제 취소요청이 실패하였습니다.(" + json.get("code") + " : " + json.get("message") + ")");
				    }
	    	    } else {
		    	    if(responseCode != 200 || !"Success".equals(code)) {
//		    	    	System.out.println(json.toJSONString());
						throw new OrderError("결제 취소요청이 실패하였습니다.(" + json.get("code") + " : " + json.get("message") + ")");
				    }
	    	    }
	    	    */

	    	    if(responseCode != 200 || !"Success".equals(code)) {
//	             	System.out.println(json.toJSONString());
					throw new OrderError("결제 취소요청이 실패하였습니다.(" + json.get("code") + " : " + json.get("message") + ")");
			    }
			    
			    p = new Param();
				p.set("orderid", 					orderid);
				p.set("code", 						code);
				p.set("message", 					json.get("message"));
				
				JSONObject body = (JSONObject) json.get("body");
				p.set("payment_id", 				body.get("paymentId"));
				p.set("pay_hist_id", 				body.get("payHistId"));
				p.set("primary_pay_means", 			body.get("primaryPayMeans"));
				p.set("primary_pay_cancel_amount",	body.get("primaryPayCancelAmount"));
				p.set("primary_pay_rest_amount",	body.get("primaryPayRestAmount"));
				p.set("npoint_cancel_amount",		body.get("npointCancelAmount"));
				p.set("npoint_rest_amount",			body.get("npointRestAmount"));
				p.set("cancel_ymdt",				body.get("cancelYmdt"));
				p.set("total_rest_amount",			body.get("totalRestAmount"));
				
				super._insert("Order.insertNaverPayCancelLog", p);
			} else if("005".equals(info.get("pay_type"))) {	// kakaopay
				System.out.println("------------- kakaopay cancel ------------");
				Param payInfo = super._row("Order.getKakaoPayInfo", orderid);
				if (payInfo == null) {
					throw new OrderError("결제 정보가 존재하지 않습니다. 관리자에 문의하세요.");
				}
				
				String ediDate = KakaopayUtil.getyyyyMMddHHmmss(); // 전문생성일시
				String md_src = ediDate + Env.getKakaoMid() + info.get("pay_amt");
			    String hash_String = KakaopayUtil.SHA256Salt(md_src, Env.getKakaoEncodeKey());
			    
				CnsPayWebConnector4NS connector = new CnsPayWebConnector4NS();
			    connector.setLogHome(Env.getKakaoLogHome());
			    connector.setCnsPayHome(Env.getKakaoCnsPayHome());
			    
			    connector.addRequestData("actionType", "CL0");
				connector.addRequestData("CancelPwd", Env.getKakaoCancelPwd());
				connector.addRequestData("EncodeKey", Env.getKakaoEncodeKey());

				connector.addRequestData("EdiDate", ediDate);
				connector.addRequestData("MID", Env.getKakaoMid());
			    connector.addRequestData("TID", payInfo.get("tid"));
			    connector.addRequestData("CancelAmt", info.get("pay_amt"));
			    connector.addRequestData("EncryptData", hash_String);
				connector.addRequestData("PartialCancelCode", "0");
			    connector.addRequestData("CancelMsg", "주문취소");

				connector.requestAction();
				
				Param p = new Param();
				p.set("orderid", orderid);
				p.set("result_code", connector.getResultData("ResultCode"));
			    p.set("result_msg", connector.getResultData("ResultMsg"));
			    p.set("error_cd", connector.getResultData("ErrorCD"));
			    p.set("error_msg", connector.getResultData("ErrorMsg"));
			    p.set("cancel_amt", connector.getResultData("CancelAmt"));
			    p.set("cancel_date", connector.getResultData("CancelDate"));
			    p.set("cancel_time", connector.getResultData("CancelTime"));
			    p.set("pay_method", connector.getResultData("PayMethod"));
			    p.set("mid", connector.getResultData("MID"));
			    p.set("tid", connector.getResultData("TID"));
			    p.set("stateCD", connector.getResultData("StateCD"));
			    p.set("cc_part_cl", connector.getResultData("CcPartCl"));
			    p.set("cancel_num", connector.getResultData("CancelNum"));
			    p.set("van_code", connector.getResultData("VanCode"));

			    super._insert("Order.insertKakaoPayCancelLog", p);
				
			    if(!"2001".equals(connector.getResultData("ResultCode"))) {
					throw new OrderError("결제 취소요청이 실패하였습니다.(" + connector.getResultData("ResultCode") + " : " + connector.getResultData("ResultMsg") + ")");
				}
			} else if("006".equals(info.get("pay_type"))) {	// payco
				System.out.println("------------- payco cancel ------------");
				Param payInfo = super._row("Order.getPaycoInfo", orderid);
				if (payInfo == null) {
					throw new OrderError("결제 정보가 존재하지 않습니다. 관리자에 문의하세요.");
				}
				
				String code = "";
				String msg = "";

				try {
					ObjectMapper mapper = new ObjectMapper();
					JsonNode node = mapper.readTree(payInfo.get("payment_details"));
					System.out.println("payment_details : " + node);
//					System.out.println("taxableAmt : " + node.get(0).path("taxableAmt"));
					
					int taxableAmt = 0;
					int vatAmt = 0;
					int taxfreeAmt = 0;
					
					for(int i = 0; i < node.size(); i++) {
						taxableAmt += node.get(i).path("taxableAmt").asInt();
						vatAmt += node.get(i).path("vatAmt").asInt();
						taxfreeAmt += node.get(i).path("taxfreeAmt").asInt();
					}
					System.out.println("-------- taxableamt : " + taxableAmt);
					System.out.println("-------- vatamt : " + vatAmt);
					System.out.println("-------- taxfreeamt : " + taxfreeAmt);

					/* 설정한 주문취소 정보로 Json String 을 작성합니다. */
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("sellerKey", Env.getPaycoSellerKey());								//[필수]가맹점 코드
					map.put("orderNo", payInfo.get("order_no"));									//[필수]주문번호
					map.put("cancelTotalAmt", info.getInt("pay_amt"));  //[필수]취소할 총 금액(전체취소, 부분취소 전부다)
					map.put("orderCertifyKey", payInfo.get("order_certify_key"));					//[필수]주문인증 key
					map.put("totalCancelTaxableAmt", taxableAmt);
					map.put("totalCancelVatAmt", vatAmt);
					map.put("totalCancelTaxfreeAmt", taxfreeAmt);
					
					PaycoUtil util = new PaycoUtil(SystemChecker.isReal() ? "REAL" : "DEV");
					String strResult = util.payco_cancel(map, Env.getPaycoLogYn(), "N");
					System.out.println("payco cancel result : " + strResult);

					// jackson Tree 이용
					mapper = new ObjectMapper();
					node = mapper.readTree(strResult);
					code = node.path("code").toString();
					msg = node.path("message").textValue();
					JsonNode result = mapper.readTree(node.path("result").toString());
					
					Param p = new Param();
					p.set("orderid", orderid);
					p.set("order_no", result.path("orderNo").textValue());
					p.set("cancel_trade_seq", result.path("cancelTradeSeq").toString());
					p.set("total_cancel_payment_amt", result.path("totalCancelPaymentAmt").toString());
					p.set("remain_cancel_possible_amt", result.path("remainCancelPossibleAmt").toString());
					p.set("cancel_payment_details", result.path("cancelPaymentDetails").toString());
					p.set("code", code);
					p.set("message", msg);
				    super._insert("Order.insertPaycoCancelLog", p);
				} catch(Exception e) {
					e.printStackTrace();
				}

				if(!code.equals("0")){
					throw new OrderError("결제 취소요청이 실패하였습니다.(" + code + " : " + msg + ")");
				}
				
			} else {	// xpay
				Param paymentInfo = super._row("Order.getLGDPaymentInfo", orderid);
				
				if (paymentInfo == null) {
					throw new OrderError("결제 정보가 존재하지 않습니다. 관리자에 문의하세요.");
				}
		
				String configPath = Env.getDocRoot() + Config.get("lgdacom.config") + SystemChecker.getCurrentName().toLowerCase();
				System.out.println("============= LGD configPath : " + configPath);
		
			    /*가상계좌 입급전 취소*/
			    boolean bSettlement = "003".equals(info.get("pay_type")) && "110".equals(info.get("status"));
		
				String CST_PLATFORM         = SystemChecker.isReal() ? "service" : "test";          //LG유플러스 결제서비스 선택(test:테스트, service:서비스)
				String CST_MID              = Config.get("lgdacom.CST_MID2");                      //LG유플러스로 부터 발급받으신 상점아이디를 입력하세요.
				String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
			    String LGD_TID = paymentInfo.get("LGD_TID");
			    
			    XPayClient xpay = new XPayClient();
			    xpay.Init(configPath, CST_PLATFORM);
			    xpay.Init_TX(LGD_MID);
			    xpay.Set("LGD_TXNAME", bSettlement ? "Settlement" : "Cancel"); // "Cancel" : 주문 취소, "Settlement" : 가상계좌반납(정산요청)
			    xpay.Set("LGD_TID", LGD_TID);
			    
			    //가상계좌 결제 환불, 입금 이후 파라미터 추가
			    if ("003".equals(info.get("pay_type")) && !"110".equals(info.get("status"))) {
			        String LGD_RFBANKCODE     		= param.get("lgd_rfbankcode"); 		    //환불계좌 은행코드 (가상계좌환불은 필수)
			        String LGD_RFACCOUNTNUM     	= param.get("lgd_rfaccountnum"); 		//환불계좌 번호 (가상계좌환불은 필수)
			        String LGD_RFCUSTOMERNAME     	= param.get("lgd_rfcustomername"); 		//환불계좌 예금주 (가상계좌환불은 필수)
			        String LGD_RFPHONE     			= param.get("lgd_rfphone"); 		    //요청자 연락처 (가상계좌환불은 필수)
			        
			        xpay.Set("LGD_RFBANKCODE", LGD_RFBANKCODE);
			        xpay.Set("LGD_RFACCOUNTNUM", LGD_RFACCOUNTNUM);
			        xpay.Set("LGD_RFCUSTOMERNAME", LGD_RFCUSTOMERNAME);
			        xpay.Set("LGD_RFPHONE", LGD_RFPHONE);
			    }
			    
			    /*
			     * 1. 결제취소 요청 결과처리
			     *
			     * 취소결과 리턴 파라미터는 연동메뉴얼을 참고하시기 바랍니다.
				 *
				 * [[[중요]]] 고객사에서 정상취소 처리해야할 응답코드
				 * 1. 신용카드 : 0000, AV11  
				 * 2. 계좌이체 : 0000, RF00, RF10, RF09, RF15, RF19, RF23, RF25 (환불진행중 응답건-> 환불결과코드.xls 참고)
				 * 3. 나머지 결제수단의 경우 0000(성공) 만 취소성공 처리
				 *
			     */
			    	    
			    boolean success = xpay.TX();
		
		        Param lgdInfo = new Param();
		        for (int i = 0; i < xpay.ResponseNameCount(); i++) {
		            System.out.print(xpay.ResponseName(i) + " = ");
		            for (int j = 0; j < xpay.ResponseCount(); j++) {
		                System.out.println("\t" + xpay.Response(xpay.ResponseName(i), j));
		                if(j == 0) {
		                	lgdInfo.set(xpay.ResponseName(i).toLowerCase(), xpay.Response(xpay.ResponseName(i), j));
		                }
		            }
		        }
		
				if("SC0010".equals(paymentInfo.get("lgd_paytype"))){
					if("0000,AV11".indexOf(lgdInfo.get("lgd_respcode")) == -1) {
						success = false;
					}
				} else if("SC0030".equals(paymentInfo.get("lgd_paytype"))) {
					if("0000,RF00,RF10,RF09,RF15,RF19,RF23,RF25".indexOf(lgdInfo.get("lgd_respcode")) == -1) {
						success = false;
					}
				} else {
					if(!"0000".equals(lgdInfo.get("lgd_respcode"))) {
						success = false;
					}
				}
		
				// 결제 로그
				if(lgdInfo != null) {	// LGD 로그
					lgdInfo.set("lgd_oid", lgdInfo.get("lgd_oid", orderid));
					lgdInfo.set("lgd_paydate", lgdInfo.get("lgd_paydate", Utils.getTimeStampString("yyyyMMddHHmmss")));
					super._insert("Order.insertLgdPaymentLog", lgdInfo);
				}
		
			    if(!success) {
			        throw new OrderError("결제 취소요청이 실패하였습니다.(" + xpay.m_szResCode + ")");
			    }
			}
		}
	}
	
	public void modifySmsyn(String orderid) {
		super._update("HotelOffer.updateSmsyn", orderid);
	}
}
