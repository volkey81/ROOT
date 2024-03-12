<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.sanghafarm.common.*"%>
<%@ page import="com.sanghafarm.service.member.MemberService"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.common.*" %>
<%@ page import ="java.util.*,java.text.SimpleDateFormat"%>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
	String failUrl = Env.getURLPath() + "/mobile/member/login.jsp"; //로그인 URL	
	String referer = request.getHeader("referer");
	System.out.println("--------- memModify2.jsp ----------referer : " + request.getHeader("referer"));
	
	if(!fs.isLogin()) {
		Utils.sendMessage(out, "잘못된 접근입니다.", failUrl);
		return;
	}
	
// 	if(!fs.isApp() && (referer == null || referer.indexOf("isSamePwdProc.jsp") == -1)) {
// 		Utils.sendMessage(out, "잘못된 접근입니다.", "memModify1.jsp");
// 		return;
// 	}
	
	String passwdChk = (String) session.getAttribute("PASSWD_CHECK");
	if(!fs.isApp() && (passwdChk == null || !"Y".equals(passwdChk))) {
		Utils.sendMessage(out, "잘못된 접근입니다.", "memModify1.jsp");
		return;
	}
	
	session.removeAttribute("PASSWD_CHECK");

	MemberService member = (new MemberService()).toProxyInstance();
	Param info = member.getImInfoById(fs.getUserId());
	if (info == null) {	
		Utils.sendMessage(out, "해당하는 회원정보가 존재하지 않습니다.", failUrl);
		return;
	}
		
	String strName   = info.get("MMB_NM");							//고객명
	String strUnfy   = info.get("UNFY_MMB_NO");						//통합회원번호
	String strHpno   = param.get("phon", info.get("WRLS_TEL_NO"));	//휴대폰번호
	String strSoc    = info.get("SOC_MMB_YN");						//소셜회원여부(소셜회원:Y,일반회원:N)
	String strCi     = info.get("SEF_CERT_CI").replace(" ", "+");	//ci값
	String strFuMail = info.get("EML_ADDR");						//이메일
	String strBirth  = info.get("BTDY");							//생년월일
	String strMnth   = info.get("BTDY_LUCR_SOCR_DV_CD");			//양력:1 음력:2
	String strAgSms  = info.get("SMS_RECV_DV_CD");					//수신동의(SMS)수신:1 비수신:2
	String strAgEml  = info.get("EML_RECV_DV_CD");					//수신동의(메일)수신:1 비수신:2
	String strAgrm   = info.get("AGRM_YN");			        		//개인정보 제3자 제공동의
	strAgSms = (strAgSms.equals("1")) ? "Y" : "N";
	strAgEml = (strAgEml.equals("1")) ? "Y" : "N";	
	String[] strEmail = new String[2];
	strEmail = strFuMail.split("@");

	String citeUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/memModify3.jsp?ci=" + strCi; //비밀번호변경URL	
	String backUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/memModify1.jsp"; //뒤로가기 URL	
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>

