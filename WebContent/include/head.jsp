<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="com.sanghafarm.common.*,
			com.efusioni.stone.common.*" %>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");	
	int	Depth_4	=	(Integer)request.getAttribute("Depth_4") == null ? 0 : (Integer)request.getAttribute("Depth_4");//객실예약하기	
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	if(request.getServletPath().indexOf("/brand/") != -1) {
		MENU_TITLE = "‘짓다 ∙ 놀다 ∙ 먹다’";
	}

	// 모바일 기기 체크
	FrontSession fs = FrontSession.getInstance(request, response);
	boolean isMobileOS = false;
	if("A".equals(fs.getDeviceType())) {
		isMobileOS = true;
	} else {
		String ua=request.getHeader("User-Agent").toLowerCase();
		if (ua.matches(".*(android|avantgo|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\\/|plucker|pocket|psp|symbian|treo|up\\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino).*")||ua.substring(0,4).matches("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\\-(n|u)|c55\\/|capi|ccwa|cdm\\-|cell|chtm|cldc|cmd\\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\\-s|devi|dica|dmob|do(c|p)o|ds(12|\\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\\-|_)|g1 u|g560|gene|gf\\-5|g\\-mo|go(\\.w|od)|gr(ad|un)|haie|hcit|hd\\-(m|p|t)|hei\\-|hi(pt|ta)|hp( i|ip)|hs\\-c|ht(c(\\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\\-(20|go|ma)|i230|iac( |\\-|\\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\\/)|klon|kpt |kwc\\-|kyo(c|k)|le(no|xi)|lg( g|\\/(k|l|u)|50|54|e\\-|e\\/|\\-[a-w])|libw|lynx|m1\\-w|m3ga|m50\\/|ma(te|ui|xo)|mc(01|21|ca)|m\\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\\-2|po(ck|rt|se)|prox|psio|pt\\-g|qa\\-a|qc(07|12|21|32|60|\\-[2-7]|i\\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\\-|oo|p\\-)|sdk\\/|se(c(\\-|0|1)|47|mc|nd|ri)|sgh\\-|shar|sie(\\-|m)|sk\\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\\-|v\\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\\-|tdg\\-|tel(i|m)|tim\\-|t\\-mo|to(pl|sh)|ts(70|m\\-|m3|m5)|tx\\-9|up(\\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\\-|2|g)|yas\\-|your|zeto|zte\\-")){
			isMobileOS = true; 
			if(ua.indexOf("v901") > -1 || ua.indexOf("v500") > -1 || ua.indexOf("v525") > -1 || ua.indexOf("lg-v700n") > -1 || ua.indexOf("lg-v607l") > -1) { 
				isMobileOS = false;	
			}
		}
	}
	
	String strUrl = request.getScheme() + "://" + request.getServerName();
	String loginUrl = strUrl + "/mobile/member/login.jsp";//로그인 URL
	String joinUrl = strUrl + "/mobile/member/joinStep2.jsp";//회원가입 URL
	String modifyUrl = fs.isSns() ? strUrl + "/mobile/member/modifySns2.jsp" : strUrl + "/mobile/member/memModify1.jsp";//회원정보수정 URL
	String updPwdUrl = strUrl + "/mobile/member/findPwd2.jsp";//비밀번호 변경 URL
	String memLveUrl = fs.isSns() ? strUrl + "/mobile/member/memLeave2.jsp" : strUrl + "/mobile/member/memLeave1.jsp";//회원탈퇴 URL
	

	if(isMobileOS && request.getRequestURI().indexOf("/mobile/") == -1) {
		String redirect = "/mobile" + request.getRequestURI();
		if(request.getQueryString() != null) redirect += "?" + request.getQueryString();
		System.out.println("++++++++++++++++++++ " + redirect);
// 		response.sendRedirect(redirect);
%>
<script>
document.location.href='<%= redirect %>';
</script>
<%
		return;
	}
