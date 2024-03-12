package com.sanghafarm.service.brand;

import java.util.List;

import com.efusioni.stone.annotation.Nolog;
import com.efusioni.stone.ibatis.IBatisOption;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class CraftSchService extends IbatisService {
	public Param getInfo(String craft) {
		return super._row("CraftSch.getInfo", craft);
	}
	
	public List<Param> getList() {
		return super._list("Code.getList1");
	}
	
	@Nolog
	public List<Param> getList2(String code1) {
		return super._list("Code.getList2", code1, IBatisOption.NOLOG);
	}
	
}
