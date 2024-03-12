<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="jwork.sso.agent.SSOHealthChecker"%>
<%@page import="jwork.sso.agent.SSOGlobals"%>
<%@page import="jwork.sso.agent.SSOManager"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.sanghafarm.common.*"%>
<%@page import="com.efusioni.stone.utils.*"%>

<%--
	[index 페이지]
	
	이 페이지는 서비스 사이트의 index페이지에 해당합니다.
	또한 사용자가 SSO 로그인 되어 있는경우 자동 로그인하는
	페이지로 동작합니다. (findCookie.jsp 호출)
	
	
	* 내용 추가 =============================================================================
	로그인 세션 또는 쿠키가 없고(사이트 로그인이 안되어있고)
	sso 쿠키가 있을때 동작되어짐
	
	- 호출 되어지는 케이스 2가지
	1. 사이트 페이지에서 호출 되어지는 케이스 : endType 가 false 이며, 처리 후 자기 자신의 페이지를 reload 처리 한다.
	2. 로그인 팝업에서 리다이렉션으로 호출 되어지는 케이스 : endType 가 true 이며, 처리 후 부모창 reload 처리 한다.
--%>

<%
try {
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	String endType = param.get("endType");

	if("".equals(endType) == false){
%>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.11.0.min.js"></script>
<%
	}
	
%>
<script>
	function postPoc() {
<%
	if("R".equals(endType)){//popup close
%>
		opener.location.reload();
		self.close();
<%
	}else if("I".equals(endType)){//index page
%>
		if(opener) {
			opener.location.href = "/";
			self.close();
		} else {
			document.location.href = "/";
		}
<%
	}else if("O".equals(endType)){//order page
%>
		if(opener) {
			opener.location.href = "/order/payment.jsp";
			self.close();
		} else {
			document.location.href = "/order/payment.jsp";
		}
<%
	}else if("CALL".equals(endType)){//callurl
%>
		if(opener) {
			opener.location.href = "<%= param.get("callurl") %>";
			self.close();
		} else {
			document.location.href = "<%= param.get("callurl") %>";
		}
<%
	}else if("APP".equals(endType)){//app page
%>
		location.href = "/webapp_ddong/common/cm_004.jsp";
<%			
	}else if("".equals(endType) == false){//opener function callback
%>
		opener.<%=endType%>();
		self.close();
<%
	}else{
%>
		self.location.reload();
<%
	}
%>
	}
</script>

<jsp:include page="/include/tas.jsp" />

<%
//String sessionUserId = (String)session.getAttribute("userid");
// 	String cookieUserId	= fs.getUserId(); //쿠키 로그인 사용자  아이디
// 	System.out.println("cookieUserId : " + cookieUserId);
	//사용자 세션이 없고
	//if(sessionUserId == null || "".equals(cookieUserId)){
// 	if("".equals(cookieUserId)){
	if(!fs.isLogin()){
		//SSO 서버가 살아있으면 
		if(SSOHealthChecker.isAlived()){
			String j_sso_q = SSOManager.encryptForCookieValidation(request , SSOGlobals.SST_CD) ;	
			System.out.println("+++++++++++++++ ssologin.jsp j_sso_q : " + j_sso_q);
%>
			<script type="text/javascript">
			//<%--=j_sso_q--%>
			<%--
			//data : 1회용 접속 코드
			--%> 
			function _jssoCompleted(data, code){
				if(data != ""){
					//if(confirm("SSO 쿠키가 존재하여 확인하러 갑니다.\n" + data) == false){
					//	return;
					//}
					//document.getElementById("j_sso_q").value = cookie ; 
					//document.ssologinfrm.submit();
					
					$.ajax({
						type:"post"
						//,contentType: "application/x-www-form-urlencoded; charset=UTF-8"
						,async:true
						,dataType:"json"
						,timeout:10000
						,data:{"j_sso_q" : data}
						,url: "/integration/ajax_ssologin.jsp"
						,success: function(data) {
							//alert(JSON.stringify(data.user_info));
							if(data.CODE == "OK"){
								//alert(data.CODE);
								//ET.exec('login', data.userid);
								postPoc();
							}else{
								alert(data.CODE);
								self.close();
							}
						}
						,error : function(xhr, status, error) {
				            alert("xhr : " + xhr.status + "\nresponseText : " + xhr.responseText + "\nstatus : " + status + "\nerror : " + error);
				        }
					});
				}else{
					<!-- //data is null. -->
<%
			if("I".equals(endType)){//index page
%>
					opener.location.href = "/";
					self.close();
<%
			}else if("".equals(endType) == false){//opener function callback
%>
					opener.<%=endType%>();
					self.close();
<%
			}
%>
				}
			}
			
			function import_jquery_js(){
				try{
					$;
				}catch(e){
					var jquery_js = document.createElement("script");
					jquery_js.type = "text/javascript";
					jquery_js.src = "https://code.jquery.com/jquery-1.11.0.min.js";
					document.getElementsByTagName('head')[0].appendChild(jquery_js);
				}
			}
			
			function import_sso_js(){
				var sso_js = document.createElement("script");
				sso_js.type = "text/javascript";
				sso_js.src = "<%=SSOGlobals.FIND_URL%>?j_sso_q=<%=URLEncoder.encode(j_sso_q)%>";
				document.getElementsByTagName('head')[0].appendChild(sso_js);
			}
			
			window.onload = function(){
				import_jquery_js();
				import_sso_js();
			}
			</script>
			<%-- <script type="text/javascript" src="<%=SSOGlobals.FIND_URL%>?j_sso_q=<%=URLEncoder.encode(j_sso_q)%>"></script> --%>
<%
		}else{
			System.out.println("SSOHealthChecker.isAlived() false");
%>
				<!-- //sso server down. -->
<%
			if("R".equals(endType) || "I".equals(endType) || "".equals(endType) == false){//popup%>
				<script type="text/javascript">
				alert("통합 로그인 서버 접속을 실패하였습니다.");
				</script>
<%	
			}
		}
	}else{
		//is login true
%>
		<!-- //is login true. -->
		<script type="text/javascript">
		postPoc()
		</script>
<%
	}
} catch(Exception e) {
	e.printStackTrace();
}
%>

