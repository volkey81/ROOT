package com.sanghafarm.service.member;

import java.util.List;

import org.json.simple.JSONObject;

import com.efusioni.stone.annotation.Transactionable;
import com.efusioni.stone.common.SystemChecker;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;
import com.sanghafarm.service.order.CouponService;

public class FamilyMemberService extends IbatisService {
	public List<Param> getList(Param param) {
		return super._list("FamilyMember.getList", param);
	}
	
	public Param getInfo(long unfyMmbNo) {
		return super._row("FamilyMember.getInfo", unfyMmbNo);
	}
	
	@Transactionable
	public void offJoin(Param param) {
		super._insert("FamilyMember.insert", param);
		
		// 쿠폰발급
		createCoupon(param.getLong("unfy_mmb_no"), param.get("benefit_type"));
	}
	
	@Transactionable
	public int offCancel(Param param) {
		int row = (int) super._update("FamilyMember.cacel", param);
		
		// 쿠폰 취소
		removeCoupon(param.getLong("unfy_mmb_no"));
		
		return row;
	}
	
	@Transactionable
	public void createCoupon(long unfyMmbNo, String benefitType) {
		/*
		Param info = super._row("ImMember.getInfo", (new Long(unfyMmbNo)).intValue());
		String userid = !"".equals(info.get("mmb_id")) ? info.get("mmb_id") : info.get("unfy_mmb_no") + "_" + info.get("soc_kind_cd");

		List<Param> list = super._list("FamilyMember.getCouponList", benefitType);
		
		for(Param row : list) {
			for(int i = 0; i < row.getInt("cnt"); i++) {
				if("1".equals(row.get("benefit_type"))) {	// on-line
					super._insert("Coupon.insertMemCoupon", new Param("userid", userid, "couponid", row.get("couponid")));
				} else {	// off-line
					super._insert("OffCoupon.insertMemCoupon", new Param("unfy_mmb_no", unfyMmbNo, "couponid", row.get("couponid")));
				}
			}
		}
		*/
		
		String couponid = SystemChecker.isReal() ? "2017113015354971117" : "2017110217175095548";
		for(int i = 0; i < 5; i++) {
			super._insert("OffCoupon.insertMemCoupon", new Param("unfy_mmb_no", unfyMmbNo, "couponid", couponid));
		}
	}
	
	@Transactionable
	public void removeCoupon(long unfyMmbNo) {
		Param info = super._row("ImMember.getInfo", (new Long(unfyMmbNo)).intValue());
		String userid = !"".equals(info.get("mmb_id")) ? info.get("mmb_id") : info.get("unfy_mmb_no") + "_" + info.get("soc_kind_cd");

		List<Param> list = super._list("FamilyMember.getCouponList", null);

		for(Param row : list) {
			if("1".equals(row.get("benefit_type"))) {	// on-line
				super._delete("Coupon.removeMemCoupon", new Param("userid", userid, "couponid", row.get("couponid")));
			} else {	// off-line
				super._delete("OffCoupon.removeMemCoupon", new Param("unfy_mmb_no", unfyMmbNo, "couponid", row.get("couponid")));
			}
		}
	}
	
	public void onJoin(Param param) {
		onJoin(param, null);
	}

	@Transactionable
	public void onJoin(Param param, Param payInfo) {
		CouponService coupon = (new CouponService()).toProxyInstance();
		int totAmt = param.getInt("tot_amt");
		int couponAmt = 0;
		
		// 쿠폰
		if(!"".equals(param.get("mem_couponid"))) {
			Param c = coupon.getMemCouponInfo(param.get("mem_couponid"));
			if("A".equals(c.get("sale_type"))) {	//  정량
				couponAmt = c.getInt("sale_amt");
			} else {	// 정률
				couponAmt = (c.getInt("max_sale") <= (totAmt * c.getInt("sale_amt") / 100)) ? 
						c.getInt("max_sale") : (totAmt * c.getInt("sale_amt") / 100);
			}

			super._update("Coupon.useMemCoupon", param.get("mem_couponid"));
		}

		param.set("grade_code", "004");
		param.set("coupon_amt", couponAmt);
		super._insert("FamilyMember.insertJoin", param);
		int seq = (Integer) super._insert("FamilyMember.insert", param);
		param.set("seq", seq);
		param.set("email", param.get("email1") + "@" + param.get("email2"));
		super._insert("FamilyMember.insertWgAddr", param);
		
		if("010".equals(param.get("pay_type"))) {	// 쿠폰 사용처리
			super._update("Coupon.setUseDateCouponSerial", param.get("coupon_serial"));
		}
		
		// 쿠폰발급
		createCoupon(param.getLong("unfy_mmb_no"), param.get("benefit_type"));
		
		if(payInfo != null) {	// LGD 로그
			if("005".equals(param.get("pay_type"))) {	// 카카오페이
				super._insert("Order.insertKakaoPayLog", payInfo);
			} else if("006".equals(param.get("pay_type"))) {	// 페이코
				super._insert("Order.insertPaycoLog", payInfo);
			} else {
				super._insert("Order.insertLgdPaymentLog", payInfo);
			}
		}
		
		// 추천인 포인트 3000 지급 -> 2018.02.28 5000 으로 변경
		if(!"".equals(param.get("recommender"))) {
			// 선물하기 제외, 본인 추천 제외
			if(!"4".equals(param.get("path")) && !param.get("unfy_mmb_no").equals(param.get("recommender"))) {
				Param p = new Param();
				p.set("trsc_biz_dv_cd", "21");
				p.set("trsc_orgn_dv_cd", "10");
				p.set("mmb_cert_dv_cd", "2");
				p.set("mmb_cert_dv_vlu", param.get("recommender"));	
				p.set("tot_sel_amt", "30000");
				p.set("tot_dc_amt", "0");
				p.set("mbrsh_dc_amt", 0);
				p.set("acml_tgt_amt", "30000");
				p.set("trsc_rsn_cd", "RF11");
				p.set("uniq_rcgn_no", param.get("orderid"));
				p.set("acml_pint", "5000");	// 2018.02.28 3000 -> 5000 으로 변경
				p.set("pint_acml_typ_cd", "20");
				p.set("rmk", "");
				
				ImMemberService immem = (new ImMemberService()).toProxyInstance();
				JSONObject json = immem.saveMemberPoint(p);
				
				// 포인트 로그
				p = new Param();
				p.set("orderid", 		param.get("orderid"));
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

				if(!"00000".equals((String) json.get("RES_CD"))) {
					System.out.println("use point result : (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
//					throw new OrderError("포인트 적립에 오류가 발생했습니다. (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
				}
			}
		}

		/* 결제수단 저장 */
		try {
			super._update("Member.updatePayType", 
						 	new Param("userid", param.get("userid"), 
									  "pay_type", "Y".equals(param.get("save_pay_type")) ? param.get("pay_type") : "001"));
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getNewId() {
		return (String) super._scalar("FamilyMember.getNewId");
	}
}
