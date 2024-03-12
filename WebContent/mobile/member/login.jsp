<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sanghafarm.common.FrontSession"%>
<%@ page import="com.efusioni.stone.security.CryptoUtil"%>
<%@ page import="com.efusioni.stone.common.SystemChecker"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.common.Config"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%
    // String strReturnUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/joinSns1.jsp"; //SNS계정 미가입 URL
    
	request.setAttribute("Depth_1", new Integer(2));
    Param param = new Param(request);
	String snsLoginUrl   = Config.get("api.auth.snsLogin." + SystemChecker.getCurrentName()); //APIURL
	String strCoopcoCd   = Config.get("join.parameter.coopcoCd");        //제휴사코드
// 	String strChnlCd     = Config.get("join.parameter.chnlCd");          //채널코드
	String strChnlCd     = SanghafarmUtils.getChnlCd(request);                         //채널코드
// 	String strNtryPath   = Config.get("join.parameter.ntryPath");        //사이트코드
	String strNtryPath   = SanghafarmUtils.getNtryPath(request);                       //사이트코드
	String strReturnUrl  = request.getScheme() + "://" + request.getServerName() + "/mobile/member/snsLoginProc.jsp"; //URL(sns로그인)
	String strLoginUrl   = request.getScheme() + "://" + request.getServerName() + "/mobile/member/loginProc.jsp"; //URL(일반로그인)
	String strIp         = request.getRemoteAddr();                      //IP주소
	String strResult     = "";                                           //전송결과
	String strMessage    = "";                                           //결과메세지
	String strResultCode ="";                                            //결과코드
	String strUnfyMmbNo  = "";                                           //통합회원번호
	String strSocId      = "";                                           //소셜아이디
	String strSocNm      = "";                                           //소셜이름
	String strErr        = "";                                           //에러판별
	String strId         = SanghafarmUtils.getCookie(request, "saveid"); //저장된 아이디
	String strSaveFlg    = SanghafarmUtils.getCookie(request, "saveidflg"); //아이디저장플레그
	FrontSession fs      = FrontSession.getInstance(request, response);
	String device_Type   = fs.getDeviceType();
	String referUrl      = request.getHeader("referer");
	if(referUrl == null || "".equals(referUrl)) {
		referUrl = Utils.safeHTML(param.get("returnUrl"));
	}

	//sns로그인URL작성
	snsLoginUrl = snsLoginUrl + "?coopcoCd=" + strCoopcoCd 
			                  + "&chnlCd=" + strChnlCd
			                  + "&ntryPath=" + strNtryPath
			                  + "&returnUrl=" + strReturnUrl
			                  + "&clientIp=" + strIp
			                  + "&socKindCd=";
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<% 
	if("web".equals(param.get("type"))){
%>
	<link rel="stylesheet" href="/css/common.css?t=<%=System.currentTimeMillis()%>">
	<link rel="stylesheet" href="/css/layout.css?t=<%=System.currentTimeMillis()%>">
	<script src="/js/jquery-ui.js?t=<%=System.currentTimeMillis()%>"></script>
<%
	} 
%>
<script>
var doubleSubmitFlag = false;    // 이중처리방지 플레그
var snsUrl = "";
var saveIdFlg = "<%=strSaveFlg%>";
var deviceType = "<%=device_Type%>";
var id = "<%=strId%>";
$(document).ready(function(){
	if(saveIdFlg == "true"){
		$("#idSave").prop("checked", true);
		$("#userId").val(id);
	}
	
	if(deviceType == "A"){
		$("#loginAuto").show();
		$("#loginAutoLab").show();
	}
	
	$("#userPwd").keyup(function (e) {
        if (e.keyCode === 13) {
        	login();
		}
    });
});

/***************************************
 * 일반로그인
 **************************************/
function login() {
	if ($("#userId").val() == '') {
           alert("아이디를 입력해 주세요.");
		$("#userId").focus();
		return;
	}

	if ($("#userPwd").val() == '') {
		alert("비밀번호를 입력해 주세요.");
		$("#userPwd").focus();
		return;
	}
	
	$("#saveIdFlg").val($("#idSave").is(":checked"));
	$("#autoLogin").val($("#loginAuto").is(":checked"));

	//----------------------------------------------------------------
	/*
	var requestInfo = ET.getRequestInfoByExec('sendEvent', {
						name	: 'login',
						value	: $("#userId").val()
					  });
	ET.getStorage().session.set('etShLoginTrk',requestInfo.url);
	*/
	//-----------------------------------------------------------------

	//API통신
    document.reqloginForm.action = "<%=strLoginUrl%>";
    document.reqloginForm.submit(); 
}


