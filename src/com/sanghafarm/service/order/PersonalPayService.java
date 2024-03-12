package com.sanghafarm.service.order;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.efusioni.stone.annotation.Transactionable;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;
import com.sanghafarm.common.FrontSession;

public class PersonalPayService extends IbatisService {
	
	public List<Param> getList(Param param) {
		return super._list("PersonalPay.getList", param);
	}
	
	public Integer getListCount() {
		return (Integer) super._scalar("PersonalPay.getListCount");
	}
	
	public Param getInfo(String orderid) {
		return super._row("PersonalPay.getInfo", orderid);
	}
	
	public void pay(HttpServletRequest request, HttpServletResponse response) throws Exception {
		pay(request, response, null);
	}

	@Transactionable
	public void pay(HttpServletRequest request, HttpServletResponse response, Param payInfo) throws Exception {
		Param param = new Param(request);
		FrontSession fs = FrontSession.getInstance(request, response);
		
		param.set("regist_user", fs.getUserId());
		param.set("status", "120");
		param.set("ship_seq", "1");
		super._update("PersonalPay.updateStatus", param);
		super._insert("Order.insertStatusLog", param);
		
		if(payInfo != null) {	// LGD 로그
			if("005".equals(param.get("pay_type"))) {	// 카카오페이
				super._insert("Order.insertKakaoPayLog", payInfo);
			} else if("006".equals(param.get("pay_type"))) {	// 페이코
				super._insert("Order.insertPaycoLog", payInfo);
			} else {
				super._insert("Order.insertLgdPaymentLog", payInfo);
			}
		}
	}
}
