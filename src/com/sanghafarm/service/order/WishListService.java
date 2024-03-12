package com.sanghafarm.service.order;

import java.util.List;

import com.efusioni.stone.annotation.Transactionable;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class WishListService extends IbatisService {
	
	public void create(Param param) {
		super._update("WishList.merge", param);
	}
	
	@Transactionable
	public void createFormCart(Param param) {
		String[] cartids = param.getValues("cartid");
		for(String cartid : cartids) {
			Param p = new Param(
						"userid", param.get("userid"),
						"cartid", cartid
					);
			super._update("WishList.mergeFromCart", p);
		}
	}

	public void remove(Param param) {
		String[] pids = param.getValues("pid");
		for(String pid : pids) {
			Param p = new Param(
						"userid", param.get("userid"),
						"pid", pid
					);
			super._delete("WishList.delete", p);
		}
	}
	
	public Integer getListCount(Param param) {
		return (Integer)super._scalar("WishList.getListCount", param);
	}

	public List<Param> getList(Param param) {
		return super._list("WishList.getList", param);
	}
	
}
