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
		String schType = (String) req.get("SCH_TYPE");
		String schKey = (String) req.get("SCH_KEY");
		String timestamp = (String) req.get("TIMESTAMP");
	
		if(!SanghafarmUtils.isValidApiParameter(timestamp)) {	// 파라미터 유효기간 만료
			res.put("RESULT", false);
			res.put("MESSAGE", "파라미터 오류 - 유효기간 만료");
		} else if("".equals(schType) || "1,2,3,4".indexOf(schType) < 0) {
			res.put("RESULT", false);
			res.put("MESSAGE", "파라미터 오류 - 검색유형");
		} else if("".equals(schKey)) {
			res.put("RESULT", false);
			res.put("MESSAGE", "파라미터 오류 - 검색어");
		} else {
			FamilyMemberService svc =(new FamilyMemberService()).toProxyInstance();
			List<Param> list = svc.getList(new Param("sch_type", schType, "sch_key", schKey));
			res.put("RESULT", true);
			res.put("MESSAGE", "성공");
			res.put("TOTAL_RECORD", list.size());
			res.put("LIST", list);
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