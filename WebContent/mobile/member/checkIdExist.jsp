<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONSerializer"%>
<%@ page import="com.efusioni.stone.utils.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.efusioni.stone.common.Config"%>
<%@ page import="com.efusioni.stone.common.SystemChecker"%>
<%
	response.setHeader("Pragma","no-cache");				// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);					// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");				// HTTP1.1 캐쉬 방지
	
	if("HTTP/1.1".equals(request.getProtocol())){
		response.setHeader("Cache-Control", "no-cache");	// HTTP1.1 캐쉬 방지
	}
	
	Param param = new Param(request);
	JSONObject result = new JSONObject();                                                    //API응답(Json)
	String checkIdUrl    = Config.get("api.info.checkIdExist." + SystemChecker.getCurrentName()); //APIURL
	String strCoopcoCd   = Config.get("join.parameter.coopcoCd");                            //제휴사코드
	String strchnlCd     = Config.get("join.parameter.chnlCd");                              //채널코드
	String query         = "";                                                               //postQuery
	String strResult     = "";                                                               //전송결과
	String strMessage    = "";                                                               //결과메세지
	String strResultCode = "";                                                               //결과코드
	
	//APIURL작성
	query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd + "&id=" + Utils.safeHTML(param.get("userId"));
	
	//API정보취득
	result = SanghafarmUtils.getAPIDataInfo(checkIdUrl,query);
	
	strResultCode = result.getString("resultCode");	
 	
 	if(strResultCode.equals("S0000")){
 		strResult = "true";
 	}else{
 		strResult = "false";
 		strMessage = result.getString("resultMessage");	
 	}
	
%>

{"result" : "<%=strResult %>","message" : "<%=strMessage %>"}
