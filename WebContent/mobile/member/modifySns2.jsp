<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sanghafarm.common.*"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.sanghafarm.service.member.MemberService"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.common.*" %>
<%@ page import ="java.util.*,java.text.SimpleDateFormat"%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	String failUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/login.jsp"; //로그인 URL	
	
	if(!fs.isLogin()) {
		Utils.sendMessage(out, "잘못된 접근입니다.", failUrl);
		return;
	}
	
	MemberService member = (new MemberService()).toProxyInstance();
	Param info = member.getImInfo(fs.getUserNo());
	if (info == null) {	
		Utils.sendMessage(out, "해당하는 회원정보가 존재하지 않습니다.", failUrl);
		return;
	}
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>

	$(function(){
		//secon fold
		var joinInOn = $(".join_TTOn").closest(".jointoggleTT");
		var joinWpOn = $(".join_agmOn").closest(".jointoggleTT");
		joinInOn.next().hide();
		joinWpOn.next().hide();
		$(".join_agmOn , .join_TTOn").on('click',function(){
			$(this).closest(".jointoggleTT").toggleClass("onArrjoin");
			$(this).closest(".jointoggleTT").next("div").toggle();
		});
		
		//checkbox 1
		if ($("#mcheckall").prop("checked")) {
			$("input[name='emlRecv']").prop("checked", true);
			$("input[name='smsRecv']").prop("checked", true);
			$(".join_agreementView > .jointoggleTT").find("em").addClass("selected");
		}
		
		$("#mcheckall").click(function() {
			if ($("#mcheckall").prop("checked")) {
				$("input[name='emlRecv']").prop("checked", true);
				$("input[name='smsRecv']").prop("checked", true);
				$(".join_agreementView > .jointoggleTT").find("em").addClass("selected");
			} else {
				$("input[name='emlRecv']").prop("checked", false);
				$("input[name='smsRecv']").prop("checked", false);
				$(".join_agreementView > .jointoggleTT").find("em").removeClass("selected");
			}
		});
			
	});


	//회원정보 수정
	function memModify(){
		var emailRegExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			
	   //메일주소 체크
		if($("#mailDomain")[0].selectedIndex != 0 ){
		    if ($("#mail").val() == '' || $("#mailDomain").val() == '' ) {
	            alert("이메일 주소를 입력해 주세요.");
			    $("#mail").focus();
			    return;
		    } else {    		    
			    if (!emailRegExp.test(  $("#mail").val() +"@"+ $("#mailDomain").val() )) {
	                alert("이메일 주소 형식이 잘못되었습니다.");
				    $("#mailDomain").focus();
				    return;
			    }
		    }
		}else{
		    if ($("#mail").val() == '' || $("#mailDomainText").val() == '' ) {
	            alert("이메일 주소를 입력해 주세요.");
			    $("#mail").focus();
			    return;
		    } else {    		    
			    if (!emailRegExp.test(  $("#mail").val() +"@"+ $("#mailDomainText").val() )) {
	                alert("이메일 주소 형식이 잘못되었습니다.");
				    $("#mailDomain").focus();
				    return;
			    }
		    }
		}
		
		if ( $("#mailDomain")[0].selectedIndex != 0 ) {
			mailaddr =$("#mail").val() + "@" + $("#mailDomain").val() ;
		} else {
			mailaddr =$("#mail").val() + "@" + $("#mailDomainText").val() ;
		}
		
		$("#cEmlAddr").val(mailaddr);
		$("#cBtdyLucrDvCd").val( $("#mnth").is(":checked") == true ? '2' : '1' );
		
		$("#cAgrmNo1").val( $("#serviceAgreeChk").prop("checked") ? 'Y' : 'N' );
		$("#cAgrmNo2").val( $("#privacyAgreeChk").prop("checked") ? 'Y' : 'N' );
		$("#cAgrmNo7010").val( $("#offerAgreeChk").prop("checked") ? 'Y' : 'N' );
		
		$("#cAppPushRecv").val( $("#agrPost").prop("checked") ? 'Y' : 'N' );
		$("#cSmsRecv").val( $("#agrSNS").prop("checked") ? 'Y' : 'N' );
		$("#cEmlRecv").val( $("#agrEmail").prop("checked") ? 'Y' : 'N' );
	
		$("#cWrlTel").val( $("#hpno").text());
				
		$("#createIdFrom").submit();
	}

	function memModify() {
		$("#modifyForm").submit();
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
		<strong>회원 정보 수정</strong>
		<jsp:include page="/mobile/member/memberClose.jsp" />
	</div>
		<strong class=formTitle>회원정보</strong> 
		<form  action="modifySnsProc.jsp" name="modifyForm" id="modifyForm" method="post">
		<table class="modifyForm read">
			<caption>회원정보수정에 대한 내용</caption>
			<colgroup>
				<col width="30%"/>
				<col width="*" />
			</colgroup>
			<tbody>
			<tr>
				<th scope="col">이름</th>
				<td><span id="name"><%= info.get("mmb_nm") %></span></td>
			</tr>
			<tr>
				<th scope="col">생년월일</th>
				<td><span id="birth"><%= info.get("btdy") %></span> <span id="mnth">(<%= "1".equals(info.get("btdy_lucr_socr_dv_cd")) ? "양" : "음" %>력)</span></td>
			</tr>
			<tr>
				<th scope="col">휴대폰번호</th>
				<td >
					<span id="hpno"><%= info.get("wrls_tel_no") %></span>
				</td>
			</tr>		
			<tr>
				<th scope="col">이메일</th>
				<td >
					<span id="hpno"><%= info.get("eml_addr") %></span>
				</td>
			</tr>						
			</tbody>
		</table>
		<!-- 회원정보 -->

		<div class="joinAgreed">
			<strong>마케팅 수신 동의</strong>
			<p>동의하시면 상하농원의 소식을 받아볼 수 있습니다.</p>
			
			<div class="jointoggleTT onArrjoin">
				<div class="chkBox">
					<label class="chk_style1">
						<em class="selected">
							<input type="checkbox" id="mcheckall" <%= "1".equals(info.get("eml_recv_dv_cd")) && "1".equals(info.get("sms_recv_dv_cd")) ? "checked" : "" %>>
						</em>
						<span><b>전체동의</b></span>
					</label>
				</div>
				<a href="javascript:void(0);" class="join_agmOn"></a>
			</div>
			<div class="join_agreementView">
				<div class="jointoggleTT onArrjoin">
					<div class="chkBox">
						<label class="chk_style1">
							<em class="selected">
								<input type="checkbox" id="emlRecv" name="emlRecv" value="Y" <%= "1".equals(info.get("eml_recv_dv_cd")) ? "checked" : "" %>>
							</em>
							<span>이메일</span>
						</label>
					</div>
				</div>
				<div class="jointoggleTT onArrjoin">
					<div class="chkBox">
						<label class="chk_style1">
							<em class="selected">
								<input type="checkbox" name="smsRecv" id="smsRecv" value="Y" <%= "1".equals(info.get("sms_recv_dv_cd")) ? "checked" : "" %>>
							</em>
							<span>SMS</span>
						</label>
					</div>
				</div>
			</div>
		</div>
		
		<div class="btnWarp">
			<a href="javascript:void(0);" class="btnCheck Large" onclick="memModify();">회원 정보 수정</a>
		</div>	
		
		</form>
	<!-- //내용영역 -->
	</div><!-- //container -->
</div><!-- //wrapper -->
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
</html>
