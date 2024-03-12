<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.member.*,
			com.sanghafarm.utils.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("로그인"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	String idSave = SanghafarmUtils.getCookie(request, "id_save");
	String loginSave = SanghafarmUtils.getCookie(request, "login_save");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	var isProcessing = false;
	var v;
	
	$(function() {
		v = new ef.utils.Validator($("#loginForm"));
		
		v.add("id", {
			"empty" : "아이디를 입력해 주세요.",
			"min" : 4,
			"max" : 20
		});
		v.add("pwd", {
			"empty" : "비밀번호를 입력해 주세요.",
			"min" : 1,
			"max" : 20
		});
	});
	
	function goLogin() {
		if(v.validate() && !isProcessing) {
			isProcessing = true;
			var param = {
					id : $("#id").val(),
					pwd : $("#pwd").val(),
					id_save : ($("#id_save").prop("checked") ? "Y" : ""),
					login_save : ($("#login_save").prop("checked") ? "Y" : ""),
					contentType : "application/x-www-form-urlencoded; charset=UTF-8"
				};
			
			$.ajax({
				url : "<%= Env.getSSLPath() %>/mobile/mypage/loginProc.jsp",
				method : "POST",
				data : param, 
				dataType : "jsonp",
				jsonp : "callback"
			}).done(function(json) {
				if(json.resultCode == 'S0000') {
<%
	if("A".equals(fs.getDeviceType())) {	
%>
					if (typeof webkit != 'undefined') {
						try {
							webkit.messageHandlers.setTmsLoginId.postMessage(json.userid);
						} catch(err) {
							alert(err);
						}
					}else {
						try {
	// 						document.location.href = "jscall://?{\"functionname\":\"setTmsLoginId\", \"userid\":\"" + json.userid + "\"}";
							var rootElm = document.documentElement;
							var newFrameElm = document.createElement("IFRAME");
							newFrameElm.setAttribute("src","jscall://?{\"functionname\":\"setTmsLoginId\", \"userid\":\"" + json.userid + "\"}");
							rootElm.appendChild(newFrameElm);
							newFrameElm.parentNode.removeChild(newFrameElm);
						} catch(e) {}
					}
<%
	}
%>
					//ET.exec('login', json.userid);
					//document.location.href='<%= param.get("callurl", "/mobile") %>';
					document.location.href='sso.jsp?callurl=<%= param.get("callurl", "/mobile") %>';
				} else {
					isProcessing = false;
					if(json.resultCode == 'E1000') {
						alert("아이디/비밀번호를 다시 확인 해 주세요.");
					} else if(json.resultCode == 'E1001') {
						if(confirm("매일Do 에서 휴면회원 해제(본인인증) 해주셔야 합니다.\n확인을 누르시면 매일Do 로 이동합니다.")) {
							document.location.href="<%= Env.getMaeildoUrl() %>";
						}
					} else if(json.resultCode == 'E1002') {
						if(confirm("매일Do에서 ‘상하농원’ 약관 동의 해주셔야 합니다.\n확인을 누르시면 매일Do로 이동합니다.")) {
//							document.location.href="<%= Env.getMaeildoUrl() %>";
							document.location.href="<%= Env.getMaeildoUrl() %>/co/pi/copi02t1.do?chnlCd=3&coopcoCd=7040&returnUrl=http://<%= request.getServerName() %>/mobile";
						}
					} else if(json.resultCode == 'E1003') {
						if(confirm("회원 재가입이 필요한 상태입니다.\n매일Do에서 로그인하시어 안내 받으시기 바랍니다.\n확인을 누르시면 매일Do로 이동합니다.")) {
							document.location.href="<%= Env.getMaeildoUrl() %>";
						}
					} else if(json.resultCode == 'E1004') {
						if(confirm("회원가입이 필요합니다.\n매일Do에서 회원가입을 해주세요.\n확인을 누르시면 매일Do로 이동합니다.")) {
							document.location.href="<%= Env.getMaeildoUrl() %>";
						}
					} else {
						alert(json.msg);
					}
				}
			});
		}
	}
	
	function snsLogin(arg) {
		var param = "coopcoCd=<%= ImMemberService.COOPCO_CD %>&chnlCd=<%= ImMemberService.CHNL_CD %>&ntryPath=<%= ImMemberService.NTRY_PATH %>";
		param += "&returnUrl=" + encodeURIComponent("http://<%= request.getServerName() %>/mobile/mypage/snsLoginProc.jsp");
		param += "&socKindCd=" + arg + "&clientIp=<%= request.getRemoteAddr() %>";
		
		document.location.href = "<%= Env.getMaeildoUrl() %>/auth/snsLogin.do?" + param;
	}
</script>
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<p class="back"><a href="#" onclick="history.back(); return false"><img src="/mobile/images/btn/btn_prev4.gif" alt="뒤로"></a></p>
	<div id="popCont">
	<!-- 내용영역 -->
		<div class="loginArea">
			<fieldset>
			<form name="loginForm" id="loginForm" action="<%= Env.getSSLPath() %>/integration/loginProc.jsp" method="post">
				<legend>로그인</legend>
				<div class="field">
					<p class="uid"><input type="text" name="id" id="id" title="아이디" placeholder="아이디" value="<%= idSave %>"></p>
					<p class="pwd"><input type="password" name="pwd" id="pwd" title="비밀번호" placeholder="비밀번호"></p>
				</div>
				<p class="chk">
					<input type="checkbox" id="id_save" value="Y" <%= !"".equals(idSave) ? "checked" : "" %>><label for="id_save">아이디 저장</label>
<%
	if(fs.isApp()) {
%>
					<input type="checkbox" id="login_save" value="Y" <%= "Y".equals(loginSave) ? "checked" : "" %>><label for="login_save">로그인 유지</label>
<%
	}
%>
				</p>
				<p class="btn"><a href="javascript:goLogin()" class="btnTypeB sizeL">로그인</a></p>
			</fieldset>
			</form>
<%
	String userAgent = request.getHeader("User-Agent").toLowerCase();

// 	if(!"A".equals(fs.getDeviceType()) || !(userAgent.indexOf("iphone") > -1 || userAgent.indexOf("ipad") > -1 || userAgent.indexOf("ipod") > -1)) {
%>			
			<ul class="member" >
				<li class="fb"><a href="javascript:fnt_join();">회원가입</a></li>
				<li><a href="javascript:fnt_find_id();">아이디 찾기</a></li>
				<li><a href="javascript:fnt_find_pw();">비밀번호 찾기</a></li>
			</ul>
<%
// 	}
%>
			<ul class="snsLogin">
				<li><a href="#" onclick="snsLogin('F'); return false" class="facebook">페이스북 계정 로그인</a></li>
				<li><a href="#" onclick="snsLogin('K'); return false" class="kakao">카카오 계정 로그인</a></li>
				<li><a href="#" onclick="snsLogin('N'); return false" class="naver">네이버 계정 로그인</a></li>
			</ul>
		</div>
	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->
<script>
//팝업높이조절
setPopup(<%=layerId%>);
</script>
</body>
</html>