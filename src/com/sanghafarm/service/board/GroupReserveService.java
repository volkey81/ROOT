package com.sanghafarm.service.board;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class GroupReserveService extends IbatisService {
	
	public void create(Param param) {
		super._insert("GroupReserve.insert", param); 
	}
	
}
