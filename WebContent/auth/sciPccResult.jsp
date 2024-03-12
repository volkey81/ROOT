<%@page import="net.sf.json.JSONSerializer"%>
<%@ page contentType = "text/html;charset=EUC-KR"%>
<%@ page import = "com.efusioni.stone.utils.Param"%>
<%@ page import = "sciclient.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "com.efusioni.stone.common.Config"%>
<%@ page import = "net.sf.json.JSONObject"%>
<%@ page import = "com.efusioni.stone.common.SystemChecker"%>
<%@ page import = "com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import = "com.sanghafarm.common.*"%>
<%@ page import = "com.sanghafarm.service.member.*"%>
<%@ page import = "org.apache.commons.lang.StringUtils"%>
<%@ page import = "com.efusioni.stone.utils.Utils"%>
<%
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma", "no-store");
    response.setHeader("Cache-Control", "no-cache");
    
    Param param = new Param(request);

	// 소켓통신을 위한 정보 설정
	String strTypeCode   = "0200";		     // 전문종별코드
	String strDocCode    = "312";	         // 업무구분코드
	String strHostIP     = SystemChecker.isReal() ? "210.207.91.239" : "210.207.91.215";  // 서버IP 설정(SCI평가정보에서 제공)
	String strPort	     = "27040";	         // 소켓 Port 설정(SCI평가정보에서 제공)
	String strReturnCode = "000";		     // 응답코드			 
	String strSequence	 = "0000000001";	 // 순번(요청건별로 유일한 값으로 설정하여 전송결과 값과 비교)
	int timeout = 5;                         // receive timeout 설정 (단위:초)

	StringBuffer strRecvBuf = new StringBuffer("");
	String strSendBuf    = "";               // 전송전문 Buf
	String strRecv       = "";
	String apiData       = "";
	byte[] bRtn = null;

	// 응답전문 변수선언
	String strBirth = "";
	String strGender = "";
	String strFgnGbn = "";
	String strSrvNo = "";
	String strReqNum = "";
	String strHpno = "";
	String strName = "";
	String strPhnGb = "";
	String strCertDate = "";
	String strHpCode = "";
	String strSmsNum = "";
	String strSmsSeq = "";
	String strRetCode = "";
	String strRetryM = "";
	String strPccSeq = "";
	String strAuthSeq = "";
	String strDi = "";
	String strCiVer = "";
	String strCi = "";
	String strScreenCd     = Utils.safeHTML(param.get("screenCd"));		// 화면판별
	String strPwdFindId    = Utils.safeHTML(param.get("userId"));		// 유저ID
	String query         = "";                                          //postQuery
	String userCi		 = Utils.safeHTML(param.get("ci").replaceAll(" ", "+"));		    // 유저CI
