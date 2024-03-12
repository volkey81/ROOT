package com.sanghafarm.service.promotion;

import java.util.ArrayList;
import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class SecondAnniversaryService extends IbatisService {

	public Param getInfo() {
		return super._row("SecondAnniversary.getInfo");
	}
	
	public List<String> getProductList(long seq) {
		List<Param> list = super._list("SecondAnniversary.getProductList", seq);
		List<String> l = new ArrayList<String>();
		
		for(Param row : list) {
			l.add(row.get("pid"));
		}
		
		return l;
	}
	
	public List<Param> getOrderList(Param param) {
		return super._list("SecondAnniversary.getOrderList", param);
	}
}
