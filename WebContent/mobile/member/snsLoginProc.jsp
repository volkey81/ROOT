<%@page import="com.sanghafarm.common.Env"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONSerializer"%>
<%@ page import="com.sanghafarm.common.FrontSession"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.InetAddress"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.efusioni.stone.utils.*"%>
<%@ page import="com.efusioni.stone.common.*"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.sanghafarm.service.member.MemberService"%>
<%@page import="jwork.sso.agent.*"%>
<jsp:include page="/include/tas.jsp" />
<%
	response.setHeader("Pragma","no-cache");				// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);					// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");				// HTTP1.1 캐쉬 방지
	
	if("HTTP/1.1".equals(request.getProtocol())){
		response.setHeader("Cache-Control", "no-cache");	// HTTP1.1 캐쉬 방지
	}
	
	BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream()));
	String line = "";
	StringBuffer buf = new StringBuffer();
	while((line = br.readLine()) != null) {
		buf.append(line);	
	}
	Param param = new Param(request);
	JSONObject data = new JSONObject();                                  //응답(Json)
	JSONObject result    = new JSONObject(); 

	String strReturnUrl = Env.getURLPath() + "/mobile/member/joinSns1.jsp"; 			//SNSurl
	String strLoginUrl = Env.getURLPath() + "/mobile/member/login.jsp"; 				//로그인url
	String strMainUrl = Env.getURLPath(); 												//메인url
	String strCoopcoCd   = Config.get("join.parameter.coopcoCd");                       //제휴사코드
// 	String strChnlCd     = Config.get("join.parameter.chnlCd");                         //채널코드
	String strChnlCd     = SanghafarmUtils.getChnlCd(request);                         //채널코드
// 	String strNtryPath   = Config.get("join.parameter.ntryPath");                       //사이트코드
	String strNtryPath   = SanghafarmUtils.getNtryPath(request);                       //사이트코드
	String getTokenUrl   = Config.get("api.token.getToken." + SystemChecker.getCurrentName()); //APIURL(토근발행)
	String strResultCode = Utils.safeHTML(param.get("resultCode"));      				//결과코드
	String strMessage = Utils.safeHTML(param.get("resultMessage"));      				//결과메세지
	String strIp         = request.getRemoteAddr();                                     //IP주소
	String query         = "";                                                          //postQuery
	String strErr = "";                                                 				//에러판별 
	String strSocId = "";                                            				    //소셜아이디
	String strSocNm = "";                                               				//소셜이름 
	String strResult ="";                                               				//전송결과
  	String strUnfyMmbNo = "";                                           				//통합회원번호
  	String strAuthToken = "";                                            				//토큰

	//취득결과판별
 	if(strResultCode.equals("S0000")){
     	//파라미터재변환(Json)
		data = (JSONObject)JSONSerializer.toJSON(param.get("data"));
		strSocId = data.getString("socId");  
		strUnfyMmbNo = data.getString("unfyMmbNo");
		
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
		    
 			FrontSession fs = FrontSession.getInstance(request, response);
			MemberService svc = (new MemberService()).toProxyInstance();
				
			Param info = svc.getImInfo(Integer.parseInt(strUnfyMmbNo));
			fs.login(info);
			
			String device_Type = fs.getDeviceType();
%>
				<jsp:include page="/include/tas.jsp" />
				<script>
					//ET.exec('login', '<%= info.get("unfy_mmb_no") + "_" + info.get("soc_kind_cd") %>');
				</script>
				<script type="text/javascript">
					if(parent.opener != null ) {
						opener.location.href = "<%=strMainUrl%>" + "/main.jsp";
						self.close();
			   		 }else{
			   			location.href = "<%=strMainUrl%>" + "/mobile/main.jsp";
			   		 } 
				</script>
<% 
		}else{
			strResult = "false";
			strMessage = result.getString("resultMessage");
			Utils.sendMessage(out, strMessage);
			return;
		}

 	}else if(strResultCode.equals("E1002")){
 		strResult = "falseJoin";
 		strErr = "false";
     	//파라미터재변환(Json)
		data = (JSONObject)JSONSerializer.toJSON(param.get("data"));
		strSocId = data.getString("socId");  
		strUnfyMmbNo = data.getString("unfyMmbNo");
 		strReturnUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/memRejoin3.jsp?unfyMmbNo=" + strUnfyMmbNo;
 		
 	}else if(strResultCode.equals("E1004")){
 		strResult = "false";
 		strErr = "false";
 		
		data = (JSONObject)JSONSerializer.toJSON(param.get("data"));
		strSocId = data.getString("socId"); 
		strSocNm = data.getString("socNm"); 
		strUnfyMmbNo = data.getString("unfyMmbNo");	
 		
 		strReturnUrl = strReturnUrl + "?socNm=" + URLEncoder.encode(strSocNm, "UTF-8")
 				                    + "&socId=" + strSocId;
 		
 	}else{
 		strResult = "false";
 		strErr = "true"; 
 	}

	if(strResult.equals("true")){   	 
		String responseMessage = SSOManager.createSSOToken(request, strUnfyMmbNo, SSOGlobals.SST_CD);
	    String j_sso_q = SSOManager.getResponseData(responseMessage);
%>
		<script type="text/javascript">
			function _jssoCompleted(data, code){
// 				console.log("snsLoginProc.jsp " + code);
				if(parent.opener != null ) {
			        opener.location.href = "<%=strMainUrl%>";
			        window.close();
			    }else{
			    	location.href = "<%=strMainUrl%>";
			    } 
			}
		</script>
		<script type="text/javascript" src="<%=SSOGlobals.ADD_URL%>?j_sso_q=<%=URLEncoder.encode(SSOManager.getResponseData(responseMessage), "utf-8")%>"></script>

		<!-- 
	    <script type="text/javascript">
     		window.opener.location.href="<%=strMainUrl%>";
     		self.close()
		</script>
		 -->
<%
	}else if(strResult.equals("falseJoin") && strErr.equals("false")){
%>		
	    <script type="text/javascript">
	        alert("<%=strMessage%>");
//	        opener.document.location.replace("<%=strReturnUrl%>");
	        document.location.replace("<%=strReturnUrl%>");
//	        self.close()
		</script>
<%
	}else if(strResult.equals("false") && strErr.equals("false")){
%>		
	    <script type="text/javascript">
	        alert("<%=strMessage%>");
//	        opener.document.location.replace("<%=strReturnUrl%>");
	        document.location.replace("<%=strReturnUrl%>");
// 	        self.close()
		</script>
<%			
	}else{
%>			
	    <script type="text/javascript">
		 alert("<%=strMessage%>");
		 self.close()
		</script>
<%
	}
%>
<%-- {"result" : "<%=strResult %>","message" : "<%=strMessage %>","err" : "<%=strResult %>"}
 --%>