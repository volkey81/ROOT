<%@page import="com.sanghafarm.common.Env"%>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.sanghafarm.common.*"%>
<%@ page import="com.efusioni.stone.utils.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String indexUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/mypage/index.jsp";
	String reaveURL = request.getScheme() + "://" + request.getServerName() + "/mobile/member/leaveProc.jsp";

	FrontSession fs = FrontSession.getInstance(request, response);
	
	String failUrl = Env.getURLPath() + "/mobile/member/login.jsp"; //로그인 URL	
	String referer = request.getHeader("referer");
	System.out.println("--------- memLeave2.jsp ----------referer : " + request.getHeader("referer"));
	
	if(!fs.isLogin()) {
		Utils.sendMessage(out, "잘못된 접근입니다.", failUrl);
		return;
	}
	
// 	if(!fs.isApp() && (referer == null || referer.indexOf("isSamePwdProc.jsp") == -1)) {
// 		Utils.sendMessage(out, "잘못된 접근입니다.", "memLeave1.jsp");
// 		return;
// 	}

	String passwdChk = (String) session.getAttribute("PASSWD_CHECK");
	if(!fs.isSns() && !fs.isApp() && (passwdChk == null || !"Y".equals(passwdChk))) {
		Utils.sendMessage(out, "잘못된 접근입니다.", "memLeave1.jsp");
		return;
	}
	
	session.removeAttribute("PASSWD_CHECK");
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
var doubleSubmitFlag = false;

function cancel() {
	if(parent.opener != null ) {	
  		 window.close();
	}else{
		location.href = "<%=indexUrl%>";
	} 
}

function leave() {

    if(doubleSubmitCheck()) return;
    
    $.ajax({
        type : "GET",
        url : "/mobile/member/leaveProc.jsp",
        data: {
            Name: 'ajax',
            Age: '10'
        },
        dataType : "json",
        success : function(data) {
            if(data.result == "true") {
        		var _popup_url = "<%= Env.getMaeildoUrl() %>/auth/ssoLogout.do?chnlCd=3&coopcoCd=7040&returnUrl=http://<%= request.getServerName() %>/integration/ssologout.jsp";
    			
        		if(parent.opener != null ) {
        			self.close();
        			opener.window.open(_popup_url,'popupMaeildoLogin', 'width=450, height=500, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=300, top=200');
        		}else{
        			window.open(_popup_url,'popupMaeildoLogin', 'width=450, height=500, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=300, top=200');
        		}
            	
            }else{	
            	alert(data.message);
            }                    
        }
    });
    
    doubleSubmitFlag = false;
}

//이중처리방지
function doubleSubmitCheck(){
    if(doubleSubmitFlag){
        return doubleSubmitFlag;
    }else{
        doubleSubmitFlag = true;
        return false;
    }
}

</script>
</head>  
<body>
<div id="wrapper" class="login">
	<%-- <jsp:include page="/mobile/include/header.jsp" /> --%>
	<div class="loginHead">
		<img src="/mobile/images/member/head.jpg" alt="" />
	</div> 	
	<div id="container" class="join">	
	<!-- 내용영역 -->
	<div class="logInTop lgPop">
		<strong>회원탈퇴</strong>
		<jsp:include page="/mobile/member/memberClose.jsp" />
	</div>
	
	<div class="LeaveMessege">
		<strong>그동안 상하농원과<br />함께해주셔서 감사합니다.</strong>
		<p>회원탈퇴를 위한 약관철회 전 안내 사항 확인해주세요</p>
	</div>
	<div class="LeaveInfo">
		<ul>
			<li>
				<strong>사이트 이용제한</strong>
				<p>
					상하농원 사이트 로그인 및 이용이 제한됩니다. 
					탈퇴후 30일 이내는 재가입이 가능하며, 기존 정보가 모두 복구됩니다.
				</p>
			</li>
			<li>
				<strong>매일 Do 포인트 이용</strong>
				<p>
					적립된 매일Do 포인트는 매일Do 서비스를 통하여 1년동안 
					유지되며, 30일내 재가입 하시는 경우 상하농원에서 사용 가능합니다.
				</p>
			</li>
			<li>
				<strong>주문/교환/반품 진행 시 탈퇴 불가</strong>
				<p>
					파머스마켓에서 진행 중인 주문/교환/반품 건이 있는 경우 
					구매확정/교환완료/반품완료 이후 탈퇴 가능합니다.
				</p>
			</li>
			<li>
				<strong>온라인 숙박예약 결제완료, 숙박취소대기 시 탈퇴불가</strong>
				<p>
					온라인으로 호텔 숙박예약 및 숙박취소대기 중인 건이 있는 경우 
					예약취소/취소처리완료 이후에 탈퇴 가능합니다.
				</p>
			</li>
			<li>
				<strong>온라인 체험예약 결제완료 시 탈퇴불가</strong>
				<p>
					온라인으로 체험예약 이용일 전인 경우, 결제를 취소하셔야
					탈퇴 가능합니다.
				</p>
			</li>
			<li>
				<strong>상하가족 가입해지 및 혜택 철회</strong>
				<p>
					탈퇴하시면 상하가족 가입기간이 남아있더라도 상하가족
					가입이 해지되며, 잔여 혜택이 철회 됩니다.
				</p>
			</li>												
		</ul>
	</div>
	<div class="btnWarp">
		<a href="javascript:void(0)" class="btnCheck Large" onclick="leave();">회원탈퇴</a>	
		<a href="javascript:void(0)" style="margin-top:5px;" class="btnCheck Large white" onclick="cancel();">취소</a>				
	</div>	
		
	<!-- //내용영역 -->
	</div><!-- //container -->
</div><!-- //wrapper -->
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
</html>
