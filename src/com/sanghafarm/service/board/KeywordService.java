package com.sanghafarm.service.board;

import java.util.List;

import com.efusioni.stone.annotation.Nolog;
import com.efusioni.stone.ibatis.IBatisOption;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class KeywordService extends IbatisService {
	
	@Nolog
	public List<Param> getList(Param param) {
		return super._list("Keyword.getList", param, IBatisOption.NOLOG);
	}
	@Nolog
	public int getListCount(Param param) {
		return (Integer) super._scalar("Keyword.getListCount", param, IBatisOption.NOLOG);
	}
	
	@Nolog
	public void create(Param param) {
		super._insert("Keyword.insert", param, IBatisOption.NOLOG);
	}
	
	@Nolog
	public void modify(Param param) {
		super._update("Keyword.update", param, IBatisOption.NOLOG);
	}
	
	@Nolog
	public void remove(int seq) {
		super._delete("Keyword.delete", seq, IBatisOption.NOLOG);
	}

	public List<Param> getMemKeywordList(long unfyMmbNo) {
		return super._list("Keyword.getMemKeywordList", unfyMmbNo);
	}
	
	public void createMemKeyword(Param param) {
		super._update("Keyword.mergeMemKeyword", param);
	}
	
	public void removeMemKeyword(Param param) {
		super._delete("Keyword.deleteMemKeyword", param);
	}
}