%>
<% if(MENU_TITLE == ""){ %>
<title>상하농원</title>
<% } else { %>
<title><%= MENU_TITLE %> | 상하농원</title>
<% } %>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="robots" content="index,follow">
<meta name="description" content="자연과 교감하고, 건강한 먹거리를 즐기는 농촌형 테마공원 | 전라도 고창군 상하 | 체험교실, 동물체험, 레스토랑, 폴바셋"/>
<meta name="description" content="건강한 먹거리의 가치를 생각하는 상하농원 농부의 땀과 정성을 담은 파머스마켓 | 계란, 수제소시지, 수제쨈, 신선식품, 상하목장"/>
<meta name="keywords" content="고창, 상하, 상하목장, 동물체험, 어린이체험, 폴바셋, 계란, 유기농, 채소"/>
<meta name="subject" content="농원소개, 짓다, 놀다, 먹다, 상하공방, 매일유업, 신선식품, 정육,계란, 가공식품, 식품명인, 정기배송, 산지직송" />
<meta property="og:title" content="먹다·놀다·짓다|상하농원">
<meta property="og:description" content="자연과 교감하고, 건강한 먹거리를 즐기는 농촌형 테마공원">
<meta property="og:image" content="http://www.sanghafarm.co.kr/images/layout/logo.png">
<meta property="og:url" content="http://www.sanghafarm.co.kr">
<meta property="al:ios:url" content="https://itunes.apple.com/app/id1239671849">
<meta property="al:ios:app_store_id" content="1239671849">
<meta property="al:ios:app_name" content="상하농원">
<meta property="al:android:url" content="applinks://play.google.com/store/apps/details?id=com.sanghafarm">
<meta property="al:android:app_name" content="상하농원">
<meta property="al:android:package" content="com.sanghafarm">

<link rel="stylesheet" href="/css/layout.css?t=<%=System.currentTimeMillis()%>">
<% if(Depth_1 == 1){ //브랜드 %>
<link rel="stylesheet" href="/css/brand-content.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/css/slick.css?t=<%=System.currentTimeMillis()%>">
<% } else if(Depth_1 == 5) { // 파머스 빌리지 %>
<link rel="stylesheet" href="/css/hotel_content.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/css/slick.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/css/animate.css">
<% } else { // 쇼핑 %>
<link rel="stylesheet" href="/css/common.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/css/content.css?t=<%=System.currentTimeMillis()%>">
<% } %>
<link rel="stylesheet" href="/css/redmond/jquery-ui-1.8.21.custom.css" type="text/css" media="all" /> 
<link rel="stylesheet" href="/css/swiper.css?t=<%=System.currentTimeMillis()%>" type="text/css" media="all" /> 
<script src="/js/jquery-1.10.2.min.js"></script>
<!-- <script src="/js/jquery-1.8.2.min.js"></script> -->
<script src="/js/jquery.easing.1.3.js"></script>
<script src="/js/jquery.cycle.all.min.js"></script>
<script src="/js/jquery.mousewheel.min.js"></script>
<!-- <script src="/js/jquery-ui-1.8.23.custom.min.js"></script> -->
<script src="/js/jquery-efuSlider.js"></script>
<script src="/js/jquery-ui.js?t=<%=System.currentTimeMillis()%>"></script>
<script src="/js/common.js?t=<%=System.currentTimeMillis()%>"></script>
<script src="/js/efusioni.js?t=<%=System.currentTimeMillis()%>"></script>
<script src="/js/jquery-ui.min.js"></script>
<script src="/mobile/js/swiper.min.js"></script>
<script src="/js/slick.js"></script>
<script src="/js/bluebird.min.js"></script>
<script src="/js/imagesloaded.pkgd.js"></script>
<!--[if lte IE 9]>
<link rel="stylesheet" href="/css/content.ie9.css?t=<%=System.currentTimeMillis()%>"> 
<![endif]-->
<!--[if lte IE 8]>
<link rel="stylesheet" href="/css/content.ie8.css?t=<%=System.currentTimeMillis()%>"> 
<script src="/js/jquery-ui.ie8.js?t=<%=System.currentTimeMillis()%>"></script>
<![endif]-->
<script>
<%
	if(SystemChecker.isReal()) {
%>
	$(document).bind("contextmenu", function(e){
// 		alert("마우스 우클릭 및 드래그를 허용하지 않습니다. 소중한 저작권을 보호해 주세요.");
		return false;
	});
<%
	}
