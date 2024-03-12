package com.sanghafarm.service.common;

import com.efusioni.stone.annotation.Nolog;
import com.efusioni.stone.ibatis.IBatisOption;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class SqlTraceService extends IbatisService {
	@Nolog
	public void trace(Param param) {
		super._insert("SqlTrace.insert", param, IBatisOption.NOLOG);
	}
}