// 	String userCi		 = URLDecoder.decode(param.get("ci"), "utf-8");		    // 유저CI

	// 검증을 위한 변수
	String reqInfo		= Utils.safeHTML(param.get("reqPccInfo"));
	String smsnum		= Utils.safeHTML(param.get("smsnum"));			// 인증번호
	String confirmSeq	= Utils.safeHTML(param.get("confirmSeq"));		// 재전송순번
	String reJoinFlg    = Utils.safeHTML(param.get("reJoinFlg","N"));   // 재가입판별 플레그
	String strUnfyMmbNo = Utils.safeHTML(param.get("unfyMmbNo",""));    // 통합회원번호
	String info_id = "";
	String info_strBirth = "";
	String info_strGender = "";
	String info_strFgnGbn = "";
	String info_strSrvNo = "";
	String info_strReqNum = "";
	String info_strName = "";
	String info_strPhnGb = "";
	String info_strHpno = "";
	String info_strCertDate = "";
	String info_strPccSeq = "";
	String info_strAuthSeq = "";
	String info_strResult = "";

	// API통신용 변수
	String strCoopcoCd = Config.get("join.parameter.coopcoCd");             //제휴사코드
	String strchnlCd = Config.get("join.parameter.chnlCd");                 //채널코드
	String resultCode = "";                                                 //처리코드
	String resultMessage = "";                                              //처리메세지
	String apiUrl = "";                                                     //APIURL
	String strResult = "";                                                  //결과
	String strResultCode = "";                                              //결과코드
	JSONObject result = new JSONObject();                                   //통신결과(JSONObject)

	try {

		// 암호화 모듈 (jar) Loading
		com.sci.v2.comm.secu.SciSecuManager sciSecuMg = new com.sci.v2.comm.secu.SciSecuManager();

		// reqInfo 결과값 복호화 : 내부 전송간 암/복호화는 Key값이 없도록 하였음
		String retInfo = sciSecuMg.getDec(reqInfo, "");
		System.out.println("--------------------- retInfo : " + retInfo);
		int info1 = retInfo.indexOf("/", 0);
		int info2 = retInfo.indexOf("/", info1 + 1);
		int info3 = retInfo.indexOf("/", info2 + 1);
		int info4 = retInfo.indexOf("/", info3 + 1);
		int info5 = retInfo.indexOf("/", info4 + 1);            
		int info6 = retInfo.indexOf("/", info5 + 1);            
		int info7 = retInfo.indexOf("/", info6 + 1);            
		int info8 = retInfo.indexOf("/", info7 + 1);            
		int info9 = retInfo.indexOf("/", info8 + 1);            
		int info10 = retInfo.indexOf("/", info9 + 1);
		int info11 = retInfo.indexOf("/", info10 + 1);
		int info12 = retInfo.indexOf("/", info11 + 1);
		
		// 복화화된 정보를 "/" 구분 해서 값 분리 하기
		info_id			 = retInfo.substring(0, info1);
// 		System.out.println("----------- info_id : " + info_id);
		info_strBirth	 = retInfo.substring(info1 + 1, info2);
// 		System.out.println("----------- info_strBirth : " + info_strBirth);
		info_strGender	 = retInfo.substring(info2 + 1, info3);
// 		System.out.println("----------- info_strGender : " + info_strGender);
		info_strFgnGbn	 = retInfo.substring(info3 + 1, info4);
// 		System.out.println("----------- info_strFgnGbn : " + info_strFgnGbn);
		info_strSrvNo	 = retInfo.substring(info4 + 1, info5);
// 		System.out.println("----------- info_strSrvNo : " + info_strSrvNo);
		info_strReqNum	 = retInfo.substring(info5 + 1, info6);
// 		System.out.println("----------- info_strReqNum : " + info_strReqNum);
		info_strName	 = retInfo.substring(info6 + 1, info7);
// 		System.out.println("----------- info_strName : " + info_strName);
		info_strPhnGb	 = retInfo.substring(info7 + 1, info8);
// 		System.out.println("----------- info_strPhnGb : " + info_strPhnGb);
		info_strHpno	 = retInfo.substring(info8 + 1, info9);
// 		System.out.println("----------- info_strHpno : " + info_strHpno);
		info_strCertDate = retInfo.substring(info9 + 1, info10);
// 		System.out.println("----------- info_strCertDate : " + info_strCertDate);
		info_strPccSeq	 = retInfo.substring(info10 + 1, info11);
// 		System.out.println("----------- info_strPccSeq : " + info_strPccSeq);
		info_strAuthSeq	 = retInfo.substring(info11 + 1, info12);
// 		System.out.println("----------- info_strAuthSeq : " + info_strAuthSeq);
		info_strResult	 = retInfo.substring(info12 + 1);
// 		System.out.println("----------- info_strResult : " + info_strResult);

	} catch (Exception ex) {
		System.out.println("[pccV5] Receive Error -" + ex.getMessage());
	}

	// 암호화 모듈 선언
	com.sci.v2.comm.secu.SciSecuManager seed  = new com.sci.v2.comm.secu.SciSecuManager();
	SocketClient sock = new SocketClient();

	try {

		// 소켓통신을 위한 전문 생성
		String resultMsg = info_strBirth + info_strGender + info_strFgnGbn + info_strSrvNo + info_strReqNum 
						+ info_strName + info_strPhnGb + info_strHpno + info_strCertDate + info_strPccSeq + info_strAuthSeq + confirmSeq + smsnum;

		strSendBuf = info_id + strTypeCode + strDocCode + strReturnCode + strSequence + resultMsg;
		
		if(strSendBuf.length() > 0)	{

			// 13. 소켓통신 요청 및 결과 수신
			strRecvBuf = sock.SendWritePacket(strHostIP, strPort, timeout, strSendBuf);
			strRecv = strRecvBuf.substring(0, strRecvBuf.length());
			bRtn = strRecvBuf.toString().getBytes("EUC-KR");

			strReturnCode = strRecvBuf.substring(15,18);

			if(strReturnCode.equals("000")) {

				//strReturnCode = "(000)정상처리";
				strReturnCode = "true";				

				byte[] btBirth		= new byte[8];
				byte[] btGender		= new byte[1];
				byte[] btFgnGbn		= new byte[1];
				byte[] btSrvNo		= new byte[6];
				byte[] btReqNum		= new byte[40];
				byte[] btName		= new byte[60];
				byte[] btPhnGb		= new byte[3];
				byte[] btHpno		= new byte[11];
				byte[] btCertDate	= new byte[14];
				byte[] btPccSeq		= new byte[16];
				byte[] btAuthSeq	= new byte[2];
				byte[] btSmsSeq		= new byte[2];
				byte[] btSmsNum		= new byte[6];
				byte[] btRetryM		= new byte[1];
				byte[] btHpCode		= new byte[10];
				byte[] btDI			= new byte[64];
				byte[] btCIVer		= new byte[1];
				byte[] btCI			= new byte[88];


				//생년월일
				System.arraycopy(bRtn, 28, btBirth, 0, 8);
				strBirth = new String(btBirth);

				//성별
				System.arraycopy(bRtn, 36, btGender, 0, 1);
				strGender = new String(btGender);

				//내외국인번호
				System.arraycopy(bRtn, 37, btFgnGbn, 0, 1);
				strFgnGbn = new String(btFgnGbn);

				//서비스번호
				System.arraycopy(bRtn, 38, btSrvNo, 0, 6);
				strSrvNo = new String(btSrvNo);
				
				//요청번호
				System.arraycopy(bRtn, 44, btReqNum, 0, 40);
				strReqNum = new String(btReqNum);
				
				//성명
				System.arraycopy(bRtn, 84, btName, 0, 60);
				strName = new String(btName);

				//이통사 구분
				System.arraycopy(bRtn, 144, btPhnGb, 0, 3);
				strPhnGb = new String(btPhnGb);

				//휴대폰번호
				System.arraycopy(bRtn, 147, btHpno, 0, 11);
				strHpno = new String(btHpno);

				//요청일시
				System.arraycopy(bRtn, 158, btCertDate, 0, 14);
				strCertDate = new String(btCertDate);

				//본인확인순번
				System.arraycopy(bRtn, 172, btPccSeq, 0, 16);
				strPccSeq = new String(btPccSeq);

				//인증순번
				System.arraycopy(bRtn, 188, btAuthSeq, 0, 2);
				strAuthSeq = new String(btAuthSeq);
				
				//재전송순번
				System.arraycopy(bRtn, 190, btSmsSeq, 0, 2);
				strSmsSeq = new String(btSmsSeq);

				//SMS 인증번호
				System.arraycopy(bRtn, 192, btSmsNum, 0, 6);
				strSmsNum = new String(btSmsNum);

				//인증번호 확인 결과
				System.arraycopy(bRtn, 198, btRetryM, 0, 1);
				strRetryM = new String(btRetryM);

				//휴대폰인증결과코드
				System.arraycopy(bRtn, 199, btHpCode, 0, 10);
				strHpCode = new String(btHpCode);

				//DI(중복가입확인정보)
				System.arraycopy(bRtn, 209, btDI, 0, 64);
				strDi = new String(btDI);

				//CI 버전
				System.arraycopy(bRtn, 273, btCIVer, 0, 1);
				strCiVer = new String(btCIVer);

				//CI
				System.arraycopy(bRtn, 274, btCI, 0, 88);
				strCi = new String(btCI);

			}else if(strReturnCode.equals("001")) {
				 strReturnCode = "(001)사용자 ID 오류";
			}else if(strReturnCode.equals("003")) {
				 strReturnCode = "(003)사용권한 없음";
			}else if(strReturnCode.equals("111")) {
				 strReturnCode = "(111)SCI평가정보 System 장애";
			}else if(strReturnCode.equals("112")) {
				 strReturnCode = "(112)SCI평가정보 DataBase 장애";
			}else if(strReturnCode.equals("113")) {
				 strReturnCode = "(113)서DataBase 처리 실패";
			}else if(strReturnCode.equals("299")) {
				 strReturnCode = "(299)전문 Format Type Error";
			}else if(strReturnCode.equals("295")) {
				 strReturnCode = "(295)전문 길이 오류";
			}else if(strReturnCode.equals("301")) {
				 strReturnCode = "(301)전문 종별 코드 오류";
			}else if(strReturnCode.equals("302")) {
				 strReturnCode = "(302)업무 구분 코드 오류";
			}else if(strReturnCode.equals("303")) {
				 strReturnCode = "(303)응답 코드 오류";
			}else {
				 strReturnCode = "기타 오류";
			}

		}else{
			strReturnCode = "조회 전문 null";
		}

		if (strReturnCode.equals("true")){
			resultMessage = this.returnMessage(strHpCode.trim());
			if(StringUtils.equals("NME0000", strHpCode.trim())){
				strResult = "true";
				session.setAttribute("name", strName);
				session.setAttribute("hpno", strHpno);
				session.setAttribute("birth", strBirth);
			}else{
				strResult = "false";
			}			
		}else{
			strResult = "false";
			resultMessage = strReturnCode;
		}
		
		//회원가입 여부 체크
		if(strScreenCd.equals("join") && strResult.equals("true") && reJoinFlg.equals("N")){
			apiUrl = Config.get("api.join.checkJoin." + SystemChecker.getCurrentName()); //APIURL
		
			query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd + "&ci=" + URLEncoder.encode(strCi, "UTF-8");
			result = SanghafarmUtils.getAPIDataInfo(apiUrl, query);
			strResultCode = result.getString("resultCode");
			
			int today = Integer.parseInt(Utils.getTimeStampString("yyyyMMdd"));
			System.out.println("-------- strBirth : " + strBirth);
			System.out.println("-------- today : " + today);
			
			if(Integer.parseInt(strBirth) + 140000 > today) {
				strResult = "false";
				resultMessage = "만 14세 미만의 회원님은 가입하실 수 없습니다.";
			} else if(strResultCode.equals("E1003")){
				strResult = "reJoin";
			}else if(strResultCode.equals("E2001") ){
				strResult = "falseJoin";
				resultMessage = result.getString("resultMessage");
			}else if(!strResultCode.equals("S0000") ){
				strResult = "false";
				resultMessage = result.getString("resultMessage");
			}else{
				resultMessage = "인증 되었습니다.\\n회원 가입 페이지로 이동합니다.";
			}
			//재가입
		}else if(strScreenCd.equals("join") && strResult.equals("true") && reJoinFlg.equals("Y")){
			apiUrl = Config.get("api.join.reJoinUser." + SystemChecker.getCurrentName()); //APIURL
		
			query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd + "&ci=" + URLEncoder.encode(strCi, "UTF-8");
			result = SanghafarmUtils.getAPIDataInfo(apiUrl, query);
			
			if(!result.getString("resultCode").equals("S0000") ){
				strResult = "false";
				resultMessage = result.getString("resultMessage");
			}else{
				strResult = "reJoinComplete";
			}
			//아이디 찾기
		}else if(strScreenCd.equals("findId") && strResult.equals("true")){
			apiUrl = Config.get("api.info.findMmbId." + SystemChecker.getCurrentName()); //APIURL
		
			query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd + "&ci=" + URLEncoder.encode(strCi, "UTF-8");
			result = SanghafarmUtils.getAPIDataInfo(apiUrl, query);
			
			if(!result.getString("resultCode").equals("S0000") ){
				strResult = "false";
				resultMessage = result.getString("resultMessage");
			}else{
				JSONObject id = new JSONObject();
				id = (JSONObject)JSONSerializer.toJSON(result.getString("data"));
				apiData = id.getString("mmbId");
			}
			//비밀번호 찾기
		}else if(strScreenCd.equals("findPwd") && strResult.equals("true")){
			apiUrl = Config.get("api.info.isSameMmb." + SystemChecker.getCurrentName()); //APIURL
		
			query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd + "&ci=" + URLEncoder.encode(strCi, "UTF-8") + "&id=" + strPwdFindId;
			result = SanghafarmUtils.getAPIDataInfo(apiUrl, query);
			
			if(!result.getString("resultCode").equals("S0000") ){
				strResult = "false";
				resultMessage = result.getString("resultMessage");
			}else{
				strResult = "true";
				resultMessage = result.getString("resultMessage");
			}
			
			session.setAttribute("SCI_AUTH", "Y");
			//휴면해제
		}else if(strScreenCd.equals("memInactive") && strResult.equals("true")){
			apiUrl = Config.get("api.info.rlsSleepUser." + SystemChecker.getCurrentName()); //APIURL
		
			query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd + "&unfyMmbNo=" + strUnfyMmbNo + "&socMmbYn=N" + "&ci=" + URLEncoder.encode(strCi, "UTF-8");
			result = SanghafarmUtils.getAPIDataInfo(apiUrl, query);
			
			if(!result.getString("resultCode").equals("S0000") ){
				strResult = "false";
				resultMessage = result.getString("resultMessage");
			}else{
				strResult = "true";
			}
			//회원정보수정
		}else if(strScreenCd.equals("infoModify") && strResult.equals("true")){

			if(!strReturnCode.equals("true")){
				strResult = "false";
			}else if(!userCi.equals(strCi)){
				System.out.println("===========================userCi:" + userCi);
				System.out.println("===========================strCi:" + strCi);
				strResult = "ciErr";
				resultMessage = "사용자 정보가 일치하지 않습니다.";
			}else{
				strResult = "true";
			}
		} else if("adultAuth".equals(strScreenCd) && "true".equals(strResult)) {	// 성인인증
			Calendar cal = Calendar.getInstance();
			cal.set(Calendar.YEAR, cal.get(Calendar.YEAR) - 19);
			String dd = Utils.getTimeStampString(cal.getTime(), "yyyyMMdd");

			System.out.println("-------------------- " + strBirth);
			System.out.println("-------------------- " + dd);
			System.out.println("-------------------- " + strCi);
			
			if(dd.compareTo(strBirth) < 0) {	// 미성년
				resultMessage = "만 19세 미만이므로 주류 상품을 구매할 수 없습니다.";
			} else {
				FrontSession fs = FrontSession.getInstance(request, response);
				MemberService member = (new MemberService()).toProxyInstance();
				Param info = member.getImInfo(fs.getUserNo());
				
				System.out.println("----------- " + info.get("sef_cert_ci").replaceAll(" ", "+"));
				System.out.println("----------- " + strCi);
				
				if(!strCi.equals(info.get("sef_cert_ci").replaceAll(" ", "+"))) {
					resultMessage = "- 회원정보와 19세 이상 본인인증 정보가 서로 일치하지 않습니다.\\n";
					resultMessage += "- Maeil Do 회원정보와 동일한 정보로 19세 이상 본인인증하세요.\\n";
					resultMessage += "- SNS회원인 경우, 본인 확인이 어려워 해당 상품을 구매하실 수 없습니다.";
				} else {
					member.modifyAdultAuth(fs.getUserId());
					SanghafarmUtils.setCookie(response, "ADULT_AUTH", "Y", fs.getDomain(), -1);
					resultMessage = "인증이 완료되었습니다.";
				}
			}
		}
	
	}catch(Exception e){
		e.printStackTrace();
		System.out.println("본인인증 에러입니다");
	}finally {
			sock.Disconnect();
			if(strScreenCd.equals("join")){
%>
{
 "result" : "<%=strResult %>" ,
 "message" : "<%=resultMessage %>",
 "strRetryM" : "<%=strRetryM %>",
 "di" : "<%=strDi %>",
 "ciVer" : "<%=strCiVer %>",
 "ci" : "<%=strCi %>" ,
 "fgnGbn" : "<%=strFgnGbn %>",
 "hpno" : "<%=strHpno %>",
 "birth" : "<%= strBirth %>" 
 }
<% 
			}else if(strScreenCd.equals("findId")){
%>
{
 "result" : "<%=strResult %>" ,
 "message" : "<%=resultMessage %>",
 "id" : "<%=apiData %>"
}
<%
			}else if(strScreenCd.equals("findPwd") || strScreenCd.equals("memInactive")){
%>
{
 "result" : "<%=strResult %>" ,
 "message" : "<%=resultMessage %>"
} 
<%
    		}else if(strScreenCd.equals("infoModify")){
%>
{
 "result" : "<%=strResult %>" ,
 "message" : "<%=resultMessage %>",
 "phno" : "<%=strHpno %>"
} 
<%
    		} else if("adultAuth".equals(strScreenCd)) {
%>
{
 "result" : "<%=strResult %>" ,
 "message" : "<%=resultMessage %>"
} 
<%
    	}
	}
