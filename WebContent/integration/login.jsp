<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.member.*" %>
<%
	if(!SystemChecker.isReal()) {
%>
<script>
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
	var return_url = "http://<%= request.getServerName() %>/integration/ssologin.jsp?endType=" + _type;
	return return_url_param_name + return_url;
}

function fnt_login(_type) {
	if(_type == undefined){
		_type = "R";
	}
	
	var _popup_url = "<%= Env.getMaeildoUrl() %>/co/li/coli01t1.do?chnlCd=3&coopcoCd=7040" + fnt_get_return_url(_type);
	
	window.open(_popup_url,'popupMaeildoLogin', getWindowOpenOption(528));
	return;
}
</script>

<a href="loginProc.jsp?unfy_mmb_no=2004321976">hassel(2004321976)</a><br/>
<a href="loginProc.jsp?unfy_mmb_no=1000004642">hassel3(1000004642)</a><br/>
<a href="loginProc.jsp?unfy_mmb_no=1000001417">stest001(1000001417)</a><br/>
<a href="loginProc.jsp?unfy_mmb_no=1000001418">stest002(1000001418)</a><br/>
<a href="loginProc.jsp?unfy_mmb_no=1000001419">stest003(1000001419)</a><br/>
<a href="loginProc.jsp?unfy_mmb_no=1000001420">stest004(1000001420)</a><br/>
<a href="loginProc.jsp?unfy_mmb_no=1000001421">stest005(1000001421)</a><br/>
<a href="loginProc.jsp?unfy_mmb_no=1000001901">test7040(기프트카드)(1000001901)</a><br/>
<a href="loginProc.jsp?unfy_mmb_no=1000002042">SNSLOGIN(1000002042)</a><br/>
<a href="loginProc.jsp?unfy_mmb_no=1000002805">smashpop4(1000002805)</a><br/>
<br/>
<br/>
<br/>
<a href="javascript:fnt_login()">PC 로그인</a><br/>
<a href="/mobile/mypage/login.jsp?callurl=/mobile">모바일 로그인</a><br/>
<a href="/mobile/member/login.jsp">(신)로그인</a><br/>

<%
	} else {
		response.sendRedirect("/");
	}
%>
