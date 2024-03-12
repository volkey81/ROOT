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

	// ��������� ���� ���� ����
	String strTypeCode   = "0200";		     // ���������ڵ�
	String strDocCode    = "311";	         // ���������ڵ�
	String strHostIP     = SystemChecker.isReal() ? "210.207.91.239" : "210.207.91.215";  // ����IP ����(SCI���������� ����)
	String strPort	     = "27040";	         // ���� Port ����(SCI���������� ����)
	String strReturnCode = "000";		     // �����ڵ�			 
	String strSequence	 = "0000000001";	 // ����(��û�Ǻ��� ������ ������ �����Ͽ� ���۰�� ���� ��)
	String message       ="";
	int timeout = 5;                         // receive timeout ���� (����:��)

	StringBuffer strRecvBuf = new StringBuffer("");
	String strSendBuf    = "";               // �������� Buf
	String strRecv       = "";
	byte[] bRtn = null;

	// �������� ��������
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


	// ������ ���� ����
	String reqInfo		= Utils.safeHTML(param.get("reqPccInfo"));
	String confirmSeq	= Utils.safeHTML(param.get("confirmSeq"));		// �����ۼ���
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

	//��ȣȭ ��� (jar) Loading
	com.sci.v2.comm.secu.SciSecuManager sciSecuMg = new com.sci.v2.comm.secu.SciSecuManager();

	// reqInfo ����� ��ȣȭ : ���� ���۰� ��/��ȣȭ�� Key���� ������ �Ͽ���
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
	
	// ��ȭȭ�� ������ "/" ���� �ؼ� �� �и� �ϱ�
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

		// ��������� ���� ���� ����
		String strPara = info_strBirth + info_strGender + info_strFgnGbn 
							+ info_strSrvNo + info_strReqNum + info_strName + info_strPhnGb + info_strHpno 
							+ info_strPccSeq + info_strAuthSeq;

		strSendBuf = info_id  + strTypeCode + strDocCode + strReturnCode + strSequence + strPara;


		if(strSendBuf.length() > 0)	
		{
			// ������� ��û �� ��� ����
			strRecvBuf = sock.SendWritePacket(strHostIP, strPort, timeout, strSendBuf);
			strRecv = strRecvBuf.substring(0, strRecvBuf.length());
			bRtn = strRecvBuf.toString().getBytes("EUC-KR");

			strReturnCode = strRecvBuf.substring(15,18);

			if(strReturnCode.equals("000")) 
			{
				//strReturnCode = "(000)����ó��";
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

				//�������
				System.arraycopy(bRtn, 28, btBirth, 0, 8);
				strBirth = new String(btBirth);

				//����
				System.arraycopy(bRtn, 36, btGender, 0, 1);
				strGender = new String(btGender);

				//���ܱ��α���
				System.arraycopy(bRtn, 37, btFgnGbn, 0, 1);
				strFgnGbn = new String(btFgnGbn);

				//���񽺹�ȣ
				System.arraycopy(bRtn, 38, btSrvNo, 0, 6);
				strSrvNo = new String(btSrvNo);

				//��û��ȣ
				System.arraycopy(bRtn, 44, btReqNum, 0, 40);
				strReqNum = new String(btReqNum);
				
				//����
				System.arraycopy(bRtn, 84, btName, 0, 60);
				strName = new String(btName);
				
				int len = 0;
				// �̸� 60 byte padding 
				len = strName.getBytes("EUC-KR").length;
				
				if (len < 60) {
					for (int i=0; i < (60-len); i++) 
					{
						strName = strName + " ";
					}
				}

				//����籸��
				System.arraycopy(bRtn, 144, btPhnGb, 0, 3);
				strPhnGb = new String(btPhnGb);

				//�޴�����ȣ
				System.arraycopy(bRtn, 147, btHpno, 0, 11);
				strHpno = new String(btHpno);

				//������ ��û ���
				System.arraycopy(bRtn, 158, btResult, 0, 1);
				strResult = new String(btResult);

				//�޴��� ���� ����ڵ�
				System.arraycopy(bRtn, 159, btHpCode, 0, 10);
				strHpCode = new String(btHpCode);
				
				//����Ȯ�μ���
				System.arraycopy(bRtn, 169, btPccSeq, 0, 16);
				strPccSeq = new String(btPccSeq);

				//��������
				System.arraycopy(bRtn, 185, btAuthSeq, 0, 2);
				strAuthSeq = new String(btAuthSeq);

				//SMS �߼ۼ���
				System.arraycopy(bRtn, 187, btSmsSeq, 0, 2);
				strSmsSeq = new String(btSmsSeq);
				
				
				// ���� Ȯ�� �� SMS ������ ���� ����
				certMsg = info_id + "/" + strBirth + "/" + strGender + "/" +  strFgnGbn + "/" + strSrvNo + "/" + strReqNum + "/" 
								+ strName + "/" + strPhnGb + "/" + strHpno + "/" + info_strCertDate + "/" + strPccSeq + "/" + strAuthSeq + "/" + strResult ;

				encCertMsg = sciSecuMg.getEnc(certMsg, "");

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
				 strReturnCode = "(113)��DataBase ó�� ����";
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
			message = this.returnMessage(strHpCode.trim());
		}else{
			message = 	strReturnCode;
		}
	}
	catch(Exception e)
	{
		e.printStackTrace();
		out.println("�������� �����Դϴ�");
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
			msg = "�ý��� ����(��Ż� ���)�Դϴ�.\n����� �ٽ� �õ��� �ּ���";
		}else if(StringUtils.equals(errCode, "NME0099")){
			msg = "�ý��� ����(��Ÿ ����)�Դϴ�.\n����� �ٽ� �õ��� �ּ���";
		}
	
		return msg;
	}

%>