$(document).ready(function(){
	var name = "<%=strName%>";
	var birth = "<%=strBirth%>";
	var hpno = "<%=strHpno%>";
	var mnth = "<%=strMnth%>";
	var mailId = "<%= strEmail.length > 0 ? strEmail[0] : "" %>";
	var mailDomain = "<%=strEmail.length > 1 ? strEmail[1] : "" %>";
	var agrSms = "<%=strAgSms%>";
	var agrEml = "<%=strAgEml%>";
	var agrRm  = "<%=strAgrm%>"
	
	$("#name").text(name);  	//이름
	$("#birth").text(birth);	//생년월일
	$("#hpno").text(hpno);		//휴대폰번호
	if(mnth == "1"){
		$("#mnth").attr('hidden', true); // 음력양력구분
	}
	$("#mail").val(mailId);		//이메일
	
	$("#mailDomain").val(mailDomain).prop("selected", true);
	
	if($("#mailDomain")[0].selectedIndex <= 0){
		$("#mailDomainText").val(mailDomain);
		$("#mailDomainText").show();
		$("#mailDomain")[0].selectedIndex = 0
	}
	
	//마케팅 수신동의
	if(agrEml == "Y" && agrSms == "Y"){
		$("#mcheckall").prop("checked", true); 
		$("#agrEmail").prop("checked", true);
		$("#agrSNS").prop("checked", true);
	}else{
		if(agrEml == "Y"){
			$("#agrEmail").prop("checked", true);
		}
		
		if(agrSms == "Y"){
			$("#agrSNS").prop("checked", true);
		}	
	}
});

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
		$("input[name='mchk']").prop("checked", true);
		$(".join_agreementView > .jointoggleTT").find("em").addClass("selected");
	}
	
	$("#mcheckall").click(function() {
		if ($("#mcheckall").prop("checked")) {
			$("input[name='mchk']").prop("checked", true);
			$(".join_agreementView > .jointoggleTT").find("em").addClass("selected");
		} else {
			$("input[name='mchk']").prop("checked", false);
			$(".join_agreementView > .jointoggleTT").find("em").removeClass("selected");
		}
	});
		
	//checkbox 2
	if ($("#acheckall").prop("checked")) {
		$("input[name='achk']").prop("checked", true);
		$(".join_agreementView > .jointoggleTT").find("em").addClass("selected");
	}
	
	$("#acheckall").click(function() {
		if ($("#acheckall").prop("checked")) {
			$("input[name='achk']").prop("checked", true);
			$(".join_agreementView > .jointoggleTT").find("em").addClass("selected");
		} else {
			$("input[name='achk']").prop("checked", false);
			$(".join_agreementView > .jointoggleTT").find("em").removeClass("selected");
		}
	});
	
	$('input:checkbox[name="achk"]').click(function(){
		var allChkFlg = true;
		 $('input:checkbox[name="achk"]').each(function() {
		     if(this.checked == false){
		    	 $("#acheckall").prop("checked", false); //checked 처리
		    	 allChkFlg = false;
		    	 return;
		      }
		 });
		 if(allChkFlg){
    		 $("#acheckall").prop("checked", true); //checked 처리		 
		 }
	});
	
	$('input:checkbox[name="mchk"]').click(function(){
		var allChkFlg = true;
		 $('input:checkbox[name="mchk"]').each(function() {
		     if(this.checked == false){
		    	 $("#mcheckall").prop("checked", false); //checked 처리
		    	 allChkFlg = false;
		    	 return;
		      }
		 });
		 if(allChkFlg){
    		 $("#mcheckall").prop("checked", true); //checked 처리		 
		 }
	});
	
});

//아이핀 인증 
function certification() {
	var CBA_window
    CBA_window = window.open('<%=citeUrl%>', 'IPINWindow', 'width=450, height=600, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=300, top=200' );
      if( CBA_window == null) {
         alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
         window.close();
      } 
} 

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
			
	//-----------------------------------------------------------------
	/*
	var etEx = ET.getElementDataExtractor();

	var _etProp = {
	'name'     : etEx.extractValue("#name"),
	'email'     : mailaddr,
	'phone' : etEx.extractValue("#hpno"),
	'emailFlag' : $("#agrEmail").prop("checked") ? 'Y' : 'N',
	'smsFlag'   : $("#agrSNS").prop("checked") ? 'Y' : 'N'
	};
	var requestInfo = ET.getRequestInfoByExec('request', 'prop', _etProp);
	ET.getStorage().session.set('etShPropTrk', requestInfo.url);
	*/
	//-----------------------------------------------------------------

	$("#createIdFrom").submit();
}

/***************************************
 * 이메일 도메인 변경
 **************************************/
function changeDomain(e) {
	
	if ( $("#mailDomain")[0].selectedIndex != 0 ) {
		$("#mailDomainText").hide();
	} else {
		$("#mailDomainText").show();
	}
}

