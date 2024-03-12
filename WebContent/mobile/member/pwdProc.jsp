<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sanghafarm.common.FrontSession"%>
<%@ page import="com.sanghafarm.common.Env"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page import="com.zeroto7.sha256.Sha256Cipher"%>
<%@ page import="com.efusioni.stone.common.Config"%>
<%@ page import="com.efusioni.stone.common.SystemChecker"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.sanghafarm.service.member.MemberService"%>

<%
	Param param = new Param(request);
	MemberService member = (new MemberService()).toProxyInstance();
	String msg = StringUtils.EMPTY;
	
	FrontSession fs = FrontSession.getInstance(request, response);
	String id = fs.isLogin() ? fs.getUserId() : param.get("reqId");
	
	if (StringUtils.isEmpty(id)) {
		Utils.sendMessage(out, "잘못된 접근입니다.");
		return;
	}

	String passwdCheck = Utils.chkValidPasswd(param.get("reqPwd1"));
	
	if(!"".equals(passwdCheck)) {
		Utils.sendMessage(out, passwdCheck);
		return;
	}
	
	
	if (!StringUtils.equals(param.get("reqPwd1"), param.get("reqPwd2"))) {
		Utils.sendMessage(out, "비밀번호가 맞지않습니다.");
		return;
	}
	
	Param info = member.getImInfoById(id);
	if(info == null || "".equals(info.get("UNFY_MMB_NO"))) {
// 		Utils.sendMessage(out, "상하농원 정보제공 동의가 되어 있지 않습니다. 매일두에서 정보제공 동의 여부를 확인해 주세요.");
%>
	<script>
	alert("상하농원 정보제공 동의가 되어 있지 않습니다.\n매일두에서 정보제공 동의 여부를 확인해 주세요.");
	if(parent.opener != null ) {
		opener.document.location.href = "https://www.maeildo.com/co/wm/cowm01q5.do";
		self.close();
	} else {
		document.location.href = "https://www.maeildo.com/co/wm/cowm01q5.do";
	}
	</script>
<%
		return;
	}

	response.setHeader("Pragma","no-cache");				// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);					// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");				// HTTP1.1 캐쉬 방지
	if("HTTP/1.1".equals(request.getProtocol())){
		response.setHeader("Cache-Control", "no-cache");	// HTTP1.1 캐쉬 방지
	}

	JSONObject result = new JSONObject();
	String pwdUpdateUrl  = Config.get("api.info.updatePwd." + SystemChecker.getCurrentName()); //APIURL
	String strCoopcoCd   = Config.get("join.parameter.coopcoCd");                       //제휴사코드
	String strchnlCd     = Config.get("join.parameter.chnlCd");                         //채널코드
	String query         = "";                                                          //postQuery
	String strResult     = "";                                                          //전송결과
	String strMessage    = "";                                                          //결과메세지
	String strResultCode = "";                                                          //결과코드
	
	query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd + "&unfyMmbNo=" + info.get("UNFY_MMB_NO") + "&pwd=" + enc(param.get("reqPwd1"));
	
	result = SanghafarmUtils.getAPIDataInfo(pwdUpdateUrl, query);
	
	strResultCode = result.getString("resultCode");	
	String loginUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/login.jsp";
 	
 	if(strResultCode.equals("S0000")){
 		strResult = "true";
 		strMessage = "비밀번호 변경이 완료되었습니다";
%>
 		<script type="text/javascript">
			var _popup_url = "<%= Env.getMaeildoUrl() %>/auth/ssoLogout.do?chnlCd=3&coopcoCd=7040&returnUrl=http://<%= request.getServerName() %>/integration/ssologout.jsp";
			alert("<%=strMessage%>")
			if(parent.opener != null ) {
				self.close();
				opener.window.open(_popup_url,'popupMaeildoLogin', 'width=450, height=500, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=300, top=200');
			}else{
				location.href = _popup_url;
				//window.open(_popup_url,'popupMaeildoLogin', 'width=450, height=500, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=300, top=200');
			}
    	
 		</script>
<% 		
 	}else{
 		strResult = "false";
 		strMessage = result.getString("resultMessage");	
 		Utils.sendMessage(out, strMessage, loginUrl);
 	}
	
%>
<%! 
private String enc(String s) {
	String key = "0to7";
	return Sha256Cipher.encrypt(s, key);
}
%>