%>

<%!
	private String returnMessage(String errCode){
	
	    String msg = "";
		
		if (StringUtils.equals(errCode, "NME0011")){
			msg = "통신사가 불일치합니다";
		}else if(StringUtils.equals(errCode, "NME0012")){
			msg = "명의가 불일치 합니다.(생년월일/성별)";
		}else if(StringUtils.equals(errCode, "NME0013")){
			msg = "분실/일시정지 휴대폰입니다.";
		}else if(StringUtils.equals(errCode, "NME0015")){
			msg = "사업자(법인) 명의 휴대폰입니다.";
		}else if(StringUtils.equals(errCode, "NME0017")){
			msg = "선불휴대폰입니다.";
		}else if(StringUtils.equals(errCode, "NME0024")){
			msg = "명의가 불일치 합니다.(성명)";
		}else if(StringUtils.equals(errCode, "NME0035")){
			msg = "SMS 승인번호가 발송 실패 했습니다.";
		}else if(StringUtils.equals(errCode, "NME0070")){
			msg = "인증번호를 다시 확인해주세요.";
		}else if(StringUtils.equals(errCode, "NME0071")){
			msg = "인증번호 재전송 횟수가 초과 되었습니다.";
		}else if(StringUtils.equals(errCode, "NME0072")){
			msg = "인증번호 입력 오류회수(5회)를 초과하였습니다.";
		}else if(StringUtils.equals(errCode, "NME0096")){
			msg = "5회 인증 오류 제한입니다.";
		}else if(StringUtils.equals(errCode, "NME0097")){
			msg = "입력정보에 오류가 있습니다.";
		}else if(StringUtils.equals(errCode, "NME0098")){
			msg = "시스템 오류(통신사 장애)입니다.\n잠시후 다시 시도해 주세요";
		}else if(StringUtils.equals(errCode, "NME0099")){
			msg = "시스템 오류(기타 오류)입니다.\n잠시후 다시 시도해 주세요";
		}
	
		return msg;
	}

%>
