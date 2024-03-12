<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.efusioni.stone.utils.*"%>
<%@ page import="com.efusioni.stone.common.Config"%>
<%@ page import="com.efusioni.stone.common.SystemChecker"%>
<%@ page import="com.zeroto7.sha256.Sha256Cipher"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%
	response.setHeader("Pragma","no-cache");				// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);					// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");				// HTTP1.1 캐쉬 방지
	
	if("HTTP/1.1".equals(request.getProtocol())){
		response.setHeader("Cache-Control", "no-cache");	// HTTP1.1 캐쉬 방지
	}
	
	Param param = new Param(request);
	JSONObject result = new JSONObject();                                               //API응답(Json)
	String joinUrl = "";                                                                //화면이동URL
	String joinDataUrl = Config.get("api.join.join." + SystemChecker.getCurrentName()); //APIURL
	String strCoopcoCd = Config.get("join.parameter.coopcoCd");                         //제휴사코드
// 	String strChnlCd = Config.get("join.parameter.chnlCd");                             //채널코드
	String strChnlCd     = SanghafarmUtils.getChnlCd(request);                         //채널코드
	String strSocMmbYn = "N";                                                           //SNS 소셜회원여부
	String strId = Utils.safeHTML(param.get("cId"));                                    //아이디
	String strPwd = enc(Utils.safeHTML(param.get("cPwd")));                             //비밃번호
	String strName = Utils.safeHTML(param.get("cName"));                                //이름
	String strCi = Utils.safeHTML(param.get("cCi"));                                    //ci값
	String strDi = Utils.safeHTML(param.get("cDi"));                                    //di값
	String strCiVersion = Utils.safeHTML(param.get("cCiVersion"));                      //ci버전
	String strGndrDvCd = Utils.safeHTML(param.get("cGndrDvCd"));                        //성별구분코드
	String strStrFgnGbn = Utils.safeHTML(param.get("cStrFgnGbn"));                      //외국인구분코드
	String strCertDv = Utils.safeHTML(param.get("cCertDv"));                            //본인인증구분코드
	String strEmlAddr = Utils.safeHTML(param.get("cEmlAddr"));                          //이메일주소(abc@abc.com)
// 	String strNtryPath = Config.get("join.parameter.ntryPath");                         //사이트코드
	String strNtryPath   = SanghafarmUtils.getNtryPath(request);                       //사이트코드
	String strBirth = Utils.safeHTML(param.get("cBirth"));                              //생년월일(YYYYMMDD)
