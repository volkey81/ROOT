package com.sanghafarm.service.order;

import java.util.List;

import com.efusioni.stone.annotation.Transactionable;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class CartService extends IbatisService {
	
	public String getNewId() {
		return (String) super._scalar("Cart.getNewId");
	}
	
	public Param getInfo(Param param) {
		return super._row("Cart.getInfo", param);
	}
	
	@Transactionable
	public void create(Param param) {
		super._update("Cart.setOrderYn", new Param("userid", param.get("userid"), "order_yn", "N"));
		
		String[] subPid = param.getValues("sub_pid");
//		String[] qty = param.getValues("qty");
		String[] routineDayArr = param.getValues("routine_day");
		String routineDay = "";
		
		for(int i = 0; i < routineDayArr.length; i++) {
			routineDay += "," + routineDayArr[i];
		}
		
		if(routineDay.length() > 1) routineDay = routineDay.substring(1);
		
		for(int i = 0; i < subPid.length; i++) {
			if(param.getInt("qty_" + subPid[i]) > 0) {
				Param p = new Param(
							"pid", param.get("pid"),
							"sub_pid", subPid[i],
							"qty", param.get("qty_" + subPid[i]),
							"userid", param.get("userid"),
							"order_yn", param.get("order_yn", "N"),
							"routine_yn", param.get("routine_yn", "N"),
							"routine_day", routineDay,
							"routine_cnt", param.get("routine_cnt"),
							"routine_period", param.get("routine_period"),
							"delivery_date", param.get("delivery_date")
						);
	
				super._delete("Cart.deleteByPid", p);
				super._insert("Cart.insert", p);
			}
		}
	}
	
	@Transactionable
	public void modify(Param param) {
		String[] routineDayArr = param.getValues("routine_day");
		String routineDay = "";
		
		for(int i = 0; i < routineDayArr.length; i++) {
			routineDay += "," + routineDayArr[i];
		}
		
		if(routineDay.length() > 1) routineDay = routineDay.substring(1);
		param.set("routine_day", routineDay);
		
		if(!"".equals(param.get("qty_" + param.get("pid")))) {
			param.set("qty", param.get("qty_" + param.get("pid")));
		}
		super._insert("Cart.update", param);
	}
	
	@Transactionable
	public void remove(Param param) {
		String[] cartid = param.getValues("cartid");
		for(String id : cartid) {
			Param p = new Param(
						"cartid", id,
						"userid", param.get("userid")
					);
			super._delete("Cart.delete", p);
		}
	}

	public void removeAll(String userid) {
		super._delete("Cart.deleteAll", userid);
	}
	public void modifyQty(Param param) {
		super._update("Cart.updateQty", param);
	}
	
	public void modifyUserid(Param param) {
		super._update("Cart.updateUserid", param);
	}
	
	public List<Param> getList(Param param) {
		return super._list("Cart.getList", param);
	}
	
	public Integer getListCount(String userid) {
		return getListCount(new Param("userid", userid));
	}
	public List<Param> getAllList(Param param) {
		return super._list("Cart.getAllList", param);
	}
	public Integer getListCount(Param param) {
		return (Integer) super._scalar("Cart.getListCount", param);
	}
	
	public void initCoupon(String userid) {
		super._update("Cart.initCoupon", userid);
	}
	
	@Transactionable
	public void setOrderYn(Param param) {
		Param p = new Param();
		p.set("userid", param.get("userid"));
		p.set("order_yn", "N");
		super._update("Cart.setOrderYn", p);
		
		String[] cartid = param.getValues("cartid");
		for(String cid : cartid) {
			p.set("order_yn", "Y");
			p.set("cartid",  cid);
			super._update("Cart.setOrderYn", p);
		}
	}
	
	public void mergeToCartList(Param param) {
		super._update("Cart.mergeToCartList", param);
	}
	
	public void removeOldDeliveryDate(String userid) {
		super._delete("Cart.deleteOldDeliveryDate", userid);
	}
}
