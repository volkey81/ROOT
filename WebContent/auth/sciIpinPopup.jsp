<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page contentType="text/html;charset=ksc5601"%>
<%
	response.setHeader("Cache-Control","no-cache");     
	response.setHeader("Pragma","no-cache");

	Param param = new Param(request);
    
    //URL작성
	String url = request.getScheme() + "://" + request.getServerName() + "/auth/sciIpinResult.jsp?retInfo="; 
		   url = url + Utils.safeHTML(param.get("retInfo")) + "&screenCd=" + Utils.safeHTML(param.get("screenCd"));
	
	//비밀번호찾기인 경우 파라미터 추가
	if(param.get("screenCd").equals("findPwd")){
		url= url + "&reqId=" + Utils.safeHTML(param.get("reqIdIpin"));
	}
	
%>
<html>
<head>
<script>
	function end() {
		window.opener.location.href = "<%=url%>";
		self.close();
	}
</script>
</head>
<body onload="javascript:end()">
</body>
</html>