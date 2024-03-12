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
	MemberService svc = (new MemberService()).toProxyInstance();
	ImMemberService immem = (new ImMemberService()).toProxyInstance();
	
	String resultCode = param.get("resultCode");
	
	if("S0000".equals(resultCode)) {
		JSONObject data = (JSONObject)JSONValue.parse(param.get("data"));
		String unfyMmbNo = (String) data.get("unfyMmbNo");
		System.out.println("unfyMmbNo : " + unfyMmbNo);
		
		Param info = svc.getImInfo(Integer.parseInt(unfyMmbNo));
		if(info != null && !"".equals(info.get("unfy_mmb_no"))) {
			fs.login(info);
			immem.getToken(Integer.parseInt(unfyMmbNo));
%>
	<script>
		document.location.href="/mobile/mypage/sso.jsp";
	</script>
<%
		} else {
			Utils.sendMessage(out, "회원정보가 존재하지 않습니다.", "/mobile/mypage/login.jsp");
		}
	} else if("E1000".equals(resultCode)) {
		Utils.sendMessage(out, "아이디/비밀번호를 다시 확인 해 주세요.", "/mobile/mypage/login.jsp");
	} else {
		String msg = "";
		if("E1001".equals(resultCode)) {
			msg = "매일Do 에서 휴면회원 해제(본인인증) 해주셔야 합니다.\\n확인을 누르시면 매일Do 로 이동합니다.";
		} else if("E1002".equals(resultCode)) {
			msg = "매일Do에서 ‘상하농원’ 약관 동의 해주셔야 합니다.\\n확인을 누르시면 매일Do로 이동합니다.";
		} else if("E1003".equals(resultCode)) {
			msg = "회원 재가입이 필요한 상태입니다.\\n매일Do에서 로그인하시어 안내 받으시기 바랍니다.\\n확인을 누르시면 매일Do로 이동합니다.";
		} else if("E1004".equals(resultCode)) {
			msg = "회원가입이 필요합니다.\\n매일Do에서 회원가입을 해주세요.\\n확인을 누르시면 매일Do로 이동합니다.";
		}
%>
	<script>
		if(confirm("<%= msg %>")) {
			document.location.href="<%= Env.getMaeildoUrl() %>";
		} else {
			document.location.href="/mobile/mypage/login.jsp";
		}
	</script>
<%
	}
%>
