<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.security.*,
			com.sanghafarm.service.order.*,
			com.sanghafarm.service.api.*,
			com.sanghafarm.utils.*,
			org.json.simple.*" %><%
	Param param = new Param(request);
	JSONObject req = new JSONObject();
	JSONObject res = new JSONObject();
	try {
		String s = SecurityUtils.decodeAES(param.get("q"));
		
		req = (JSONObject)JSONValue.parse(s.trim());
		String memCouponid = (String) req.get("MEM_COUPONID");
		String timestamp = (String) req.get("TIMESTAMP");
	
		if(!SanghafarmUtils.isValidApiParameter(timestamp)) {	// 파라미터 유효기간 만료
			res.put("RESULT", false);
			res.put("MESSAGE", "파라미터 오류 - 유효기간 만료");
		} else if("".equals(memCouponid)) {
			res.put("RESULT", false);
			res.put("MESSAGE", "파라미터 오류 - 쿠폰아이디");
		} else {
			OffCouponService svc =(new OffCouponService()).toProxyInstance();
			Param info = svc.getMemCouponInfo(memCouponid);

			if(!"Y".equals(info.get("available"))) {
				svc.resetMemCoupon(memCouponid);
				
				res.put("RESULT", true);
				res.put("MESSAGE", "취소처리 완료");
			} else {
				res.put("RESULT", false);
				res.put("MESSAGE", "사용 가능한 쿠폰입니다.");
			}
		}
	} catch(Exception e) {
		e.printStackTrace();
		res.put("RESULT", false);
		res.put("MESSAGE", e.getMessage());
	}
	
	try {
		PosApiService api = (new PosApiService()).toProxyInstance();
		api.createLog(new Param("uri", request.getRequestURI(),
								"parameter", param.get("q"),
								"request", req.toString(),
								"response", res.toString()));	
	} catch(Exception e) {
		e.printStackTrace();
	}
	
	System.out.println(req.toString());
	System.out.println(res.toString());
	String s = SecurityUtils.encodeAES(res.toString());
	response.setContentLength(s.length());
	out.println(s);
%>