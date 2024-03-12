<%@page import="jwork.sso.agent.SSOHealthChecker"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="jwork.sso.agent.SSOGlobals"%>
<%@page import="jwork.sso.agent.SSOManager"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.efusioni.stone.security.CryptoUtil"%>
<%@ page import="net.sf.json.JSONSerializer"%>
<%@ page import="com.zeroto7.sha256.Sha256Cipher"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.sanghafarm.service.product.ProductService"%>
<%@ page import="org.apache.commons.collections4.CollectionUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.efusioni.stone.common.*,com.efusioni.stone.utils.*,com.sanghafarm.common.*,com.sanghafarm.service.member.*" %>
<%
	response.setHeader("Pragma","no-cache");				// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);					// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");				// HTTP1.1 캐쉬 방지
	
	if("HTTP/1.1".equals(request.getProtocol())){
		response.setHeader("Cache-Control", "no-cache");	// HTTP1.1 캐쉬 방지
	}
	
	Param param = new Param(request);
	
	JSONObject result    = new JSONObject();                                            // API응답(Json)
	JSONObject data      = new JSONObject();                                            //API응답(Json)
	String loginUrl      = Config.get("api.login.login." + SystemChecker.getCurrentName()); //APIURL(로그인)
	String getTokenUrl   = Config.get("api.token.getToken." + SystemChecker.getCurrentName()); //APIURL(토근발행)
	String retUrl        = param.get("referUrl", Env.getURLPath());						//URL(메인이동)
	String strCoopcoCd   = Config.get("join.parameter.coopcoCd");                       //제휴사코드
// 	String strChnlCd     = Config.get("join.parameter.chnlCd");                         //채널코드
	String strChnlCd     = SanghafarmUtils.getChnlCd(request);                         //채널코드
	String strUserId     = param.get("userId").trim();                         //유져ID
	String strUserPwd    = enc(param.get("userPwd"));                   //유져비밀번호