%>
	
	function getWindowOpenOption(height){ 
		
		//새창의 크기
		var cw=450;
		var ch=476;
		if(height){
			ch = height
		}
	 
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
		var return_url = "<%=strUrl %>/integration/ssologin.jsp?endType=" + _type;
		return return_url_param_name + return_url;
	}
	
	function fnt_login(_type) {
<%
	if(!SystemChecker.isReal()) {
%>
        var _popup_url = "<%=loginUrl%>";
	    //window.open(_popup_url,'popupMaeildoLogin', getWindowOpenOption(604));
		location.href = _popup_url + "?type=web"
<%
	} else {
%>
		//alert("gb_login() start !!");
		
		if(_type == undefined){
			_type = "R";
		}
	    
	    //var returnurl = "http://"+gbDominUrl+"/member/loginReload.jsp";
		//var popupURL = "http://"+gbLoginDominUrl+"/member/member_login.jsp?returnurl=" + returnurl;
		//var _popup_url = "<%= Env.getMaeildoUrl() %>/co/li/coli01t1.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
	    var _popup_url = "https://www.sanghafarm.co.kr/mobile/member/login.jsp?returnUrl=" + encodeURIComponent(document.location.href);
		//window.open(_popup_url,'popupMaeildoLogin', getWindowOpenOption(604));
		//return;
		location.href = _popup_url + "&type=web"
<%
	}
%>
	}
	
	/*공통 로그아웃*/
	function fnt_logout(){
		var _popup_url = "<%= Env.getMaeildoUrl() %>/auth/ssoLogout.do?chnlCd=3&coopcoCd=7040&returnUrl=http://<%= request.getServerName() %>/integration/ssologout.jsp";
		window.open(_popup_url,'popupMaeildoLogin', getWindowOpenOption());
		return;
	}
	
	/*공통 회원가입*/
	function fnt_join(_type){
		
		if(_type == undefined){
			_type = "I";
		}
		
		var _popup_url = "<%=joinUrl%>";
		
		//window.open("http://"+gbLoginDominUrl+"/member.do?command=signup_family&step=01&join_sec=27",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=no, copyhistory=no');
		//window.open(_popup_url,'popupMaeildoJoin', getWindowOpenOption(604));
		//return;
		location.href = _popup_url + "?type=web"
	}
	
	/*공통 회원수정*/
	function fnt_member_info(_type){
	
<%-- 		if(_type == undefined){
			_type = "I";
		}
		
		var _popup_url = "<%= Env.getMaeildoUrl() %>/co/mp/comp01t2.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type); --%>
		var _popup_url = "<%=modifyUrl%>";
		
		//window.open("http://"+gbLoginDominUrl+"/member.do?command=editinfo&guide=family",'','width=730, height=630, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
	   	window.open(_popup_url,'popupMaeildoInfo', getWindowOpenOption(600));
	 	return;
	}
	
<%-- 	/*공통 팝업 아이디,비번 찾기*/
	function fnt_find_id(_type){
	
		if(_type == undefined){
			_type = "I";
		}
		
		var _popup_url = "<%= Env.getMaeildoUrl() %>/co/pi/copi01t1.do?purpose=findID&chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
		
		//window.open("http://"+gbLoginDominUrl+"/member/find_idpw.jsp",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
	    window.open(_popup_url,'popupMaeildoId', getWindowOpenOption());
	    return;
	}
	
	/*공통 팝업 아이디,비번 찾기*/
	function fnt_find_pw(_type){
	
		if(_type == undefined){
			_type = "I";
		}
		
		var _popup_url = "<%= Env.getMaeildoUrl() %>/co/li/coli01t4.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
		
		//window.open("http://"+gbLoginDominUrl+"/member/find_idpw.jsp",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
	    window.open(_popup_url,'popupMaeildoPw', getWindowOpenOption());
	    return;
	} --%>

	/*공통 비번 변경*/
 	function fnt_change_pw(_type){
	
		if(_type == undefined){
			_type = "I";
		}
		
		var _popup_url = "<%= Env.getMaeildoUrl() %>/co/mp/comp01t4.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
		var _popup_url = "<%=updPwdUrl %>";
		
		//window.open("http://"+gbLoginDominUrl+"/member/find_idpw.jsp",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
	    window.open(_popup_url,'popupMaeildoPw', getWindowOpenOption(550));
	    return;
	}

	/*마케팅 정보수신동의 변경*/
	function fnt_change_mkt(_type){
	
		if(_type == undefined){
			_type = "I";
		}
		
		var _popup_url = "<%= Env.getMaeildoUrl() %>/co/mp/comp01t9.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
		
		//window.open("http://"+gbLoginDominUrl+"/member/find_idpw.jsp",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
	    window.open(_popup_url,'popupMaeildoPw', getWindowOpenOption(394));
	    return;
	} 

	/*약관동의철회*/
	function fnt_out(){
		<%-- var _popup_url = "<%= Env.getMaeildoUrl() %>/co/mp/comp01r7.do?chnlCd=3&coopcoCd=7040&returnUrl=http://<%= request.getServerName() %>/integration/ssologout.jsp"; --%>
		var _popup_url = "<%=memLveUrl%>";
		//window.open("http://"+gbLoginDominUrl+"/member/find_idpw.jsp",'','width=1000, height=600, left=0,top=0,toolbar=no, location=no, directories=no, status=no, menubar=no, resizable=no, scrollbars=yes, copyhistory=no');
	    window.open(_popup_url,'popupMaeildoPw', getWindowOpenOption(600));
	    return;
	}
	
	/*임직원인증*/
	function fnt_corp_auth(){
		var _popup_url = "/mobile/member/corpAuth.jsp";
	    window.open(_popup_url,'corpAuth', getWindowOpenOption(370));
	    return;
	}
</script>

<jsp:include page="/include/apm.jsp" />
