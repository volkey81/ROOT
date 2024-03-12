<%@page import="com.efusioni.stone.common.SystemChecker"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="java.text.Format"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page contentType = "text/html;charset=EUC-KR"%>
<%@ page import = "sciclient.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>

<%
	Param param = new Param(request);

    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma", "no-store");
    response.setHeader("Cache-Control", "no-cache");

	// 소켓통신을 위한 정보 설정
	String strTypeCode   = "0200";		     // 전문종별코드
	String strDocCode    = "311";	         // 업무구분코드
	String strHostIP     = SystemChecker.isReal() ? "210.207.91.239" : "210.207.91.215";  // 서버IP 설정(SCI평가정보에서 제공)
	String strPort	     = "27040";	         // 소켓 Port 설정(SCI평가정보에서 제공)
	String strReturnCode = "000";		     // 응답코드			 
	String strSequence	 = "0000000001";	 // 순번(요청건별로 유일한 값으로 설정하여 전송결과 값과 비교)
	String message       ="";
	int timeout = 5;                         // receive timeout 설정 (단위:초)

	StringBuffer strRecvBuf = new StringBuffer("");
	String strSendBuf    = "";               // 전송전문 Buf
	String strRecv       = "";
	byte[] bRtn = null;

	// 응답전문 변수선언
	String strBirth = "";
	String strGender = "";
	String strFgnGbn = "";
	String strSrvNo = "";
	String strReqNum = "";
	String strHpno = "";
	String strName = "";
	String strResult = "";
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

	String certMsg = "";
	String encCertMsg = "";


	// 검증을 위한 변수
	String reqInfo		= Utils.safeHTML(param.get("reqPccInfo"));
	String confirmSeq	= Utils.safeHTML(param.get("confirmSeq"));		// 재전송순번
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

	//암호화 모듈 (jar) Loading
	com.sci.v2.comm.secu.SciSecuManager sciSecuMg = new com.sci.v2.comm.secu.SciSecuManager();

	// reqInfo 결과값 복호화 : 내부 전송간 암/복호화는 Key값이 없도록 하였음
	String retInfo = sciSecuMg.getDec(reqInfo, "");
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
	info_strBirth	 = retInfo.substring(info1 + 1, info2);
	info_strGender	 = retInfo.substring(info2 + 1, info3);
	info_strFgnGbn	 = retInfo.substring(info3 + 1, info4);
	info_strSrvNo	 = retInfo.substring(info4 + 1, info5);
	info_strReqNum	 = retInfo.substring(info5 + 1, info6);
	info_strName	 = retInfo.substring(info6 + 1, info7);
	info_strPhnGb	 = retInfo.substring(info7 + 1, info8);
	info_strHpno	 = retInfo.substring(info8 + 1, info9);
	info_strCertDate = retInfo.substring(info9 + 1, info10);
	info_strPccSeq	 = retInfo.substring(info10 + 1, info11);
	info_strAuthSeq	 = retInfo.substring(info11 + 1, info12);
	info_strResult	 = retInfo.substring(info12 + 1);

	SocketClient sock = new SocketClient();

	try 
	{

		// 소켓통신을 위한 전문 생성
		String strPara = info_strBirth + info_strGender + info_strFgnGbn 
							+ info_strSrvNo + info_strReqNum + info_strName + info_strPhnGb + info_strHpno 
							+ info_strPccSeq + info_strAuthSeq;

		strSendBuf = info_id  + strTypeCode + strDocCode + strReturnCode + strSequence + strPara;


		if(strSendBuf.length() > 0)	
		{
			// 소켓통신 요청 및 결과 수신
			strRecvBuf = sock.SendWritePacket(strHostIP, strPort, timeout, strSendBuf);
			strRecv = strRecvBuf.substring(0, strRecvBuf.length());
			bRtn = strRecvBuf.toString().getBytes("EUC-KR");

			strReturnCode = strRecvBuf.substring(15,18);

			if(strReturnCode.equals("000")) 
			{
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
				byte[] btResult		= new byte[1];
				byte[] btHpCode		= new byte[10];
				byte[] btPccSeq		= new byte[16];
				byte[] btAuthSeq	= new byte[2];
				byte[] btSmsSeq		= new byte[2];

				//생년월일
				System.arraycopy(bRtn, 28, btBirth, 0, 8);
				strBirth = new String(btBirth);

				//성별
				System.arraycopy(bRtn, 36, btGender, 0, 1);
				strGender = new String(btGender);

				//내외국인구분
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
				
				int len = 0;
				// 이름 60 byte padding 
				len = strName.getBytes("EUC-KR").length;
				
				if (len < 60) {
					for (int i=0; i < (60-len); i++) 
					{
						strName = strName + " ";
					}
				}

				//이통사구분
				System.arraycopy(bRtn, 144, btPhnGb, 0, 3);
				strPhnGb = new String(btPhnGb);

				//휴대폰번호
				System.arraycopy(bRtn, 147, btHpno, 0, 11);
				strHpno = new String(btHpno);

				//재전송 요청 결과
				System.arraycopy(bRtn, 158, btResult, 0, 1);
				strResult = new String(btResult);

				//휴대폰 인증 결과코드
				System.arraycopy(bRtn, 159, btHpCode, 0, 10);
				strHpCode = new String(btHpCode);
				
				//본인확인순번
				System.arraycopy(bRtn, 169, btPccSeq, 0, 16);
				strPccSeq = new String(btPccSeq);

				//인증순번
				System.arraycopy(bRtn, 185, btAuthSeq, 0, 2);
				strAuthSeq = new String(btAuthSeq);

				//SMS 발송순번
				System.arraycopy(bRtn, 187, btSmsSeq, 0, 2);
				strSmsSeq = new String(btSmsSeq);
				
				
				// 최종 확인 및 SMS 재전송 변수 생성
				certMsg = info_id + "/" + strBirth + "/" + strGender + "/" +  strFgnGbn + "/" + strSrvNo + "/" + strReqNum + "/" 
								+ strName + "/" + strPhnGb + "/" + strHpno + "/" + info_strCertDate + "/" + strPccSeq + "/" + strAuthSeq + "/" + strResult ;

				encCertMsg = sciSecuMg.getEnc(certMsg, "");

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
				 strReturnCode = "(113)서DataBase 처리 실패";
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
			message = this.returnMessage(strHpCode.trim());
		}else{
			message = 	strReturnCode;
		}
	}
	catch(Exception e)
	{
		e.printStackTrace();
		out.println("본인인증 에러입니다");
	}
	finally {
		sock.Disconnect(); 
%>
{"result" : "<%=StringUtils.equals("NME0000", strHpCode.trim()) ? "true" : "false" %>" ,"message" : "<%=message %>", "confirmSeq" : "<%=strSmsSeq%>" ,"reqInfo" :"<%=encCertMsg %>"}
<%
    }
%>

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
			msg = "시스템 오류(통신사 장애)입니다.\n잠시후 다시 시도해 주세요";
		}else if(StringUtils.equals(errCode, "NME0099")){
			msg = "시스템 오류(기타 오류)입니다.\n잠시후 다시 시도해 주세요";
		}
	
		return msg;
	}

%>

