<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.security.*,
			com.sanghafarm.service.member.*,
			com.sanghafarm.service.api.*,
			com.sanghafarm.utils.*,
			org.json.simple.*" %><%
	Param param = new Param(request);
	JSONObject req = new JSONObject();
	JSONObject res = new JSONObject();
	try {
		String s = SecurityUtils.decodeAES(param.get("q"));
		
		req = (JSONObject)JSONValue.parse(s.trim());
		long unfyMmbNo = (Long) req.get("UNFY_MMB_NO");
		String timestamp = (String) req.get("TIMESTAMP");
	
		if(!SanghafarmUtils.isValidApiParameter(timestamp)) {	// 파라미터 유효기간 만료
			res.put("RESULT", false);
			res.put("MESSAGE", "파라미터 오류 - 유효기간 만료");
		} else if("".equals(unfyMmbNo)) {
			res.put("RESULT", false);
			res.put("MESSAGE", "파라미터 오류 - 통합회원번호");
		} else {
			FamilyMemberService svc =(new FamilyMemberService()).toProxyInstance();
			Param info = svc.getInfo(unfyMmbNo);
			
			if("N".equals(info.get("family_yn"))) {
				res.put("RESULT", false);
				res.put("MESSAGE", "현재 패밀리 회원이 아닙니다.");
			} else {
				Param p = new Param(
							"unfy_mmb_no", unfyMmbNo,
							"status", "2",
							"update_user", "POS"
						);
				int row = svc.offCancel(p);
				System.out.println("canceled row : " + row);
				
				res.put("RESULT", true);
				res.put("MESSAGE", "취소되었습니다.");
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