// 	String strBtdyLucrDvCd = Utils.safeHTML(param.get("cBtdyLucrDvCd"));                //양력/음력구분코드
	String strBtdyLucrDvCd = "1";                //양력/음력구분코드 2023.05.10 무조건 1로 전송
	String strAgrmNo1 = Utils.safeHTML(param.get("cAgrmNo1"));                          //매일멤버십이용약관
	String strAgrmNo2 = Utils.safeHTML(param.get("cAgrmNo2"));                          //개인정보수집 이용동의
	String strAgrmNo7010 = Utils.safeHTML(param.get("cAgrmNo7010"));                    //개인정보 제3자제공동의
	String strAgrmNo7040 = Utils.safeHTML(param.get("cAgrmNo7010"));                    //개인정보 제3자제공동의
	String strAppPushRecv = "N";                                                        //마케팅 수신동의(push)
	String strSmsRecv = Utils.safeHTML(param.get("cSmsRecv"));                          //마케팅 수신동의(sms)
	String strEmlRecv = Utils.safeHTML(param.get("cEmlRecv"));                          //마케팅 수신동의(email)
	String strWrlTel = Utils.safeHTML(param.get("cWrlTel"));                            //무선전화번호(01012345678)
	String strAddrFlag = Utils.safeHTML(param.get("cAddrFlag"));                        //주소구분
	String strPostcode = Utils.safeHTML(param.get("cPostCode"));                        //구 우편번호
	String strZonecode = Utils.safeHTML(param.get("cZoneCode"));                        //신 우편번호
	String strAddress1 = Utils.safeHTML(param.get("cAddress1"));                        //기본주소
	String strAddress2 = Utils.safeHTML(param.get("cAddress2"));                        //상세주소
	String query         = "";                                                          //postQuery
	String strResult ="";                                                               //전송결과
	String strMessage ="";                                                              //결과메세지
	String strResultCode ="";                                                           //결과코드
	String unfyMmbNo = "";
	
	//인증정보 일치체크
	if (strCertDv.equals("1")){
		session.getAttribute("name");
		session.getAttribute("hpno");
		session.getAttribute("birth");
	}else{
		session.getAttribute("name");
		session.getAttribute("birth");
	}
	
	//회원가입URL작성
	query = "coopcoCd=" + strCoopcoCd 
			     + "&chnlCd=" + strChnlCd 
			     + "&socMmbYn=" + strSocMmbYn
			     + "&id=" + strId
			     + "&pwd=" + strPwd
			     + "&name=" + strName
			     + "&ci=" + URLEncoder.encode(strCi, "UTF-8")
			     + "&di=" + strDi
			     + "&ciVersion=" + strCiVersion
			     + "&gndrDvCd=" + strGndrDvCd
			     + "&strFgnGbn=" + strStrFgnGbn
			     + "&certDv=" + strCertDv
			     + "&emlAddr=" + strEmlAddr
			     + "&ntryPath=" + strNtryPath
			     + "&birth=" + strBirth
			     + "&btdyLucrDvCd=" + strBtdyLucrDvCd
			     + "&agrmNo1=" + strAgrmNo1
			     + "&agrmNo2=" + strAgrmNo2
			     + "&agrmNo7010=N" 
			     + "&agrmNo7020=N" 
			     + "&agrmNo7021=N" 
			     + "&agrmNo7030=N"
			     + "&agrmNo7040=" + strAgrmNo7010
			     + "&agrmNo7050=N"
			     + "&agrmNo7060=N"
			     + "&appPushRecv=" + strAppPushRecv
			     + "&smsRecv=" + strSmsRecv
			     + "&emlRecv=" + strEmlRecv
			     + "&wrlTel=" + strWrlTel;

	// 2023.06.08 01시부터 제로투세븐(7020) 삭제, 궁중비책(7021) 추가
	/*
	String today = Utils.getTimeStampString("yyyyMMddHHmm");
	if(today.compareTo("202306080100") < 0) {
    	query += "&agrmNo7020=N"; 
	} else {
		query += "&agrmNo7021=N"; 
	}
	*/

	//도로명주소
	if (strAddrFlag.equals("1")){
		query = query + "&addrFlag=" + strAddrFlag 
								+ "&rozipNo=" + strPostcode 
								+ "&rozipZoneNo=" + strZonecode 
								+ "&rozipBaseAddr=" + strAddress1 
								+ "&rozipDtlsAddr=" + strAddress2;
	//지번주소
	}else if(strAddrFlag.equals("2")){
		query = query + "&addrFlag=" + strAddrFlag 
								+ "&zipNo=" + strPostcode 
								+ "&zipZoneNo=" + strZonecode 
								+ "&zipBaseAddr=" + strAddress1 
								+ "&zipDtlsAddr=" + strAddress2;
	}
    //API데이터 취득
//     if(SystemChecker.isReal()) {
		result = SanghafarmUtils.getAPIDataInfo(joinDataUrl, query);
		System.out.println("================= joinProc.js result : " + result);
	 	strResult = result.getString("resultCode");
	 	unfyMmbNo = result.getJSONObject("data").getString("unfyMmbNo");
//     } else {
//     	strResult = "S0000";
//     }
    
	if(strResult.equals("S0000")){
// 		joinUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/joinComplete.jsp";
		joinUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/joinStep4.jsp?type=" + param.get("type");
%>
	<jsp:include page="/include/tas.jsp" />
	<form name="joinForm" id="joinForm" action="joinStep4.jsp" method="post">
		<input type="hidden" name="userid" value="<%= strId %>">
		<input type="hidden" name="unfy_mmb_no" value="<%= unfyMmbNo %>">
		<input type="hidden" name="type" value="<%= param.get("type") %>">
	</form>
	<script>
		//기존 소스
		/*
		ET.exec('signup', '<%= strId %>', {
			'name' : '<%= strName %>',
			'email' : '<%= strEmlAddr %>',
			'phone' : '<%= strWrlTel %>',
			'emailFlag' : '<%= strEmlRecv %>',
			'smsFlag' : '<%= strSmsRecv %>
		});'
		*/
			
		function getEtCookie(cname) {
			try {
				var name = cname + "=";
// 				console.log("cookie", document.cookie);
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
			} catch(e) {}
		}
		var reqInfos = getEtCookie('etShSignupTrk');
		if(reqInfos){
			var _img1 = document.createElement("img");	
			reqInfos = JSON.parse(reqInfos);
			var _propInfo = reqInfos['prop'];
			if ( _propInfo && _propInfo.url ) {
				_img1.setAttribute('src', _propInfo.url);
			}
			
			var _img2 = document.createElement("img");
			var _joinInfo = reqInfos['join'];
			if ( _joinInfo && _joinInfo.url ) {
				_img2.setAttribute('src', _joinInfo.url);
			}
		}
		
		document.getElementById("joinForm").submit();
	</script>
<%
	}else{
 		joinUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/joinFail.jsp";
%>
	<script type="text/javascript">
	    location.href = "<%=joinUrl%>";
	</script>
<%
	}
%>

<%! 
private String enc(String s) {
	String key = "0to7";
	return Sha256Cipher.encrypt(s, key);
}
%>