// 	String strNtryPath   = Config.get("join.parameter.ntryPath");                       //사이트코드
	String strNtryPath   = SanghafarmUtils.getNtryPath(request);                       //사이트코드
	String strAutoYn     = param.get("autoLogin");						//자동로그인여부
	String strIp         = request.getRemoteAddr();                                     //IP주소
	String strSaveIdFlg  = param.get("saveIdFlg","");					//아이디 저장
	String query         = "";                                                          //postQuery
	String strResult     = "";                                                          //전송결과
	String strMessage    = "";                                                          //결과메세지
	String strResultCode = "";                                                          //결과코드
	String strUnfyMmbNo  = "";                                                          //통합멤버십 회원번호
	String strAuthToken  = "";                                                          //토큰   
	FrontSession fs = FrontSession.getInstance(request, response);
	
	if(retUrl.indexOf("loginProc.jsp") != -1) {
		retUrl = Env.getURLPath();
	} else if(retUrl.indexOf("joinComplete.jsp") != -1) {
		retUrl = Env.getURLPath();
	} else if(!retUrl.startsWith("http")) {
		retUrl = Env.getURLPath() + retUrl;
	} else if(retUrl.startsWith("http") && retUrl.indexOf("sanghafarm.co.kr") == -1) {
		retUrl = Env.getURLPath();
	}
	
	// 호텔 스페셜 오퍼
	Param hoffer = (Param) session.getAttribute("HOTEL_OFFER_FORM");
	Param hroom = (Param) session.getAttribute("HOTEL_ROOM_FORM");
	if(hoffer != null && StringUtils.isNotEmpty(hoffer.get("pid"))) {
		retUrl = "/hotel/offer/session.jsp";
	} else if(hroom != null && StringUtils.isNotEmpty(hroom.get("chki_date"))) {
		retUrl = "/hotel/room/reservation/session.jsp";
	}

	try{
		int expiry = -1;
		int maxExpiry = 60*60*24*100;
		
		if(strAutoYn.equals("true")){
			strAutoYn = "Y";
		}else{
			strAutoYn = "N";
		}
		
		//APIURL작성
		query = "coopcoCd=" + strCoopcoCd
		        + "&chnlCd=" + strChnlCd 
		        + "&id=" + strUserId
		        + "&pwd=" + strUserPwd
		        + "&ntryPath=" + strNtryPath
		        + "&clientIp=" + strIp
		        + "&autoYn=" + strAutoYn;
		
		//API정보취득(로그인)
		result = SanghafarmUtils.getAPIDataInfo(loginUrl, query);	
		strResultCode = result.getString("resultCode");

		System.out.println("------------ loginProc retUrl : " + retUrl);
		System.out.println("------------ loginProc query : " + query);
		System.out.println("------------ loginProc result : " + result);

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
			    
				if(strAutoYn.equals("Y")){
					SanghafarmUtils.setCookie(response, "autoToken", strAuthToken, fs.getDomain(), maxExpiry);
					expiry = maxExpiry;
				} else {
					SanghafarmUtils.setCookie(response, "autoToken", "", fs.getDomain(), 0);
				}
				
				MemberService svc = (new MemberService()).toProxyInstance();
					
				Param info = svc.getImInfo(Integer.parseInt(strUnfyMmbNo));
				if (info == null) {			
					Utils.sendMessage(out, "해당하는 회원정보가 존재하지 않습니다.");
					return;
				}
				
				fs.login(info);
				
				SanghafarmUtils.setCookie(response, "saveid", strUserId, fs.getDomain(), maxExpiry);
				SanghafarmUtils.setCookie(response, "saveidflg", strSaveIdFlg, fs.getDomain(), maxExpiry);

				String device_Type = fs.getDeviceType();
				String referUrl = StringUtils.EMPTY;
				if (StringUtils.isNotEmpty(param.get("referUrl"))) {
					referUrl = param.get("referUrl");
				}
				strResult = "login";
			   return;
			}else{
				strResult = "false";
				strMessage = result.getString("resultMessage");
				Utils.sendMessage(out, strMessage);
				return;
			}
				
		}else if(strResultCode.equals("E1002")){
			strResult = "true";
	    	data = (JSONObject)JSONSerializer.toJSON(result.getString("data"));
		    strUnfyMmbNo = data.getString("unfyMmbNo");
		    strMessage = result.getString("resultMessage");
			retUrl = "/mobile/member/memRejoin3.jsp?unfyMmbNo=" + strUnfyMmbNo;
		}else if(strResultCode.equals("E1001")){
			strResult = "dormancy";
	    	data = (JSONObject)JSONSerializer.toJSON(result.getString("data"));
		    strUnfyMmbNo = data.getString("unfyMmbNo");
			retUrl = "/mobile/member/memInactive.jsp?userId=" + strUserId + "&unfyMmbNo=" + strUnfyMmbNo;
		}else{
			strResult = "false";
			strMessage = result.getString("resultMessage");
			Utils.sendMessage(out, strMessage);
			return;
		}

	 }catch(Exception e){
		 System.out.println("err");
	 }finally{
		 System.out.println("---------- loginProc.jsp strResult : " + strResult);
		if(strResult.equals("login")){
%>
<script>
	// android app 
	try {
		window.javascriptBridge.androidLogin('<%= strUserId %>');
	} catch(e) {}
</script>
<%
			if(SystemChecker.isLocal()) {
%>
		<script type="text/javascript">
			if (window.opener && window.opener !== window) {
		        opener.location.href = "<%=retUrl%>";
				opener.location.reload();
		        window.close();
		    } else {
	    		location.href = "<%=retUrl%>";
		    } 
		</script>
<%				
			} else {
				String responseMessage = SSOManager.createSSOToken(request, strUnfyMmbNo, SSOGlobals.SST_CD);
				System.out.println("---------- loginProc.jsp responseMessage : " + responseMessage);
			    String j_sso_q = SSOManager.getResponseData(responseMessage);
%>
		<jsp:include page="/include/tas.jsp" />
		<script>
			//기존소스
			//ET.exec('login', '<%= strUserId %>');
			function getEtCookie(cname) {
				var name = cname + "=";
				var decodedCookie = decodeURIComponent(document.cookie);
				var ca = decodedCookie.split(';');
				for(var i = 0; i <ca.length; i++) {
					var c = ca[i];
					while (c.charAt(0) == ' ') {
						c = c.substring(1);
					}
					if (c.indexOf(name) == 0) {
						return c.substring(name.length, c.length);
					}
				  }
				  return "";
				}
			document.cookie = "etUserId=<%= strUserId %>; path=/";
			var _img = document.createElement("img");
			_img.setAttribute('src', getEtCookie('etShLoginTrk'));
		</script>
		<script type="text/javascript">
			function _jssoCompleted(data, code){
// 				if(parent.opener != null ) {
				if (window.opener && window.opener !== window) {
			        opener.location.href = "<%=retUrl%>";
//					opener.location.reload();
			        window.close();
			    }else{
			    	location.href = "<%=retUrl%>";
			    } 
			}
		</script>
		<script type="text/javascript" src="<%=SSOGlobals.ADD_URL%>?j_sso_q=<%=URLEncoder.encode(j_sso_q, "utf-8")%>"></script>
<%
			}
		}else if(strResult.equals("true")){
%>
			<script type="text/javascript">
				alert("<%=strMessage%>")
//				location.href = "<%=retUrl%>";

				if (window.opener && window.opener !== window) {
			        opener.location.href = "<%=retUrl%>";
			        window.close();
			    }else{
			    	location.href = "<%=retUrl%>";
			    } 
			</script>
<%
		}else if(strResult.equals("dormancy")){
%>
			<script type="text/javascript">
//				location.href = "<%=retUrl%>";
				if (window.opener && window.opener !== window) {
			        opener.location.href = "<%=retUrl%>";
			        window.close();
			    }else{
			    	location.href = "<%=retUrl%>";
			    } 
			</script>
<%
		}					
	}
%>
<%!
private String enc(String s) {
	String key = "0to7";
	return Sha256Cipher.encrypt(s, key);
}
%>

