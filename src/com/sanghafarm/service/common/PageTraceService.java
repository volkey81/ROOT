package com.sanghafarm.service.common;

import com.efusioni.stone.annotation.Nolog;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class PageTraceService extends IbatisService {
	@Nolog
	public void trace(Param param) {
		param.set("sessionid", cut(param.get("sessionid"), 200));
		param.set("uri", cut(param.get("uri"), 300));
		param.set("user_agent", cut(param.get("user_agent"), 200));
		param.set("cookie", cut(param.get("cookie").replaceAll("p=[a-zA-Z0-9\\%\\/=\\|]*;\\s*", ""), 4000));
		param.set("stack", cut(param.get("stack"), 4000));

		super._insert("PageTrace.insert", param);
	}
	
	private String cut(String str, int length) {
		if (str.length() > length) {
			return str.substring(0, length);
		}
		else return str;
	}
}
