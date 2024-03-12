<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.order.*" %>
<%
	boolean result = false;
	String msg = null;

	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		msg = FrontSession.LOGIN_MSG;
	} else {
		Param param = new Param(request);
		param.set("userid", fs.getUserId());
		
		CouponService svc = (new CouponService()).toProxyInstance();
		String serial = param.get("coupon_serial");
		if(serial.length() == 16) {
			serial = serial.substring(0, 4) + "-" + serial.substring(4, 8) + "-" + serial.substring(8, 12) + "-" + serial.substring(12, 16);
			param.set("coupon_serial", serial);
		}
		
		Param info = svc.getCouponSerialInfo(serial);
		if(info == null || "".equals(info.get("couponid"))) {
			msg = "쿠폰번호를 정확히 입력하세요.";
		} else if(!"".equals(info.get("userid"))) {
			msg = "이미 등록된 쿠폰입니다.";
		} else {
			param.set("couponid", info.get("couponid"));
			svc.createMemCouponSerial(param);
			result = true;
			msg = "등록되었습니다.";
		}
		
	}
%>
{"result" : <%= result %>, "msg" : "<%=msg %>"}