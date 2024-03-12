package com.sanghafarm.service.hotel;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class HotelNoticeService extends IbatisService {
	public Integer getListCount(Param param) {
		return (Integer)super._scalar("HotelNotice.getListCount", param);
	}

	public List<Param> getList(Param param) {
		return super._list("HotelNotice.getList", param);
	}
	
	public Param getInfo(Param param) {
		return super._row("HotelNotice.getInfo", param); 
	}
	
	public Param getPrevInfo(Param param) {
		return super._row("HotelNotice.getPrevInfo", param); 
	}
	
	public Param getNextInfo(Param param) {
		return super._row("HotelNotice.getNextInfo", param); 
	}
	
	public void modifyHit(Param param) {
		super._update("HotelNotice.updateHit", param);
	}
}
