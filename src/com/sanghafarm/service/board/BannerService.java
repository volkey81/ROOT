package com.sanghafarm.service.board;

import java.util.List;

import com.efusioni.stone.annotation.Nolog;
import com.efusioni.stone.ibatis.IBatisOption;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class BannerService extends IbatisService {
	
	@Nolog
	public List<Param> getList(Param param){
		return super._list("Banner.getList", param, IBatisOption.NOLOG); 
	}
	
}
