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
<% if(Depth_1 == 1){ //브랜드 %>
<link rel="stylesheet" href="/css/brand-content.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/css/brand-content2.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/css/brand-content3.css?t=<%=System.currentTimeMillis()%>">
<% } else { //쇼핑 %>
<link rel="stylesheet" href="/css/content.css?t=<%=System.currentTimeMillis()%>">
<% } %>
<link rel="stylesheet" href="/css/redmond/jquery-ui-1.8.21.custom.css" type="text/css" media="all" /> 
<script src="/js/jquery-1.10.2.min.js"></script>
<!-- <script src="/js/jquery-1.8.2.min.js"></script> -->
<script src="/js/jquery.easing.1.3.js"></script>
<script src="/js/jquery.cycle.all.min.js"></script>
<script src="/js/jquery.mousewheel.min.js"></script>
<!-- <script src="/js/jquery-ui-1.8.23.custom.min.js"></script> -->
<script src="/js/jquery-efuSlider.js"></script>
<script src="/js/jquery-ui.js?t=<%=System.currentTimeMillis()%>"></script>
<script src="/js/common.js"></script>
<script src="/js/efusioni.js"></script>
<script src="/js/jquery-ui.min.js"></script>
<!--[if lte IE 9]>
<link rel="stylesheet" href="/css/content.ie9.css?t=<%=System.currentTimeMillis()%>"> 
<![endif]-->
<!--[if lte IE 8]>
<link rel="stylesheet" href="/css/content.ie8.css?t=<%=System.currentTimeMillis()%>"> 
<script src="/js/jquery-ui.ie8.js?t=<%=System.currentTimeMillis()%>"></script>
<![endif]-->
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
		return return_url_param_name + return_url;
	}
	
	function fnt_login(_type) {
		//alert("gb_login() start !!");
		
		if(_type == undefined){
			_type = "I";
		}
	    
	    //var returnurl = "http://"+gbDominUrl+"/member/loginReload.jsp";
		//var popupURL = "http://"+gbLoginDominUrl+"/member/member_login.jsp?returnurl=" + returnurl;
		var _popup_url = "/co/li/coli01t1.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
	
		window.open(_popup_url,'popupMaeildoLogin', getWindowOpenOption());
		return;
	}
	
	/*공통 로그아웃*/
	function fnt_logout(){
		var _popup_url = "/auth/ssoLogout.do?chnlCd=3&coopcoCd=7040&returnUrl=http://<%= request.getServerName() %>/integration/ssologout.jsp";
		window.open(_popup_url,'popupMaeildoLogin', getWindowOpenOption());
		return;
	}
	
	/*공통 회원가입*/
	function fnt_join(_type){
	
		if(_type == undefined){
			_type = "I";
		}
		
		var _popup_url = "/co/pi/copi01t1.do?purpose=joinMember&chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
		
		//window.open("http://"+gbLoginDominUrl+"/member.do?command=signup_family&step=01&join_sec=27",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=no, copyhistory=no');
		window.open(_popup_url,'popupMaeildoJoin', getWindowOpenOption());
		return;
	}
	
	/*공통 회원수정*/
	function fnt_member_info(_type){
	
		if(_type == undefined){
			_type = "C";
		}
		
		//var _popup_url = "https://www.maeildo.com/co/mp/comp01t2.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
		var _popup_url = "/integration/info_manage.jsp";
		
		//window.open("http://"+gbLoginDominUrl+"/member.do?command=editinfo&guide=family",'','width=730, height=630, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
	   	window.open(_popup_url,'popupMaeildoInfo', getWindowOpenOption());
	 	return;
	}
	
	/*공통 팝업 아이디,비번 찾기*/
	function fnt_find_id(_type){
	
		if(_type == undefined){
			_type = "C";
		}
		
		var _popup_url = "/co/pi/copi01t1.do?purpose=findID&chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
		
		//window.open("http://"+gbLoginDominUrl+"/member/find_idpw.jsp",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
	    window.open(_popup_url,'popupMaeildoId', getWindowOpenOption());
	    return;
	}
	
	/*공통 팝업 아이디,비번 찾기*/
	function fnt_find_pw(_type){
	
		if(_type == undefined){
			_type = "C";
		}
		
		var _popup_url = "/co/li/coli01t4.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
		
		//window.open("http://"+gbLoginDominUrl+"/member/find_idpw.jsp",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
	    window.open(_popup_url,'popupMaeildoPw', getWindowOpenOption());
	    return;
	}
</script>
