package com.sanghafarm.service.brand;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class ExpClassService extends IbatisService {
	
	public Integer getListCount(Param param) {
		return (Integer)super._scalar("ExpClass.getListCount", param);
	}

	public List<Param> getList(Param param) {
		return super._list("ExpClass.getList", param);
	}
	
	public Param getInfo(int seq) {
		return super._row("ExpClass.getInfo", seq); 
	}
}
