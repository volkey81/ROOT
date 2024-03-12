<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.order.*,
			com.sanghafarm.utils.*" %>
<%
	boolean isOk = false;
	
	if(isOk) {
		String[] s = {
		};
		
		CouponService coupon = (new CouponService()).toProxyInstance();
		
		for(String id : s) {
			coupon.createMemCoupon(new Param("userid", id, "couponid", "2019070215441223959"));
		}
	}
	
	response.sendRedirect("/");
%>
