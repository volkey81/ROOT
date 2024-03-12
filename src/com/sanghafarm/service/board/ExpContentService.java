package com.sanghafarm.service.board;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class ExpContentService extends IbatisService {
	
	public List<Param> getList(Param param){
		return super._list("ExpContent.getList", param); 
	}
	
	public Integer getListCount(Param param){
		return (Integer) super._scalar("ExpContent.getListCount", param); 
	}
	
	public Param getInfo(String seq) {
		return super._row("ExpContent.getInfo", seq);
	}
	
	public List<Param> getListByDate(String date) {
		return super._list("ExpContent.getListByDate", date);
	}
	
	public List<Param> getAreaList(String seq) {
		return super._list("ExpContent.getAreaList", seq);
	}
	
	public List<Param> getListByTime(String date) {
		return super._list("ExpContent.getListByTime", date);
	}
	
	public List<Param> getListByDateOrderNM(Param param) {
		return super._list("ExpContent.getListByDateOrderNM", param);
	}
	
}
