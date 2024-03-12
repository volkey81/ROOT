package com.sanghafarm.service.board;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class NoticeService extends IbatisService {
	public Integer getListCount(Param param) {
		return (Integer)super._scalar("Notice.getListCount", param);
	}

	public List<Param> getList(Param param) {
		return super._list("Notice.getList", param);
	}
	
	public Param getInfo(Param param) {
		return super._row("Notice.getInfo", param); 
	}
	
	public Param getPrevInfo(Param param) {
		return super._row("Notice.getPrevInfo", param); 
	}
	
	public Param getNextInfo(Param param) {
		return super._row("Notice.getNextInfo", param); 
	}
	
	public void modifyHit(Param param) {
		super._update("Notice.updateHit", param);
	}
}
