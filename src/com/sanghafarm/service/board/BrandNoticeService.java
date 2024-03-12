package com.sanghafarm.service.board;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class BrandNoticeService extends IbatisService {
	public Integer getListCount(Param param) {
		return (Integer)super._scalar("BrandNotice.getListCount", param);
	}

	public List<Param> getList(Param param) {
		return super._list("BrandNotice.getList", param);
	}
	
	public Param getInfo(Param param) {
		return super._row("BrandNotice.getInfo", param); 
	}
	
	public Param getPrevInfo(Param param) {
		return super._row("BrandNotice.getPrevInfo", param); 
	}
	
	public Param getNextInfo(Param param) {
		return super._row("BrandNotice.getNextInfo", param); 
	}
	
	public void modifyHit(Param param) {
		super._update("BrandNotice.updateHit", param);
	}
}
