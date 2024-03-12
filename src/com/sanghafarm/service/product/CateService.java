package com.sanghafarm.service.product;

import java.util.List;

import com.efusioni.stone.annotation.Nolog;
import com.efusioni.stone.ibatis.IBatisOption;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class CateService extends IbatisService {

	@Nolog
	public List<Param> getAllTreeList() {  
		return super._list("Cate.getAllTreeList", IBatisOption.NOLOG);
	}
	
	@Nolog
	public List<Param> get1DepthTreeList(Param param) {  
		return super._list("Cate.get1DepthTreeList", param, IBatisOption.NOLOG);
	}
	
	@Nolog
	public List<Param> get1DepthList(Param param) {
		return super._list("Cate.get1DepthList", param, IBatisOption.NOLOG);
	}
	
	@Nolog
	public List<Param> getSubDepthList(Param param) {
		return super._list("Cate.getSubDepthList", param, IBatisOption.NOLOG);
	}
	
	@Nolog
	public List<Param> getSiblingDepthList(Param param) {
		return super._list("Cate.getSiblingDepthList", param, IBatisOption.NOLOG);
	}
	
	@Nolog
	public Param getInfo(int cateSeq) {
		return super._row("Cate.getInfo", cateSeq, IBatisOption.NOLOG);
	}
	
	@Nolog
	public Param getLocationPath(Param param) {
		return super._row("Cate.getLocationPath", param, IBatisOption.NOLOG);
	}
	
	@Nolog
	public List<Param> getSubList(Param param) {
		return super._list("Cate.getSubList", param, IBatisOption.NOLOG);
	}
	
	@Nolog
	public String getPath(int cateSeq) {
		return (String)super._scalar("Cate.getPath", cateSeq, IBatisOption.NOLOG);
	}
	
}