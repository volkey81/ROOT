package com.sanghafarm.service.hotel;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

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
import com.sanghafarm.utils.SanghafarmUtils;

import kr.co.lgcns.module.lite.CnsPayWebConnector4NS;
import lgdacom.XPayClient.XPayClient;

public class HotelReserveService extends IbatisService {
	public String getNewId() {
		return (String) super._scalar("HotelReserve.getNewId");
	}
	
	public void create(HttpServletRequest request, HttpServletResponse response, List<Param> roomList) throws Exception {
		create(request, response, roomList, null);
	}

	@SuppressWarnings("unchecked")
	@Transactionable
	public void create(HttpServletRequest request, HttpServletResponse response, List<Param> roomList, Param payInfo) throws Exception {
		FrontSession fs = FrontSession.getInstance(request, response);
		Param param = new Param(request);
		RMSApiService api = new RMSApiService();
		ImMemberService immem = (new ImMemberService()).toProxyInstance();
		
		String orderid = param.get("orderid");
		int night = SanghafarmUtils.getDateDiff(param.get("chki_date"), param.get("chot_date"));
		int totAmt = param.getInt("tot_amt");
		int couponAmt = param.getInt("coupon_amt");
		int promocdAmt = param.getInt("promocd_amt");
		int pointAmt = Integer.parseInt(param.get("point_amt", "0").replace(",", ""));
		int giftcardAmt = Integer.parseInt(param.get("giftcard_amt", "0").replace(",", ""));
		
		param.set("coupon_amt", couponAmt);
		param.set("promocd_amt", promocdAmt);
		param.set("point_amt", pointAmt);
		param.set("giftcard_amt", giftcardAmt);
		param.set("userid", fs.getUserId());
		param.set("pay_amt", param.get("LGD_AMOUNT"));
		
		JSONObject forecast = api.forecast(param);
		JSONArray resvList = new JSONArray();

		for(Param row : roomList) {
//			System.out.println("++++++++++++++ roomList : " + row);
			row.set("orderid", orderid);
//			row.set("chrg_grup_gbcd", row.get("chrg_grup_gbcd_01"));
			row.set("amt", fs.isStaff() ? row.get("room_amt_02") : row.get("room_amt_01"));
			
			// amt_list
			JSONArray list = (JSONArray) forecast.get("LIST");
			JSONArray amtList = new JSONArray();
			
			for(int i = 0; i < list.size(); i++) {
				JSONObject r = (JSONObject) JSONValue.parse(list.get(i).toString());
				
				if(!r.get("APLY_DATE").equals(param.get("chot_date").replaceAll("\\.", ""))) {	// 체크아웃일 제외
					if(row.get("room_knd_gbcd").equals(r.get("ROOM_KND_GBCD"))) {
//						System.out.println("++++++++++++++ roomList2 : " + r);
						int upr = fs.isStaff() ? Integer.parseInt((String)r.get("ROOM_AMT_02")) : Integer.parseInt((String)r.get("ROOM_AMT_01"));
						int salePric = upr + (row.getInt("add_amt") / night);
						int vat = salePric / 11;
						int supyPric = salePric - vat;
								
						JSONObject o = new JSONObject();
						o.put("APLY_DATE", r.get("APLY_DATE"));
						o.put("MENU_CD", RMSApiService.MENU_CD);
						o.put("ROOM_KND_GBCD_A", r.get("ROOM_KND_GBCD"));
//						o.put("CHRG_GRUP_GBCD_A", fs.isStaff() ? "710" : "990");
						o.put("CHRG_GRUP_GBCD_A", r.get("CHRG_GRUP_GBCD_01"));
						o.put("SSN_GBCD", r.get("SSN_GBCD"));
						o.put("BEGIN_DATE", param.get("chki_date").replaceAll("\\.", ""));
						o.put("SALE_PRIC", salePric);
						o.put("UPR", upr);
						o.put("SUPY_PRIC", supyPric);
						o.put("VAT", vat);
						o.put("MDFT_YN", "N");
						o.put("MDFT_RESN_CNTN", "");
						
						amtList.add(o);
					}
				}					
			}

			JSONObject resv = new JSONObject();
			resv.put("BUSI_PLAC_CD", RMSApiService.BUSI_PLAC_CD);
			resv.put("ROOM_KND_GBCD", row.get("room_knd_gbcd"));
//			resv.put("CHRG_GRUP_GBCD", fs.isStaff() ? "710" : "990");
			resv.put("CHRG_GRUP_GBCD", row.get("chrg_grup_gbcd_01"));
			resv.put("CHKI_DATE", param.get("chki_date").replaceAll("\\.", ""));
			resv.put("LODG_CNT", night);
			resv.put("CHOT_DATE", param.get("chot_date").replaceAll("\\.", ""));
			resv.put("ROOM_CNT", 1);
			resv.put("PERS_ADLT", row.getInt("pers_adlt"));
			resv.put("PERS_KIDS", row.getInt("pers_kids"));
			resv.put("GUS_NM", param.get("name"));
			resv.put("PHONO_R", param.get("mobile1") + param.get("mobile2") + param.get("mobile3"));
			resv.put("TAX_YN", "Y");
			resv.put("REM_CNTN", row.get("rem_cntn"));
			resv.put("AMT_COUNT", amtList.size());
			resv.put("AMT_LIST", amtList);

			resvList.add(resv);

			// insert T_HRESERVE_ROOM
			super._insert("HotelReserve.insertRoom", row);
		}
		
		JSONArray payList = new JSONArray();
		if(param.getInt("coupon_amt") != 0) {
			JSONObject o = new JSONObject();
			o.put("PAY_GBCD", "CO");
			o.put("PAY_AMT", param.getInt("coupon_amt"));
			payList.add(o);
		}
		if(param.getInt("promocd_amt") != 0) {
			JSONObject o = new JSONObject();
			o.put("PAY_GBCD", "PC");
			o.put("PAY_AMT", param.getInt("promocd_amt"));
			payList.add(o);
		}
		if(param.getInt("giftcard_amt") != 0) {
			JSONObject o = new JSONObject();
			o.put("PAY_GBCD", "GC");
			o.put("PAY_AMT", param.getInt("giftcard_amt"));
			payList.add(o);
		}
		if(param.getInt("point_amt") != 0) {
			JSONObject o = new JSONObject();
			o.put("PAY_GBCD", "PO");
			o.put("PAY_AMT", param.getInt("point_amt"));
			payList.add(o);
		}
				

		JSONObject json = new JSONObject();
		json.put("BUSES_CD", RMSApiService.BUSES_CD);
		json.put("MEM_NO", fs.getUserNo() + "");
		json.put("PHONO", param.get("mobile1") + param.get("mobile2") + param.get("mobile3"));
		json.put("RESV_PATH_GBCD", RMSApiService.RESV_PATH_GBCD);
		json.put("RESV_RECORD", resvList.size());
		json.put("RESV_LIST", resvList);
		json.put("PAY_COUNT", payList.size());
		json.put("PAY_LIST", payList);
		
		// 쿠폰사용 등록
		if(!"".equals(param.get("mem_couponid"))) {
			super._update("Coupon.useMemCoupon", param.get("mem_couponid"));
		}

		JSONObject res = api.reserve(json);
		if(!"Y".equals(res.get("RESULT").toString())) {
			System.out.println("rms result : " + res.get("MESSAGE"));
			throw new OrderError("RMS 예약에 오류가 발생했습니다. " + res.get("MESSAGE"));
		}
		
		param.set("intg_resv_no", res.get("INTG_RESV_NO"));
		
		try {
			// insert T_HRESERVE
			super._insert("HotelReserve.insert", param);
	
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
				p.set("item_nm", 			"파머스빌리지 객실예약");
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
			
		} catch(Exception e) {
			e.printStackTrace();
			
			res = api.cancel(param);
			System.out.println("---- cancel result : (" + res.get("RESULT") + ") " + res.get("MESSAGE"));
			
			throw new OrderError("예약중 오류가 발생했습니다.");
		}
	}
	
