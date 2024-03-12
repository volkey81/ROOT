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

	// ��������� ���� ���� ����
	String strTypeCode   = "0200";		     // ���������ڵ�
	String strDocCode    = "312";	         // ���������ڵ�
	String strHostIP     = SystemChecker.isReal() ? "210.207.91.239" : "210.207.91.215";  // ����IP ����(SCI���������� ����)
	String strPort	     = "27040";	         // ���� Port ����(SCI���������� ����)
	String strReturnCode = "000";		     // �����ڵ�			 
	String strSequence	 = "0000000001";	 // ����(��û�Ǻ��� ������ ������ �����Ͽ� ���۰�� ���� ��)
	int timeout = 5;                         // receive timeout ���� (����:��)

	StringBuffer strRecvBuf = new StringBuffer("");
	String strSendBuf    = "";               // �������� Buf
	String strRecv       = "";
	String apiData       = "";
	byte[] bRtn = null;

	// �������� ��������
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
	String strScreenCd     = Utils.safeHTML(param.get("screenCd"));		// ȭ���Ǻ�
	String strPwdFindId    = Utils.safeHTML(param.get("userId"));		// ����ID
	String query         = "";                                          //postQuery
	String userCi		 = Utils.safeHTML(param.get("ci").replaceAll(" ", "+"));		    // ����CI
