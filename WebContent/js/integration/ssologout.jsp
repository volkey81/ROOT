<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="jwork.sso.agent.SSOHealthChecker"%>
<%@page import="jwork.sso.agent.SSOManager"%>
<%@page import="jwork.sso.agent.SSOGlobals"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.sanghafarm.common.*,
				com.efusioni.stone.utils.*"%>
<!--
	통합 로그아웃 하는 페이지 입니다.
	
	* 추가
	샘플 파일로 각 사이트의 로그아웃 페이지에 알맞게 붙여 넣는다.ㅋ 알아서 ㅋ
-->

<%
	FrontSession fs = FrontSession.getInstance(request, response);
	fs.logout();
	session.removeAttribute("recentList");
	session.invalidate();
	Param param = new Param(request);
	String returnUrl = param.get("return_url", "/");
			
	if(SSOHealthChecker.isAlived()) {
		String j_sso_q = SSOManager.encryptForCookieRemove(request , SSOGlobals.SST_CD);
%>
		<script>
		function _jssoCompleted(data, code){
			//alert("로그아웃을 완료하였습니다. loginForm 로 이동합니다.");
// 			alert("로그아웃 하였습니다(1).");
			if(opener){
				opener.location.href="<%= returnUrl %>"
				self.close();
			}else{
				self.location.href="<%= returnUrl %>";
			}
		}
		</script>
		<script type="text/javascript" src="<%=SSOGlobals.REMOVE_URL%>?j_sso_q=<%=URLEncoder.encode(j_sso_q)%>"></script>
<%			
		
	}else{
%>
		<script>
		//alert(" SSO 서버가 죽어있으므로 자사 세션만 로그아웃 시키고 loginForm 페이지로 이동합니다.  ");
// 		alert("로그아웃 되었습니다(2).");
		if(opener){
			opener.location.href="<%= returnUrl %>"
			self.close();
		}else{
			self.location.href="<%= returnUrl %>";
		}
		</script>
<%		
	}
%>

<script>
window.onload = function pageOnload(){
	//페이지를 전부 로딩한 시점에 SSO 서버장애로 인하여 removeCookie를 받지 못한는 경우입니다. 
	if( (typeof _VjssoLoadCheck) == "undefined"){
		//alert("SSO 서버가 죽어 있으므로 세션만 로그아웃 시키고 loginForm 페이지로 이동합니다.");
// 		alert("로그아웃을 완료하였습니다(3).");
		if(opener){
			opener.location.href="<%= returnUrl %>"
			self.close();
		}else{
			self.location.href="<%= returnUrl %>";
		}
	}
}
</script>
