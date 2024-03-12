package com.sanghafarm.service.hotel;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class HotelMainService extends IbatisService {
	
	public List<Param> getList(Param param){
		return super._list("HotelMain.getList", param); 
	}
	
}
