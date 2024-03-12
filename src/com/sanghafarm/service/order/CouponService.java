package com.sanghafarm.service.order;

import java.util.List;

import com.efusioni.stone.annotation.Transactionable;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class CouponService extends IbatisService {
	
	public List<Param> getDownloadableList(Param param) {
		return super._list("Coupon.getDownloadableList", param);
	}
	
	public List<Param> getApplyableList(Param param) {
		return super._list("Coupon.getApplyableList", param);
	}
	
	public List<Param> getApplyableList2(Param param) {
		return super._list("Coupon.getApplyableList2", param);
	}
	
	public List<Param> getCartApplyableList(Param param) {
		return super._list("Coupon.getCartApplyableList", param);
	}
	
	public Param getInfo(String couponid) {
		return super._row("Coupon.getInfo", couponid);
	}
	
	public Param getInfoByMemCoupon(String memCouponid) {
		return super._row("Coupon.getInfoByMemCoupon", memCouponid);
	}
	
	public List<Param> getApplyProductList(Param param) {
		return super._list("Coupon.getApplyProductList", param);
	}

	public Param getDownloadableInfo(Param param) {
		return super._row("Coupon.getDownloadableInfo", param);
	}
	
	public Param getMemCouponInfo(String memCouponid) {
		return super._row("Coupon.getMemCouponInfo", memCouponid);
	}
	
	public int getDownloadedCnt(Param param) {
		return (int) super._scalar("Coupon.getDownloadedCnt", param);
	}
	
	public void createMemCoupon(Param param) {
		super._insert("Coupon.insertMemCoupon", param);
	}

	@Transactionable
	public void applyCoupon(Param param) {
		super._update("Coupon.resetMemCoupon", param);
		super._update("Coupon.applyMemCoupon", param);
	}
	
	public void cancelCoupon(Param param) {
		super._update("Coupon.cancelMemCoupon", param);
	}
	
	public List<Param> getMemCouponList(Param param) {
		return super._list("Coupon.getMemCouponList", param);
	}
	
	public Integer getMemCouponListCount(Param param) {
		return (Integer) super._scalar("Coupon.getMemCouponListCount", param);
	}

	public Param getCouponSerialInfo(String couponSerial) {
		return super._row("Coupon.getCouponSerialInfo", couponSerial);
	}
	
	@Transactionable
	public void createMemCouponSerial(Param param) {
		super._update("Coupon.setUserCouponSerial", param);
		super._insert("Coupon.insertMemCoupon", param);
	}
	
	public boolean getPromotionCondition1(String userid) {
		Param info = super._row("Coupon.getPromotionCondition1", userid);
		if(info == null || "".equals(info.get("orderid"))) {
			return false;
		} else {
			return true;
		}
	}

	public List<Param> getApplyableList3(Param param) {
		return super._list("Coupon.getApplyableList3", param);
	}
	
	public boolean isApplyableProduct(Param param) {
		List<Param> list = super._list("Coupon.isApplyableProduct", param);
		if(list.size() > 0) return true;
		else return false;
	}
}
