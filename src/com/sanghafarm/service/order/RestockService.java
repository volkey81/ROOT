package com.sanghafarm.service.order;

import com.efusioni.stone.annotation.Transactionable;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class RestockService extends IbatisService {
	
	@Transactionable
	public void create(Param param) {
		String[] pid = param.getValues("pid");
		for(int i = 0; i < pid.length; i++) {
			Param p = new Param();
			p.set("pid", pid[i]);
			p.set("name", param.get("name"));
			p.set("mobile", param.get("mobile"));
			super._update("Restock.insert", p);
		}
	}
	
	
}
