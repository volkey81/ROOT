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
	String strSocMmbYn = "Y";                                                           //SNS 소셜회원여부
	String strSocKindCd = Utils.safeHTML(param.get("cSnsKind"));                        //소셜종류
	String strSocId = Utils.safeHTML(param.get("cSocId"));                              //소셜아이디
	String strSocNm = Utils.safeHTML(param.get("cSocNm"));                              //소셜이름
	String strGndrDvCd = "5";                  									        //성별구분코드
	String strStrFgnGbn = "1";                                                          //외국인구분코드
	String strCertDv = "0";                                                             //본인인증구분코드
	String strEmlAddr = Utils.safeHTML(param.get("cEmlAddr"));                          //이메일주소(abc@abc.com)
// 	String strNtryPath = Config.get("join.parameter.ntryPath");                         //사이트코드
	String strNtryPath   = SanghafarmUtils.getNtryPath(request);                       //사이트코드
	String strBirth = Utils.safeHTML(param.get("cBirth"));                              //생년월일(YYYYMMDD)
	String strBtdyLucrDvCd = Utils.safeHTML(param.get("cBtdyLucrDvCd"));                //양력/음력구분코드

	String strAgrmNo1 = Utils.safeHTML(param.get("cAgrmNo1"));                          //매일멤버십이용약관
	String strAgrmNo2 = Utils.safeHTML(param.get("cAgrmNo2"));                          //개인정보수집 이용동의
	String strAgrmNo7010 = Utils.safeHTML(param.get("cAgrmNo7010"));                    //개인정보 제3자제공동의
	String strAppPushRecv = Utils.safeHTML(param.get("cAppPushRecv"));                  //마케팅 수신동의(push)
	String strSmsRecv = Utils.safeHTML(param.get("cSmsRecv"));                          //마케팅 수신동의(sms)
	String strEmlRecv = Utils.safeHTML(param.get("cEmlRecv"));                          //마케팅 수신동의(email)
	String strWrlTel = Utils.safeHTML(param.get("cWrlTel"));                            //무선전화번호(01012345678)
	String query         = "";                                                          //postQuery
	String strResult ="";                                                               //전송결과
	String strMessage ="";                                                              //결과메세지
	String strResultCode ="";                                                           //결과코드
	String unfyMmbNo = "";
	
	//회원가입URL작성
	query = "coopcoCd=" + strCoopcoCd 
			     + "&chnlCd=" + strChnlCd 
			     + "&socMmbYn=" + strSocMmbYn
			     + "&socKindCd=" + strSocKindCd
			     + "&socId=" + strSocId
			     + "&socNm=" + strSocNm
			     + "&gndrDvCd=" + strGndrDvCd
			     + "&strFgnGbn=" + strStrFgnGbn
			     + "&certDv=" + strCertDv
			     + "&emlAddr=" + strEmlAddr
			     + "&ntryPath=" + strNtryPath
			     + "&birth=" + strBirth
			     + "&btdyLucrDvCd=" + strBtdyLucrDvCd
			     + "&agrmNo1=" + strAgrmNo1
			     + "&agrmNo2=" + strAgrmNo2
			     + "&agrmNo7010=" + strAgrmNo7010
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

	//API데이터 취득
	result = SanghafarmUtils.getAPIDataInfo(joinDataUrl, query);
 	strResult = result.getString("resultCode");
 	unfyMmbNo = result.getJSONObject("data").getString("unfyMmbNo");

	if(!strResult.equals("S0000")){
		joinUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/joinFail.jsp";
		response.sendRedirect(joinUrl);
		return;
	}
// 	joinUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/joinComplete.jsp";
%>

	<!-- 
	<script type="text/javascript">
	    location.href = "<%=joinUrl%>";
	</script>
	 -->
	 
	<form name="joinForm" id="joinForm" action="joinStep4.jsp" method="post">
		<input type="hidden" name="userid" value="<%= unfyMmbNo %>_<%= strSocKindCd %>">
		<input type="hidden" name="unfy_mmb_no" value="<%= unfyMmbNo %>">
		<input type="hidden" name="type" value="<%= param.get("type") %>">
	</form>
	<script>
		document.joinForm.submit();
	</script>