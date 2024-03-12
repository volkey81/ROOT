<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.order.*,
			com.google.gson.*"%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	CouponService coupon = (new CouponService()).toProxyInstance();
	CartService cart = (new CartService()).toProxyInstance();
	
	Param info = coupon.getInfoByMemCoupon(param.get("mem_couponid"));
	
	param.set("userid", fs.getUserId());
	
	param.set("grade_code", fs.getGradeCode());
	param.set("order_yn", "Y");
	
	// 일반상품
	param.set("routine_yn", "N");
	param.set("ptype", "A");
	List<Param> list1 = cart.getList(param);
	
	// 산지직송 상품
	param.set("ptype", "C");
	List<Param> list2 = cart.getList(param);

	// 정기구매
	param.set("routine_yn", "Y");
	param.remove("ptype");
	List<Param> list3 = cart.getList(param);

	// 배송일 지정 상품
	param.set("routine_yn", "N");
	param.set("ptype", "D");
	List<Param> list4 = cart.getList(param);

	int couponAmt = 0;
	int totalAmt = 0;
	
	if("001".equals(info.get("coupon_type"))) {
		Param p = new Param();
		p.set("userid", fs.getUserId());
		p.set("device_type", fs.getDeviceType());
		p.set("grade_code", fs.getGradeCode());
		p.set("mem_couponid", param.get("mem_couponid"));

		for(Param row : list1) {
			p.set("pid", row.get("sub_pid"));
			if(coupon.isApplyableProduct(p)) {
				int amt = row.getInt("sale_price") * row.getInt("qty");
				totalAmt += amt;
			}
		}
		
		for(Param row : list2) {
			p.set("pid", row.get("sub_pid"));
			if(coupon.isApplyableProduct(p)) {
				int amt = row.getInt("sale_price") * row.getInt("qty");
				totalAmt += amt;
			}
		}
		
		for(Param row : list3) {
			p.set("pid", row.get("sub_pid"));
			if(coupon.isApplyableProduct(p)) {
				int routineSaleAmt = 0;
				int price = row.getInt("sale_price") * row.getInt("qty") * row.getInt("routine_cnt");

				if("A".equals(row.get("routine_sale_type"))) {
					routineSaleAmt = row.getInt("routine_sale_amt") * row.getInt("qty") * row.getInt("routine_cnt");
				} else {
					routineSaleAmt = row.getInt("sale_price") * row.getInt("qty") * row.getInt("routine_cnt") * row.getInt("routine_sale_amt") / 100;
				}
				
				int amt = price - routineSaleAmt;
				totalAmt += amt;
			}
		}
		
		for(Param row : list4) {
			p.set("pid", row.get("sub_pid"));
			if(coupon.isApplyableProduct(p)) {
				int amt = row.getInt("sale_price") * row.getInt("qty");
				totalAmt += amt;
			}
		}

		if(totalAmt >= info.getInt("min_price")) {
			if("A".equals(info.get("sale_type"))) {	// 정액
				couponAmt = totalAmt > info.getInt("sale_amt") ? info.getInt("sale_amt") : totalAmt;
			} else {
				couponAmt = totalAmt * info.getInt("sale_amt") / 100;
				couponAmt = couponAmt > info.getInt("max_sale") ? info.getInt("max_sale") : couponAmt;
				couponAmt = couponAmt > totalAmt ? totalAmt : couponAmt;
			}
		}
	} else if("003".equals(info.get("coupon_type"))) {
		// 배송비 계산 -----------------
		int totalPrice1 = 0;
		for(Param row : list1) {
			totalPrice1 += row.getInt("sale_price") * row.getInt("qty");
		}
		int shipAmt1 = totalPrice1 == 0 ? 0 : (totalPrice1 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt"));
		
		int totalPrice2 = 0;
		for(Param row : list2) {
			totalPrice2 += row.getInt("sale_price") * row.getInt("qty");
		}
		int shipAmt2 = totalPrice2 == 0 ? 0 : (totalPrice2 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt"));
	
		int totalPrice4 = 0;
		for(Param row : list4) {
			totalPrice4 += row.getInt("sale_price") * row.getInt("qty");
		}
		int shipAmt4 = totalPrice4 == 0 ? 0 : (totalPrice4 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt"));
		
		int shipAmt = shipAmt1 + shipAmt2 + shipAmt4;
// 	 	System.out.println("---------------- shipAmt : " + shipAmt);
		//-----------------------------------------

		if("A".equals(info.get("sale_type"))) {	// 정액
			couponAmt = shipAmt > info.getInt("sale_amt") ? info.getInt("sale_amt") : shipAmt;
		} else {
			couponAmt = shipAmt * info.getInt("sale_amt") / 100;
			couponAmt = couponAmt > info.getInt("max_sale") ? info.getInt("max_sale") : couponAmt;
			couponAmt = couponAmt > shipAmt ? shipAmt : couponAmt;
		}
	}
	
	
	
	info.set("COUPON_AMT", couponAmt);
	
	out.println(new Gson().toJson(info));
// 	System.out.println(new Gson().toJson(info));
%>
