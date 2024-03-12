package com.sanghafarm.service.board;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class FarmerMenuService extends IbatisService {
	
	public Param getInfo(Param param) {
		return super._row("FarmerMenu.getInfo", param);
	}
	
	public List<Param> getList(Param param){
		return super._list("FarmerMenu.getList", param); 
	}
	
	public Integer getListCount(Param param){
		return (Integer)super._scalar("FarmerMenu.getListCount", param);
	}
	
	public List<Param> getProductList(String seq){
		return getProductList(new Param("seq", seq));
	}

	public List<Param> getProductList(Param param){
		return super._list("FarmerMenu.getProductList", param);
	}

	public Param getPrevInfo(Param param) {
		return super._row("FarmerMenu.getPrevInfo", param); 
	}
	
	public Param getNextInfo(Param param) {
		return super._row("FarmerMenu.getNextInfo", param); 
	}
	
	public void modifyHit(Param param) {
		super._update("FarmerMenu.updateHit", param);
	}
}
