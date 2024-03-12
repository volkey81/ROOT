package com.sanghafarm.service.order;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class OffCouponService extends IbatisService {
	
	public Param getInfo(String couponid) {
		return super._row("OffCoupon.getInfo", couponid);
	}
	
	public Param getInfoByMemCoupon(String memCouponid) {
		return super._row("OffCoupon.getInfoByMemCoupon", memCouponid);
	}
	
	public Param getMemCouponInfo(String memCouponid) {
		return super._row("OffCoupon.getMemCouponInfo", memCouponid);
	}
	
	public void createMemCoupon(Param param) {
		super._insert("OffCoupon.insertMemCoupon", param);
	}

	public void cancelCoupon(Param param) {
		super._update("OffCoupon.cancelMemCoupon", param);
	}
	
	public List<Param> getMemCouponList(Param param) {
		return super._list("OffCoupon.getMemCouponList", param);
	}
	
	public Integer getMemCouponListCount(long unfyMmbNo) {
		return getMemCouponListCount(new Param("unfy_mmb_no", unfyMmbNo));
	}

	public Integer getMemCouponListCount(Param param) {
		return (Integer) super._scalar("OffCoupon.getMemCouponListCount", param);
	}

	public List<Param> getMemUseableCouponList(Param param) {
		return super._list("OffCoupon.getMemUseableCouponList", param);
	}

	public Integer getMemUseableCouponListCount(long unfyMmbNo) {
		return (Integer) super._scalar("OffCoupon.getMemUseableCouponListCount", unfyMmbNo);
	}

	public void useMemCoupon(String memCouponid) {
		super._update("OffCoupon.useMemCoupon", memCouponid);
	}

	public void resetMemCoupon(String memCouponid) {
		super._update("OffCoupon.resetMemCoupon", memCouponid);
	}
	
	public List<Param> getDownloadableList(Param param) {
		return super._list("OffCoupon.getDownloadableList", param);
	}

	public Param getDownloadableInfo(Param param) {
		return super._row("OffCoupon.getDownloadableInfo", param);
	}
	
	public Integer getUsedCount(Param param) {
		return (Integer) super._scalar("OffCoupon.getUsedCount", param);
	}
}
