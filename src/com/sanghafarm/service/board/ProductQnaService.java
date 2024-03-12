package com.sanghafarm.service.board;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class ProductQnaService extends IbatisService {
	public void create(Param param) {
		super._insert("ProductQna.insert", param);
	}
	
	public Integer getListCount(Param param) {
		return (Integer)super._scalar("ProductQna.getListCount", param);
	}

	public List<Param> getList(Param param) {
		return super._list("ProductQna.getList", param);
	}
}
