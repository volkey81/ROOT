<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="com.sanghafarm.common.*,
			com.efusioni.stone.common.*" %>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");	
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
%>
<% if(MENU_TITLE == ""){ %>
<title>상하농원</title>
<% } else { %>
<title><%=request.getAttribute("MENU_TITLE") %> | 상하농원</title>
<% } %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="format-detection" content="telephone=no">
<meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0, maximum-scale=3.0, minimum-scale=1.0">
<% if(Depth_1 == 1){ //브랜드 %>
<link rel="stylesheet" href="/mobile/css/brand-content.css?t=<%=System.currentTimeMillis()%>">
<% } else { //쇼핑 %>
<link rel="stylesheet" href="/mobile/css/content.css?t=<%=System.currentTimeMillis()%>">
<% } %>
<link rel="stylesheet" href="/css/redmond/jquery-ui-1.8.21.custom.css" type="text/css" media="all" /> 
<script src="/js/jquery-1.10.2.min.js"></script>
<!-- <script src="/js/jquery-1.8.2.min.js"></script> -->
<script src="/js/jquery.easing.1.3.js"></script>
<script src="/js/jquery.cycle.all.min.js"></script>
<script src="/js/jquery.mousewheel.min.js"></script>
<!-- <script src="/js/jquery-ui-1.8.23.custom.min.js"></script> -->
<script src="/js/jquery-efuSlider.js"></script>
<script src="/mobile/js/iscroll.js"></script>
<script src="/mobile/js/jquery-ui.js?t=<%=System.currentTimeMillis()%>"></script>
<script src="/js/common.js"></script>
<script src="/js/efusioni.js"></script>
<script src="/js/jquery-ui.min.js"></script>
<script src="/mobile/js/swiper.min.js"></script>
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
		var return_url = "http://<%= request.getServerName() %>/integration/ssologin.jsp?endType=" + _type;
		var callurl = "<%//= request.getRequestURI() %>";
<%
	if(!"".equals(request.getQueryString())) {
%>
		callurl += "?<%//= request.getQueryString() %>";
<%
	}
%>
		return_url += "&callurl=" + callurl;
		return return_url_param_name + encodeURIComponent(return_url);
	}
	
	function fnt_login(_type) {
		/*
		if(_type == undefined){
			_type = "CALL";
		}
	    
		var _popup_url = "<%//= Env.getMaeildoUrl() %>/co/li/coli01t1.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
	
// 		window.open(_popup_url,'popupMaeildoLogin', getWindowOpenOption());
		document.location.href = _popup_url;
		*/
		
// 		showPopupLayer('/mobile/popup/login.jsp');
		document.location.href = '/mobile/mypage/login.jsp?callurl=' + encodeURIComponent(document.location.href);
		return;
	}
	
	/*공통 로그아웃*/
	function fnt_logout(){
<%
	if(SystemChecker.isReal()) {
%>
		var _popup_url = "<%//= Env.getMaeildoUrl() %>/auth/ssoLogout.do?chnlCd=3&coopcoCd=7040&returnUrl=" + encodeURIComponent("http://<%= request.getServerName() %>/integration/ssologout.jsp?return_url=/mobile");
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
	
		if(_type == undefined){
			_type = "I";
		}
		
		var _popup_url = "<%//= Env.getMaeildoUrl() %>/co/pi/copi01t1.do?purpose=joinMember&chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
		
		//window.open("http://"+gbLoginDominUrl+"/member.do?command=signup_family&step=01&join_sec=27",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=no, copyhistory=no');
//  		window.open(_popup_url,'popupMaeildoJoin', getWindowOpenOption());
 		document.location.href=_popup_url;
		return;
	}
	
	/*공통 회원수정*/
	function fnt_member_info(_type){
	
		if(_type == undefined){
			_type = "I";
		}
		
		//var _popup_url = "https://www.maeildo.com/co/mp/comp01t2.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
		var _popup_url = "/integration/info_manage.jsp";
		
		//window.open("http://"+gbLoginDominUrl+"/member.do?command=editinfo&guide=family",'','width=730, height=630, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
// 	   	window.open(_popup_url,'popupMaeildoInfo', getWindowOpenOption());
		document.location.href=_popup_url;
	 	return;
	}
	
	/*공통 팝업 아이디,비번 찾기*/
	function fnt_find_id(_type){
	
		if(_type == undefined){
			_type = "I";
		}
		
		var _popup_url = "<%//= Env.getMaeildoUrl() %>/co/pi/copi01t1.do?purpose=findID&chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
		
		//window.open("http://"+gbLoginDominUrl+"/member/find_idpw.jsp",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
// 	    window.open(_popup_url,'popupMaeildoId', getWindowOpenOption());
	    document.location.href=_popup_url;
	    return;
	}
	
	/*공통 팝업 아이디,비번 찾기*/
	function fnt_find_pw(_type){
	
		if(_type == undefined){
			_type = "I";
		}
		
		var _popup_url = "<%//= Env.getMaeildoUrl() %>/co/li/coli01t4.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
		
		//window.open("http://"+gbLoginDominUrl+"/member/find_idpw.jsp",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
// 	    window.open(_popup_url,'popupMaeildoPw', getWindowOpenOption());
	    document.location.href=_popup_url;
	    return;
	}
</script>
