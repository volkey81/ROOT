package com.sanghafarm.service.hotel;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class HotelPromotionService extends IbatisService {
	public Integer getListCount(Param param) {
		return (Integer)super._scalar("HotelPromotion.getListCount", param);
	}

	public List<Param> getList(Param param) {
		return super._list("HotelPromotion.getList", param);
	}
	
	public Param getInfo(Param param) {
		return super._row("HotelPromotion.getInfo", param); 
	}
	
	public void modifyHit(Param param) {
		super._update("HotelPromotion.updateHit", param);
	}
}