// 	String userCi		 = URLDecoder.decode(param.get("ci"), "utf-8");		    // ����CI

	// ������ ���� ����
	String reqInfo		= Utils.safeHTML(param.get("reqPccInfo"));
	String smsnum		= Utils.safeHTML(param.get("smsnum"));			// ������ȣ
	String confirmSeq	= Utils.safeHTML(param.get("confirmSeq"));		// �����ۼ���
	String reJoinFlg    = Utils.safeHTML(param.get("reJoinFlg","N"));   // �簡���Ǻ� �÷���
	String strUnfyMmbNo = Utils.safeHTML(param.get("unfyMmbNo",""));    // ����ȸ����ȣ
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

	// API��ſ� ����
	String strCoopcoCd = Config.get("join.parameter.coopcoCd");             //���޻��ڵ�
	String strchnlCd = Config.get("join.parameter.chnlCd");                 //ä���ڵ�
	String resultCode = "";                                                 //ó���ڵ�
	String resultMessage = "";                                              //ó���޼���
	String apiUrl = "";                                                     //APIURL
	String strResult = "";                                                  //���
	String strResultCode = "";                                              //����ڵ�
	JSONObject result = new JSONObject();                                   //��Ű��(JSONObject)

	try {

		// ��ȣȭ ��� (jar) Loading
		com.sci.v2.comm.secu.SciSecuManager sciSecuMg = new com.sci.v2.comm.secu.SciSecuManager();

		// reqInfo ����� ��ȣȭ : ���� ���۰� ��/��ȣȭ�� Key���� ������ �Ͽ���
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
		
		// ��ȭȭ�� ������ "/" ���� �ؼ� �� �и� �ϱ�
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

	// ��ȣȭ ��� ����
	com.sci.v2.comm.secu.SciSecuManager seed  = new com.sci.v2.comm.secu.SciSecuManager();
	SocketClient sock = new SocketClient();

	try {

		// ��������� ���� ���� ����
		String resultMsg = info_strBirth + info_strGender + info_strFgnGbn + info_strSrvNo + info_strReqNum 
						+ info_strName + info_strPhnGb + info_strHpno + info_strCertDate + info_strPccSeq + info_strAuthSeq + confirmSeq + smsnum;

		strSendBuf = info_id + strTypeCode + strDocCode + strReturnCode + strSequence + resultMsg;
		
		if(strSendBuf.length() > 0)	{

			// 13. ������� ��û �� ��� ����
			strRecvBuf = sock.SendWritePacket(strHostIP, strPort, timeout, strSendBuf);
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


				//�������
				System.arraycopy(bRtn, 28, btBirth, 0, 8);
				strBirth = new String(btBirth);

				//����
				System.arraycopy(bRtn, 36, btGender, 0, 1);
				strGender = new String(btGender);

				//���ܱ��ι�ȣ
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

				//����� ����
				System.arraycopy(bRtn, 144, btPhnGb, 0, 3);
				strPhnGb = new String(btPhnGb);

				//�޴�����ȣ
				System.arraycopy(bRtn, 147, btHpno, 0, 11);
				strHpno = new String(btHpno);

				//��û�Ͻ�
				System.arraycopy(bRtn, 158, btCertDate, 0, 14);
				strCertDate = new String(btCertDate);

				//����Ȯ�μ���
				System.arraycopy(bRtn, 172, btPccSeq, 0, 16);
				strPccSeq = new String(btPccSeq);

				//��������
				System.arraycopy(bRtn, 188, btAuthSeq, 0, 2);
				strAuthSeq = new String(btAuthSeq);
				
				//�����ۼ���
				System.arraycopy(bRtn, 190, btSmsSeq, 0, 2);
				strSmsSeq = new String(btSmsSeq);

				//SMS ������ȣ
				System.arraycopy(bRtn, 192, btSmsNum, 0, 6);
				strSmsNum = new String(btSmsNum);

				//������ȣ Ȯ�� ���
				System.arraycopy(bRtn, 198, btRetryM, 0, 1);
				strRetryM = new String(btRetryM);

				//�޴�����������ڵ�
				System.arraycopy(bRtn, 199, btHpCode, 0, 10);
				strHpCode = new String(btHpCode);

				//DI(�ߺ�����Ȯ������)
				System.arraycopy(bRtn, 209, btDI, 0, 64);
				strDi = new String(btDI);

				//CI ����
				System.arraycopy(bRtn, 273, btCIVer, 0, 1);
				strCiVer = new String(btCIVer);

				//CI
				System.arraycopy(bRtn, 274, btCI, 0, 88);
				strCi = new String(btCI);

			}else if(strReturnCode.equals("001")) {
				 strReturnCode = "(001)����� ID ����";
			}else if(strReturnCode.equals("003")) {
				 strReturnCode = "(003)������ ����";
			}else if(strReturnCode.equals("111")) {
				 strReturnCode = "(111)SCI������ System ���";
			}else if(strReturnCode.equals("112")) {
				 strReturnCode = "(112)SCI������ DataBase ���";
			}else if(strReturnCode.equals("113")) {
				 strReturnCode = "(113)��DataBase ó�� ����";
			}else if(strReturnCode.equals("299")) {
				 strReturnCode = "(299)���� Format Type Error";
			}else if(strReturnCode.equals("295")) {
				 strReturnCode = "(295)���� ���� ����";
			}else if(strReturnCode.equals("301")) {
				 strReturnCode = "(301)���� ���� �ڵ� ����";
			}else if(strReturnCode.equals("302")) {
				 strReturnCode = "(302)���� ���� �ڵ� ����";
			}else if(strReturnCode.equals("303")) {
				 strReturnCode = "(303)���� �ڵ� ����";
			}else {
				 strReturnCode = "��Ÿ ����";
			}

		}else{
			strReturnCode = "��ȸ ���� null";
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
		
		//ȸ������ ���� üũ
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
				resultMessage = "�� 14�� �̸��� ȸ������ �����Ͻ� �� �����ϴ�.";
			} else if(strResultCode.equals("E1003")){
				strResult = "reJoin";
			}else if(strResultCode.equals("E2001") ){
				strResult = "falseJoin";
				resultMessage = result.getString("resultMessage");
			}else if(!strResultCode.equals("S0000") ){
				strResult = "false";
				resultMessage = result.getString("resultMessage");
			}else{
				resultMessage = "���� �Ǿ����ϴ�.\\nȸ�� ���� �������� �̵��մϴ�.";
			}
			//�簡��
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
			//���̵� ã��
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
			//��й�ȣ ã��
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
			//�޸�����
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
			//ȸ����������
		}else if(strScreenCd.equals("infoModify") && strResult.equals("true")){

			if(!strReturnCode.equals("true")){
				strResult = "false";
			}else if(!userCi.equals(strCi)){
				System.out.println("===========================userCi:" + userCi);
				System.out.println("===========================strCi:" + strCi);
				strResult = "ciErr";
				resultMessage = "����� ������ ��ġ���� �ʽ��ϴ�.";
			}else{
				strResult = "true";
			}
		} else if("adultAuth".equals(strScreenCd) && "true".equals(strResult)) {	// ��������
			Calendar cal = Calendar.getInstance();
			cal.set(Calendar.YEAR, cal.get(Calendar.YEAR) - 19);
			String dd = Utils.getTimeStampString(cal.getTime(), "yyyyMMdd");

			System.out.println("-------------------- " + strBirth);
			System.out.println("-------------------- " + dd);
			System.out.println("-------------------- " + strCi);
			
			if(dd.compareTo(strBirth) < 0) {	// �̼���
				resultMessage = "�� 19�� �̸��̹Ƿ� �ַ� ��ǰ�� ������ �� �����ϴ�.";
			} else {
				FrontSession fs = FrontSession.getInstance(request, response);
				MemberService member = (new MemberService()).toProxyInstance();
				Param info = member.getImInfo(fs.getUserNo());
				
				System.out.println("----------- " + info.get("sef_cert_ci").replaceAll(" ", "+"));
				System.out.println("----------- " + strCi);
				
				if(!strCi.equals(info.get("sef_cert_ci").replaceAll(" ", "+"))) {
					resultMessage = "- ȸ�������� 19�� �̻� �������� ������ ���� ��ġ���� �ʽ��ϴ�.\\n";
					resultMessage += "- Maeil Do ȸ�������� ������ ������ 19�� �̻� ���������ϼ���.\\n";
					resultMessage += "- SNSȸ���� ���, ���� Ȯ���� ����� �ش� ��ǰ�� �����Ͻ� �� �����ϴ�.";
				} else {
					member.modifyAdultAuth(fs.getUserId());
					SanghafarmUtils.setCookie(response, "ADULT_AUTH", "Y", fs.getDomain(), -1);
					resultMessage = "������ �Ϸ�Ǿ����ϴ�.";
				}
			}
		}
	
	}catch(Exception e){
		e.printStackTrace();
		System.out.println("�������� �����Դϴ�");
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
