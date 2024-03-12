package com.sanghafarm.service.hotel;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class HotelPromocdService extends IbatisService {
	public Param getInfo(Param param) {
		return super._row("HotelPromocd.getInfo", param);
	}
}
