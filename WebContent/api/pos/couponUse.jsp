<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.security.*,
			com.sanghafarm.service.order.*,
			com.sanghafarm.service.api.*,
			com.sanghafarm.service.member.*,
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

			boolean isOK = true;
			if("Y".equals(info.get("available"))) {
				String couponid = SystemChecker.isReal() ? "2017113015354971117" : "2017110217175095548";
				if(couponid.equals(info.get("couponid"))) {	// 무료입장쿠폰
					FamilyMemberService family = (new FamilyMemberService()).toProxyInstance();
					Param familyInfo = family.getInfo(info.getLong("unfy_mmb_no"));
					
					if("004".equals(familyInfo.get("family_grade_code"))) {
						info.set("gb", "notoday");
						int cnt = svc.getUsedCount(info);
						
						if(cnt == 0) {
							info.set("gb", "today");
							cnt = svc.getUsedCount(info);
							if(cnt >= 2) {
								res.put("RESULT", false);
								res.put("MESSAGE", "하루 사용 한도 초과");
								isOK = false;
							}
						}
					}
				}
			} else {
				res.put("RESULT", false);
				res.put("MESSAGE", "사용 불가능 쿠폰");
			}
			
			if(isOK) {
				svc.useMemCoupon(memCouponid);
				res.put("RESULT", true);
				res.put("MESSAGE", "사용처리 완료");
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