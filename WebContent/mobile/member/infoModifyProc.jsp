<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page import="com.zeroto7.sha256.Sha256Cipher"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.efusioni.stone.common.SystemChecker"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.efusioni.stone.common.Config"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.sanghafarm.service.member.MemberService"%>
<%@ page import="com.sanghafarm.common.*"%>

<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
			
	String msg = StringUtils.EMPTY;
	
	response.setHeader("Pragma","no-cache");				// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);					// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");				// HTTP1.1 캐쉬 방지
	
	if("HTTP/1.1".equals(request.getProtocol())){
		response.setHeader("Cache-Control", "no-cache");	// HTTP1.1 캐쉬 방지
	}

	JSONObject result = new JSONObject();
	String infoUpdateUrl   = Config.get("api.info.updateUserInfo." + SystemChecker.getCurrentName()); //APIURL(회원정보수정)
	String mktgUpdateUrl   = Config.get("api.info.updateMktg." + SystemChecker.getCurrentName()); //APIURL(마케팅 정보수신동의 변경)
	String strCoopcoCd     = Config.get("join.parameter.coopcoCd");                       //제휴사코드
	String strchnlCd       = Config.get("join.parameter.chnlCd");                         //채널코드
	
	String strUnfyMmbNo    = Utils.safeHTML(param.get("cUnfyMmbNo"));                     //통합회원번호
	String strWrlTel       = Utils.safeHTML(param.get("cWrlTel")).replace("-", "");       //전화번호
	String strSocMmbYn     = Utils.safeHTML(param.get("cSocMmbYn"));                      //소셜회원여부
	String strCi           = Utils.safeHTML(param.get("cCi"));                        	  //ci값
	String strEmlAddr      = Utils.safeHTML(param.get("cEmlAddr"));                       //이메일주소
	String strBirth        = Utils.safeHTML(param.get("cBirth"));                         //생년월일
	String strBtdyLucrDvCd = Utils.safeHTML(param.get("cBtdyLucrDvCd"));                  //양력/음력구분코드
	String strAgrmNo7010   = Utils.safeHTML(param.get("cAgrmNo7010"));                    //개인정보 제3자 제공동의
	String strSmsRecv      = Utils.safeHTML(param.get("cSmsRecv"));                       //수신동의(SMS)
	String strEmlRecv      = Utils.safeHTML(param.get("cEmlRecv"));                       //수신동의(메일)
	String query         = "";                                                            //postQuery
	String strResult     = "";                                                            //전송결과
	String strMessage    = "";                                                            //결과메세지
	String strResultCode = "";                                                            //결과코드
	String successUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/mypage/index.jsp";
	String failUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/memModify2.jsp";
	
	//API용쿼리작성(회원정보수정)
	query = "coopcoCd=" + strCoopcoCd 
	       + "&chnlCd=" + strchnlCd  
	       + "&unfyMmbNo=" + strUnfyMmbNo 
	       + "&wrlTel=" + strWrlTel
	       + "&socMmbYn=" + strSocMmbYn
	       + "&ci=" + URLEncoder.encode(strCi, "UTF-8") 
	       + "&emlAddr=" + strEmlAddr 
	       + "&btdy=" + strBirth
	       + "&btdyLucrDvCd=" + strBtdyLucrDvCd;

	//API통신
	result = SanghafarmUtils.getAPIDataInfo(infoUpdateUrl, query);
	
	//결과코드 취득
	strResultCode = result.getString("resultCode");	

	//성공여부 판별
	if(!strResultCode.equals("S0000")){
		strMessage = result.getString("resultMessage");
		Utils.sendMessage(out, strMessage);
		return;
	}
	
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
	<jsp:include page="/include/tas.jsp" />
	<script>
		//기존소스
		/*
		ET.exec('prop', '<%= fs.getUserId() %>', {
			'name' : '<%= fs.getUserNm() %>',
			'email' : '<%= strEmlAddr %>',
			'phone' : '<%= strWrlTel %>',
			'emailFlag' : '<%= strEmlRecv %>',
			'smsFlag' : '<%= strSmsRecv %>'
		});
		*/
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
		var _img = document.createElement("img");
		_img.setAttribute('src', getEtCookie('etShPropTrk'));
	</script>
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