/***************************************
 * SNS로그인
 **************************************/
function snsLogin(snsKind) {
	
//    	sessionStorage.setItem('snsKind', snsKind);
  	setCookie("cookieSnsKind", snsKind, 1);
  	
	//이중처리방지
   if(doubleSubmitCheck()) return;
   snsUrl = "<%=snsLoginUrl %>" + snsKind;
   location.href = snsUrl;
	
   doubleSubmitFlag = false; 
   
}

//이중처리방지
function doubleSubmitCheck(){
    if(doubleSubmitFlag){
        return doubleSubmitFlag;
    }else{
        doubleSubmitFlag = true;
    }
}

</script> 
</head>  
<body>
<div id="wrapper" class="login<%= "web".equals(param.get("type")) ? " webType" : "" %> loginMain">
<% 
	if("web".equals(param.get("type"))){
%>
	<jsp:include page="/include/header.jsp" />
<%
	}
%>	
	<div id="container" class="join">
	<!-- 내용영역 -->
	<div class="logInTop lgPop">
		<strong>로그인</strong>
<% 
	if(!"web".equals(param.get("type"))){
%>		
		<jsp:include page="/mobile/member/memberClose.jsp" />
<%
	}
%>
	</div>

		<form name="reqloginForm" id="reqloginForm" method="post">
		<input type="hidden" name="referUrl" id="referUrl" value="<%=referUrl %>">
		<table class="loginForm">
		
			<caption>회원가입 회원정보에 대한 내용</caption>
			<tr>
				<td style="padding-top:0;">
					<input type="text" name="userId" id="userId" placeholder="아이디" style="width:100%;" maxlength="12" value="">					
				</td>
			</tr>
			<tr>
				<td>
					<input type="password" name="userPwd" id="userPwd" style="width:100%" placeholder="비밀번호" maxlength="32">
				</td>
			</tr>
			<tr>
				<td>
					<input type="checkbox" id="idSave" name="idSave"/><label for="idSave">아이디 저장</label>
					<input type="checkbox" id="loginAuto" name="loginAuto" style="margin-left:10px;" hidden="hidden"/><label id="loginAutoLab" for="loginAuto" hidden="hidden">자동 로그인</label>					
<%
	if(!SystemChecker.isReal()) {
%>
					<a href="/integration/login.jsp">&nbsp;</a>
<%
	}
%>
				</td>
			</tr>			
		</table>
		<div class="btnWarp">
		    <a href="javascript:void(0);" class="btnCheck Large" onclick="login();">로그인</a>
		</div>
		<input type="hidden" name="saveIdFlg" id="saveIdFlg" value=""/>
		<input type="hidden" name="autoLogin" id="autoLogin" value=""/>
		</form>		
		<!-- 로그인 -->
		
		<div class="loginSelect">
			<ul>
				<li><a href="/mobile/member/joinStep2.jsp?type=<%=param.get("type") %>">회원가입</a></li>
				<li><a href="/mobile/member/findId1.jsp?type=<%=param.get("type") %>">아이디 찾기</a></li>
				<li><a href="/mobile/member/findPwd1.jsp?type=<%=param.get("type") %>">비밀번호 찾기</a></li>								
			</ul>
		</div>
<%
// 	if(!fs.isApp()) {
%>	
		<div class="snsWarp">
			<div class="btnWarp">
				<a href="javascript:void(0);" class="btnCheck Large facebook" onclick="snsLogin('F');">페이스북 계정 로그인</a>
				<a href="javascript:void(0);" class="btnCheck Large kakao" onclick="snsLogin('K');">카카오 계정 로그인</a>
				<a href="javascript:void(0);" class="btnCheck Large naver" onclick="snsLogin('N');">네이버 계정 로그인</a>							
			</div>	
		</div>
		<p class="logInfo"><b>상하가족 서비스</b>를 이용하실 분은<br />SNS계정으로 가입, 로그인이 아닌<br /><b>일반회원으로 가입</b>, <b>로그인</b> 해주세요.</p>	
<%
// 	}
%>
	<!-- //내용영역 -->
	</div><!-- //container -->
<% 
	if("web".equals(param.get("type"))){
%>
	<jsp:include page="/include/footer.jsp" />
<%
	}
%>
</div><!-- //wrapper -->
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
</html>
