<%@page import="com.efusioni.stone.security.CryptoUtil"%>
<%@page import="net.sf.json.JSONSerializer"%>
<%@page import="com.zeroto7.sha256.Sha256Cipher"%>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.member.*" %>
<%
	response.setHeader("Pragma","no-cache");				// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);					// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");				// HTTP1.1 캐쉬 방지
	
	if("HTTP/1.1".equals(request.getProtocol())){
		response.setHeader("Cache-Control", "no-cache");	// HTTP1.1 캐쉬 방지
	}
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	JSONObject result    = new JSONObject();                                            //API응답(Json)
	JSONObject data      = new JSONObject();                                            //API응답(Json)
	String autoLoginUrl  = Config.get("api.login.autoLogin." + SystemChecker.getCurrentName()); //APIURL(자동로그인)
	String getTokenUrl   = Config.get("api.token.getToken." + SystemChecker.getCurrentName()); //APIURL(토근발행)
	String retUrl        = Env.getURLPath();							     			//URL(메인이동)
	String strCoopcoCd   = Config.get("join.parameter.coopcoCd");                       //제휴사코드
// 	String strChnlCd     = Config.get("join.parameter.chnlCd");                         //채널코드
	String strChnlCd     = SanghafarmUtils.getChnlCd(request);                         //채널코드
	String strToken      = SanghafarmUtils.getCookie(request, "autoToken");             //토근
// 	String strNtryPath   = Config.get("join.parameter.ntryPath");                       //사이트코드
	String strNtryPath   = SanghafarmUtils.getNtryPath(request);                       //사이트코드
	String strIp         = request.getRemoteAddr();                                     //IP주소
	String query         = "";                                                          //postQuery
	String strResult     = "";                                                          //전송결과
	String strMessage    = "";                                                          //결과메세지
	String strResultCode = "";                                                          //결과코드
	String strUnfyMmbNo  = "";                                                          //통합멤버십 회원번호
	String strAuthToken  = "";                                                          //토큰
	int expiry = -1;
	int maxExpiry = 60*60*24*100;
	
	//APIURL작성
	query = "coopcoCd=" + strCoopcoCd
	        + "&chnlCd=" + strChnlCd 
	        + "&authToken=" + strToken
	        + "&ntryPath=" + strNtryPath
	        + "&clientIp=" + strIp;
	
	//API정보취득(로그인)
	result = SanghafarmUtils.getAPIDataInfo(autoLoginUrl, query);	
	strResultCode = result.getString("resultCode");

	//처리성공여부판별
	if(strResultCode.equals("S0000")){
    	data = (JSONObject)JSONSerializer.toJSON(result.getString("data"));
	    strUnfyMmbNo = data.getString("unfyMmbNo");
			
		if(data.has("authToken") == true){
			strAuthToken = data.getString("authToken");
		}
		
		result = new JSONObject();	
		query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strChnlCd + "&unfyMmbNo=" + strUnfyMmbNo;
		
		//API정보취득(토근취득)
		result = SanghafarmUtils.getAPIDataInfo(getTokenUrl, query);	
		strResultCode = result.getString("resultCode");	

		//처리성공여부판별
		if(strResultCode.equals("S0000")){
			strResult = "true";
			data = new JSONObject();
			data = (JSONObject)JSONSerializer.toJSON(result.getString("data"));

		    strAuthToken = data.getString("authToken");
			SanghafarmUtils.setCookie(response, "autoToken", strAuthToken, fs.getDomain(), maxExpiry);
			expiry = maxExpiry;

		    retUrl = retUrl + "/mobile/main.jsp";
			MemberService svc = (new MemberService()).toProxyInstance();
				
			Param info = svc.getImInfo(Integer.parseInt(strUnfyMmbNo));
			fs.login(info);
			response.sendRedirect("/");
		}else{
			strResult = "false";
			strMessage = result.getString("resultMessage");
			SanghafarmUtils.setCookie(response, "autoToken", "", fs.getDomain(), 0);
			retUrl = retUrl + "/mobile/login.jsp";
		}
			
	}else{
		strResult = "false";
		strMessage = result.getString("resultMessage");
		SanghafarmUtils.setCookie(response, "autoToken", "", fs.getDomain(), 0);
		retUrl = retUrl + "/mobile/login.jsp";
	}
	
	if(strResult.equals("true")){
%>
	<script type="text/javascript">
	   location.href = "<%=retUrl%>";
	</script>
<% 		
	}else{
%>
	<script type="text/javascript">
	   alert("<%=strMessage%>");
	   location.href = "<%=retUrl%>";
	</script>
<%
	}
%>
