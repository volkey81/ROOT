<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*, java.net.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			jwork.sso.agent.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
 	if(fs.isLogin()) {
 		String responseMessage = "";
		if(SSOHealthChecker.isAlived()) {
			responseMessage = SSOManager.createSSOToken(request, fs.getUserNo() + "", SSOGlobals.SST_CD);
			System.out.println("++++++ sso.jsp responseMessage : " + responseMessage);
%>
<script>
	function _jssoCompleted(data, code){
// 		alert(code + " : " + data);
		self.location.href = '<%= param.get("callurl", "/mobile") %>';
	}
</script>
<script type="text/javascript" src="<%=SSOGlobals.ADD_URL%>?j_sso_q=<%=URLEncoder.encode(SSOManager.getResponseData(responseMessage), "utf-8")%>"></script>
<%
		}
 	}
%>
