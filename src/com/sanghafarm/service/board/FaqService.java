package com.sanghafarm.service.board;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class FaqService extends IbatisService {

	public Integer getListCount(Param param) {
		return (Integer)super._scalar("Faq.getListCount", param);
	}

	public List<Param> getList(Param param) {
		return super._list("Faq.getList", param);
	}
	
}
