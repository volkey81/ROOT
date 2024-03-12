package com.sanghafarm.service.product;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class ExpProductService extends IbatisService {
	
	public List<Param> getExpListByDate(Param param) {
		return super._list("ExpProduct.getExpListByDate", param);
	}
	
	public List<Param> getExpList(Param param) {
		return super._list("ExpProduct.getExpList", param);
	}
	
	public List<Param> getPriceList(String expPid) {
		return super._list("ExpProduct.getPriceList", expPid);
	}
	
	public Integer getPriceInfo(Param param) {
		return (Integer) super._scalar("ExpProduct.getPriceInfo", param);
	}
	
	public Param getInfo(String expPid) {
		return super._row("ExpProduct.getInfo", expPid);
	}
	
	public List<Param> getAllExpListByDate(Param param) {
		return super._list("ExpProduct.getAllExpListByDate", param);
	}

	public List<Param> getSelProductList(Param param) {
		return super._list("ExpProduct.getSelProductList", param);
	}
	
}