	public Param getHreserveInfo(String orderid) {
		return super._row("HotelReserve.getHreserveInfo", orderid);
	}
	
	public List<Param> getHreserveRoomList(String orderid) {
		return super._list("HotelReserve.getHreserveRoomList", orderid);
	}
	
	public void cancelOrder(Param param) {
		RMSApiService rms = new RMSApiService();
		JSONObject res = rms.cancel(param);
		
		if(!"Y".equals((String) res.get("RESULT"))) {
			System.out.println("cancel result : (" + res.get("RESULT") + ") " + res.get("MESSAGE"));
			throw new OrderError("예약 취소에 오류가 발생했습니다. " + res.get("MESSAGE"));
		}
		
		Param info = super._row("HotelReserve.getHreserveInfoByResno", param.get("intg_resv_no"));
		String orderid = info.get("orderid");

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
	
	public Param getHreserveInfoByResno(String resno) {
		return super._row("HotelReserve.getHreserveInfoByResno", resno);
	}
	
	public void modifySmsyn(String orderid) {
		super._update("HotelReserve.updateSmsyn", orderid);
	}
	
	public Param getDateList(String sdate) {
		Param p = new Param();

		try {
			List<Param> list = super._list("HotelReserve.getDateList", sdate);
			for(Param row : list) {
				p.set(row.get("aply_date"), row.getInt("a") + row.getInt("b") + row.getInt("c") + row.getInt("d") + row.getInt("p") + row.getInt("q") + row.getInt("e"));
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());							
		}		
		
		try {
//			super._update("HotelReserve.closeDBLink", "DBLINK_FARMPRD", IBatisOption.NOLOG);
			super._update("HotelReserve.closeDBLink", "DBLINK_FARMPRD");
		} catch (Exception e) {
			System.out.println(e.getMessage());							
		}		
		
		return p;
	}
	
	
	public String issuePoint(String orderid) {
		Param info = getHreserveInfo(orderid);
		if(!SystemChecker.isLocal() && (info == null || "".equals(info.get("orderid")))) {
			return "INVALID ORDERID";
		}
		
		String intgResvNo = SystemChecker.isLocal() ? "133111" : info.get("intg_resv_no");
		
		Param pointInfo = super._row("Order.getPointLogInfo", new Param("orderid", orderid, "trsc_typ_cd", "210", "trsc_biz_dv_cd", "21")); 
		// 포인트 적립 내역이 없을 경우에만 적립
		if(pointInfo != null && !"".equals(pointInfo.get("orderid"))) {
			return "ALREADY ISSUED";
		}		
		
		RMSApiService rms = new RMSApiService();
		JSONObject json = rms.detail(new Param("intg_resv_no", intgResvNo));
		String result = (String) json.get("RESULT");
		if(result == null || !result.equals("Y")) {
			return "RMS RESULT NOT 'Y'";
		}
		
		JSONArray arr = (JSONArray) json.get("RSV_LIST");
		String resvStGbcd = (String) ((JSONObject) arr.get(0)).get("RESV_ST_GBCD");
		if(resvStGbcd == null || !resvStGbcd.equals("I")) {
			return "RMS RESV_ST_GBCD NOT 'I'" + (resvStGbcd != null ? " ," + resvStGbcd : "");
		}
		
		ImMemberService im = new ImMemberService();
		Param imInfo = im.getInfoById(info.get("userid"));
		if(!SystemChecker.isLocal() && (imInfo == null || "".equals(imInfo.get("unfy_mmb_no")))) {
			return "INVALID IM MEMBER";
		}

		int unfyMmbNo = SystemChecker.isLocal() ? 133176 : imInfo.getInt("unfy_mmb_no");
		int totAmt = info.getInt("tot_amt", 0);
		int dcAmt = info.getInt("coupon_amt", 0) + info.getInt("promocd_amt", 0) + info.getInt("point_amt", 0);
		int tgtAmt = totAmt - dcAmt;
		int acmlPoint = tgtAmt / 100;
		
		Param p = new Param();
		p.set("trsc_biz_dv_cd", "21");
		p.set("trsc_orgn_dv_cd", "10");
		p.set("mmb_cert_dv_cd", "2");
		p.set("mmb_cert_dv_vlu", unfyMmbNo);	
		p.set("tot_sel_amt", info.get("tot_amt"));
		p.set("tot_dc_amt", dcAmt);
		p.set("mbrsh_dc_amt", 0);
		p.set("acml_tgt_amt", tgtAmt);
		p.set("trsc_rsn_cd", "RF01");
		p.set("uniq_rcgn_no", orderid);
		p.set("acml_pint", acmlPoint);
		p.set("rmk", "");
		
		ImMemberService immem = (new ImMemberService()).toProxyInstance();
		json = immem.saveMemberPoint(p);
		
		if(!"00000".equals((String) json.get("RES_CD"))) {
			System.out.println("use point result : (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
			System.out.println("포인트 적립에 오류가 발생했습니다. (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
			return "POINT ISSUE ERROR(" + json.get("RES_CD") + ") " + json.get("RES_MSG");
		}

		// 포인트 로그
		p = new Param();
		p.set("orderid", 		orderid);
		p.set("ship_seq", 		"0");
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

		return "SUCCESS";
	}
}
