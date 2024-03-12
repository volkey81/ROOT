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
    
  	//�ð� üũ		
	long  _accessTime = session.getAttribute("_last_send_sms_time") == null ? 1 : (Long)(session.getAttribute("_last_send_sms_time")); 

	if ( _accessTime > 0 ){
		long	_currNowTime	=	System.currentTimeMillis();
        long	_intervalTime	=	_currNowTime - _accessTime;
        long	_expireTime		=	3000;	//3��          

        //3�ʳ� ����
        if ( _intervalTime < _expireTime ){	
        	result = "false";	
			return;
        } else {
        	session.setAttribute("_last_send_sms_time", System.currentTimeMillis());
        }
	}
    
	// ������ ���� �ʼ� ������ �ޱ�
	Param param = new Param(request);

	// ��������� ���� ���� ����
	String strTypeCode   = "0200";		     // ���������ڵ�
	String strDocCode    = "310";	         // ���������ڵ�
	String strHostIP     = SystemChecker.isReal() ? "210.207.91.239" : "210.207.91.215"; // ����IP ����(SCI���������� ����)
	String strPort	     = "27040";	         // ���� Port ����(SCI���������� ����)
	String strReturnCode = "000";		     // �����ڵ�			 
	String strSequence	 = "0000000001";	 // ����(��û�Ǻ��� ������ ������ �����Ͽ� ���۰�� ���� ��)
	
	int timeout = 5;                         // receive timeout ���� (����:��)

	StringBuffer strRecvBuf = new StringBuffer("");
	String strSendBuf    = "";               // �������� Buf
	String strRecv       = "";
	String rtnString     = "";

	byte[] bRtn = null;
	int len = 0;
	int i = 0;
	
	String message		= StringUtils.EMPTY;
	String birth		= Utils.safeHTML(param.get("birth"));	   // �������(YYYYMMDD)
	String gender		= Utils.safeHTML(param.get("gender"));	   // ����(M-��, F-��)
	String fgnGbn		= Utils.safeHTML(param.get("fgnGbn"));	   // ��/�ܱ��α���(1-������, 2-�ܱ���)
	String id			= "MIU004";	                               // ����Ȯ�� ȸ���� ���̵�
	String srvNo		= "020001";                                // ����Ȯ�� ���񽺹�ȣ
	String reqNum		= Utils.safeHTML(param.get("reqNum"));	   // ����Ȯ�� ��û��ȣ
	String name			= Utils.safeHTML(param.get("name"));	   // ����
	String hpcorp		= Utils.safeHTML(param.get("hpcorp"));	   // �����
	String hpno			= Utils.safeHTML(param.get("hpno"));	   // �޴�����ȣ
	String certDate		= Utils.safeHTML(param.get("certDate"));   // �����ð�
	// ���� ��� ���� ����
	String rBirth       = "";                                               // �������
	String rGender      = "";                                               // ����
	String rFgnGbn      = "";                                               // ���ܱ��α���
	String rid			= "";                                               // ȸ���� ���̵�
	String rSrvNo	    = "";                                               // ���񽺹�ȣ
	String rReqNum      = "";                                               // ����Ȯ�� ��û��ȣ
	String rName        = "";                                               // ����
	String rHpno        = "";                                               // �ڵ��� ��ȣ
	String rResult      = "";                                               // ����Ȯ�ΰ�� (Y/N/M)
	String rHpcorp      = "";                                               // ����� ����
	String rCertDate    = "";                                               // �����ð�
	String rHpcode      = "";                                               // �޴��� ���� ��� �ڵ�
	String rSmsnum      = "";                                               // �޴��� ���� ��ȣ
	String rRetCode     = "";                                               // ���� ���?
	String rRetryM      = "";                                               // �߼� ���� ����(Y/N)
	String rPccSeq      = "";                                               // ���� Ȯ�� ����
	String rAuthSeq     = "";                                               // ���� ����
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
	

	// ��ȣȭ ��� �� ��Ÿ�� ����
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
		
		// �̸� 60 byte padding 
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

		// �޴�����ȣ 11 byte padding
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

		// ��û��ȣ 40 byte padding
		len = reqNum.getBytes().length;
		rtnString = reqNum;
		
		if (len < 40) {
			for (i=0; i < (40-len); i++) 
			{
				rtnString = rtnString + " ";
			}
		}
		reqNum = rtnString;
		

		// ��������� ���� ���� ����
		String reqInfo = birth + gender + fgnGbn + srvNo + reqNum + name + hpcorp + hpno + certDate;
		strSendBuf = id + strTypeCode + strDocCode + strReturnCode + strSequence + reqInfo;
		System.out.println("===============================================strSendBuf:" + strSendBuf.getBytes("EUC-KR").length + ":" + strSendBuf);
		if(strSendBuf.length() > 0)	
		{
			//08. ������� ��û �� ��� ����
			strRecvBuf = sock.SendWritePacket(strHostIP, strPort, timeout, strSendBuf);
			System.out.println("-------------- " + strRecvBuf.length() + " : " + strRecvBuf);
			strRecv = strRecvBuf.substring(0, strRecvBuf.length());
			bRtn = strRecvBuf.toString().getBytes("EUC-KR");
			strReturnCode = strRecvBuf.substring(15,18);
			
			if(strReturnCode.equals("000")) {

				//strReturnCode = "(000)����ó��";
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

				//�������
				System.arraycopy(bRtn, 28, btBirth, 0, 8);
				rBirth = new String(btBirth);
				System.out.println("-------------- rBirth : " + rBirth);

				//����
				System.arraycopy(bRtn, 36, btGender, 0, 1);
				rGender = new String(btGender);
				System.out.println("-------------- rGender : " + rGender);

				//���ܱ��α���
				System.arraycopy(bRtn, 37, btFgnGbn, 0, 1);
				rFgnGbn = new String(btFgnGbn);
				System.out.println("-------------- rFgnGbn : " + rFgnGbn);

				//���񽺹�ȣ
				System.arraycopy(bRtn, 38, btSrvNo, 0, 6);
				rSrvNo = new String(btSrvNo);
				System.out.println("-------------- rSrvNo : " + rSrvNo);

				//��û��ȣ
				System.arraycopy(bRtn, 44, btReqNum, 0, 40);
				rReqNum = new String(btReqNum);
				System.out.println("-------------- rReqNum : " + rReqNum);

				//����
				System.arraycopy(bRtn, 84, btName, 0, 60);
				rName = new String(btName);
				System.out.println("-------------- rName : " + rName);
				
				// �̸� 60 byte padding 
				len = rName.getBytes("EUC-KR").length;
				
				if (len < 60) {
					for (i=0; i < (60-len); i++) 
					{
						rName = rName + " ";
					}
				}
				System.out.println("-------------- rName : " + rName);
				
				//�����
				System.arraycopy(bRtn, 144, btHpCorp, 0, 3);
				rHpcorp = new String(btHpCorp);
				System.out.println("-------------- rHpcorp : " + rHpcorp);
				
 				//�޴�����ȣ
				System.arraycopy(bRtn, 147, btHpno, 0, 11);
				rHpno = new String(btHpno);
				System.out.println("-------------- rHpno : " + rHpno);
				
				//��û�Ͻ�
				System.arraycopy(bRtn, 158, btCertDate, 0, 14);
				rCertDate = new String(btCertDate);
				System.out.println("-------------- rCertDate : " + rCertDate);
				
                //�����
				System.arraycopy(bRtn, 172, btResult, 0, 1);
				rResult = new String(btResult);
				System.out.println("-------------- rResult : " + rResult);

 				//�޴�����������ڵ�
				System.arraycopy(bRtn, 173, btHpCode, 0, 10);
				rHpcode = new String(btHpCode);
				System.out.println("-------------- rHpcode : " + rHpcode);

				//����Ȯ�μ���
				System.arraycopy(bRtn, 183, btPccSeq, 0, 16);
				rPccSeq = new String(btPccSeq);
				System.out.println("-------------- rPccSeq : " + rPccSeq);

				//��������
				System.arraycopy(bRtn, 199, btAuthSeq, 0, 2);
				rAuthSeq = new String(btAuthSeq); 
				System.out.println("-------------- rAuthSeq : " + rAuthSeq);
				

				// SMS Ȯ�� �� �������� ���� ���� ���� �ϱ�
				certMsg = id + "/" + rBirth + "/" + rGender + "/" +  rFgnGbn + "/" + rSrvNo + "/" + rReqNum + "/" 
								+ rName + "/" + rHpcorp + "/" + rHpno + "/"  + rCertDate + "/" + rPccSeq + "/" + rAuthSeq + "/" + rResult;

				System.out.println("------ certMsg : " + certMsg);
				// ���� ������ �̵��� ���Ǵ� �������� Key�� ��� ���� �ʰ� ��ȣȭ ��.
				encCertMsg = seed.getEnc(certMsg, "");
				System.out.println("------ encCertMsg : " + encCertMsg);

			} 
			else if(strReturnCode.equals("001")) 
			{
				 strReturnCode = "(001)����� ID ����";
			}
			else if(strReturnCode.equals("003")) 
			{
				 strReturnCode = "(003)������ ����";
			}
			else if(strReturnCode.equals("111")) 
			{
				 strReturnCode = "(111)SCI������ System ���";
			}
			else if(strReturnCode.equals("112")) 
			{
				 strReturnCode = "(112)SCI������ DataBase ���";
			}
			else if(strReturnCode.equals("113")) 
			{
				 strReturnCode = "(113)DataBase ó�� ����";
			} 
 			else if(strReturnCode.equals("299")) 
			{
				 strReturnCode = "(299)���� Format Type Error";
			} 
 			else if(strReturnCode.equals("295")) 
			{
				 strReturnCode = "(295)���� ���� ����";
			} 
			else if(strReturnCode.equals("301")) 
			{
				 strReturnCode = "(301)���� ���� �ڵ� ����";
			} 
			else if(strReturnCode.equals("302")) 
			{
				 strReturnCode = "(302)���� ���� �ڵ� ����";
			} 
			else if(strReturnCode.equals("303")) 
			{
				 strReturnCode = "(303)���� �ڵ� ����";
			} 
			else 
			{
				 strReturnCode = "��Ÿ ����";
			}
			
		} 
		else 
		{
			strReturnCode = "��ȸ ���� null";
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
		System.out.println("�������� �����Դϴ�");
	}
	finally {
		sock.Disconnect();
	}