window.onbeforeunload = function(e) {
	location.href = "<%=backUrl%>";
};

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
		<form  action="" name="" id="" method="post">
		<table class="modifyForm">
			<caption>회원정보수정에 대한 내용</caption>
			<colgroup>
				<col width="30%"/>
				<col width="*" />
			</colgroup>
			<tbody>
			<tr>
				<th scope="col">이름</th>
				<td><span id="name">홍길동</span></td>
			</tr>
			<tr>
				<th scope="col">생년월일</th>
				<td><span id="birth">1980-01-01</span> <span id="mnth">(음력)</span></td>
			</tr>
			<tr>
				<th scope="col">휴대폰번호</th>
				<td >
					<span id="hpno">010-1234-5678</span>
					<a href="javascript:void(0);" class="btnCheck fr" onclick="certification();">인증</a>	
					<p>※ 연락처 변경을 위해서는 본인인증이 필요합니다.</p>	
				</td>
			</tr>						
			<tr>
				<td colspan="3" style="background: #fff;">
					<input type="text" id="mail" value="" placeholder="*이메일주소" style="margin-top:10px; width:62%;">&nbsp;@
					<select id="mailDomain" onchange="javascript:changeDomain(this);" style="width:30%; margin-top:10px;">
						<option value="">직접입력</option>
						<%
	for(String domain : SanghafarmUtils.EMAILS) {
%>									
						<option value="<%= domain %>"><%= domain %></option>
<%
	}
%>
					</select>
					<input type="text" id="mailDomainText" value="" style="width:100%; margin-top:10px;" hidden="true">	
					<p>※ 개명으로 인한 이름변경 시 고객센터 (1522-3698) 로 문의 바랍니다.</p>		
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
							<input type="checkbox" id="mcheckall">
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
								<input type="checkbox" id="agrEmail" name="mchk">
							</em>
							<span>이메일</span>
						</label>
					</div>
				</div>
				<div class="jointoggleTT onArrjoin">
					<div class="chkBox">
						<label class="chk_style1">
							<em class="selected">
								<input type="checkbox" id="agrSNS" name="mchk">
							</em>
							<span>SMS</span>
						</label>
					</div>
				</div>
			</div>
		</div>
		
<!-- 		<div class="infoAgree">
			<p>제 3자 제공처 : 매일유업</p>
			<p>이용목적 : 웹사이트 로그인, 매일Do 멤버십서비스 및 포인트, 기프트카드 관련 서비스</p>			
		</div> -->
		
		<div class="btnWarp">
			<a href="javascript:void(0);" class="btnCheck Large" onclick="memModify();">회원 정보 수정</a>
		</div>	
		
		</form>
	<!-- //내용영역 -->
	</div><!-- //container -->
</div><!-- //wrapper -->
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
	<form name="createIdFrom" id="createIdFrom" action="/mobile/member/infoModifyProc.jsp" method="POST">
		<input type="hidden" name="cUnfyMmbNo" id="cUnfyMmbNo" value="<%=strUnfy%>" />
		<input type="hidden" name="cWrlTel" id="cWrlTel" value="<%=strHpno%>" />
		<input type="hidden" name="cSocMmbYn" id="cSocMmbYn" value="<%=strSoc%>"/>
		<input type="hidden" name="cCi" id="cCi" value="<%=strCi%>"/>
		<input type="hidden" name="cEmlAddr" id="cEmlAddr" value="<%=strFuMail%>" />
		<input type="hidden" name="cBirth" id="cBirth" value="<%=strBirth%>" />
		<input type="hidden" name="cBtdyLucrDvCd" id="cBtdyLucrDvCd" value="<%=strMnth %>" />
		<input type="hidden" name="cAgrmNo7010" id="cAgrmNo7010" value="<%=strAgrm%>"/>
		<input type="hidden" name="cSmsRecv" id="cSmsRecv" value="<%=strAgSms%>"/>
		<input type="hidden" name="cEmlRecv" id="cEmlRecv" value="<%=strAgEml%>"/>
	</form>
</html>
