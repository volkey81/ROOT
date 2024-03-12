<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.order.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	CouponService coupon = (new CouponService()).toProxyInstance();

	param.set("userid", fs.getUserId());
	param.set("device_type", fs.getDeviceType());
	param.set("grade_code", fs.getGradeCode());
	param.set("coupon_type", "006");
	List<Param> couponList = coupon.getApplyableList2(param);
	if(couponList == null || couponList.size() == 0) {
%>
	<option value="">적용 가능한 쿠폰이 없습니다.</option>
<%
	} else {
%>
	<option value="">쿠폰을 선택하세요.</option>
<%
		for(Param r : couponList) {
%>
	<option value="<%= r.get("mem_couponid") %>|<%= r.get("sale_type") %>|<%= r.get("sale_amt") %>|<%= r.get("max_sale") %>|<%= r.get("min_price") %>|<%= r.get("coupon_name") %>"><%= r.get("coupon_name") %></option>
<%
		}
	}
%>
