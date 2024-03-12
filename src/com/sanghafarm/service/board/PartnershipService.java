package com.sanghafarm.service.board;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class PartnershipService extends IbatisService {
	
	public void create(Param param) {
		super._insert("Partnership.insert", param);
	}
}
