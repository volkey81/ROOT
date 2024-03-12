package com.sanghafarm.service.board;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class PopupService extends IbatisService {
	public List<Param> getList(Param param) {
		return super._list("Popup.getList", param);
	}

	public Param getInfo(Param param) {
		return super._row("Popup.getInfo", param); 
	}
}
