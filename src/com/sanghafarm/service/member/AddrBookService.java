package com.sanghafarm.service.member;

import java.util.List;

import com.efusioni.stone.annotation.Transactionable;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class AddrBookService extends IbatisService {
	
	public List<Param> getList(Param param) {
		return super._list("AddrBook.getList", param);
	}
	
	public Integer getListCount(Param param) {
		return (Integer) super._scalar("AddrBook.getListCount", param);
	}
	
	public Param getInfo(Param param) {
		return super._row("AddrBook.getInfo", param); 
	}
	
	public Param getDefaultInfo(String userid) {
		return super._row("AddrBook.getDefaultInfo", userid); 
	}
	
	public Param getLatestInfo(String userid) {
		return super._row("AddrBook.getLatestInfo", userid); 
	}
	
	public void create(Param param) {
		super._insert("AddrBook.insert", param);
	}
	
	public void modify(Param param) {
		super._update("AddrBook.update", param);
	}
	
	public void remove(Param param) {
		super._update("AddrBook.delete", param);
	}

	@Transactionable
	public void modifyDefault(Param param) {
		Param p = new Param(
					"userid", param.get("userid"),
					"default_yn", "N"
				);
		super._update("AddrBook.updateDefault", p);
		
		param.set("default_yn",  "Y");
		super._update("AddrBook.updateDefault", param);
	}
}
