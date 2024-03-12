<%@page import="com.efusioni.stone.common.SystemChecker"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page contentType = "text/html;charset=EUC-KR"%>
<%@ page import = "sciclient.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.io.*" %>

<%
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma", "no-store");
    response.setHeader("Cache-Control", "no-cache");
    
    String rtest = "";
	String certMsg ="";
	String result = "";
    
  	//시간 체크		
	long  _accessTime = session.getAttribute("_last_send_sms_time") == null ? 1 : (Long)(session.getAttribute("_last_send_sms_time")); 

	if ( _accessTime > 0 ){
		long	_currNowTime	=	System.currentTimeMillis();
        long	_intervalTime	=	_currNowTime - _accessTime;
        long	_expireTime		=	3000;	//3초          

        //3초내 접근
        if ( _intervalTime < _expireTime ){	
        	result = "false";	
			return;
        } else {
        	session.setAttribute("_last_send_sms_time", System.currentTimeMillis());
        }
	}
    
	// 인증을 위한 필수 데이터 받기
	Param param = new Param(request);

	// 소켓통신을 위한 정보 설정
	String strTypeCode   = "0200";		     // 전문종별코드
	String strDocCode    = "310";	         // 업무구분코드
	String strHostIP     = SystemChecker.isReal() ? "210.207.91.239" : "210.207.91.215"; // 서버IP 설정(SCI평가정보에서 제공)
	String strPort	     = "27040";	         // 소켓 Port 설정(SCI평가정보에서 제공)
	String strReturnCode = "000";		     // 응답코드			 
	String strSequence	 = "0000000001";	 // 순번(요청건별로 유일한 값으로 설정하여 전송결과 값과 비교)
	
	int timeout = 5;                         // receive timeout 설정 (단위:초)

	StringBuffer strRecvBuf = new StringBuffer("");
	String strSendBuf    = "";               // 전송전문 Buf
	String strRecv       = "";
	String rtnString     = "";

	byte[] bRtn = null;
	int len = 0;
	int i = 0;
	
	String message		= StringUtils.EMPTY;
	String birth		= Utils.safeHTML(param.get("birth"));	   // 생년월일(YYYYMMDD)
	String gender		= Utils.safeHTML(param.get("gender"));	   // 성별(M-남, F-여)
	String fgnGbn		= Utils.safeHTML(param.get("fgnGbn"));	   // 내/외국인구분(1-내국인, 2-외국인)
	String id			= "MIU004";	                               // 본인확인 회원사 아이디
	String srvNo		= "020001";                                // 본인확인 서비스번호
	String reqNum		= Utils.safeHTML(param.get("reqNum"));	   // 본인확인 요청번호
	String name			= Utils.safeHTML(param.get("name"));	   // 성명
	String hpcorp		= Utils.safeHTML(param.get("hpcorp"));	   // 이통사
	String hpno			= Utils.safeHTML(param.get("hpno"));	   // 휴대폰번호
	String certDate		= Utils.safeHTML(param.get("certDate"));   // 검증시간
	// 서버 결과 수신 변수
	String rBirth       = "";                                               // 생년월일
	String rGender      = "";                                               // 성별
	String rFgnGbn      = "";                                               // 내외국인구분
	String rid			= "";                                               // 회원사 아이디
	String rSrvNo	    = "";                                               // 서비스번호
	String rReqNum      = "";                                               // 본인확인 요청번호
	String rName        = "";                                               // 성명
	String rHpno        = "";                                               // 핸드폰 번호
	String rResult      = "";                                               // 본인확인결과 (Y/N/M)
	String rHpcorp      = "";                                               // 이통사 구분
	String rCertDate    = "";                                               // 검증시간
	String rHpcode      = "";                                               // 휴대폰 인증 결과 코드
	String rSmsnum      = "";                                               // 휴대폰 인증 번호
	String rRetCode     = "";                                               // 연동 결과?
	String rRetryM      = "";                                               // 발송 성공 여부(Y/N)
	String rPccSeq      = "";                                               // 본인 확인 순번
	String rAuthSeq     = "";                                               // 인증 순번
	String rDI			= "";
	String rCI			= "";
	String rCIVersion	= "";
	String encCertMsg   = "";
	String callBack = Utils.safeHTML(param.get("callback"));
	
	if (SystemChecker.isReal()) {
        srvNo = "020001";	
	}else{
        srvNo = "018007";
//         srvNo = "027001";
	}
	

	// 암호화 모듈 및 통신모듈 선언
	com.sci.v2.comm.secu.SciSecuManager seed  = new com.sci.v2.comm.secu.SciSecuManager();

	SocketClient sock = new SocketClient();

	try 
	{
		// id 8 byte padding
		len = id.length();
		rtnString = id;
		rid = id;
		
		if (len < 8) {
			for (i=0; i < (8-len); i++) 
			{
				rtnString = rtnString + " ";
			}
		}
		id = rtnString;
		rtnString = "";
		
		// 이름 60 byte padding 
		len = name.getBytes("EUC-KR").length;
		rtnString = name;
		
		if (len < 60) {
			for (i=0; i < (60-len); i++) 
			{
				rtnString = rtnString + " ";
			}
		}
		name = rtnString;
		rtnString = "";

		// 휴대폰번호 11 byte padding
		len = hpno.getBytes().length;
		rtnString = hpno;
		
		if (len < 11) {
			for (i=0; i < (11-len); i++) 
			{
				rtnString = rtnString + " ";
			}
		}
		hpno = rtnString;
		rtnString = "";

		// 요청번호 40 byte padding
		len = reqNum.getBytes().length;
		rtnString = reqNum;
		
		if (len < 40) {
			for (i=0; i < (40-len); i++) 
			{
				rtnString = rtnString + " ";
			}
		}
		reqNum = rtnString;
		

		// 소켓통신을 위한 전문 생성
		String reqInfo = birth + gender + fgnGbn + srvNo + reqNum + name + hpcorp + hpno + certDate;
		strSendBuf = id + strTypeCode + strDocCode + strReturnCode + strSequence + reqInfo;
		System.out.println("===============================================strSendBuf:" + strSendBuf.getBytes("EUC-KR").length + ":" + strSendBuf);
		if(strSendBuf.length() > 0)	
		{
			//08. 소켓통신 요청 및 결과 수신
			strRecvBuf = sock.SendWritePacket(strHostIP, strPort, timeout, strSendBuf);
			System.out.println("-------------- " + strRecvBuf.length() + " : " + strRecvBuf);
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
				byte[] btHpCorp		= new byte[3];
				byte[] btHpno		= new byte[11];
				byte[] btCertDate	= new byte[14];
				byte[] btResult		= new byte[1];
				byte[] btHpCode		= new byte[10];
				byte[] btPccSeq		= new byte[16];
				byte[] btAuthSeq	= new byte[2];

				//생년월일
				System.arraycopy(bRtn, 28, btBirth, 0, 8);
				rBirth = new String(btBirth);
				System.out.println("-------------- rBirth : " + rBirth);

				//성별
				System.arraycopy(bRtn, 36, btGender, 0, 1);
				rGender = new String(btGender);
				System.out.println("-------------- rGender : " + rGender);

				//내외국인구분
				System.arraycopy(bRtn, 37, btFgnGbn, 0, 1);
				rFgnGbn = new String(btFgnGbn);
				System.out.println("-------------- rFgnGbn : " + rFgnGbn);

				//서비스번호
				System.arraycopy(bRtn, 38, btSrvNo, 0, 6);
				rSrvNo = new String(btSrvNo);
				System.out.println("-------------- rSrvNo : " + rSrvNo);

				//요청번호
				System.arraycopy(bRtn, 44, btReqNum, 0, 40);
				rReqNum = new String(btReqNum);
				System.out.println("-------------- rReqNum : " + rReqNum);

				//성명
				System.arraycopy(bRtn, 84, btName, 0, 60);
				rName = new String(btName);
				System.out.println("-------------- rName : " + rName);
				
				// 이름 60 byte padding 
				len = rName.getBytes("EUC-KR").length;
				
				if (len < 60) {
					for (i=0; i < (60-len); i++) 
					{
						rName = rName + " ";
					}
				}
				System.out.println("-------------- rName : " + rName);
				
				//이통사
				System.arraycopy(bRtn, 144, btHpCorp, 0, 3);
				rHpcorp = new String(btHpCorp);
				System.out.println("-------------- rHpcorp : " + rHpcorp);
				
 				//휴대폰번호
				System.arraycopy(bRtn, 147, btHpno, 0, 11);
				rHpno = new String(btHpno);
				System.out.println("-------------- rHpno : " + rHpno);
				
				//요청일시
				System.arraycopy(bRtn, 158, btCertDate, 0, 14);
				rCertDate = new String(btCertDate);
				System.out.println("-------------- rCertDate : " + rCertDate);
				
                //결과값
				System.arraycopy(bRtn, 172, btResult, 0, 1);
				rResult = new String(btResult);
				System.out.println("-------------- rResult : " + rResult);

 				//휴대폰인증결과코드
				System.arraycopy(bRtn, 173, btHpCode, 0, 10);
				rHpcode = new String(btHpCode);
				System.out.println("-------------- rHpcode : " + rHpcode);

				//본인확인순번
				System.arraycopy(bRtn, 183, btPccSeq, 0, 16);
				rPccSeq = new String(btPccSeq);
				System.out.println("-------------- rPccSeq : " + rPccSeq);

				//인증순번
				System.arraycopy(bRtn, 199, btAuthSeq, 0, 2);
				rAuthSeq = new String(btAuthSeq); 
				System.out.println("-------------- rAuthSeq : " + rAuthSeq);
				

				// SMS 확인 및 재전송을 위한 변수 조합 하기
				certMsg = id + "/" + rBirth + "/" + rGender + "/" +  rFgnGbn + "/" + rSrvNo + "/" + rReqNum + "/" 
								+ rName + "/" + rHpcorp + "/" + rHpno + "/"  + rCertDate + "/" + rPccSeq + "/" + rAuthSeq + "/" + rResult;

				System.out.println("------ certMsg : " + certMsg);
				// 내부 페이지 이동시 사용되는 변수들은 Key를 사용 하지 않고 암호화 함.
				encCertMsg = seed.getEnc(certMsg, "");
				System.out.println("------ encCertMsg : " + encCertMsg);

			} 
			else if(strReturnCode.equals("001")) 
			{
				 strReturnCode = "(001)사용자 ID 오류";
			}
			else if(strReturnCode.equals("003")) 
			{
				 strReturnCode = "(003)사용권한 없음";
			}
			else if(strReturnCode.equals("111")) 
			{
				 strReturnCode = "(111)SCI평가정보 System 장애";
			}
			else if(strReturnCode.equals("112")) 
			{
				 strReturnCode = "(112)SCI평가정보 DataBase 장애";
			}
			else if(strReturnCode.equals("113")) 
			{
				 strReturnCode = "(113)DataBase 처리 실패";
			} 
 			else if(strReturnCode.equals("299")) 
			{
				 strReturnCode = "(299)전문 Format Type Error";
			} 
 			else if(strReturnCode.equals("295")) 
			{
				 strReturnCode = "(295)전문 길이 오류";
			} 
			else if(strReturnCode.equals("301")) 
			{
				 strReturnCode = "(301)전문 종별 코드 오류";
			} 
			else if(strReturnCode.equals("302")) 
			{
				 strReturnCode = "(302)업무 구분 코드 오류";
			} 
			else if(strReturnCode.equals("303")) 
			{
				 strReturnCode = "(303)응답 코드 오류";
			} 
			else 
			{
				 strReturnCode = "기타 오류";
			}
			
		} 
		else 
		{
			strReturnCode = "조회 전문 null";
		}
		
		if (strReturnCode.equals("true")){
			message = this.returnMessage(rHpcode.trim());
			if(StringUtils.equals("NME0000", rHpcode.trim())){
				result = "true"; 
			}else{
				result = "false";
			}			
		}else{
			result = "false";
			message = 	strReturnCode;
		}
		
	}
	catch(Exception e)
	{
		e.printStackTrace();
		System.out.println(e.getMessage());
		System.out.println("본인인증 에러입니다");
	}
	finally {
		sock.Disconnect();
	}
%>
{"result" : "<%=result %>", "message" : "<%=message %>", "certMsg" : "<%=encCertMsg%>"}
<%!
	private String returnMessage(String errCode){
	
	    String msg = "인증번호를 발송하였습니다.\\n인증번호를 입력해주세요.";

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
			msg = "시스템 오류(통신사 장애)입니다. 잠시후 다시 시도해 주세요";
		}else if(StringUtils.equals(errCode, "NME0099")){
			msg = "시스템 오류(기타 오류)입니다. 잠시후 다시 시도해 주세요";
		}
	
		return msg;
	}

%>