<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.member.*,
				 org.json.simple.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	ImMemberService immem = (new ImMemberService()).toProxyInstance();
	MemberService svc = (new MemberService()).toProxyInstance();
	
	String resultCode = "";
	String msg = "";
	
	param.set("clientIp", request.getRemoteAddr());
	JSONObject json = immem.login(param);
	String userid = "";
	
	if(json == null) {
		msg = "시스템 오류가 발생하였습니다.";
	} else {
		resultCode = (String) json.get("resultCode");
		if("S0000".equals(resultCode)) {
			JSONObject data = (JSONObject)JSONValue.parse(json.get("data").toString());
			String unfyMmbNo = (String) data.get("unfyMmbNo");
			System.out.println("unfyMmbNo : " + unfyMmbNo);
			
			Param info = svc.getImInfo(Integer.parseInt(unfyMmbNo));
			if(info != null && !"".equals(info.get("unfy_mmb_no"))) {
				int maxExpiry = 60*60*24*100;
				
				int expiry = -1;
				if("Y".equals(param.get("id_save"))) {
					SanghafarmUtils.setCookie(response, "id_save", param.get("id"), fs.getDomain(), maxExpiry);
				} else {
					SanghafarmUtils.setCookie(response, "id_save", "", fs.getDomain(), 0);
				}
				
				if("Y".equals(param.get("login_save"))) {
					SanghafarmUtils.setCookie(response, "login_save", "Y", fs.getDomain(), maxExpiry);
					expiry = maxExpiry;
				} else {
					SanghafarmUtils.setCookie(response, "login_save", "", fs.getDomain(), 0);
				}

				fs.login(info, expiry);
				userid = !"".equals(info.get("mmb_id")) ? info.get("mmb_id") : info.get("unfy_mmb_no") + "_" + info.get("soc_kind_cd");

				immem.getToken(Integer.parseInt(unfyMmbNo));
			} else {
				msg = "회원정보가 존재하지 않습니다.";
			}
			
		}
	}
%>
<%= param.get("callback") %> (
	{
		"resultCode" : "<%= resultCode %>",
		"userid" : "<%= userid %>",
		"msg" : "<%= msg %>" 
	}
)