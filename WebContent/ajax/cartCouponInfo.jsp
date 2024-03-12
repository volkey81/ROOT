<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.order.*,
			com.google.gson.*"%>
<%
	Param param = new Param(request);
	CouponService coupon = (new CouponService()).toProxyInstance();
	
	Param info = coupon.getInfoByMemCoupon(param.get("mem_couponid"));
	List<Param> list = coupon.getApplyProductList(new Param("couponid", info.get("couponid"), "ie_code", "E"));
	info.set("EXCLUDE", list);
	
	out.println(new Gson().toJson(info));
// 	System.out.println(new Gson().toJson(info));
%>
