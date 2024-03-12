<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
    Param param = new Param(request);
    String strName = URLDecoder.decode(param.get("socNm"),"UTF-8"); //이름
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
$(function(){
	//input text
	$(".focusing input").off().on({"focusin" : function() {
		$(this).next("span").fadeOut('fast');
		$('.focusingIn input').addClass("warningborder");
		}, "focusout" : function() {
			$('.focusingIn input').removeClass("warningborder");
			if( $(this).val().length ){
				$(this).next("span").fadeOut('fast');
			}else{
				$(this).next("span").fadeIn('fast');
			}
		}
	});
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
</script> 
<script type="text/javascript">
var checkedId = "";
var count = 0;
var doubleSubmitFlag = false;

$(function() {
// 	var snsKind = sessionStorage.getItem("snsKind");
	var snsKind = getCookie("cookieSnsKind");
	console.log("snsKind : " + snsKind);
	$("#cSnsKind").val(snsKind);
// 	sessionStorage.removeItem("snsKind");
	setCookie("cookieSnsKind", "", 1);
});

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

/***************************************
 * 회원가입
 **************************************/
function snsJoin() {
	
    if(doubleSubmitCheck()) return;

	if ( joinValidation() ) {
		
		var mailaddr = "";
		
		$("#cId").val( $("#userId").val() );
		$("#cPwd").val( $("#userPwd1").val() );
		$("#cName").val( $("#name").val() );
		
		if ( $("#mailDomain")[0].selectedIndex != 0 ) {
			mailaddr =$("#mail").val() + "@" + $("#mailDomain").val() ;
		} else {
			mailaddr =$("#mail").val() + "@" + $("#mailDomainText").val() ;
		}
		
// 		var snsKind = sessionStorage.getItem("snsKind");
// 		console.log("snsKind : " + snsKind);
// 		$("#cSnsKind").val(snsKind);
// 		sessionStorage.removeItem("snsKind");
		$("#cEmlAddr").val(mailaddr);
		$("#cBirth").val($("#birth").val());
		$("#cBtdyLucrDvCd").val( $("#mnth").is(":checked") == true ? '2' : '1' );
		
		$("#cAgrmNo1").val( $("#serviceAgreeChk").prop("checked") ? 'Y' : 'N' );
		$("#cAgrmNo2").val( $("#privacyAgreeChk").prop("checked") ? 'Y' : 'N' );
		$("#cAgrmNo7010").val( $("#offerAgreeChk").prop("checked") ? 'Y' : 'N' );
		
		$("#cAppPushRecv").val('N');
		$("#cSmsRecv").val( $("#agrSNS").prop("checked") ? 'Y' : 'N' );
		$("#cEmlRecv").val( $("#agrEmail").prop("checked") ? 'Y' : 'N' );
		$("#cAddress2").val($("#ship_addr2").val());

		$("#cWrlTel").val( $("#hpno").val());		
		$("#createIdFrom").submit();
		
	} else {
		doubleSubmitFlag = false;
	}
}

/***************************************
 * 회원가입 validation
 **************************************/
function joinValidation() {
	var emailRegExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
	var phoneRegExp = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})([0-9]{3,4})([0-9]{4})$/;
	var birthRegExp = /[12][0-9]{3}[01][0-9][0-3][0-9]/; // YYYYMMDD
	var blankRegExp = /[\s]/g;
	var birth = $("#birth").val();
    // 생년월일
    if (birth == '' || !birthRegExp.test(birth) ) {
        alert("생년월일을 19880227형식의 8자리 숫자로 입력해주세요.");
        $("#birth").focus();
        return false;
    }else if(!birth.isDate()){
        alert("생년월일을 19880227형식의 8자리 숫자로 입력해주세요.");
        $("#birth").focus();
        return false;    	
    }else{
        var tempBirthDay = $("#birth").val();
        var Today = new Date();
        var todays = fGetDate(Today);
        var n = todays - parseInt(tempBirthDay) - 140000;
    
        if (n < 0) {
            //$("#warningTXT_inputBirthDay").show();
            $("#birth").focus();
            alert("만 14세 미만의 회원님은 가입하실 수 없습니다.");
            return false;
        }
    }

    if($("#mailDomain")[0].selectedIndex != 0 ){
        if ($("#mail").val() == '' || $("#mailDomain").val() == '' ) {
               alert("이메일 주소를 입력해 주세요.");
   		    $("#mail").focus();
   		    return false;
   	    } else {    		    
   		    if (!emailRegExp.test(  $("#mail").val() +"@"+ $("#mailDomain").val() )) {
                   alert("이메일 주소 형식이 잘못되었습니다.");
   			    $("#mailDomain").focus();
   			    return false;
   		    }
   	    }
   	}else{
   	    if ($("#mail").val() == '' || $("#mailDomainText").val() == '' ) {
               alert("이메일 주소를 입력해 주세요.");
   		    $("#mail").focus();
   		    return false;
   	    } else {    		    
   		    if (!emailRegExp.test(  $("#mail").val() +"@"+ $("#mailDomainText").val() )) {
                   alert("이메일 주소 형식이 잘못되었습니다.");
   			    $("#mailDomain").focus();
   			    return false;
   		    }
   	    }
   	}
    // 휴대폰 번호
    if ($("#hpno").val() == '') {
    	alert("휴대폰번호를 형식에 맞춰 입력해주세요");
        $("#hpno").focus();
        return false;
    } else {
        if (!phoneRegExp.test($("#hpno").val())) {
        	alert("휴대폰번호 입력정보에 오류가 있습니다.");
            $("#hpno").focus();
            return false;
        }
    }

    // maeil DO 이용약관 동의
    if (!$("#serviceAgreeChk").prop("checked")) {
           alert("Maeil Do 이용 약관에 동의해 주세요.");
    	return false;
   	}
    
    // 개인정보 수집 및 이용동의
    if (!$("#privacyAgreeChk").prop("checked")) {
           alert("개인 정보 수집 및 이용동의 약관에 동의해 주세요.");
    	return false;
   	}

	return true;
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

// 14세미만 가입제한
function fGetDate(pDate){
    var Date = pDate.getFullYear();

    if(pDate.getMonth() < 10){
        Date = Date + "0" + (pDate.getMonth() + 1);         
    }else{
        Date = Date + "" + (pDate.getMonth() + 1);
    }
    
    if(pDate.getDate() < 10){
        Date = Date + "0" + pDate.getDate();
    }else{
        Date = Date + "" + pDate.getDate();
    }
    return Date;
}

//숫자만입력가능
function isNumberPressed(obj) {
		return !(event.keyCode < 48 || event.keyCode > 57);
}

//생년월일 유효성 체크
function isValidDate(dateStr) {
     var year = Number(dateStr.substr(0,4)); 
     var month = Number(dateStr.substr(4,2));
     var day = Number(dateStr.substr(6,2));
     var today = new Date(); // 날자 변수 선언
     var yearNow = today.getFullYear();
     var adultYear = yearNow-20;
 
 
     if (year < 1900 || year > adultYear){
          return false;
     }
     if (month < 1 || month > 12) { 
          return false;
     }
    if (day < 1 || day > 31) {
          return false;
     }
     if ((month==4 || month==6 || month==9 || month==11) && day==31) {
          return false;
     }
     if (month == 2) {
          var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
          if (day>29 || (day==29 && !isleap)) {
               return false;
          }
     }
     return true;
}

</script>
</head>  
<body>
<div id="wrapper" class="login<%= "web".equals(param.get("type")) ? " webType" : "" %>">
<% 
	if("web".equals(param.get("type"))){
%>
	<jsp:include page="/include/header.jsp" />
<%
	}
%>
	<div class="loginHead">
		<img src="/mobile/images/member/head.jpg" alt="" />
	</div> 	
	<div id="container" class="join">
	<!-- 내용영역 -->
<% 
	if(!"web".equals(param.get("type"))){
%>	
	<div class="logInTop lgPop">
		<strong>회원가입</strong>	
		<jsp:include page="/mobile/member/memberClose.jsp" />
	</div>
<%
	}
%>
		<strong class=formTitle>회원정보</strong> 
		<form  action="" name="joinForm" id="joinForm" method="post">
		<table class="joinForm">
			<caption>회원가입 회원정보에 대한 내용</caption>
			<tr>
				<td class="focusing fix">
					<strong>*이름</strong>
					<label class="focusingIn" style="width:100%;">
						<input type="text" id="name" maxlength="11" value="<%=strName %>" readonly>
					</label>
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" name="birth" id="birth" style="width:81%;" placeholder="*생년월일" maxlength="8" onKeyPress="return isNumberPressed(this)">
					<input type="checkbox" id="mnth" name="mnth" style="margin-left:5px;">
					<label for="mnth">음력</label>	
				</td>
			</tr>	
			<tr>
				<td class="focusing">
					<strong>휴대폰 번호</strong>
					<label class="focusingIn" style="width:100%;">
						<input type="text" id="hpno" maxlength="11" onKeyPress="return isNumberPressed(this)">
						<span>-없이 입력하세요</span>
					</label>
				</td>
			</tr>		
			<tr>
				<td>
					<input type="text" id="mail" value="" placeholder="*이메일주소" style="width:62%;">&nbsp;@
					<select id="mailDomain" onchange="javascript:changeDomain(this);" style="width:30%;">
						<option value="">직접입력</option>
<%
	for(String domain : SanghafarmUtils.EMAILS) {
%>									
						<option value="<%= domain %>"><%= domain %></option>
<%
	}
%>
					</select>
					<input type="text" id="mailDomainText" value="" style="width:100%; margin-top:10px;">			
				</td>
			</tr>
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
								<input type="checkbox" name="mchk" id="agrEmail">
							</em>
							<span>이메일</span>
						</label>
					</div>
				</div>
				<div class="jointoggleTT onArrjoin">
					<div class="chkBox">
						<label class="chk_style1">
							<em class="selected">
								<input type="checkbox" name="mchk" id="agrSNS">
							</em>
							<span>SMS</span>
						</label>
					</div>
				</div>
			</div>
		</div><!-- 마케팅 수신 동의 -->
		
		<div class="joinAgreed">
			<strong>이용약관 동의</strong>

			<div class="jointoggleTT onArrjoin">
				<div class="chkBox">
					<label class="chk_style1">
						<em class="selected">
							<input type="checkbox" id="acheckall">
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
								<input type="checkbox" name="achk" id="serviceAgreeChk" value="Y">
							</em>
							<span>Maeil Do 이용약관 동의 <b>(필수)</b></span>
						</label>
					</div>
					<a href="javascript:void(0);" class="join_TTOn"></a>
				</div>
				<div class="jointoggleVW">
					<div class="join_txtbox">
					<b>개인정보 수집/이용동의</b><br>
					본인은 SK텔레콤㈜(이하’회사’ 라 합니다) 가 제공하는 본인확인서비스(이하’서비스’라 합니다) 를 이용하기 위해, 다음과 같이 ‘회사’가 본인의 개인정보를 수집/이용하고 개인정보의 취급을 위탁하는 것에 동의합니다
					수집항목 
					- 이용자의 성명, 이동전화번호, 가입한 이동전화 회사본인은 SK텔레콤㈜(이하’회사’ 라 합니다) 가 제공하는 본인확인서비스(이하’서비스’라 합니다) 를 이용하기 위해, 다음과 같이 ‘회사’가 본인의 개인정보를 수집/이용하고 개인정보의 취급을 위탁하는 것에 동의합니다
					수집항목 
					- 이용자의 성명, 이동전화번호, 가입한 이동전화 회사
					</div>
				</div>				
				<div class="jointoggleTT onArrjoin">
					<div class="chkBox">
						<label class="chk_style1">
							<em class="selected">
								<input type="checkbox" name="achk" id="privacyAgreeChk" value ="Y">
							</em>
							<span>개인정보 수집 및 이용동의 <b>(필수)</b></span>
						</label>
					</div>
					<a href="javascript:void(0);" class="join_TTOn"></a>
				</div>
				<div class="jointoggleVW">
					<div class="join_txtbox">
					<b>개인정보 수집/이용동의</b><br>
					본인은 SK텔레콤㈜(이하’회사’ 라 합니다) 가 제공하는 본인확인서비스(이하’서비스’라 합니다) 를 이용하기 위해, 다음과 같이 ‘회사’가 본인의 개인정보를 수집/이용하고 개인정보의 취급을 위탁하는 것에 동의합니다
					수집항목 
					- 이용자의 성명, 이동전화번호, 가입한 이동전화 회사본인은 SK텔레콤㈜(이하’회사’ 라 합니다) 가 제공하는 본인확인서비스(이하’서비스’라 합니다) 를 이용하기 위해, 다음과 같이 ‘회사’가 본인의 개인정보를 수집/이용하고 개인정보의 취급을 위탁하는 것에 동의합니다
					수집항목 
					- 이용자의 성명, 이동전화번호, 가입한 이동전화 회사
					</div>
				</div>					
				<div class="jointoggleTT onArrjoin" style="padding-bottom:7px;">
					<div class="chkBox">
						<label class="chk_style1">
							<em class="selected">
								<input type="checkbox" name="achk" id="offerAgreeChk">
							</em>
							<span>개인정보 제3자 제공동의 (선택)</span>
						</label>
					</div>
					<a href="javascript:void(0);" class="join_TTOn"></a>
				</div>
				<div class="jointoggleVW">
					<div class="join_txtbox">
					<b>개인정보 수집/이용동의</b><br>
					본인은 SK텔레콤㈜(이하’회사’ 라 합니다) 가 제공하는 본인확인서비스(이하’서비스’라 합니다) 를 이용하기 위해, 다음과 같이 ‘회사’가 본인의 개인정보를 수집/이용하고 개인정보의 취급을 위탁하는 것에 동의합니다
					수집항목 
					- 이용자의 성명, 이동전화번호, 가입한 이동전화 회사본인은 SK텔레콤㈜(이하’회사’ 라 합니다) 가 제공하는 본인확인서비스(이하’서비스’라 합니다) 를 이용하기 위해, 다음과 같이 ‘회사’가 본인의 개인정보를 수집/이용하고 개인정보의 취급을 위탁하는 것에 동의합니다
					수집항목 
					- 이용자의 성명, 이동전화번호, 가입한 이동전화 회사
					</div>
				</div>					
			</div>
		</div><!-- 이용약관 동의 -->
		
		<div class="infoAgree">
			<p>제 3자 제공처 : 매일유업</p>
			<p>이용목적 : 웹사이트 로그인, 매일Do 멤버십서비스 및 포인트, 기프트카드 관련 서비스</p>			
		</div>
		
		<div class="btnWarp">
			<a href="javascript:void(0)" class="btnCheck Large" onclick="snsJoin();">회원 가입하기</a>	
		</div>	
		
		</form>
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
	<form name="createIdFrom" id="createIdFrom" action="/mobile/member/snsJoinProc.jsp" method="POST">
	    <input type="hidden" name="cSnsKind" id="cSnsKind" value=""/>
	    <input type="hidden" name="cSocId" id="cSocId" value="<%=Utils.safeHTML(param.get("socId",""))%>"/>
		<input type="hidden" name="cSocNm" id="cSocNm" value="<%=strName%>"/>
		<input type="hidden" name="cEmlAddr" id="cEmlAddr" value="" />
		<input type="hidden" name="cBtdyLucrDvCd" id="cBtdyLucrDvCd" value="" />
		<input type="hidden" name="cBirth" id="cBirth" value="" />
		<input type="hidden" name="cAgrmNo1" id="cAgrmNo1" value=""/>
		<input type="hidden" name="cAgrmNo2" id="cAgrmNo2" value=""/>
		<input type="hidden" name="cAgrmNo7010" id="cAgrmNo7010" value=""/>
		<input type="hidden" name="cAppPushRecv" id="cAppPushRecv" value=""/>
		<input type="hidden" name="cSmsRecv" id="cSmsRecv" value=""/>
		<input type="hidden" name="cEmlRecv" id="cEmlRecv" value=""/>
		<input type="hidden" name="cWrlTel" id="cWrlTel" value=""/>
	</form>
</html>
