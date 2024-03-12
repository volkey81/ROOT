<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page import="com.zeroto7.sha256.Sha256Cipher"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.sanghafarm.common.*"%>
<%@ page import="com.efusioni.stone.common.SystemChecker"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.efusioni.stone.common.Config"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.sanghafarm.service.member.MemberService"%>

<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	String msg = StringUtils.EMPTY;
	
	String failUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/modifySns2.jsp";
	
	if(!fs.isLogin()) {
		Utils.sendMessage(out, "잘못된 접근입니다.", failUrl);
		return;
	}

	response.setHeader("Pragma","no-cache");				// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);					// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");				// HTTP1.1 캐쉬 방지
	
	if("HTTP/1.1".equals(request.getProtocol())){
		response.setHeader("Cache-Control", "no-cache");	// HTTP1.1 캐쉬 방지
	}

	JSONObject result = new JSONObject();
	String mktgUpdateUrl   = Config.get("api.info.updateMktg." + SystemChecker.getCurrentName()); //APIURL(마케팅 정보수신동의 변경)
	String strCoopcoCd     = Config.get("join.parameter.coopcoCd");                       //제휴사코드
	String strchnlCd       = Config.get("join.parameter.chnlCd");                         //채널코드
	
	
	String strUnfyMmbNo    = fs.getUserNo() + "";                     //통합회원번호
	String strSmsRecv      = Utils.safeHTML(param.get("smsRecv", "N"));                       //수신동의(SMS)
	String strEmlRecv      = Utils.safeHTML(param.get("emlRecv", "N"));                       //수신동의(메일)
	String query         = "";                                                            //postQuery
	String strResult     = "";                                                            //전송결과
	String strMessage    = "";                                                            //결과메세지
	String strResultCode = "";                                                            //결과코드
	String successUrl = "http://" + request.getServerName() + "/mobile/mypage/index.jsp";
	
	//API용쿼리작성(마케팅 정보수신동의 변경)
	query = "coopcoCd=" + strCoopcoCd 
		       + "&chnlCd=" + strchnlCd  
		       + "&smsRecv=" + strSmsRecv 
		       + "&emlRecv=" + strEmlRecv
		       + "&unfyMmbNo=" + strUnfyMmbNo;
	
	//API통신
	result = SanghafarmUtils.getAPIDataInfo(mktgUpdateUrl, query);
	
	//결과코드 취득
	strResultCode = result.getString("resultCode");	
 	
 	if(strResultCode.equals("S0000")){
%>
 	<script type="text/javascript">
 		if(window.close()) {
 			alert("회원정보수정이 완료되었습니다.");
	        window.close();
	    }else{
 			alert("회원정보수정이 완료되었습니다.");
	    	location.href = "<%=successUrl%>";
	    }
 	</script>
<% 
 	}else{
 		strResult = "false";
 		strMessage = result.getString("resultMessage");	
 		Utils.sendMessage(out, strMessage, failUrl);
 	}
%>