%>
{"result" : "<%=result %>", "message" : "<%=message %>", "certMsg" : "<%=encCertMsg%>"}
<%!
	private String returnMessage(String errCode){
	
	    String msg = "������ȣ�� �߼��Ͽ����ϴ�.\\n������ȣ�� �Է����ּ���.";

		if (StringUtils.equals(errCode, "NME0011")){
			msg = "��Ż簡 ����ġ�մϴ�";
		}else if(StringUtils.equals(errCode, "NME0012")){
			msg = "���ǰ� ����ġ �մϴ�.(�������/����)";
		}else if(StringUtils.equals(errCode, "NME0013")){
			msg = "�н�/�Ͻ����� �޴����Դϴ�.";
		}else if(StringUtils.equals(errCode, "NME0015")){
			msg = "�����(����) ���� �޴����Դϴ�.";
		}else if(StringUtils.equals(errCode, "NME0017")){
			msg = "�����޴����Դϴ�.";
		}else if(StringUtils.equals(errCode, "NME0024")){
			msg = "���ǰ� ����ġ �մϴ�.(����)";
		}else if(StringUtils.equals(errCode, "NME0035")){
			msg = "SMS ���ι�ȣ�� �߼� ���� �߽��ϴ�.";
		}else if(StringUtils.equals(errCode, "NME0070")){
			msg = "������ȣ�� �ٽ� Ȯ�����ּ���.";
		}else if(StringUtils.equals(errCode, "NME0071")){
			msg = "������ȣ ������ Ƚ���� �ʰ� �Ǿ����ϴ�.";
		}else if(StringUtils.equals(errCode, "NME0072")){
			msg = "������ȣ �Է� ����ȸ��(5ȸ)�� �ʰ��Ͽ����ϴ�.";
		}else if(StringUtils.equals(errCode, "NME0096")){
			msg = "5ȸ ���� ���� �����Դϴ�.";
		}else if(StringUtils.equals(errCode, "NME0097")){
			msg = "�Է������� ������ �ֽ��ϴ�.";
		}else if(StringUtils.equals(errCode, "NME0098")){
			msg = "�ý��� ����(��Ż� ���)�Դϴ�. ����� �ٽ� �õ��� �ּ���";
		}else if(StringUtils.equals(errCode, "NME0099")){
			msg = "�ý��� ����(��Ÿ ����)�Դϴ�. ����� �ٽ� �õ��� �ּ���";
		}
	
		return msg;
	}

%>