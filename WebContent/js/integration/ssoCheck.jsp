<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*, java.net.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			jwork.sso.agent.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	String j_sso_q = "";
	
 	if(!fs.isLogin()) {
		if(SSOHealthChecker.isAlived()) {
			j_sso_q = SSOManager.encryptForCookieValidation(request, SSOGlobals.SST_CD);
			System.out.println("++++++ ssoCheck.jsp j_sso_q : " + j_sso_q);
			System.out.println(SSOGlobals.FIND_URL + "?j_sso_q=" + URLEncoder.encode(j_sso_q));
%>
<script>
	function _jssoCompleted(data, code) {
		if(data != "") {
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
// 						alert(data.CODE);
						self.location.reload();
					}
				}
				,error : function(xhr, status, error) {
		            alert("xhr : " + xhr.status + "\nresponseText : " + xhr.responseText + "\nstatus : " + status + "\nerror : " + error);
		        }
			});
		}
	}

	function import_sso_js() {
		var sso_js = document.createElement("script");
		sso_js.type = "text/javascript";
		sso_js.src = "<%=SSOGlobals.FIND_URL%>?j_sso_q=<%=URLEncoder.encode(j_sso_q)%>";
		document.getElementsByTagName('head')[0].appendChild(sso_js);
	}
	
	$(function() {
		import_sso_js();
	});
</script>
<%
		}
 	}
%>