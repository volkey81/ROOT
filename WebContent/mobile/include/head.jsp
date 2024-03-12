<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="com.sanghafarm.common.*,
			com.efusioni.stone.common.*" %>
<%@page import="com.efusioni.stone.utils.Param"%>			
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");	
	int	Depth_4	=	(Integer)request.getAttribute("Depth_4") == null ? 0 : (Integer)request.getAttribute("Depth_4");	
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	if(request.getServletPath().indexOf("/brand/") != -1) {
		MENU_TITLE = "‘짓다 ∙ 놀다 ∙ 먹다’";
	}

	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	String chnlCd = "A".equals(fs.getDeviceType()) ? "42" : "41";

	/*
	String loginUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/login.jsp";//결과 수신 URL
	String strUrl = request.getScheme() + "://" + request.getServerName();
	String joinUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/joinStep1.jsp";//회원가입 URL
	String modifyUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/memModify1.jsp";//회원정보수정 URL
	String updPwdUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/findPwd2.jsp";//비밀번호 변경 URL
	String memLveUrl = fs.isSns() ? strUrl + "/mobile/member/memLeave2.jsp" : strUrl + "/mobile/member/memLeave1.jsp";//회원탈퇴 URL
	*/
	
	String strUrl = request.getScheme() + "://" + request.getServerName();
	String loginUrl = strUrl + "/mobile/member/login.jsp";//로그인 URL
	String joinUrl = strUrl + "/mobile/member/joinStep2.jsp";//회원가입 URL
	String modifyUrl = fs.isSns() ? strUrl + "/mobile/member/modifySns2.jsp" : strUrl + "/mobile/member/memModify1.jsp";//회원정보수정 URL
	String updPwdUrl = strUrl + "/mobile/member/findPwd2.jsp";//비밀번호 변경 URL
	String memLveUrl = fs.isSns() ? strUrl + "/mobile/member/memLeave2.jsp" : strUrl + "/mobile/member/memLeave1.jsp";//회원탈퇴 URL
%>
<% if(MENU_TITLE == "" || MENU_TITLE == null){ %>
<title>상하농원</title>
<% } else { %>
<title><%= MENU_TITLE %> | 상하농원</title>
<% } %>
<!-- <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="naver-site-verification" content="35c8a35ec38cd11142e8ce3879615f97156d50e4"/>
<meta name="description" content="자연과 교감하고, 건강한 먹거리를 즐기는 농촌형 테마공원 | 체험, 파머스마켓, 동물농장, 레스토랑 등 운영"/>
<meta name="description" content="기분 좋은 선물, 건강한 먹거리의 가치를 생각하는 상하농원 농부의 땀과 정성을 담은 파머스마켓"/>
<meta name="description" content="풍요로운 자연은 품고 건강한 생산을 하는 상하농원 체험안내"/>
<meta name="format-detection" content="telephone=no"> -->

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="robots" content="index,follow">
<meta name="description" content="자연과 교감하고, 건강한 먹거리를 즐기는 농촌형 테마공원 | 전라도 고창군 상하 | 체험교실, 동물체험, 레스토랑, 폴바셋"/>
<meta name="description" content="건강한 먹거리의 가치를 생각하는 상하농원 농부의 땀과 정성을 담은 파머스마켓 | 계란, 수제소시지, 수제쨈, 신선식품, 상하목장"/>
<meta name="keywords" content="고창, 상하, 상하목장, 동물체험, 어린이체험, 폴바셋, 계란, 유기농, 채소"/>
<meta name="subject" content="농원소개, 짓다, 놀다, 먹다, 상하공방, 매일유업, 신선식품, 정육,계란, 가공식품, 식품명인, 정기배송, 산지직송" />
<meta property="og:title" content="먹다·놀다·짓다|상하농원">
<meta property="og:description" content="자연과 교감하고, 건강한 먹거리를 즐기는 농촌형 테마공원">
<meta property="og:image" content="http://www.sanghafar.co.kr/images/layout/logo.png">
<meta property="og:url" content="http://www.sanghafarm.co.kr">
<meta property="al:ios:url" content="https://itunes.apple.com/app/id1239671849">
<meta property="al:ios:app_store_id" content="1239671849">
<meta property="al:ios:app_name" content="상하농원">
<meta property="al:android:url" content="applinks://play.google.com/store/apps/details?id=com.sanghafarm">
<meta property="al:android:app_name" content="상하농원">
<meta property="al:android:package" content="com.sanghafarm">


<meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0, maximum-scale=5.0, minimum-scale=1.0">
<link rel="apple-touch-icon" href="/mobile/images/common/favicon.png">
<link rel="apple-touch-startup-image" href="/mobile/images/common/favicon.png">
<% if(Depth_1 == 1){ //브랜드 %>
<link rel="stylesheet" href="/mobile/css/brand-common.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/mobile/css/layout.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/mobile/css/brand-content.css?t=<%=System.currentTimeMillis()%>">
<% } else if(Depth_1 == 5) { // 파머스 빌리지 %>
<link rel="stylesheet" href="/mobile/css/hotel-common.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/mobile/css/layout.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/mobile/css/hotel-content.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/mobile/css/animate.css">
<% } else { //쇼핑 %>
<link rel="stylesheet" href="/mobile/css/common.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/mobile/css/layout.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/mobile/css/content.css?t=<%=System.currentTimeMillis()%>">
<% } %>
<link rel="stylesheet" href="/css/redmond/jquery-ui-1.8.21.custom.css" type="text/css" media="all" />
<link rel="stylesheet" href="/mobile/css/slick.css?t=<%=System.currentTimeMillis()%>"> 
<script src="/js/jquery-1.10.2.min.js"></script>
<!-- <script src="/js/jquery-1.8.2.min.js"></script> -->
<script src="/js/jquery.easing.1.3.js"></script>
<script src="/js/jquery.cycle.all.min.js"></script>
<script src="/js/jquery.mousewheel.min.js"></script>
<!-- <script src="/js/jquery-ui-1.8.23.custom.min.js"></script> -->
<script src="/js/jquery-efuSlider.js"></script>
<script src="/mobile/js/iscroll.js"></script>
<script src="/js/common.js?t=<%=System.currentTimeMillis()%>"></script>
<script src="/js/efusioni.js?t=<%=System.currentTimeMillis()%>"></script>
<script src="/js/jquery-ui.min.js"></script>
<script src="/js/jquery.imgpreload.js"></script>
<script src="/js/imagesloaded.pkgd.js"></script>
<script src="/js/bluebird.min.js"></script>
<script src="/mobile/js/swiper.min.js"></script>
<script src="/mobile/js/slick.min.js"></script>
<script src="/mobile/js/jquery-ui.js?t=<%=System.currentTimeMillis()%>"></script>
<script>
	function getWindowOpenOption(){
		
		//새창의 크기
		var cw=450;
		var ch=476;
	 
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		
		//열 창의 포지션
		var px=(sw-cw)/2;
	    var py=(sh-ch)/2;
		
		return 'left='+px+',top='+py+',width='+cw+',height='+ch+',toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no';
	}
	
	function fnt_get_return_url(_type){
		var return_url_param_name = "&returnUrl=";
		var return_url = "<%= strUrl %>/integration/ssologin.jsp?endType=" + _type;
		var callurl = "<%= request.getRequestURI() %>";
<%
	if(!"".equals(request.getQueryString())) {
%>
		callurl += "?<%= request.getQueryString() %>";
<%
	}
%>
		return_url += "&callurl=" + callurl;
		return return_url_param_name + encodeURIComponent(return_url);
	}
	
	function fnt_login(_type) {
		<%-- 		if(_type == undefined){
					_type = "CALL";
				}
			    
		        var _popup_url = "<%= Env.getMaeildoUrl() %>/co/li/coli01t1.do?chnlCd=<%= chnlCd %>&coopcoCd=7040" + fnt_get_return_url(_type);
			    window.open(_popup_url,'popupMaeildoLogin', getWindowOpenOption());
				document.location.href = _popup_url; 
				
//		 		showPopupLayer('/mobile/popup/login.jsp');
//				document.location.href = '/mobile/mypage/login.jsp?callurl=' + encodeURIComponent(document.location.href);--%>
//		 	    var _popup_url = "<%=loginUrl%>?returnUrl=" + encodeURIComponent(document.location.href);
		 	    var _popup_url = "<%=loginUrl%>";
				document.location.href = _popup_url + "?type=<%= param.get("type") %>"
				
				return;
	}
	
	/*공통 로그아웃*/
	function fnt_logout(){
<%
	if(SystemChecker.isReal()) {
%>
		var _popup_url = "<%= Env.getMaeildoUrl() %>/auth/ssoLogout.do?chnlCd=<%= chnlCd %>&coopcoCd=7040&returnUrl=" + encodeURIComponent("http://<%= request.getServerName() %>/integration/ssologout.jsp?return_url=/mobile");
<%
	} else {
%>
		var _popup_url = "/integration/ssologout.jsp?return_url=/mobile";
<%
	}
%>
// 		window.open(_popup_url,'popupMaeildoLogin', getWindowOpenOption());
		document.location.href = _popup_url;
		return;
	}
	
	/*공통 회원가입*/
	function fnt_join(_type){
		
		//if(_type == undefined){
		//	_type = "I";
		//}
		//window.open("http://"+gbLoginDominUrl+"/member.do?command=signup_family&step=01&join_sec=27",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=no, copyhistory=no');
		//window.open(_popup_url,'popupMaeildoJoin', getWindowOpenOption());
		var _popup_url = "<%=joinUrl%>";
 		document.location.href=_popup_url + "?type=<%= param.get("type") %>"
		return;
	}
	
	/*공통 회원수정*/
	function fnt_member_info(_type){
	
<%-- 		if(_type == undefined){
			_type = "I";
		}
		
		var _popup_url =  "<%= Env.getMaeildoUrl() %>/co/mp/comp01t2.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);		
		window.open("http://"+gbLoginDominUrl+"/member.do?command=editinfo&guide=family",'','width=730, height=630, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
		window.open(_popup_url,'popupMaeildoInfo', getWindowOpenOption()); --%>
		var _popup_url = "<%=modifyUrl%>";
		document.location.href=_popup_url;
	 	return;
	}
	
<%-- 	/*공통 팝업 아이디,비번 찾기*/
	function fnt_find_id(_type){
	
		if(_type == undefined){
			_type = "I";
		}
		
		var _popup_url = "<%= Env.getMaeildoUrl() %>/co/pi/copi01t1.do?purpose=findID&chnlCd=<%= chnlCd %>&coopcoCd=7040" + fnt_get_return_url(_type) + "&target=web";
		
		//window.open("http://"+gbLoginDominUrl+"/member/find_idpw.jsp",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
		//window.open(_popup_url,'popupMaeildoId', getWindowOpenOption());
	    document.location.href=_popup_url;
	    return;
	}--%>
	
	/*공통 팝업 아이디,비번 찾기*/
	function fnt_find_pw(_type){
	
		if(_type == undefined){
			_type = "I";
		}
		
		<%-- var _popup_url = "<%= Env.getMaeildoUrl() %>/co/li/coli01t4.do?chnlCd=<%= chnlCd %>&coopcoCd=7040" + fnt_get_return_url(_type) + "&target=web"; --%>
		var _popup_url = "<%=updPwdUrl %>";
		//window.open("http://"+gbLoginDominUrl+"/member/find_idpw.jsp",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
		//window.open(_popup_url,'popupMaeildoPw', getWindowOpenOption());
	    document.location.href=_popup_url;
	    return;
	} 
	
	/*공통 비번 변경*/
 	function fnt_change_pw(_type){
	
		if(_type == undefined){
			_type = "I";
		}
		
		var _popup_url = "<%= Env.getMaeildoUrl() %>/co/mp/comp01t4.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
		var _popup_url = "<%=updPwdUrl %>";
		
		document.location.href=_popup_url;
		
		//window.open("http://"+gbLoginDominUrl+"/member/find_idpw.jsp",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
	    //window.open(_popup_url,'popupMaeildoPw', getWindowOpenOption(550));
	    return;
	}
	
 	function fnt_out(){
		var _popup_url = "<%=memLveUrl%>";
	   document.location.href=_popup_url;
	    return;
	}
	
	function goSetting() {
		if (typeof webkit != 'undefined') {
			try {
				webkit.messageHandlers.callbackHandler.postMessage('goAppSetting');
			} catch(err) {
				alert(err);
			}
		}else {
			document.location.href= "jscall://?{\"functionname\":\"goAppSetting\"}";
		}
	}
	
	/*임직원인증*/
	function fnt_corp_auth(){
		var _popup_url = "/mobile/member/corpAuth.jsp";
		document.location.href=_popup_url;
	    return;
	}
</script>

<jsp:include page="/include/apm.jsp" />
