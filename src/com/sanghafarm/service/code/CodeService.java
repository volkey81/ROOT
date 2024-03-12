package com.sanghafarm.service.code;

import java.util.List;

import com.efusioni.stone.annotation.Nolog;
import com.efusioni.stone.ibatis.IBatisOption;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class CodeService extends IbatisService {
	public Param getInfo1(String code1) {
		return super._row("Code.getInfo1", code1);
	}
	
	public Param getInfo2(Param param) {
		return super._row("Code.getInfo2", param);
	}
	
	public String getCode2Name(String code1, String code2){
		return getCode2Name(new Param("code1", code1, "code2", code2));
	}
	
	public String getCode2Name(Param param){
		return (String)super._scalar("Code.getCode2Name", param);
	}
	
	public List<Param> getList1() {
		return super._list("Code.getList1");
	}
	
	@Nolog
	public List<Param> getList2(String code1) {
		return super._list("Code.getList2", code1, IBatisOption.NOLOG);
	}
	
}
