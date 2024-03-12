<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page import="com.zeroto7.sha256.Sha256Cipher"%>
<%@ page import="com.efusioni.stone.common.Config"%>
<%@ page import="com.efusioni.stone.common.SystemChecker"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.sanghafarm.common.*"%>

<%
	Param param = new Param(request);

	response.setHeader("Pragma","no-cache");				// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);					// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");				// HTTP1.1 캐쉬 방지
	
	if("HTTP/1.1".equals(request.getProtocol())){
		response.setHeader("Cache-Control", "no-cache");	// HTTP1.1 캐쉬 방지
	}

	JSONObject result = new JSONObject();
	String pwdUpdateUrl  = Config.get("api.info.isSamePwd." + SystemChecker.getCurrentName()); //APIURL
	String strCoopcoCd   = Config.get("join.parameter.coopcoCd");                       //제휴사코드
	String strchnlCd     = Config.get("join.parameter.chnlCd");                         //채널코드
	String strScreenType = Utils.safeHTML(param.get("screenType"));                     //화면구분코드
	String userPwd       = enc(param.get("pwd"));										//패스워드
	String userId        = Utils.safeHTML(param.get("userId"));							//아이디
	String successUrl    = "";                                                          //성공 URL
	String failUrl       = "";                                                          //실패 URL
	String query         = "";                                                          //postQuery
	String strResult     = "";                                                          //전송결과
	String resultMessage = "";                                                          //결과메세지
	String strResultCode = "";                                                          //결과코드
	String backFlg       = "";														    //
	 
	try{
		
		query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd  + "&pwd=" + userPwd + "&id=" + userId;
		
		result = SanghafarmUtils.getAPIDataInfo(pwdUpdateUrl, query);
		
		strResultCode = result.getString("resultCode");	
		resultMessage = result.getString("resultMessage");
		if(!strResultCode.equals("S0000")){
%>
<script>
	alert("<%=resultMessage %>");
	history.back();
</script>
<%			
		}else{
			String nextUrl = "";
			if("leave".equals(strScreenType)) {
				nextUrl = Env.getSSLPath() + "/mobile/member/memLeave2.jsp";
			} else {
				nextUrl = Env.getSSLPath() + "/mobile/member/memModify2.jsp";
			}
			
			session.setAttribute("PASSWD_CHECK", "Y");
%>
<script>
	document.location.href="<%= nextUrl %>";
</script>
<%
		}
		
	 }catch(Exception e){
		 System.out.println("err");
	 }

	
%>

<%! 
private String enc(String s) {
	String key = "0to7";
	return Sha256Cipher.encrypt(s, key);
}
%>

