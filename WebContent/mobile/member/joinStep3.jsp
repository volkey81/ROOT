<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.common.*" %>
<%@ page import ="java.util.*,java.text.SimpleDateFormat"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="javax.sound.sampled.AudioFormat.Encoding"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%
	request.setAttribute("Depth_1", new Integer(2));

	String referer = request.getHeader("Referer");
	System.out.println("referer ---------------------- " + referer);

	if(SystemChecker.isReal()) {
		if(referer == null || referer.indexOf("joinStep2.jsp") == -1) {
			response.sendRedirect("joinStep2.jsp");
			return;
		}
	}
	
	Param param = new Param(request);
    String strName   = Utils.safeHTML(param.get("name"));
    String strBirth  = Utils.safeHTML(param.get("birth"));
    String strGender = Utils.safeHTML(param.get("genderVal"));
    String strFgnGbn = Utils.safeHTML(param.get("fgnGbn"));
    String strCertDv = Utils.safeHTML(param.get("certDv"));
    //String strCertDv = "2";
    String strHpno   = Utils.safeHTML(param.get("hpno",""));
    String strGenderCd ="";
    
    if (strCertDv.equals("2")){
    	if (strFgnGbn.equals("0") ){
    		strFgnGbn = "1";
    	}else{
    		strFgnGbn = "2";
    	}
    } else if (!strCertDv.equals("1")){
    	strFgnGbn = "3";
    }
    
    if(strGender.equals("M")){
    	if(Integer.parseInt(strBirth) <= 20000101){
    		strGenderCd = "1";	
    	}else{
    		strGenderCd = "3";
    	}
    	
    }else if(strGender.equals("F")){
    	if(Integer.parseInt(strBirth) <= 20000101){
    		strGenderCd = "2";	
    	}else{
    		strGenderCd = "4";
    	}
    }else{
    	strGenderCd = "5";
    }
    
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
	if (request.isSecure()) {	
%>
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<%
	} else {
%>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<%
	}
%>
<script>
$(function(){
	$(document).ready(function() {
		var checkForm = "<%=strCertDv%>";
		if(checkForm == "2"){
	        $("#hpno").removeAttr("readonly");
	        $("#hpnoTd").removeClass("fix");
		}else{
			$("#hpnoSpan").css("display","none");
		}
	});
	
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
	
	$("#userId").change(function() {
		idChkFlg = 'N';
	});
	
});
</script> 
<script type="text/javascript">
var idChkFlg = 'N';
var checkedId = "";
var count = 0;
var doubleSubmitFlag = false;
var v;
$(function(){
	v = new ef.utils.Validator($("#joinForm"));
	v.add("userId", {
		empty : "아이디를 입력해주세요."
	})
	v.add("userPwd1", {
		empty : "비밀번호를 입력해주세요."
	});
});

/***************************************
 * ID 중복 체크
 **************************************/
function duplicateId() {
	
    if(doubleSubmitCheck()) return;
    
	var id = $("#userId").val();
	if (id == '') {
		alert("아이디를 입력해주세요.");
		doubleSubmitFlag = false;
		return;
	} else {
		var idRegExp = /^[A-Za-z0-9]{4,12}$/;
		// 영문/숫자 4~12자리 체크
		var chkNum = id.search(/[0-9]/g); 
	    var chkEng = id.search(/[a-z]/ig);
		if (!idRegExp.test( id )) {
            alert("영문/숫자 포함 4~12자리로 아이디를 입력해 주세요.");
			$("#userId").focus();
			doubleSubmitFlag = false;
			return;
/* 		} else if((chkNum < 0 || chkEng < 0)) {
		    if(chkNum < 0 || chkEng < 0) { */ 
		}else if(id.length < 4 || id.length > 12 ){
		    	alert("영문/숫자 포함 4~12자리로 아이디를 입력해 주세요.");
				$("#userId").focus();
				doubleSubmitFlag = false;
				return;
		  //  }
		}
	}
	
    var param = {
    		userId : $('#userId').val()
        }
	
    $.ajax({
        type : "POST",
        url : '/mobile/member/checkId.jsp',
        dataType : "json",
        data : param,
        success : function(data) {
    		if(data.result == "true") {
    			idChkFlg = "Y";
    			checkedId = id;
    			alert("사용하실 수 있는 아이디입니다.");	
    		}else{
    			if (data.message != "") {
    				alert(data.message);				
    			}
    		}
        }
    });
	
	doubleSubmitFlag = false;
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

/***************************************
 * 회원가입
 **************************************/
function join(joinType) {
	
    if(doubleSubmitCheck()) return;

	if (joinValidation()) {
		
		var mailaddr = "";
		
		$("#cId").val( $("#userId").val() );
		$("#cPwd").val( $("#userPwd1").val() );
		$("#cName").val( $("#name").val() );
		
		if ( $("#mailDomain")[0].selectedIndex != 0 ) {
			mailaddr =$("#mail").val() + "@" + $("#mailDomain").val() ;
		} else {
			mailaddr =$("#mail").val() + "@" + $("#mailDomainText").val() ;
		}
		
		$("#cEmlAddr").val(mailaddr);
// 		$("#cBtdyLucrDvCd").val( $("#mnth").is(":checked") == true ? '2' : '1' );
		
		$("#cAgrmNo1").val( $("#serviceAgreeChk").prop("checked") ? 'Y' : 'N' );
		$("#cAgrmNo2").val( $("#privacyAgreeChk").prop("checked") ? 'Y' : 'N' );
		$("#cAgrmNo7010").val( $("#offerAgreeChk").prop("checked") ? 'Y' : 'N' );
		
		$("#cAppPushRecv").val('N');
		$("#cSmsRecv").val( $("#agrSNS").prop("checked") ? 'Y' : 'N' );
		$("#cEmlRecv").val( $("#agrEmail").prop("checked") ? 'Y' : 'N' );
		$("#cAddress2").val($("#ship_addr2").val());

		$("#cWrlTel").val( $("#hpno").val());
				
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
		ET.setUserId(etEx.extractValue("#userId"))
		var reqInfos = {
			prop		: ET.getRequestInfoByExec('request', 'prop', _etProp),
			join		: ET.getRequestInfoByExec('sendEvent', {
				name	: 'join',
				value	: etEx.extractValue("#userId")
			})
		}
		ET.getStorage().session.set('etShSignupTrk',JSON.stringify(reqInfos));
		ET.getStorage().session.del('etUserId');
		*/
		//-----------------------------------------------------------------
		
		$("#createIdFrom").submit();
		
	} else {
		doubleSubmitFlag = false;
	}
}

/***************************************
 * 회원가입 validation
 **************************************/
function joinValidation(joinType) {
	var emailRegExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
	var phoneRegExp = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})([0-9]{3,4})([0-9]{4})$/;
	var birthRegExp = /[12][0-9]{3}[01][0-9][0-3][0-9]/; // YYYYMMDD
	var blankRegExp = /[\s]/g;
	var idRegExp = /^[A-Za-z0-9]{4,12}$/;
		
	var id = $("#userId").val();
	var passwd = $("#userPwd1").val(); 	// 비밀번호
	
	if (v.validate()) {
		//if (!id.isid()) {
			
		if (!idRegExp.test( id )) {
            alert("영문/숫자 포함 4~12자리로 아이디를 입력해 주세요.");
			$("#userId").focus();
			return;
		}
				
		if(id.length < 4 || id.length > 12 ){
			alert("영문/숫자 포함 4~12자리로 아이디를 입력해 주세요.");
			$("#userId").focus();
			return false;
		}
		
		if (idChkFlg == 'N') {
            alert("아이디 중복확인을 해주세요.");
			$("#userId").focus();
			return false;
		}
			
		if (checkedId != id ) {
            alert("아이디 중복확인을 해주세요.");
			$("#userId").focus();
			return false;
		}
		if (!chkValidPasswd(passwd)) {
			$("#userPwd2").focus();
			return false;
		}
		if ( $("#userPwd2").val() == '' ) {
            alert("입력한 비밀번호를 다시 입력해 주세요.");
			$("#userPwd2").focus();
			return false;
		}
		
		if ( $("#userPwd1").val() != $("#userPwd2").val() ) {
            alert("비밀번호 확인이 입력하신 비밀번호와 다릅니다.");
			$("#userPwd2").focus();
			return false;
		}
		
	}else{
		return false;
	}
						
/* 	    // 아이핀 인증시에만 휴대폰 번호 검증
	    var authType = 'CERT_DIV_CD.IPIN';
	    if(authType == 'CERT_DIV_CD.IPIN' || authType == '') {
		    // 휴대폰 번호
		    if ( $("#phone").val() == '' ) {
                alert("휴대폰 번호를 입력해주세요");
			    $("#phone").focus();
		    	return false;
		    } else {
	            if ($("#phone").val() == ) {
				    alert("휴대폰 번호를 입력해주세요");
				    $("#phone").focus();
				    return false;
			    } 
	    	}
    	}	 */
    	
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
        
        // 생년월일
        if ($("#birth").val() == '' || !birthRegExp.test($("#birth").val()) ) {
            alert("생년월일을 19880227형식의 8자리 숫자로 입력해주세요.");
            $("#birth").focus();
            return false;
        }else if(isValidDate($("#birth").val()) == false){
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

//숫자만입력가능
function isNumberPressed(obj) {
		return !(event.keyCode < 48 || event.keyCode > 57);
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

//생년월일 유효성 체크
function isValidDate(dateStr) {
     var year = Number(dateStr.substr(0,4)); 
     var month = Number(dateStr.substr(4,2));
     var day = Number(dateStr.substr(6,2));
     var today = new Date(); // 날자 변수 선언
     var yearNow = today.getFullYear();
     var adultYear = yearNow-20;
 
 	/*
     if (year < 1900 || year > adultYear){
          return false;
     }
 	*/
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
	<div class="logInTop lgPop">
		<ul class="step">
			<li>본인인증</li>
			<li class="fb">회원가입</li>
			<li>추천인 입력</li>
		</ul>
<% 
	if(!"web".equals(param.get("type"))){
%>		
		<jsp:include page="/mobile/member/memberClose.jsp" />
<%
	}
%>
	</div>
		<strong class=formTitle>회원정보</strong> 
		<!-- 우편번호 팝업 -->
		<!-- <div id="zipArea" style="display:none;border:1px solid;width:300px;height:300px;position:relative;margin-bottom:8px;"> -->
		<div id="zipArea" style="display:none;position:absolute;overflow:hidden;z-index:999;-webkit-overflow-scrolling:touch;">
			<img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1;width:25px;height:25px;" onclick="foldDaumPostcode()" alt="접기 버튼">
		</div>
		<form  action="" name="joinForm" id="joinForm" method="post">
		<input type="hidden" name="dupInfo" id="dupInfo" value="<%=Utils.safeHTML(param.get("dupInfo")) %>" />
		<input type="hidden" name="connInfo" id="connInfo" value="<%=Utils.safeHTML(param.get("connInfo")) %>" />
		<input type="hidden" name="connInfoVer" id="connInfoVer" value="<%=Utils.safeHTML(param.get("connInfoVer")) %>" />
		<table class="joinForm">
			<caption>회원가입 회원정보에 대한 내용</caption>
			<tr>
				<td style="padding-top:0;">
					<input type="text" name="userId" id="userId" value="" placeholder="*아이디" style="width:76%;" maxlength="12">
						<a href="javascript:void(0)" class="btnCheck" onclick="duplicateId();">중복확인</a>
					<input type="hidden" id="checkId"/>						
				</td>
			</tr>
			<tr>
				<td>
					<input type="password" name="userPwd1" id="userPwd1"  value="" style="width:100%" placeholder="*비밀번호" maxlength="32">
				</td>
			</tr>
			<tr>
				<td>
					<input type="password" id="userPwd2"  value="" style="width:100%" placeholder="*비밀번호 확인" maxlength="32">
					<p class="warn">소문자, 대문자, 숫자 특수문자 중 최소 2가지 이상, 10자리 이상 입력</p>
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
			<tr>
				<td class="focusing fix">
					<strong>*이름</strong>
					<label class="focusingIn" style="width:100%;">
						<input type="text" id="name" maxlength="45" value="<%=URLDecoder.decode(strName,"UTF-8") %>" readonly>
					</label>
				</td>
			</tr>
			<tr>
				<td class="focusing fix">
					<strong>*생년월일</strong>
					<label class="focusingIn">
<%-- 						<input style="width:82% !important; margin-right:5px;" type="text" id="birth" value="<%=Utils.safeHTML(strBirth) %>"  maxlength="8" readonly> --%>
						<input type="text" id="birth" value="<%=Utils.safeHTML(strBirth) %>"  maxlength="8" readonly>
					</label>
<!-- 					<input type="checkbox" id="mnth" name="mnth"/><label for="mnth">음력</label> -->
				</td>
			</tr>
			
			<tr>
				<td class="focusing fix">
					<strong>*성별</strong>
					<label class="focusingIn" style="width:100%;">
						<input type="text" id="gender" value="<%=StringUtils.equals(Utils.safeHTML(strGender), "M") ? "남자" :  "여자" %>" maxlength="11" readonly>
					</label>
				</td>
			</tr>						
			<tr>
				<td class="focusing fix" id ="hpnoTd">
					<strong>*휴대폰 번호</strong>
					<label class="focusingIn" style="width:100%;">
						<input type="text" id="hpno" maxlength="11" value="<%=strHpno%>" readonly onKeyPress="return isNumberPressed(this)">
						<span id = "hpnoSpan">-없이 입력하세요</span>
					</label>
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" id="ship_post_no"  value="" style="width:73%" readonly title="우편번호" placeholder="우편번호" maxlength="32">
					<a href="javascript:execDaumPostcode()" class="btnFind">우편번호찾기</a>

				</td>
			</tr>						
			<tr>
				<td>
					<input type="text" id="ship_addr1"  value="" style="width:100%" readonly title="주소" placeholder="주소" maxlength="32">
				</td>
			</tr>					
			<tr>
				<td>
					<input type="text" id="ship_addr2" value="" style="width:100%" placeholder="나머지 주소 입력" maxlength="32">
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
								<input type="checkbox" id="serviceAgreeChk" name="achk" value="Y" >
							</em>
							<span>Maeil Do 이용약관 동의 <b>(필수)</b></span>
						</label>
					</div>
					<a href="javascript:void(0);" class="join_TTOn"></a>
				</div>
				<div class="jointoggleVW">
					<div class="join_txtbox">
					제 1조 (목적)<br>
						이 약관은 Do포인트와 Do포인트 회원사가 각각 운영하는 사이트에서 제공하는 웹사이트 서비스, 매일 멤버십 서비스 및 사이버 몰 등의 Do포인트 서비스(이하 “서비스”라 한다)를 이용함에 있어 Do포인트와 이용자의 권리ㆍ의무 및 책임사항을 규정함을 목적으로 합니다. 
						※「PC통신, 무선 등을 이용하는 전자상거래에 대해서도 그 성질에 반하지 않는 한 이 약관을 준용합니다」 <br><br>
						
						제 2조 (정의) <br>
						①“Do포인트”라 함은 하나의 ID와 비밀번호로 매일 Do 포인트와 계열사의 사이트들을 이용할 수 있는 통합회원서비스로서, 매일유업㈜가 운영하는 사업자의 의미로도 사용합니다. <br>
						②“Do포인트 회원사”라 함은 매일 Do 포인트 및 매일유업㈜의 계열사를 의미합니다. (2016년 12월 1일 기준 매일유업㈜, ㈜제로투세븐, 크리스탈제이드, ㈜엠즈씨드, 상하농원㈜ 가 해당됩니다.) <br>
						③“Family회원사 사이트” : 온라인을 통해 Do포인트에서 제공하는 서비스를 이용할 수 있는 매일유업㈜ 또는 계열사의 인터넷 사이트를 말합니다. 이는 추후 추가 및 변경될 수 있습니다. <br>
						서비스 홈페이지 (2016년 12월 1일 기준) <br>
						-. 매일닷컴 (브랜드사이트 포함) : www.maeil.com <br>
						-. 매일아이닷컴(브랜드 사이트 포함) : www.maeili.com<br> 
						-. 제로투세븐 쇼핑몰 : www.0to7.com <br>
						-. 크리스탈제이드 : www.crystaljade.co.kr <br>
						-. 키친살바토레 : www.kitchensalvatore.co.kr <br>
						-. 폴바셋 : www.baristapaulbassett.co.kr <br>
						-. 상하농원(주) : www.sanghafarm.co.kr <br>
						④ Do포인트 프로그램 : Do포인트 회원사로 구성된 통합 포인트 기반의 고객관리 프로그램으로 Do포인트 회원사의 제품 구매 또는 그에 준하는 활동 후 적립 받은 포인트를 통하여 차별화된 혜택을 제공하는 서비스입니다. <br>
						⑤ 매일 포인트 : Do포인트 회원사로 구성된 매일 멤버십 프로그램에서 제공하는 서비스 이용에 통용되는 포인트를 말합니다. <br>
						⑥ 사용가능포인트 : Do포인트 회원사의 브랜드에서 제품 및 서비스를 구입할 경우 고지한 적립률에 따라 부여되어 즉시 사용이 가능한 포인트를 말합니다. <br>
						⑦ 사용가능예정포인트 : Do포인트 회원사의 브랜드에서 제품 및 서비스를 구입하였으나 해당시점에 구입 결제 승인이 완료되지 않아 적립 예정인 포인트로 구입 결제 승인이 완료된 직수 사용가능포인트로 전환되는 포인트를 말합니다. <br>
						⑧ 소멸예정포인트 : 잔여 소멸기간이 1개월 이하로 남은 포인트로 해당된 잔여 기간 동안 사용하지 않을 경우 소멸되는 포인트를 말합니다. (현재 소멸기간: 24개월) <br>
						⑨ 이용자 : 관계사 사이트에 접속하여 이 약관에 따라 Do포인트가 제공하는 서비스를 받는 회원 및 비회원을 말합니다. <br>
						⑩ 정회원 : Do포인트에 개인정보를 제공하여 회원등록을 하고 Do포인트로부터 이용 승낙을 받은 자를 의미합니다. <br>
						⑪ SNS회원 : 네이버, 카카오, 페이스북 ID를 통해 Do포인트에 개인정보를 제공하여 회원등록을 하고 Do포인트로부터 이용 승낙을 받은 자를 의미합니다. <br>
						⑫ 비회원 : 회원 가입하지 않고 Do포인트가 제공하는 서비스를 이용하는 자를 말합니다. <br>
						⑬ ID : 회원식별과 회원의 서비스 이용을 위하여 회원 본인이 설정하여 Do포인트가 정하는 일정한 기준에 의해 표기된 인식문자를 말하며, 하나의 ID로 회원이 관계사 사이트에 별도의 회원가입 절차 없이 편리하게 이용할 수 있도록 합니다. <br>
						⑭ 제휴 사이트 : Do포인트가 업무제휴를 통해 공동 마케팅, 공동사업 등을 추진하기 위하여 업무제휴 한 사업체 및 그 사업체의 웹사이트를 의미합니다. <br>
						⑮ 휴면회원 : 회원가입 이후 1년 동안 로그인 기록이 없는 회원을 의미합니다. <br><br>
						
						제 3조 (약관 등의 명시와 설명 및 개정) <br>
						① 본 약관의 내용은 당사의 서비스홈페이지 화면에 게시하거나 기타의 방법으로 회원에게 공지하고, 이에 동의한 회원이 Do포인트 회원에 가입함으로써 효력이 발생합니다. <br>
						② 본 약관은 Do포인트에 가입된 회원을 포함하여 서비스를 이용하고자 하는 모든 회원에 대하여 그 효력을 발생합니다 <br>
						③ 본 약관은 수시로 개정될 수 있으며 약관을 개정하고자 할 경우 당사는 개정된 약관을 적용하고자 하는 날로부터 14일 이전에 약관이 개정된다는 사실과 개정된 내용 등을 아래 규정된 방법 중 1가지 이상의 방법으로 회원에게 고지합니다. 다만, 개정된 내용 중 회원에게 불리하게 적용되는 내용이 있는 경우 경우에는 30일의 유예기간을 두고 고지합니다. <br>
						1. e-mail 통보 <br>
						2. 휴대폰 단문메시지 (SMS) <br>
						3. 멤버십 홈페이지(http://www.maeildo.com) 내 게시<br>
						4. 영업점 및 가맹점 내 게시 <br>
						5. 기타 회원 가입 시, 회원이 제공한 연락처 정보 등을 이용한 기타의 안내 방법 <br>
						④ 당사가 e-mail 통보 또는 서면 통보의 방법으로 본 약관이 개정된 사실 및 개정된 내용을 회원에게 고지하는 경우에는 회원이 기제공한 e-mail 주소나 주소지 중 가장 최근에 제공된 곳으로 통보하며 이 경우, 당사가 적법한 통보를 완료한 것으로 봅니다. <br>
						⑤ Do포인트가 전항에 따라 개정약관을 공지 또는 통지하면서 회원에게 30일간의 기간 내에 의사표시를 하지 않으면 개정약관을 적용 받겠다는 의사표시가 표명된 것으로 본다는 뜻을 명확히 공지 또는 통지하였음에도 회원이 명시적으로 개정약관 적용 거부의 의사표시를 하지 않으면 회원이 개정 약관에 동의한 것으로 간주합니다.<br> 
						⑥ 회원은 개정된 약관에 대해 거부할 권리가 있습니다. 회원은 개정된 약관에 동의하지 않는다는 의사표시를 한 경우에는 회사는 회원에게 개정 약관을 적용할 수 없으며, 회원은 서비스 이용을 중단하고 회원 탈퇴를 할 수 있습니다. 다만 기존 약관을 적용할 수 없는 특별한 사정이 있는 경우에는 회사는 이용계약을 해지할 수 있습니다. <br>
						⑦ 본 규정에 의하여 개정된 약관은 원칙적으로 그 효력 발생일로부터 장래를 향하여 유효합니다. <br>
						⑧ 본 규정의 통지방법 및 통지의 효력은 본 약관의 각 조항에서 규정하는 개별적인 또는 전체적인 통지의 경우에 이를 준용합니다. <br><br>
						
						제 4조 (약관 외 준칙) <br>
						① 이 약관은 Do포인트가 제공하는 서비스 별 이용약관(이하 '서비스별 약관 '이라 합니다.)과 함께 적용합니다. <br>
						② 서비스별 약관에 명시된 사항이 이 약관과 다를 경우 서비스별 약관을 우선 적용하되, 서비스별 약관에 명시되지 않은 사항이 있을 경우에는 이 약관을 적용합니다. <br>
						③ 이 약관에 명시되지 아니한 사항과 이 약관의 해석에 관하여는 전자상거래 등에서의 소비자보호에 관한 법률, 약관의 규제 등에 관한 법률, 공정거래위원회가 정하는 전자상거래 등에서의 소비자보호지침 및 관계법령 또는 상관례에 따릅니다. <br>
						
						제 5조 (서비스의 제공 및 변경) <br>
						① Do포인트는 다음과 같은 업무를 수행합니다.<br> 
						1. 재화 또는 용역에 대한 정보 제공 및 구매계약의 체결<br> 
						2. 구매계약이 체결된 재화 또는 용역의 배송<br> 
						3. 기타 Do포인트가 정하는 업무 <br>
						② 서비스는 회원 자격을 부여 받은 이용자 모두 이용할 수 있습니다. 단, 유료서비스 및 특정서비스의 경우에는 서비스 이용 신청 시 Do포인트에서 요구하는 조건이 만족되어야 이용자격을 부여 받을 수 있습니다.<br> 
						③ Do포인트는 재화 또는 용역의 품절 또는 기술적 사양의 변경 등의 경우에는 장차 체결되는 계약에 의해 제공할 재화 또는 용역의 내용을 변경할 수 있습니다. 이 경우에는 변경된 재화 또는 용역의 내용 및 제공일자를 명시하여 현재의 재화 또는 용역의 내용을 게시한 곳에 즉시 공지합니다.<br> 
						④ Do포인트가 제공하기로 이용자와 계약을 체결한 서비스의 내용을 재화 등의 품절 또는 기술적 사양의 변경 등의 사유로 변경할 경우에는 그 사유를 이용자에게 통지 가능한 주소로 즉시 통지합니다.<br> 
						⑤ 전항의 경우 Do포인트는 이로 인하여 이용자가 입은 손해를 배상합니다. 다만, Do포인트가 고의 또는 과실이 없음을 입증하는 경우에는 그러하지 아니합니다. <br><br>
						
						제 6조 (서비스의 중단) <br>
						① Do포인트는 다음 각 호에 해당되는 경우 서비스의 전부 또는 일부를 제한하거나 중지할 수 있습니다.<br> 
						1. 서비스용 설비의 보수 등 공사로 인한 부득이한 경우<br> 
						2. 전기통신사업법에 규정된 기간통신사업자가 전기통신서비스를 중지했을 경우<br> 
						3. 국가비상사태, 정전, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 정상적인 서비스 이용에 지장이 있을 경우<br> 
						4. 기타 불가항력적인 사유가 있는 경우<br> 
						② Do포인트는 제1항의 사유로 서비스의 제공이 일시적으로 중단됨으로 인하여 이용자 또는 제3자가 입은 손해에 대하여 배상합니다. 단, Do포인트가 고의 또는 과실이 없음을 입증하는 경우에는 그러하지 아니합니다.<br> 
						③ 사업종목의 전환, 사업의 포기, 업체간의 통합 등의 이유로 서비스를 제공할 수 없게 되는 경우에는 Do포인트는 제9조에 정한 방법으로 이용자에게 통지합니다.<br><br> 
						
						제 7조 (회원가입 및 카드) <br>
						① 회원 가입은 당사에서 정한 서비스 홈페이지나 모바일 페이지를 통해 본 약관과 ‘개인정보취급방침(‘개인정보 수집 제공 및 활용 동의’ 등)'에 동의하고, 회원 개인별 온라인 기반의 아이디를 신청함으로써 회원가입을 신청합니다. 단, 만 14세 미만의 경우, 당사의 서비스 홈페이지를 통해서만 회원 가입이 가능하며 이 경우 법정 대리인의 동의를 받아 본 약관에 동의하고 가입신청을 합니다. 다만 이 경우 법률에 의거 일부 브랜드의 정책에 따라 법정대리인의 동의여부와 관계없이 가입을 제한하거나 일부 서비스 제공이 불가 할 수 있습니다.<br> 
						② Do포인트는 제1항과 같이 회원으로 가입할 것을 신청한 이용자 중 다음 각호에 해당하는 경우 서비스 이용승낙을 하지 않거나 사후에 이용 계약을 해지할 수 있습니다. <br>
						1. 가입신청자가 이 약관 제8조 제3항에 의하여 이전에 회원자격을 상실한 적이 있는 경우, 다만 제8조 제3항에 의한 회원자격 상실 후 3년이 경과한 자로서 Do포인트의 회원재가입 승낙을 얻은 경우에는 예외로 한다.<br> 
						2. 등록 내용에 허위, 기재누락, 오기가 있는 경우 <br>
						3. 타인 명의로 신청한 경우 <br>
						4. 주민등록 상의 본인실명으로 신청하지 않은 경우<br> 
						5. 정보를 악용하거나 사회의 안녕과 질서 혹은 미풍양속을 저해할 목적으로 신청한 경우<br> 
						6. 이용자의 귀책사유로 이용승낙이 곤란한 경우, 기타 Do포인트가 정한 이용신청 조건에 미비된 경우<br> 
						7. 기 가입된 회원이 다른 ID로 이중 회원 가입을 신청한 경우<br> 
						8. Do포인트의 서비스 설비 용량에 여유가 없는 경우<br>
						9. 14세 미만 아동이 법정대리인(부모 등)의 동의를 얻지 않은 경우<br> 
						10. 기타 회원으로 등록하는 것이 Do포인트의 기술상 현저히 지장이 있다고 판단되는 경우<br> 
						③ 만 14세 미만의 아동인 경우에는 회원가입 및 전자상거래 등을 제한할 수 있습니다<br> 
						④ 회원은 다음 각 호에 해당하는 ID를 이용할 수 없으며 이러한 ID가 등록 신청된 경우에는 Do포인트가 동 ID의 등록을 반려하거나 취소할 수 있고, 회원 ID 변경 시까지 서비스 이용을 제한할 수 있습니다.<br> 
						1. 타인에서 혐오감으로 주거나 미풍양속에 어긋나는 경우<br> 
						2. 기타 Do포인트 소정의 합리적인 사유가 있는 경우<br>
						⑤ 회원가입계약의 성립시기는 Do포인트의 승낙이 회원에게 도달한 시점으로 합니다.<br> 
						⑥ 회원은 관계사 사이트에 등록한 회원정보에 변경이 있는 경우, 즉시 Do포인트에서 정하는 방법에 따라 해당 변경사항을 Do포인트에게 통지하거나 수정하여야 합니다.<br> 
						⑦ 고객으로부터 회원가입 신청이 있는 경우 당사는 자체 기준에 따른 심사를 거친 후 고객에게 회원 자격을 부여 할 수 있으며 회원 자격이 부여된 고객은 당사로부터 가입 완료 공지를 받은 시점부터 회원으로서의 지위를 취득하고 카드를 즉시 발급받을 수 있습니다.<br> 
						⑧ 회원에게 제공되는 매일 멤버십 카드는 카드 발급처에 따라 폴바셋 카드, 모바일앱을 통한 모바일 카드, MMS전송을 이용한 MMS 카드가 제공되며, 세 종류의 카드를 모두 이용하려면 본 조 1항에 명시된 방법으로 회원 가입 절차를 완료하여야 합니다.<br> 
						⑨ 회원은 당사의 영업점이나 가맹점의 개별정책에 의하여 회원 가입 절차 없이 폴바셋 카드만을 우선 발급받을 수 있으나, 회원 가입 절차를 완료하지 않고 폴바셋 카드만 우선 수령한 회원이 정상적인 매일 멤버십 App 서비스를 제공 받기 위해서는 본 조 1항에 명시된 방법으로 회원 가입 절차를 완료하여야 합니다. (2015년 7월 1일부로 스티커 카드의 신규발급이 중단되었으며, 기 발급된 스티커 카드는 활용이 불가능합니다.)<br> 
						⑩ 회원은 회원자격을 타인에게 양도하거나 대여 또는 담보의 목적으로 이용할 수 없습니다.<br> 
						⑪ 본 조 1항의 회원가입을 완료한 회원에게 부여되는 폴바셋, 모바일, MMS의 카드는 회원 개인별로 1개의 고유한 번호(난수번호)로 관리되며, 추가의 다른 번호의 폴바셋 카드를 발급 받았을 경우 당사 홈페이지나 모바일을 통해 정상 등록된 이후 사용이 가능하며, 등록된 스티커카드 중 가장 최근에 등록된 카드의 번호로 모든 종류의 카드가 갱신되어 관리됩니다.<br> 
						⑫ 회원이 매일 멤버십 서비스를 당사에서 이용하고자 할 경우, 카드를 제시해야 하며 당사는 미성년자 여부나 본인 확인 등 합리적인 이유가 있을 때 회원에게 신분증 제시를 요청할 수 있습니다. 회원은 이러한 요청을 있을 경우 요청에 응해야 정상적이고 원활한 매일 멤버십 서비스를 제공 받을 수 있습니다.<br> 
						⑬ 회원의 카드는 회원 본인만 사용 가능합니다. 카드는 제3자에게 임의적으로 대여 사용하게 하거나 양도 또는 담보의 목적으로 사용 할 수 없습니다<br> 
						⑭ 카드는 회원 스스로의 책임하에 관리하여야 하며 회원의 고의 또는 과실로 카드의 훼손, 분실, 도난 되거나 비밀번호가 유출되는 등의 사고가 발생할 경우, 당해 회원은 즉시 그 사실을 당사에 즉시 통지하여야 합니다.<br> 
						⑮ 당사는 회원으로부터 본 조 제 14항에 따른 통지를 받을 경우, 즉시 사고 등록 및 당해 회원카드의 사용을 중지하는 등 필요한 제반 조치를 취합니다. 단, 당사는 회원이 본 조 제 14항에 따른 통지 시점 이전에 발생한 손해로서, 해당 사고가 회원의 고의 또는 과실 등 귀책사유에 의한 경우에는 이에 대해서 어떠한 책임도 지지 않습니다.<br><br> 
						
						제 8조 (회원 탈퇴 및 자격 상실 등) <br>
						① 회원은 언제든지 서면, e-mail, 전화, 기타 당사가 정하는 방법으로 회원탈퇴를 요청할 수 있으며, 회원의 탈퇴는 Do포인트 이용약관에 준하여 적용됩니다. 단, 본 조 제 2항의 경우에는 탈퇴가 유보거나 불가능합니다.<br> 
						② 포인트 사용 후 사용 된 포인트의 적립 원천이 되는 구매 행위의 취소로 인해 마이너스(-) 포인트가 발생한 회원은 별도 당사의 승인이나 해당 포인트에 해당하는 금액을 변제 하기 전까지는 탈퇴가 불가 합니다.<br> 
						③ 회원이 다음 각호의 사유에 해당하는 경우, Do포인트는 회원자격을 제한 및 정지시킬 수 있습니다.<br> 
						1. 가입 신청 시에 허위 내용을 등록한 경우<br> 
						2. Do포인트 서비스를 이용하여 구입한 재화 등의 대금, 기타 Do포인트 서비스 이용에 관련하여 회원이 부담하는 채무를 기일에 지급하지 않는 경우<br> 
						3. 다른 사람의 Do포인트 서비스 이용을 방해하거나 그 정보를 도용하는 등 전자상거래 질서를 위협하는 경우<br> 
						4. Do포인트 서비스를 이용하여 법령 또는 이 약관이 금지하거나 공서양속에 반하는 행위를 하는 경우<br> 
						5. 다른 회원의 ID와 비밀번호 등을 도용하는 행위<br> 
						6. 본 서비스를 통하여 얻은 정보를 Do포인트의 사전 승낙 없이 회원의 이용 이외의 목적으로 복제하거나 이를 출판 및 방송 등에 사용하거나 제3자에게 제공하는 행위<br> 
						7. 타인의 특허, 상표, 영업비밀, 저작권, 기타 지적 재산권을 침해하는 내용을 게재하거나 e-mail 기타의 방법으로 타인에게 유포하는 행위<br> 
						8. 공공질서 및 미풍양속에 위반되는 저속ㆍ음란한 내용의 정보ㆍ문장ㆍ도형 등을 전송ㆍ 게시ㆍe-mail 기타의 방법으로 타인에게 유포하는 행위 <br>
						9. 모욕적이거나 위협적이어서 타인의 프라이버시를 침해할 수 있는 내용을 전송ㆍ게시ㆍe-mail 기타의 방법으로 타인에게 유포하는 행위<br> 
						10. 범죄와 결부된다고 객관적으로 판단되는 행위<br> 
						11. Do포인트의 승인을 받지 않고 개인정보를 수집 또는 저장하는 행위<br> 
						12. 다른 사람의 Do포인트 서비스 이용을 방해하거나 그 정보를 도용하는 등 전자거래 질서 기타 Do포인트의 서비스를 위협하는 행위<br> 
						13. 이 약관을 포함하여 기타 Do포인트가 정한 이용조건 및 관계법령을 위반하는 경우<br> 
						④ Do포인트는 휴면회원의 경우 회원정보의 보호 및 운영의 효율성을 위하여, Do포인트가 정한 기한 내에 답변이 없을 시에는 이용계약을 해지하거나 서비스 이용을 제한 할 수 있습니다.<br> 
						⑤ Do포인트가 회원 자격을 제한ㆍ정지 시킨 후, 동일한 행위가 2회 이상 반복되거나 30일 이내에 그 사유가 시정되지 아니하는 경우 Do포인트는 회원자격을 상실시킬 수 있습니다.<br> 
						⑥ Do포인트는 본 조의 규정에 의하여 해지된 회원에 대하여는 별도로 정한 기간 동안 가입을 제한할 수 있습니다. 다만, Do포인트가 서비스 이용계약 해지 등 회원자격을 상실시키는 경우에는 회원에게 이를 사전에 통지하고 소명할 기회를 부여한 후, 회원등록을 말소할 수 있습니다.<br><br> 
						
						제 9조 (회원에 대한 통지 및 정보의 제공) <br>
						① Do포인트가 회원에 대한 통지를 하는 경우, 회원이 Do포인트와 미리 약정하여 지정한 전자우편 주소로 할 수 있습니다.<br> 
						② Do포인트는 불특정다수 회원에 대한 통지의 경우 1주일 이상 관계사 사이트 게시판에 게시함으로써 개별 통지에 갈음할 수 있습니다. 다만, 회원 본인의 거래와 관련하여 중대한 영향을 미치는 사항에 대하여는 개별통지를 합니다.<br> 
						③ Do포인트는 회원이 서비스를 이용할 때 필요하다고 인정되는 다양한 정보를 공지사항이나 회원이 미리 약정하여 지정한 e-mail 또는 여타 통신수단을 이용하여 회원에게 제공할 수 있습니다.<br><br> 
						
						제 10조 (회원의 게시물) <br>
						① Do포인트는 회원이 게재하거나 등록하는 서비스 내의 자료(또는 내용물)이 다음 각 호에 해당한다고 판단되는 경우에 사전동의 없이 삭제할 수 있습니다.<br>
						1. 다른 회원 또는 제3자를 비방하거나 중상모략으로 명예를 손상시키는 내용인 경우<br> 
						2. 공공질서 및 미풍양속에 위반되는 내용인 경우<br> 
						3. 범죄적 행위에 결부된다고 인정되는 내용일 경우<br> 
						4. Do포인트의 저작권, 제 3자의 저작권, 기타 권리를 침해하는 내용인 경우<br> 
						5. Do포인트에서 규정한 게시 기간을 초과한 경우 <br>
						6. 게시판의 성격에 부합하지 않는 게시물인 경우 <br>
						7. 스팸성 게시물인 경우 <br>
						8. 음란물 게재 혹은 음란 사이트 링크 등을 하는 경우<br> 
						9. 기타 Do포인트의 이익을 침해하는 경우<br> 
						10. 내용물이 공익적 성격과 상반된 개인의 이익을 위한 상업적 성격이라고 판단될 경우<br> 
						11. 기타 관계법령에 위반된다고 판단되는 경우<br> 
						② Do포인트는 회원의 게시물을 소중하게 생각하며 변조, 훼손되지 않도록 최선을 다하여 보호합니다. 그러나 다음의 경우는 그렇지 아니합니다.<br> 
						1. Do포인트는 바람직한 게시판 문화를 활성화하기 위하여 동의 없는 타인의 신상 공개시 특정부분을 삭제하거나 기호 등으로 수정하여 게시할 경우<br> 
						2. 다른 주제의 게시판으로 이동 가능한 내용일 경우 해당 게시물에 이동 경로를 밝혀 오해가 없도록 조치할 경우<br><br> 
						
						제 11조 (게시물의 저작권) <br>
						① 근본적으로 게시물에 관련된 제반 권리와 책임은 작성자 본인에게 있습니다. 또 게시물을 통해 자발적으로 공개된 정보는 보호받기 어려우므로 정보 공개 전에 심사숙고 하시기 바랍니다.<br> 
						1. 회원이 창작하여 관계사 사이트에 게재 또는 등록한 게시물에 대한 저작권은 회원 본인에게 있으며 해당 게시물이 타인의 지적 재산권을 침해하여 발생되는 모든 책임은 회원 본인에게 해당됨<br> 
						2. 회원은 자신이 창작, 등록한 게시물을 Do포인트의 서비스를 운영, 전송, 배포 또는 홍보하기 위해 Do포인트에 사용료 없이 사용권을 부여하며, 사용권은 Do포인트 서비스를 운영하는 동안 유효하며 회원의 탈퇴 후에도 유효함<br> 
						② Do포인트가 작성한 저작물에 대한 저작권 기타 지적재산권은 Do포인트에 귀속합니다. 이용자는 서비스를 이용하여 얻은 정보를 Do포인트의 사전승인 없이 복제, 송신, 출판, 배포, 방송, 가공, 판매하는 행위 등 서비스 내에 개재된 자료를 상업적으로 이용하거나 제3자에게 이용하게 하여서는 안됩니다.<br><br> 
						
						제 12조 (광고 게재 및 광고주와의 거래) <br>
						① Do포인트는 서비스의 운용과 관련하여 서비스 화면, e-mail 등에 광고를 게재할 수 있습니다. 회원은 서비스 이용 시 노출되는 광고 게재에 대해 동의하는 것으로 간주됩니다.<br> 
						② 서비스 상에 게재된 광고 내용이나 서비스를 통한 광고주의 판촉활동에 대하여 회원은 본인의 책임과 판단으로 참여하거나 교신 또는 거래하여야 하며, 그 결과로서 발생하는 모든 손실 또는 손해에 대해 Do포인트는 책임지지 않는 것을 원칙으로 합니다.<br><br> 
						
						제 13조 (서비스 이용시간)<br> 
						① Do포인트 서비스의 이용은 Do포인트의 업무상 또는 기술상에 특별한 지장이 없는 한 연중무휴 1일 24시간 가능함을 원칙으로 합니다. 다만, 정기점검 등의 필요로 Do포인트가 정한 날이나 시간은 제외됩니다.<br> 
						② Do포인트는 Do포인트 서비스를 일정 범위로 분할하여 각 범위별로 이용가능 시간을 별도로 정할 수 있습니다. 이 경우, Do포인트는 제 9조에 규정된 방법으로 통지합니다.<br><br> 
						
						제 14조 (서비스 이용의 한계와 책임)<br> 
						회원은 Do포인트가 서면으로 허용한 경우를 제외하고는 서비스를 이용하여 상품을 판매하는 영업활동을 할 수 없습니다. 특히, 회원은 해킹, 돈벌이 광고, 음란 사이트 등을 통한 상업행위, 상용 S/W 불법배포 등을 할 수 없습니다. 이를 위반하여 발생된 영업활동의 손실 및 관계기관에 의한 구속 등 법적 조치 등에 관해서는 회원이 모든 책임을 부담합니다.<br><br> 
						
						제 15조 (구매신청)<br> 
						Do포인트 서비스 이용자는 관계사 사이트 상에서 다음 또는 이와 유사한 방법에 의하여 구매를 신청하며, Do포인트는 이용자가 구매신청을 함에 있어서 다음의 각 내용을 알기 쉽게 제공하여야 합니다. 단, 회원인 경우 제2호 내지 제4호의 적용을 제외할 수 있습니다.<br> 
						1. 재화 등의 검색 및 선택<br> 
						2. 성명, 주소, 전화번호, 전자우편주소(또는 이동전화번호) 등의 입력<br> 
						3. 약관내용, 청약철회권이 제한되는 서비스, 배송료ㆍ설치비 등의 비용부담과 관련한 내용에 대한 확인<br> 
						4. 이 약관에 동의하고 위 3호의 사항을 확인하거나 거부하는 표시(예, 마우스 클릭)<br> 
						5. 재화 등의 구매신청 및 이에 관한 확인 또는 Do포인트의 확인에 대한 동의<br> 
						6. 결제방법의 선택 <br><br>
						
						제 16조 (계약의 성립) <br>
						① Do포인트는 제15조와 같은 구매신청에 대하여 다음 각호에 해당하면 승낙하지 않을 수 있습니다. 다만, 미성년자와 계약을 체결하는 경우에는 법정 동의를 얻지 못하면 미성년자 본인 또는 법정대리인이 계약을 취소할 수 있다는 내용을 고지하여야 합니다.<br>
						1. 신청 내용에 허위, 기재누락, 오기가 있는 경우<br> 
						2. 미성년자가 담배, 주류 등 청소년보호법에서 금지하는 재화 및 용역을 구매하는 경우<br> 
						3. 기타 구매신청에 승낙하는 것이 Do포인트의 기술상 현저히 지장이 있다고 판단하는 경우<br> 
						② Do포인트의 승낙이 제20조 제1항의 수신확인통지형태로 이용자에게 도달한 시점에 계약이 성립한 것으로 봅니다.<br> 
						③ Do포인트의 승낙의 의사표시에는 이용자의 구매 신청에 대한 확인 및 판매가능 여부, 구매신청의 정정 취소 등에 관한 정보 등을 포함하여야 합니다.<br><br> 
						
						제 17조 (지급방법)<br> 
						Do포인트에서 구매한 재화 또는 용역에 대한 대금지급방법은 다음 각호의 방법 중 가용한 방법으로 할 수 있습니다. 단, Do포인트는 이용자의 지급방법에 대하여 재화 등의 대금에 어떠한 명목의 수수료도 추가하여 징수할 수 없습니다.<br> 
						1. 폰뱅킹, 인터넷뱅킹, 메일 뱅킹 등의 각종 계좌이체<br> 
						2. 선불카드, 직불카드, 신용카드 등의 각종 카드 결제<br> 
						3. 온라인무통장입금<br> 
						4. 전자화폐에 의한 결제<br> 
						5. 수령시 대금지급<br> 
						6. 마일리지 등 Do포인트가 지급한 포인트에 의한 결제<br> 
						7. Do포인트와 계약을 맺었거나 Do포인트가 인정한 상품권에 의한 결제<br> 
						8. 기타 전자적 지급 방법에 의한 대금 지급 등<br><br> 
						
						제 18조 (수신확인통지ㆍ구매신청 변경 및 취소)<br> 
						① Do포인트는 이용자의 구매신청이 있는 경우 이용자에게 수신확인통지를 합니다.<br> 
						② 수신확인통지를 받은 이용자는 의사표시의 불일치 등이 있는 경우에는 수신확인통지를 받은 후 즉시 구매신청 변경 및 취소를 요청할 수 있고 Do포인트는 배송 전에 이용자의 요청이 있는 경우에는 지체 없이 그 요청에 따라 처리하여야 합니다. 다만 이미 대금을 지불한 경우에는 제24조의 청약철회 등에 관한 규정에 따릅니다.<br><br> 
						
						제 19조 (매일포인트 관련 규정)<br> 
						① 매일 포인트의 정의<br> 
						1. 포인트는 회원이 당사에서 판매 되는 상품이나 서비스의 구매하거나 당사에서 주최하는 이벤트, 추가 적립 서비스, 서베이 참여 등 마케팅 활동 등과 관련하여 획득한 포인트를 말합니다.<br> 
						2. 매일 포인트를 적립 또는 사용하기 위해서는 회원으로 가입해야 합니다.<br> 
						3. 당사는 상품을 구입하거나 서비스를 이용하고 그에 따른 대금을 결제한 회원에게 당사에 약정 고지된 바에 따라 포인트를 산정, 부여합니다. 단, 포인트와 관련하여 발생하는 제세공과금은 회원이 부담합니다.<br> 
						② 매일 포인트의 적립<br> 
						1. 매일 포인트는 회원의 상품 구매 또는 서비스 이용 금액에 비례하여 Do포인트가 정하는 적립률에 따라 부여 됩니다. 적립된 매일 포인트는 매일두닷컴 (maeildo.com) 및 관계사 사이트에서 확인이 가능합니다.<br> 
						2. 포인트는 다음과 같은 방법으로 적립할 수 있고, 적립 방법은 변경 될 수 있으며, 세부적인 내용은 매일 멤버십 홈페이지나 매일 멤버십 모바일앱에서 고지합니다.<br>
						- 멤버십 카드나 고객 식별 정보를 통한 적립 방식 : 영업점/가맹점 방문 구매 시 카드 제공 또는 고객 식별 정보 제공을 통해 인증 후 고지된 적립 비율에 따라 해당 포인트가 적립됩니다.<br> 
						- 구매에 따른 자동 적립 방식 : 온라인 쇼핑 이용 시 상품 안내에 고지된 적립 비율에 따라 해당 포인트가 구매 결제 완료 이후 적립됩니다.<br> 
						- 제품코드 등록 방식 : 분유, 이유식 캔제품의 제품코드를 등록할 때 캔별로 해당 포인트만큼 적립되고, 아이정보를 기준으로 생후 24개월까지만 적립이 가능하며, 월 최대로 적립할 수 있는 캔수는 분유 6캔, 이유식 3캔입니다. 제품코드를 등록할 수 있는 분유, 이유식 제품 내역은 매일아이닷컴에서 상세한 내용을 안내합니다.<br> 
						- 배달 여부 인증에 따른 자동 적립 방식 : 매일유업 가정배달 신청 시 배달 여부 인증에 따라 배달에 따른 결제 금액 입금 완료 시 고지된 적립 비율에 따라 해당 포인트가 적립됩니다.<br> 
						3. 당사의 브랜드별 적립 비율과 적립 브랜드, 적립 품목은 매일 멤버십 홈페이지에 고지된 내용에 따르며, 수시로 변경될 수 있으며, 본 약관의 제 3조, 3항에 따라 고지되거나 해당되는 영업점/가맹점에서 개별 고지됩니다.<br> 
						4. 당사의 브랜드 정책에 따라 일부 영업점/가맹점에서는 포인트 적립이 불가하거나 적립률이 차등 적용 될 수도 있으며, 이 경우 해당 영업점/가맹점이나 쇼핑몰에 해당 내용을 별도 표기 또는 안내 합니다.<br> 
						5. 포인트는 구매 시점 기준일의 익일 자동 일괄 적립되나, 일부 브랜드의 경우는 해당 브랜드의 요구하는 방법에 의해 추후 적립을 해야 합니다. 적립되는 포인트는 가용화되는 때부터 물품 또는 서비스 구매 시, 사용할 수 있습니다. 가용화 되어 사용 가능한 포인트는 당사의 매일 멤버십 서비스 홈페이지 또는 모바일 앱에서 확인이 가능합니다<br> 
						6. 포인트 적립은 구매 후 결제가 확정된 경우 적립되며, 포인트 결제의 경우는 적립에 제외됩니다. 만약, 포인트 적립 후 결제를 취소하시거나 구매를 철회하실 경우 해당 결제에 따라 발생한 포인트는 적립이 원상복귀 됩니다. 이 때 적립한 포인트를 이미 사용한 경우 원상복귀 되는 포인트는 마이너스(-)로 적립이 됩니다. (표시예시: -100p)<br> 
						7. 당사의 영업점/가맹점 이용 시 결제 즉시 포인트 적립을 못하였을 경우 당사의 지정된 기간 안에 사후 적립을 허용하며, 본 기간을 지났을 경우의 사후 적립은 불가합니다.<br> 
						- 외식매장 사후적립 기간 : 당일에 한하며, 구매영수증 지참 시 가능 <br>
						- 의류매장 사후적립 기간 : 일주일 내에 한하며, 구매영수증 지참 시 가능<br> 
						8. 매일 포인트의 적립처 및 유의사항은 아래와 같습니다. <br>
						- 분유/이유식 제품의 제품코드 등록을 통해 매일 포인트를 적립할 수 있습니다.<br> 
						제품별 적립 포인트는 Do포인트의 정책에 따릅니다. 적립대상은 등록하신 아기생일로부터 생후 24개월까지이며, 월별 적립캔수는 분유 제품 6캔/월, 이유식제품 3캔/월 로 제한함<br> 
						- 엠즈다이닝 외식 브랜드매장에서 결제 시 매일 포인트를 적립할 수 있습니다. 포인트 적립에 참여하는 외식 브랜드는 Do포인트의 정책에 따라 변경될 수 있습니다. 적립대상 및 적립율은 Do포인트의 내부 브랜드정책에 따릅니다.<br> 
						- 매일 포인트는 상품금액 결제 후 적립이 되며, 결제금액 중 제휴할인 및 포인트 사용액을 제외한 실 결제 금액에 한하여 적립됩니다. 매일포인트는 Table 및 일행당 1개의 카드에만 적립됩니다. <br>
						- 매장 내 판매되는 상품의 경우 결제금액에 대한 포인트 적립은 불가하며, 브랜드별 정책에 따릅니다. 또한, 백화점/쇼핑몰 입점매장은 매장에 따라 매일포인트 적립/사용 규정이 상이하며, 매일포인트와 타 포인트 간, 중복 할인 / 중복적립 / 중복 사용 여부는 브랜드별/입점매장별 규정에 따릅니다.<br> 
						
						- 매일유업 제품의 가정배달 신청 시, 가정배달코드 등록 후 음용금액 결제를 통해 매일 포인트를 적립할 수 있습니다. 적립대상은 매일유업 가정배달 제품을 가정배달 신청한 경우에 한합니다. 가정배달 신청 시, 제품별 차등되는 매일 포인트 적립규정에 따라, 적립됩니다.<br> 
						- 매일 포인트는 음용금액 결제가 익월 청구기간 안에 결제될 때에만, 익월 포인트 적립됩니다.<br> 
						- 배달 가능지역의 고객님만 신청할 수 있으며, 배달가능지역은 홈페이지 및 가정배달 전화상담을통해서 확인할 수 있습니다.<br> 
						- 매일 포인트는 음용금액 중 매일 포인트 사용액을 제외한 실 결제 금액에 한하여 적립됩니다.<br> 
						
						- 0to7 의류 브랜드인 알로&루, 포래즈, 알퐁소 제품을 구매하면 매일 포인트를 적립할 수 있습니다. 포인트 적립에 참여하는 의류 브랜드는 Do포인트의 정책에 따라 변경될 수 있습니다.<br> 
						- 매일 포인트는 상품금액 결제 후 적립이 되며, 상품금액 중 매일 포인트 사용액을 제외한 실 결제 금액에 한하여 적립됩니다.<br> 
						- 상품 교환의 경우 교환 시 추가 지급되는 금액에 대해서만 포인트를 지급합니다.<br> 
						단, 이월/기획/세일 상품은 적립대상에서 제외됩니다.<br> 
						- 오프라인 매장에서 적립된 매일 포인트의 사용은 익일 사용 가능합니다.<br> 
						- 또한, E-mart 입점매장에서는 매일 포인트 적립만 가능하고, 사용은 불가합니다.<br> 
						
						- 0to7 온라인 쇼핑몰(www.0to7.com)의 상품을 구매하면 매일 포인트를 적립할 수 있습니다. 단, Do포인트의 정책에 따라 포인트를 미지급하는 상품이 있습니다. 적립대상 및 적립율은 Do포인트의 내부정책에 따릅니다.<br> 
						매일 포인트는 각종 할인내역(매일포인트, 쿠폰 등)을 제외한 실 결제 금액에 한하여 적립됩니다. 매일 포인트는 상품의 출고 완료 후, 적립되어 사용할 수 있습니다.<br> 
						
						- 매일유업 소비자패널이 되시면 활동에 따라 매일 포인트가 적립됩니다. 소비자패널은 매일유업 제품개발과 서비스 개선에 의견을 주시는 분들로 별도 모집되어 운영됩니다.<br> 
						
						- MMS 카드는 알로&루, 포래즈, 알퐁소 모든 매장에서 발급 및 재발급이 가능합니다.<br> 
						Do포인트 서비스 회원이신 고객님은 멤버십 카드를 통한 매일 포인트의 적립 및 사용이 가능합니다.<br> 
						Do포인트 서비스 회원으로 등록되지 않은 회원의 경우, 적립일로부터 60일 내에 Do포인트 서비스 회원으로 가입해야만 적립된 매일 포인트를 사용할 수 있습니다.<br> 
						미 가입시에는 60일 경과 후 자동 소멸됩니다.<br> 
						
						9. 0to7 의류 3개 브랜드 매장에서의 포인트 적립은 2011년2월1일부터 적용되며, 유기농 제품 가정배달 신청 시 매일 포인트 적립은 2011년 3월1일부터 적용되며, 유기농 포함 가정배달 전제품 신청시 매일포인트 적립은 2012년 11월부터 적용됩니다. 엠즈다이닝 브랜드매장에서의 포인트 적립은 2013년 2월부터 적용됩니다.<br> 
						
						③ 매일 포인트의 사용 <br>
						1. 매일 포인트는 관계사 사이트 내/외부에서 Do포인트가 지정한 활동을 통해 포인트 사용이 가능합니다.<br> 
						2. 포인트를 사용하기 위해서는 회원 가입을 통해 회원의 지위를 취득하고 반드시 카드를 발급 등록 및 소유해야 합니다. 적립된 포인트 사용 순서는 회원이 보유 중인 사용가능포인트에서 중 소멸 일자가 빠른 포인트부터 우선적으로 차감 됩니다.<br> 
						3. 포인트 사용은 브랜드별 별도로 사용 가능 최저 포인트 및 포인트 사용 단위를 정하며 이는 당사의 서비스 이용 홈페이지 또는 영업점/가맹점 매장 내 고시(구두안내포함) 중 1가지 이상 방법으로 고지 됩니다. 현재 당사에서 회원이 포인트를 사용 하기 위해서는 아래 사용가능포인트의 최소 잔여 금액 및 사용 단위에 따라 사용이 가능합니다.<br> 
						
						최소 사용가능포인트 사용단위 사용처 <br>
						100 P 10 P 0to7쇼핑몰, 알로&루, 포래즈, 알퐁소, 음료교환 기프티콘, 포인트 기부, 매일 포인트샵, 매일 다이렉트<br> 
						1000 P 10 P 엠즈다이닝 <br>
						
						4. 포인트 사용은 1포인트를 1원처럼 사용하실 수 있으나, 포인트는 현금과 동일하지 않으며, 현금으로 환불되지 않습니다.<br> 
						5. 포인트 사용은 매일 멤버십 프로그램 온라인 사이트에서 고지된 사용처를 통하여 사용하실 수 있으며, Do포인트 사이트() 상세한 내용을 안내합니다.<br> 
						6. 별도의 회원가입 없이 MMS카드만 발급받은 경우나 회원가입은 하였어도 MMS카드를 사용 등록하지 않은 경우 해당되는(회원가입 후 등록 되지 않은) MMS카드에 적립된 포인트는 사용할 수 없습니다.<br> 
						7. 회원은 상품/서비스의 결제 수단으로 사용하는 것 외에 당사가 지정한 사은품 (상품권 포함)을 포인트를 사용하여 교환해 수령할 수 있습니다. 단, 이를 위해서는 당사가 정한 조건을 준수하여야 합니다.<br> 
						8. 회원은 포인트를 타인에게 양도하거나 대여 또는 담보의 목적으로 이용할 수 없습니다. 다만, 당사에서 인정하는 "포인트 선물하기" 등의 절차를 따른 경우는 예외로 합니다. "포인트 선물하기"에 따라 타 회원에게 양도 또는 증여 받은 포인트는 다시 타 회원에게 재 양도는 불가하며 당사 정책에 따라 당해 포인트 사용 유효기간 및 양도 금액 한도/횟수의 제한이 있을 수 있으며, 이에 대한 사항은 당사 서비스 홈페이지에 고지 합니다.<br> 
						9. 포인트 사용 후 사용 된 포인트의 적립 원천이 되는 구매 행위의 취소로 인해 잔여 포인트가 마이너스(-)인 경우 잔여 가용포인트가 0 포인트가 되기 전까지 적립되는 포인트는 사용이 불가합니다.<br> 
						10. 매일 포인트의 사용처 및 유의사항은 아래와 같습니다.<br> 
						- 0to7 쇼핑몰 : 적립된 매일 포인트를 통해 0to7 쇼핑몰의 상품을 구매할 수 있습니다. 구매하신 제품의 반품하실 경우, 사용하셨던 매일 포인트는 반품절차 진행완료 후, 환불 됩니다.<br> 
						또한, 매일 포인트와 쇼핑 적립금은 다릅니다. 2010년 12월 31일까지 적립된 쇼핑적립금은 유효기간이 종료되기 전까지 사용가능하며, 유효기간이 종료되면 폐지 됩니다.<br> 
						
						- 음료교환 기프티 콘 : 적립된 매일 포인트를 통해 음료교환 기프티 콘을 사용할 수 있습니다. 음료교환 기프티 콘이란, 매일유업의 제품을 편의점에서 교환 받을 수 있는 모바일 쿠폰입니다.<br> 
						음료교환 기프티 콘의 유효기간은 내부정책에 따르며, 구매 완료한 음료교환 기프티 콘은 취소/환불되지 않습니다. 유효기간이 지난 기프티 콘은 사용 및 환불이 불가합니다.<br> 
						또한, 음료교환 기프티 콘은 입력하신 휴대전화번호에만 적용됩니다.<br> 
						
						- 알로&루/포래즈/알퐁소 : 0to7의 의류 브랜드인 알로&루/포래즈/알퐁소의 상품을 구매하실 때 매일 포인트를 사용할 수 있습니다.<br> 
						알로&루, 포래즈, 알퐁소 매장에서 적립된 매일 포인트는 결제일 익일부터 사용가능 합니다.<br> 
						- 매일 다이렉트 : 가정배달 제품 가정배달 신청 시, 적립된 매일 포인트를 사용하여 음용금액을 결제할 수 있습니다.<br> 
						매일유업 가정배달에서는 100포인트부터 사용이 가능합니다.<br> 
						단, 가정배달의 음용금액 결제 시에 사용된 매일 포인트는 환불이 불가합니다.<br> 
						
						- 엠즈다이닝 외식매장 : 엠즈다이닝 외식매장 브랜드에서 매일 포인트를 사용하여 청구금액을 결제할 수 있습니다. 엠즈다이닝 외식매장에서는 1,000포인트부터 사용이 가능합니다. 포인트 사용시, 멤버십 모바일카드 및 실물카드를 제시하여야 합니다. 매일 포인트 사용에 참여하는 외식브랜드는 Do포인트의 내부정책에 의하여 변경될 수 있습니다. 매일 포인트 사용율 및 사용 가능한 제품에 대한 정책은 브랜드별/입점매장에 정책에 따라 달라질 수 있습니다.<br> 
						매일 포인트 사용과 타 포인트 중복적립/사용, 제휴중복할인 또는 제휴포인트 중복 적립/사용여부는 Do포인트 내부정책에 따릅니다.<br> 
						
						- 포인트 기부하기 : 매일유업㈜과 함께하는 사랑배달 캠페인을 통해 적립된 매일 포인트를 기부할 수 있습니다.<br> 
						
						- 와인 전문점 1만원 교환권 : 매일유업에서 운영하는 와인 전문점 1만원 교환권을 매일 포인트로 신청할 수 있습니다.<br> 
						와인전문점은 레뱅드 메일이며, 와인 전문점은 Do포인트의 내부사정에 의하여 변경될 수 있습니다. <br>
						와인 전문점 1만원 교환권은 잔여 매일 포인트가 10,000 점 이상인 고객만 신청이 가능하며, 1만원 교환권을 신청하실 경우, 10,000 매일 포인트가 차감됩니다. 
						또한, 매일 포인트 결제가 끝난 교환권은 취소가 불가합니다. <br>
						와인 전문점 1만원 교환권의 유효기간은 신청일로부터 3개월이며, 유효기간이 끝나면 사용이 불가합니다.<br> 
						와인 전문점 1만원 교환권은 레뱅드 매일의 다른 쿠폰과 중복 사용이 가능합니다. <br>
						
						6. 0to7 의류 3개 브랜드 매장에서의 포인트 사용은 2011년2월1일부터 적용되며, 유기농 제품 가정배달 신청 시 매일 포인트 사용은 2011년3월1일부터 적용되며, 유기농 제품 포함 가정배달 신청 시 매일포인트 사용은 2012년 12월부터 적용됩니다. 엠즈다이닝 포인트사용은 2013년 2월부터 적용됩니다.<br> 
						
						7. 회원은 매일 포인트를 타인에게 양도 또는 대여하거나 담보의 목적으로 제공할 수 없습니다. <br>
						
						④ 기존 매일 멤버십 포인트 및 쇼핑몰 적립금의 매일 포인트 전환안내 <br>
						관계사 사이트에서 기존 회원에게 개별적으로 제공했거나 제공한 적이 있는 기존 멤버십 포인트 또는 적립금은 아래와 같이 사용 가능합니다.<br> 
						1. 분유/이유식 구매 및 소비자패널 활동으로 인해 적립한 멤버십 포인트는 매일 포인트로 전환이 됩니다.<br> 
						2. 0to7 쇼핑몰의 쇼핑 적립금은 매일 포인트로 전환이 되지 않습니다. 다만, 기존의 쇼핑 적립금은 회사가 정한 정책에 따라 유효기간 만료 전까지는 매일 포인트와 복합적으로 사용이 가능합니다.<br> 
						3. 0to7 의류 마일리지는 매일 포인트로 전환이 되지 않습니다. 기존의 의류 마일리지는 매일 포인트와 복합적으로 사용이 불가합니다.<br> 
						기존의 의류 포인트는 Do포인트가 별도로 정한 정책에 따라 사용할 수 있습니다.<br> 
						⑤ 매일 포인트의 소멸<br> 
						1. 회원이 적립한 매일 포인트는 적립 월로부터 2년 동안 유효하며, 기간 내 미 사용한 매일 포인트는 월 단위로 자동 소멸됩니다. 적립 월로부터 2년 후가 되는 매월 1일 00:00시에 자동으로 소멸됩니다.<br> 
						(예) 2011년1월11일 적립<br> 
						→ 2013년1월 31일까지 사용 가능, 2013년1월31일 자정 소멸 (2월1일 0시)<br> 
						2. 이벤트 포인트는 해당 이벤트에 따라 별도 적용 됩니다.<br> 
						3. 회원님의 잔여 매일 포인트 중에서 가장 유효기간이 짧은 매일 포인트부터 차감됩니다.<br> 
						4. 소멸된 매일 포인트는 복구가 되지 않습니다.<br> 
						5. 다음 각 항에 해당하는 경우, 당사는 포인트 소멸 기간과는 별도로 회원이 보유한 포인트를 강제로 소멸할 수 있습니다.<br> 
						- 회원이 가입을 탈퇴할 경우 보유하고 있는 매일 포인트는 모두 소멸됩니다.<br> 
						- 본 약관의 제 19조 제 3항 제7호을 포함한 회원이 부정한 방법으로 포인트를 적립한 경우, 당사는 회원이 부정한 방법으로 취득한 포인트를 강제로 회수할 수 있습니다.<br> 
						6. 포인트 소멸은 유효기간이 가장 짧은 포인트부터 차감되며, 소멸된 포인트는 원상복구가 불가능 합니다.<br> 
						7. 회원이 부정한 방법으로 매일 포인트를 적립한 경우, Do포인트는 회원이 부정한 방법으로 취득한 매일 포인트를 강제로 회수할 수 있습니다.<br><br> 
						
						제 20조 (서비스 기간 및 기타) <br>
						① 매일 멤버십 프로그램에서 제공하는 멤버십 서비스는 매일 포인트 유효기간까지만 유효합니다. 단, 포인트를 통한 혜택만 제한되며, 멤버십 회원으로서의 자격은 유지됩니다.<br> 
						② Do포인트는 매일 멤버십 프로그램에 참여하는 회원이 포인트를 사용할 수 있는 다양한 기회를 제공하며, 매일 멤버십 사이트에서 상세한 내용을 안내합니다.<br> 
						③ 매일 멤버십 프로그램에 참여한 회원 중 일정 기준을 만족시킬 경우 차별화된 서비스가 제공되며, 서비스에 대한 내용은 매일 멤버십 사이트에 고지되거나, 해당된 고객에게 개별 고지됩니다.<br><br> 
						
						제 21조 (재화 등의 공급) <br>
						① Do포인트는 이용자와 재화 등의 공급시기에 관하여 별도의 약정이 없는 이상, 이용자가 청약을 한 날부터 7일 이내에 재화 등을 배송할 수 있도록 주문제작, 포장 등 기타의 필요한 조치를 취합니다. 다만, Do포인트가 이미 재화 등의 대금의 전부 또는 일부를 받은 경우에는 대금의 전부 또는 일부를 받은 날부터 2영업일 이내에 조치를 취합니다. 이때 Do포인트는 이용자가 재화 등의 공급 절차 및 진행 사항을 확인할 수 있도록 적절한 조치를 합니다.<br> 
						② Do포인트는 이용자가 구매한 재화에 대해 배송수단, 수단별 배송비용 부담자, 수단별 배송기간 등을 명시합니다. 만약 Do포인트가 약정 배송기간을 초과한 경우에는 그로 인한 이용자의 손해를 배상하여야 합니다. 다만 Do포인트가 고의ㆍ과실이 없음을 입증한 경우에는 그러하지 아니합니다.<br><br> 
						
						제 22조 (환급) <br>
						Do포인트는 이용자가 구매 신청한 재화 등이 품절 등의 사유로 인도 또는 제공을 할 수 없을 때에는 지체 없이 그 사유를 이용자에게 통지하고 사전에 재화 등의 대금을 받은 경우에는 대금을 받은 날부터 2영업일 이내에 환급하거나 환급에 필요한 조치를 취합니다.<br><br> 
						
						제 23조 (청약철회 등)<br> 
						① Do포인트와 재화 등의 구매에 관한 계약을 체결한 이용자는 수신확인의 통지를 받은 날부터 7일 이내에는 청약의 철회를 할 수 있습니다.<br> 
						② 이용자는 재화 등을 배송 받은 경우 다음 각호의 1에 해당하는 경우에는 반품 및 교환을 할 수 없습니다.<br> 
						1. 이용자에게 책임 있는 사유로 재화 등이 멸실 또는 훼손된 경우(다만, 재화 등의 내용을 확인하기 위하여 포장 등을 훼손한 경우에는 청약철회를 할 수 있습니다)<br> 
						2. 이용자의 사용 또는 일부 소비에 의하여 재화 등의 가치가 현저히 감소한 경우<br> 
						3. 시간의 경과에 의하여 재판매가 곤란할 정도로 재화 등의 가치가 현저히 감소한 경우<br> 
						4. 같은 성능을 지닌 재화 등으로 복제가 가능한 경우 그 원본인 재화 등의 포장을 훼손한 경우<br> 
						③ 제2항 제2호 내지 제4호의 경우에 Do포인트가 사전에 청약철회 등이 제한되는 사실을 소비자가 쉽게 알 수 있는 곳에 명기하거나 시용상품을 제공하는 등의 조치를 하지 않았다면 이용자의 청약철회 등이 제한되지 않습니다.<br> 
						④ 이용자는 제1항 및 제2항의 규정에 불구하고 재화 등의 내용이 표시 광고 내용과 다르거나 계약내용과 다르게 이행된 때에는 당해 재화 등을 공급받은 날부터 3월 이내, 그 사실을 안 날 또는 알 수 있었던 날부터 30일 이내에 청약철회 등을 할 수 있습니다.<br><br> 
						
						제 24조 (청약철회 등의 효과) <br>
						① Do포인트는 이용자로부터 재화 등을 반환 받은 경우 3영업일 이내에 이미 지급받은 재화 등의 대금을 환급합니다. 이 경우 Do포인트가 이용자에게 재화 등의 환급을 지연한 때에는 그 지연기간에 대하여 공정거래위원회가 정하여 고시하는 지연이자율을 곱하여 산정한 지연이자를 지급합니다.<br> 
						② Do포인트는 위 대금을 환급함에 있어서 이용자가 신용카드 또는 전자화폐 등의 결제수단으로 재화 등의 대금을 지급한 때에는 지체 없이 당해 결제수단을 제공한 사업자로 하여금 재화 등의 대금의 청구를 정지 또는 취소하도록 요청합니다.<br> 
						③ 청약철회 등의 경우 공급받은 재화 등의 반환에 필요한 비용은 이용자가 부담합니다. Do포인트는 이용자에게 청약철회 등을 이유로 위약금 또는 손해배상을 청구하지 않습니다. 다만 재화 등의 내용이 표시 광고 내용과 다르거나 계약내용과 다르게 이행되어 청약철회 등을 하는 경우 재화 등의 반환에 필요한 비용은 Do포인트가 부담합니다.<br> 
						④ 이용자가 재화 등을 제공 받을 때 발송비를 부담한 경우에 Do포인트는 청약철회 시 그 비용을 누가 부담하는지를 이용자가 알기 쉽도록 명확하게 표시합니다.<br><br> 
						
						제 25조 (개인정보보호)<br> 
						① Do포인트는 회원정보 수집 시 이용자의 동의를 얻어 서비스 제공 및 이용을 위하여 필요한 최소한의 회원정보(이름, 본인확인인증결과값(중복가입확인정보(DI), 암호화된 동일인식별정보(CI)) 생년월일, 주소, 전화번호, 휴대전화번호, 문자서비스 수신여부, e-mail주소, e-mail 수신 여부, ID, 비밀번호 등)와 최적화되고 고객지향적인 마케팅을 수행하기 위해 필요한 이외의 정보를 선택사항으로 수집하고 있습니다. 단, Do포인트가 수집하는 회원의 정보 목록은 서비스 변경이나 Do포인트 사정에 따라 변경될 수 있으며, 이 경우 변경사항을 이 약관 제 9조에 규정된 방법을 준용하여 회원에게 알려드리며 별도의 약관 절차는 생략합니다.<br> 
						② Do포인트는 회원이 관계사 사이트 및 제휴 사이트를 편리하게 이용하도록 하기 위하여 회원의 동의를 받아 관계사 사이트와 제휴 사이트 간에 제 1항의 회원정보를 공유할 수 있습니다.<br> 
						③ Do포인트는 서비스 제공과 관련하여 취득한 회원의 개인정보는 본인의 동의 없이 이 약관 및 개인정보취급방침에 정한 목적 이외의 용도로 이용하거나 제3자에게 제공할 수 없습니다. 단, 다음 각 호의 1에 해당하는 경우는 예외로 합니다.<br> 
						1. 배송업무상 배송업체에게 배송에 필요한 최소한의 이용자의 정보(성명, 주소, 전화번호)를 알려주는 경우<br> 
						2. 통계작성, 학술연구 또는 시장조사를 위하여 필요한 경우로서 특정 개인을 식별할 수 없는 형태로 제공하는 경우 <br>
						3. 재화 등의 거래에 따른 대금정산을 위하여 필요한 경우 <br>
						4. 도용방지를 위하여 본인확인에 필요한 경우<br> 
						5. 법률의 규정 또는 법률에 의하여 필요한 불가피한 사유가 있는 경우<br> 
						④ Do포인트 또는 그로부터 개인정보를 제공받은 제 3자는 개인정보의 수집목적 또는 제공받은 목적을 달성한 때에는 당해 개인정보를 지체 없이 파기합니다.<br> 
						⑤ 이용자는 언제든지 Do포인트가 가지고 있는 자신의 개인정보에 대해 열람 및 오류정정을 요구할 수 있으며 Do포인트는 이에 대해 지체 없이 필요한 조치를 취할 의무를 집니다. 이용자가 오류의 정정을 요구한 경우에는 Do포인트는 그 오류를 정정할 때까지 당해 개인정보를 이용하지 않습니다.<br> 
						⑥ Do포인트는 회원의 정보관리를 위하여 개인정보 관리 책임자를 두고, 개인정보 관리 책임자의 성명 및 전화번호 기타 연락처를 각 인터넷 웹사이트 등을 통하여 이용자에게 고지합니다.<br> 
						⑦ Do포인트는 개인정보의 보호에 대한 상세한 내용을 관계 법령에 의거하여 개인정보취급방침에 명시하고 있으며, 회원이 상시 확인할 수 있도록 각 사이트를 통해 공지하고 있습니다. 다만, 관계사 사이트 이외의 링크된 사이트에서는 Do포인트 개인정보취급방침이 적용되지 않습니다.<br><br> 
						
						제 26조 (Do포인트의 의무) <br>
						① Do포인트는 법령과 이 약관이 금지하거나 공서양속에 반하는 행위를 하지 않으며 이 약관이 정하는 바에 따라 지속적이고, 안정적으로 서비스를 제공하기 위하여 최선을 다하여야 합니다.<br> 
						② Do포인트는 이용자가 안전하게 인터넷 서비스를 이용할 수 있도록 이용자의 개인정보(신용정보 포함)보호를 위한 보안 시스템을 갖추어야 합니다.<br> 
						③ Do포인트가 상품이나 용역에 대하여 「표시ㆍ광고의공정화에관한법률」 제3조 소정의 부당한 표시ㆍ광고행위를 함으로써 이용자가 손해를 입은 때에는 이를 배상할 책임을 집니다.<br> 
						④ Do포인트는 이용자가 원하지 않는 영리목적의 광고성 전자우편을 발송하지 않습니다.<br><br> 
						
						제 27조 (회원의 의무)<br> 
						① 회원은 이 약관에서 규정하는 사항과 서비스 이용안내 또는 주의사항 등 Do포인트가 적법한 절차와 내용으로 공지 혹은 통지하는 사항을 준수하여야 하며 기타 Do포인트의 업무에 방해되는 행위를 하여서는 안됩니다.<br> 
						② 회원은 자신에게 부여된 ID와 비밀번호의 관리 소홀과 부정 사용이 발생하지 않도록 유의하여야 하며 Do포인트의 고의ㆍ과실이 없는 한 회원의 ID와 비밀번호에 관한 모든 관리 책임은 회원에게 있습니다.<br> 
						③ 회원 자신의 ID나 비밀번호가 부정하게 사용되었다는 사실을 발견한 경우에는 즉시 Do포인트에 신고하여야 하며 Do포인트의 고의ㆍ과실이 없는 한, 신고를 하지 않아 발생하는 모든 결과에 대한 책임은 회원에게 있습니다.<br> 
						④ 회원은 Do포인트에 제공한 개인정보와 관련하여 변경사항이 있는 경우에는 지체 없이 Do포인트에 그 변경사실을 통지하여야 하며, 이를 위반하여 발생한 일체의 손해에 대하여 Do포인트는 어떠한 책임도 지지 않습니다.<br> 
						⑤ 회원은 자신의 ID 및 비밀번호를 도난 당하거나 제3자가 사용하고 있음을 인지한 경우에는 바로 Do포인트에 통지해야 하며, Do포인트의 안내가 있는 경우에는 그에 따라야 합니다.<br> 
						⑥ 회원은 Do포인트의 사전승낙 없이는 서비스를 이용하여 영업활동을 할 수 없으며 그 영업활동 결과와 회원이 약관을 위반한 영업활동을 하여 발생한 결과에 대하여 Do포인트는 책임지지 않습니다. 회원의 이와 같은 영업활동으로 Do포인트가 손해를 입은 경우, 회원은 Do포인트에 대하여 손해배상책임을 부담합니다.<br><br> 
						
						제 28조 (이용자의 의무)<br> 
						이용자는 다음 행위를 하여서는 안됩니다.<br> 
						1. 신청 또는 변경 시 허위 내용의 등록<br> 
						2. 타인의 정보 도용<br> 
						3. Do포인트에 게시된 정보의 변경<br> 
						4. Do포인트가 정한 정보 이외의 정보(컴퓨터 프로그램 등) 등의 송신 또는 게시<br> 
						5. Do포인트 기타 제3자의 저작권 등 지적재산권에 대한 침해<br> 
						6. Do포인트 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위<br> 
						7. 외설 또는 폭력적인 메시지, 화상, 음성, 기타 공서양속에 반하는 정보를 Do포인트에 공개 또는 게시하는 행위<br><br> 
						
						제 29조 (연결 웹사이트와 피연결 웹사이트 간의 관계)<br> 
						① 관계사 사이트와 하위 웹사이트가 하이퍼 링크(예: 하이퍼 링크의 대상에는 문자, 그림 및 동화상 등이 포함됨)방식 등으로 연결된 경우, 전자를 연결 웹사이트라고 하고 후자를 피연결 웹사이트라고 합니다.<br> 
						② Do포인트는 피연결 웹사이트가 독자적으로 제공하는 재화 등에 의하여 이용자와 행하는 거래에 대해서 어떠한 책임도 지지 않습니다.<br> <br>
						
						제 30조 (저작권의 귀속 및 이용제한)<br> 
						① Do포인트가 작성한 저작물에 대한 저작권 기타 지적재산권은 Do포인트에 귀속합니다.<br> 
						② 이용자는 Do포인트 서비스를 이용함으로써 얻은 정보 중 Do포인트에게 지적재산권이 귀속된 정보를 Do포인트의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안됩니다.<br> 
						③ Do포인트는 약정에 따라 이용자에게 귀속된 저작권을 사용하는 경우 당해 이용자에게 통보하여야 합니다.<br><br> 
						
						제 31조 (면책조항)<br> 
						① Do포인트는 회원이 Do포인트의 서비스 제공으로부터 기대되는 이익을 얻지 못했거나 서비스 자료에 대한 취사선택 또는 이용으로 발생하는 손해 등에 대해서는 Do포인트에 귀책사유가 없는 한 책임을 지지 않습니다.<br> 
						② Do포인트는 회원의 귀책사유로 인하여 발생한 서비스 이용의 장애에 대해서는 책임을 지지 않습니다.<br>
						③ Do포인트는 회원이 게시 또는 전송한 자료의 내용에 대해서는 책임을 지지 않습니다.<br> 
						④ Do포인트는 회원 상호간 또는 회원과 제3자 상호간에 서비스를 매개로 하여 거래 등을 한 경우에는 책임이 면제 됩니다.<br> 
						⑤ Do포인트는 회원이 제28조 규정을 위배하여 발생하는 손해 등에 대해서는 책임을 지지 않습니다.<br><br> 
						
						제 32조 (분쟁해결)<br> 
						① Do포인트와 회원은 서비스와 관련하여 분쟁이 발생한 경우에 이를 원만하게 해결하기 위해 필요한 모든 노력을 기울여야 합니다.<br> 
						② Do포인트는 이용자가 제기하는 정당한 의견이나 불만을 반영하고 그 피해를 보상처리하기 위하여 피해보상처리기구를 설치ㆍ운영합니다.<br> 
						③ Do포인트는 이용자로부터 제출되는 불만사항 및 의견은 우선적으로 그 사항을 처리합니다. 다만, 신속한 처리가 곤란한 경우에는 이용자에게 그 사유와 처리일정을 즉시 통보해 드립니다.<br> 
						④ Do포인트와 이용자간에 발생한 전자상거래 분쟁과 관련하여 이용자의 피해구제신청이 있는 경우에는 공정거래위원회 또는 시 도지사가 의뢰하는 분쟁조정기관의 조정에 따를 수 있습니다.<br><br> 
						
						제 33조 (재판권 및 준거법)<br> 
						① Do포인트와 이용자간에 발생한 전자상거래 분쟁에 관한 소송은 민사소송법상의 관할법원에 제소합니다.<br> 
						② Do포인트와 이용자간에 제기된 전자상거래 소송에는 한국법을 적용합니다. 
					</div>
				</div>				
				<div class="jointoggleTT onArrjoin">
					<div class="chkBox">
						<label class="chk_style1">
							<em class="selected">
								<input type="checkbox" id="privacyAgreeChk" name="achk" value ="Y" >
							</em>
							<span>개인정보 수집 및 이용동의 <b>(필수)</b></span>
						</label>
					</div>
					<a href="javascript:void(0);" class="join_TTOn"></a>
				</div>
				<div class="jointoggleVW">
					<div class="join_txtbox">
					개인정보 처리방침 <br><br>

						1. 총칙 <br>
						매일 Do Point는 (이하 '회사'는) 매일 Do Point 이용자(이하 ‘이용자’) 의 개인정보를 중요시하며, "정보통신망 이용촉진 및 정보보호 등에 관한 법률”을 준수하고 있으며, 그에 의거한 개인정보처리방침을 정하여 이용자의 권익보호에 최선을 다하고 있습니다.<br> 
						회사는 개인정보처리방침을 통하여 이용자의 제공하시는 개인정보가 어떠한 용도와 방식으로 이용되고 있으며, 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 알려드립니다.<br> <br>
						
						2. 수집하는 개인정보 항목 및 수집방법<br> 
						① 회사는 회원가입, 서비스 신청 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.<br> 
						▶ 필수항목(회원 기초정보)<br> 
						- 이름, 성별, 생년월일, 비밀번호, 주소, 휴대전화번호, e-mail 주소<br> 
						#. 서비스 제공을 위해 필요한 최소한의 개인정보이므로 동의를 해 주셔야 서비스 이용이 가능합니다.<br> 
						▶ 선택항목(회원 및 아기 부가정보)<br> 
						- SMS 수신여부, e-mail 수신여부, 아기이름, 출산일 등<br> 
						- 단, 회원의 기본적 인권 침해의 우려가 있는 민감한 인종 및 a민족, 사상 및 신조, 출신지 및 본적지, 정치적 성향 및 범죄기록, 건강상태 및 성생활 등의 개인정보는 수집하지 않습니다.<br> 
						- 또한, 일부 필수입력사항(우편물 수령지 주소 등)은 회원가입 채널에 따라 수집시점이 달라질 수 있습니다.<br> 
						▶ 생성정보<br> 
						- 서비스 이용과정이나 사업 처리 과정에서 자동으로 생성되어 수집될 수 있는 항목.<br> 
						- 사이트 이용시 : 서비스 이용기록(이용시간, 이용매장, 포인트, 상품 또는 서비스 구매내역 등), 접속 로그, 쿠키, 접속IP정보, 결제기록, 이용정지 기록, 부정이용 기록, 탈퇴일, 탈퇴사유<br> 
						- Point 등록/사용시 : Point 사용/적립액, Point 사용/적립 채널, 적립/사용일자 등<br> 
						- DM 수신 신청시 : DM 수신여부, DM 신청/발송정보, 상담정보 등<br> 
						② 회사는 다음과 같은 방법으로 개인정보를 수집하고 있습니다.<br> 
						- 홈페이지, 서면양식, 전화, 팩스를 통한 회원가입<br> 
						- 상담 게시판, 이벤트/경품행사 응모, 배송 요청<br> 
						- 제휴사로부터의 제공<br> 
						- 생성정보 수집 툴을 통한 수집<br><br> 
						
						3. 개인정보 수집 및 이용목적<br> 
						① 회원관리 <br>
						- 통합 회원제 서비스 이용에 따른 본인 확인, 개인식별, 불량회원의 부정 이용 방지와 비인가 사용 방지, 가입 의사 확인, 가입 및 가입횟수 제한, 만 14세 미만 아동 개인정보 수집 시 법정 대리인 동의여부 확인, 추후 법정 대리인 본인 확인, 분쟁조정을 위한 기록보존, 불만처리 등 민원처리, 고지사항 전달 등<br> 
						② 서비스 제공을 위한 계약 이행<br> 
						- Point 적립 및 사용<br> 
						- 물품 배송 또는 청구서 등 발송, 금융거래 본인 인증 및 금융 서비스, 구매 및 요금 결제, 요금 추심<br> 
						③ 마케팅 및 광고 활용<br> 
						- 이벤트/쿠폰 등 광고성 정보 전달, 접속빈도 파악, 서비스 이용 통계<br><br> 
						
						4. 개인정보의 제3자 제공에 대한 동의<br> 
						① 회사는 회원의 개인정보를 ‘개인정보의 수집, 이용 목적 및 수집하는 개인정보 항목’에서 고지한 범위 내에서 이용하며, 동 범위를 초과하여 이용하거나 타인 또는 타기업, 기관에 제공하지 않습니다. 단 회원이 사전에 동의하거나 관계법률에서 정한 절차와 방법에 따라 수사기관이 개인정보 제공을 요구하는 경우 또는 영업의 양수로 인해 부득이하게 개인정보 이전이 필요한 경우(별도 회원 사전 공지)는 별도로 제외 됩니다. 현재 회원의 개인정보를 제공하고 있는 업체는 아래와 같습니다.<br> 
						<개인정보 제 3자 제공 업체><br> 
						▶ 제3자 : (주) 제로투세븐, 엠즈씨즈, 크리스탈제이드, 상하농원<br> 
						- 이용목적 : 웹사이트 로그인, 매일 Do Point 적립 및 사용, 기타 매일 매일 Do Point 관련한 서비스 제공 목적<br> 
						- 제공하는 개인정보항목 : 이용자 기초정보 및 부가정보, 매일 Do Point 정보<br> 
						- 보유 및 이용기간 : 회원이 제휴사 이용약관에 동의한 때로부터 제휴사의 이용약관 철회 혹은 매일 Do Point 탈퇴시까지<br> 
						
						② 회원은 개인정보 제3자 제공 동의를 거부할 권리가 있으며, 제3자 제공 동의 여부와 관계 없이 회원에 가입할 수 있습니다. 단, 개인정보 제3자 제공 동의 거부 시, 서비스 이용에 제한될 수 있습니다. <br><br>
						
						5. 수집한 개인정보의 취급 및 위탁 <br>
						회사는 매일 Family 서비스 이행을 위해 아래와 같이 개인정보 취급 업무를 외부 전문업체에 위탁하여 운영하고 있으며, 관련 법령에 따라 위탁 계약 시 개인정보가 안전하게 관리될 수 있도록 필요한 사항을 규정하고 있습니다.<br><br> 
						
						<개인정보의 위탁취급> <br>
						
						▶위탁 목적 : 매일Do 포인트 적립 및 사용, 고객 안내 및 CS 처리, 이용회원의 부정 이용 방지 및 비인가 사용 방지<br> 
						- 위탁 제휴사 : (주) 제로투세븐<br> 
						- 보유 및 이용기간 : 회원 탈퇴시 혹은 위탁 계약 종료시 까지<br> 
						- 위착 정보 : 회원정보 전체<br> 
						
						▶위탁 목적 : 홈페이지 관리 및 전산처리<br> 
						- 위탁 제휴사 : ㈜ 아이비즈소프트웨어<br> 
						- 보유 및 이용기간 : 회원 탈퇴시 혹은 위탁 계약 종료시 까지<br> 
						- 위착 정보 : 회원정보 전체<br> 
						
						▶위탁 목적 : 기프티콘 서비스를 위한 휴대폰 인증<br>	
						- 위탁 제휴사 : 엠하우스<br> 
						- 보유 및 이용기간 : 위탁 목적이 달성 될 때 까지<br> 
						- 위착 정보 : 성명, 핸드폰번호, 발송상품내역<br> 
						
						▶위탁 목적 : 본인 확인을 위한 휴대폰 인증<br> 
						- 위탁 제휴사 : SCI 평가정보<br> 
						- 보유 및 이용기간 : 위탁 목적이 달성 될 때 까지<br> 
						- 위착 정보 : 본인 식별 정보<br> 
						
						▶위탁 목적 : 고객 CS 상담<br> 
						- 위탁 제휴사 : 메타넷엠씨씨<br> 
						- 보유 및 이용기간 : 회원 탈퇴시 혹은 위탁 계약 종료시 까지<br> 
						- 위착 정보 : 회원정보 전체<br> 
						
						▶위탁 목적 : 클라우드 전산관리<br> 
						- 위탁 제휴사 : 베스핀글로벌<br> 
						- 보유 및 이용기간 : 회원 탈퇴시 혹은 위탁 계약 종료시 까지<br> 
						- 위착 정보 : 회원정보 전체<br> 
						
						*위탁 목적에 대한 세부사항은 [6. 개인정보의 보유 및 이용기간]항목 참조<br><br> 
						
						6. 개인정보의 보유 및 이용기간<br> 
						① 회사는 이용자가 동의한 날부터 개인정보의 수집 및 이용목적을 달성할 때까지의 기간에 한하여 이용자의 개인정보를 보유 및 이용하며, 개인정보 수집 및 이용목적이 달성된 경우에는 해당 정보를 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존 후 파기하고. 제2항에 해당하는 정보는 제2항의 보존기간 경과 후 파기합니다. 또한, 회사는 개인정보의 수집 및 이용목적이 달성되지 않았더라도 회원이 최종 로그인한 날짜를 기준으로 3년(단, 2015년 8월 18일 이후에는 1년)간 회원이 로그인을 하지 않았을 경우 정보통신망 이용촉진 및 정보보호 등에 관한 법률에 따라 회원의 개인정보를 파기할 수 있습니다.<br> 
						▶ 회원 적립 Point 소멸 방지 및 Point 서비스의 부정이용 방지<br> 
						- 보존항목 : 이름, 본인확인인증결과값(중복가입확인정보(DI), 암호화된 동일인식별정보(CI), ID, 비밀번호, 주소, 전화번호, 휴대전화번호, 문자서비스 수신여부, e-mail주소, e-mail 수신여부, DM 수신여부, 아기이름, 출산일, 탈퇴일시, 탈퇴사유, DM 신청/발송정보, 상담정보, 부정이용 기록<br> 
						- 보존기간 : 탈퇴 후 3년(단, 전자상거래 이력 발생 시, 최장 5년 까지 보관)<br> 
						▶ 회원의 구매, 결제 및 배송 관련 확인과 클레임 처리<br> 
						- 보존항목 : 결재정보(계좌번호, 카드번호 등), 배송정보(배송 주소지, 수령인 연락처 등)<br> 
						- 보존기간 : 회원 탈퇴시 까지<br> 
						▶ 이벤트/쿠폰 등 광고성 정보 전달, 접속빈도 파악, 서비스 이용 통계<br> 
						- 보존항목 : 서비스 이용기록(이용시간, 이용매장, 포인트, 상품 또는 서비스 구매내역 등), 접속 로그, 쿠키, 접속IP정보 등<br> 
						- 보존기간 : 회원 탈퇴시 까지<br> 
						▶ ID 중복 가입 방지 사유<br> 
						- 보존항목 : ID, 탈퇴일시, 탈퇴사유<br> 
						- 보존기간 : 탈퇴후 5년<br> 
						
						② 제1항에도 불구하고 회사는 관련법령에 의거하여 이용자의 개인정보를 다음과 같이 보유할 수 있습니다.<br> 
						▶ 계약 또는 청약철회 등에 관한 기록<br> 
						- 보존이유 : 전자상거래 등에서의 소비자보호에 관한 법률<br> 
						- 보존기간 : 5년<br> 
						▶ 대금결제 및 재화 등의 공급에 관한 기록<br> 
						- 보존이유 : 전자상거래 등에서의 소비자보호에 관한 법률<br> 
						- 보존기간 : 5년<br> 
						▶ 소비자의 불만 또는 분쟁처리에 관한 기록<br> 
						- 보존이유 : 전자상거래 등에서의 소비자보호에 관한 법률<br> 
						- 보존기간 : 3년<br><br> 
						
						7. 개인정보의 파기절차 및 방법<br> 
						회사는 개인정보 수집 및 이용목적이 달성된 후 또는 제6조에 의한 보유기간 경과 후에는 해당 정보를 지체 없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.<br> 
						① 파기절차<br> 
						- 회원가입 및 서비스 신청 등을 위하여 입력하신 정보는 목적이 달성된 후 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조) 일정 기간 저장된 후 파기되어 집니다.<br> 
						- 동 개인정보는 법률에 의한 경우가 아니고서는 보유 이외의 다른 목적으로 이용되지 않습니다.<br> 
						② 파기방법<br> 
						- 전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.<br> 
						- 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각합니다.<br><br> 
						
						8. 장기 미이용 회원 개인정보 분리 보관<br> 
						① 회사는 관련 법령에 의거하여 휴면 회원의 개인정보를 접근이 불가능한 별도의 보관장치에 분리 보관합니다.<br> 
						1) 시행일자 : 2015년 8월 18일<br> 
						2) 관련 법령 : 정보통신망 이용촉진 및 정보보호 등에 관한 법률 제29조 및 동법 시행령 제16조<br> 
						3) 휴면 회원 : 매일 Do Point 서비스를 1년 이상 이용하지 않은 회원<br> 
						② 다음 조건을 모두 만족하는 경우에 휴면 회원으로 전환됩니다.<br> 
						1) 포인트 거래이력이 1년 이상 없는 회원<br> 
						2) 서비스 홈페이지(PC/모바일웹, 앱 포함) 로그인 이력이 1년 이상 없는 회원<br> 
						3) 고객센터 상담 이력이 1년 이상 없는 회원<br> 
						4) 잔여포인트가 없는 회원<br> 
						③ 회사는 휴면 전환 30일 전까지 휴면 예정 회원에게 별도 분리 보관되는 사실 및 휴면 예정일, 별도 분리 보관하는 개인정보 항목을 이메일, 서면, 모사전송, 전화 또는 이와 유사한 방법 중 어느 하나의 방법으로 이용자에게 알립니다. 해당 통지 수단에 대한 정보가 부재 또는 오류인 경우에는 홈페이지 공지사항 게시로 대신합니다.<br> 
						④ 휴면 상태 이전에 발급되었던 쿠폰은 해당 유효기간 만료 시 자동 소멸되며, 기간이 만료된 쿠폰은 재발행 되지 않습니다.<br> 
						⑤ 휴면 회원이 포인트 거래, 서비스 홈페이지 로그인, 고객센터 상담 등을 통해 매일 Do Point 서비스를 재이용하는 경우 휴면계정은 일반 회원 계정으로 복구됩니다.<br> 
						
						9. 이용자 및 법정대리인의 권리와 그 행사방법 <br>
						이용자 및 법정대리인은 언제든지 등록되어 있는 자신 혹은 당해 만 14세 미만의 아동의 개인정보를 조회하거나 수정할 수 있으며 가입 해지를 요청할 수도 있습니다.<br> 
						이용자 혹은 만 14세 미만 아동의 개인정보 조회, 수정을 위해서는 ‘개인정보변경’(또는 ‘회원정보수정’ 등)을, 가입해지(동의철회)를 위해서는 ‘회원탈퇴’를 클릭하여 본인 확인 절차를 거치신 후 직접 열람, 정정 또는 탈퇴가 가능합니다. 혹은 개인정보보호책임자에게 서면, 전화 또는 e-mail로 정정을 요청하시면, 본인 확인 절차 후에 조치하겠습니다.<br> 
						이용자가 개인정보의 오류에 대한 정정을 요청하신 경우에는 정정을 완료하기 전까지 당해 개인정보를 이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리결과를 제3자에게 지체없이 통지하여 정정이 이루어지도록 하겠습니다.<br> 
						회사는 이용자의 요청에 의해 해지 또는 삭제된 개인정보는 “회사가 수집하는 개인정보의 보유 및 이용기간”에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 처리하고 있습니다.<br><br> 
						
						10. 개인정보 자동수집 장치의 설치, 운영 및 그 거부에 관한 사항<br> 
						회사는 이용자의 정보를 수시로 저장하고 찾아내는 ‘쿠키(cookie)’ 등을 운용합니다. 쿠키란 회사의 웹사이트를 운영하는데 이용되는 서버가 이용자의 브라우저에 보내는 아주 작은 텍스트 파일로서 웹서비스 또는 모바일 서비스 이용 시 이용자의 브라우저에게 보내는 소량의 정보이며 이용자의 단말기(PC, 스마트폰, 태블릿 PC 등) 하드디스크에 저장됩니다. 회사는 다음과 같은 목적을 위해 쿠키를 사용합니다.<br> 
						① 쿠키 등 사용 목적<br> 
						- 이용자의 접속 빈도나 방문 시간 등을 분석, 이용자의 취향과 관심분야를 파악 및 자취 추적, 각종 이벤트 참여 정도 및 방문 회수 파악 등을 통한 타겟 마케팅 및 개인 맞춤 서비스 제공.<br> 
						- 이용자는 쿠키 설치에 대한 선택권을 가지고 있습니다. 따라서, 이용자는 웹브라우저에서 옵션을 설정함으로써 모든 쿠키를 허용하거나, 쿠키가 저장될 때마다 확인을 거치거나, 아니면 모든 쿠키의 저장을 거부할 수도 있습니다.<br> 
						② 쿠키 설정 거부 방법<br> 
						- 쿠키 설정을 거부하는 방법으로는 이용자가 사용하는 웹 브라우저의 옵션을 선택함으로써 모든 쿠키를 허용하거나 쿠키를 저장할 때마다 확인을 거치거나, 모든 쿠키의 저장을 거부할 수 있습니다.<br> 
						- 단, 사용자께서 쿠키 설정을 거부하였을 경우, 서비스 제공에 어려움이 있을 수 있습니다.<br> 
						- 쿠키 설정 여부를 지정하는 방법(인터넷 익스플로러의 경우)<br> 
						웹 브라우저 상단의 [도구] > [인터넷 옵션] > [개인정보 탭] > [개인정보취급 수준]을 설정하시면 됩니다.<br><br> 
						
						11. 개인정보의 기술적/관리적 보호 대책<br> 
						이용자의 개인정보는 비밀번호에 의해 보호되고 있습니다. 이용자 계정의 비밀번호는 오직 본인만이 알 수 있으며, 개인정보의 확인 및 변경도 비밀번호를 알고 있는 본인에 의해서만 가능합니다. 따라서 이용자 자신의 비밀번호는 누구에게도 알려주면 안됩니다. 또한 작업을 마치신 후에는 로그아웃(log-out)하시고 웹브라우저를 종료하는 것이 바람직합니다. 특히 다른 사람과 컴퓨터를 공유하여 사용하거나 공공장소에서 이용한 경우 개인정보가 다른 사람에게 알려지는 것을 막기 위해서 이와 같은 절차가 더욱 필요합니다.<br> 
						① 기술적 대책<br> 
						회사는 이용자의 개인정보를 취급함에 있어 개인정보가 분실, 도난, 누출, 변조 또는 훼손되지 않도록 안전성 확보를 위하여 다음과 같은 기술적 대책을 강구하고 있습니다.<br> 
						- 이용자의 개인정보는 비밀번호에 의해 보호되며 파일 및 전송데이터를 암호화하거나 파일 잠금기능(Lock)을 사용하여 중요한 데이터는 별도의 보안기능을 통해 보호되고 있습니다.<br> 
						- 회사는 백신프로그램을 이용하여 컴퓨터 바이러스에 의한 피해를 방지하기 위한 조치를 취하고 있습니다.<br> 
						- 백신프로그램은 주기적으로 업데이트되며 갑작스런 바이러스가 출현할 경우 백신이 나오는 즉시 이를 제공함으로써 개인정보가 침해되는 것을 방지하고 있습니다.<br> 
						- 회사는 암호알고리즘을 이용하여 네트워크 상의 개인정보를 안전하게 전송할 수 있는 보안장치(SSL 또는 SET)를 채택하고 있습니다.<br> 
						- 해킹 등 외부침입에 대비하여 침입차단시스템 및 취약점 분석시스템 등을 이용하여 보안에 만전을 기하고 있습니다.<br> 
						② 관리적 대책<br> 
						- 회사는 이용자의 개인정보에 대한 접근권한을 최소한의 인원으로 제한하고 있습니다. 그 최소한의 인원에 해당하는 자는 다음과 같습니다.<br> 
						* 이용자를 직접 상대로 하여 마케팅 업무를 수행하는 자<br> 
						* 개인정보관리책임자 및 담당자 등 개인정보관리업무를 수행하는 자<br> 
						* 기타 업무상 개인정보의 취급이 불가피한 자<br><br> 
						
						12. 개인정보 관리 책임자<br> 
						회사는 이용자의 개인정보를 보호하고 개인정보와 관련한 불만을 처리하기 위하여 아래와 같이 관련 부서 및 개인정보관리책임자를 지정하고 있습니다.<br> 
						① 개인정보처리담당자<br> 
						- 부서명 : CRM팀<br> 
						- 직책 : 대리<br> 
						- 담당자 : 박경하<br> 
						- 전화번호 : 02-2127-9810<br> 
						- e-mail : khpark@maeil.com<br> 
						② 개인정보관리책임자 <br>
						- 담당자 : 목준균<br> 
						- 직책 : 상무<br> 
						- 전화번호 : 02-3671-3761<br> 
						이용자께서는 회사의 서비스를 이용하시며 발생하는 모든 개인정보보호 관련 민원을 개인정보관리책임자 혹은 담당부서로 신고하실 수 있습니다. 회사는 이용자들의 신고사항에 대해 신속하게 충분한 답변을 드릴 것입니다.<br> 
						기타 개인정보침해에 대한 신고나 상담이 필요하신 경우에는 아래 기관에 문의하시기 바랍니다.<br> 
						- 개인분쟁조정위원회 (www.1336.or.kr / 국번없이 1336)<br> 
						- 정보보호마크인증위원회 (www.eprivacy.or.kr / 02-580-0533~4)<br> 
						- 대검찰청 사이버범죄수사단 (www.spo.go.kr / 02-3480-3571)<br> 
						- 경찰청 사이버테러대응센터 (www.ctrc.go.kr / 1566-0112)<br><br> 
						
						13. 고지의 의무<br> 
						① 본 개인정보처리방침을 포함한 기타 개인정보 보호에 대한 상세한 내용은 회사가 운영하는 홈페이지 첫 화면에 공개함으로써 이용자가 언제나 용이하게 보실 수 있도록 조치하고 있습니다. 본 개인정보처리방침의 내용은 수시로 변경될 수 있으므로 사이트를 방문하실 때마다, 이를 확인하시기 바랍니다.<br> 
						② 회사는 개인정보처리방침을 개정하는 경우 최소 7일전부터 웹사이트 공지사항(또는 개별공지)을 통하여 공지할 것입니다.<br> 
						
						개인정보취급방침 시행일자 : 2018.09.12<br>
					</div>
				</div>					
				<div class="jointoggleTT onArrjoin" style="padding-bottom:7px;">
					<div class="chkBox">
						<label class="chk_style1">
							<em class="selected">
								<input type="checkbox" id="offerAgreeChk" name="achk" >
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
			<a href="javascript:void(0)" class="btnCheck Large" onclick="join();">회원 가입하기</a>	
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
	<form name="createIdFrom" id="createIdFrom" action="/mobile/member/joinProc.jsp" method="POST">
	    <input type="hidden" name="cId" id="cId" value=""/>
	    <input type="hidden" name="cPwd" id="cPwd" value=""/>
		<input type="hidden" name="cName" id="cName" value=""/>
		<input type="hidden" name="cCi" id="cCi" value="<%=Utils.safeHTML(param.get("connInfo")) %>"/>
		<input type="hidden" name="cDi" id="cDi" value="<%=Utils.safeHTML(param.get("dupInfo")) %>" />
		<input type="hidden" name="cCiVersion" id="cCiVersion" value="<%=Utils.safeHTML(param.get("connInfoVer")) %>" />
		<input type="hidden" name="cGndrDvCd" id="cGndrDvCd" value="<%=strGenderCd %>" />
		<input type="hidden" name="cStrFgnGbn" id="cStrFgnGbn" value="<%=strFgnGbn %>" />
		<input type="hidden" name="cCertDv" id="cCertDv" value="<%=strCertDv %>" />
		<input type="hidden" name="cEmlAddr" id="cEmlAddr" value="" />
		<input type="hidden" name="cBirth" id="cBirth" value="<%=Utils.safeHTML(param.get("birth"))%>" />
		<input type="hidden" name="cBtdyLucrDvCd" id="cBtdyLucrDvCd" value="1" />
		<input type="hidden" name="cAgrmNo1" id="cAgrmNo1" value=""/>
		<input type="hidden" name="cAgrmNo2" id="cAgrmNo2" value=""/>
		<input type="hidden" name="cAgrmNo7010" id="cAgrmNo7010" value=""/>
		<input type="hidden" name="cAppPushRecv" id="cAppPushRecv" value=""/>
		<input type="hidden" name="cSmsRecv" id="cSmsRecv" value=""/>
		<input type="hidden" name="cEmlRecv" id="cEmlRecv" value=""/>
		<input type="hidden" name="cWrlTel" id="cWrlTel" value=""/>
		<input type="hidden" name="cAddrFlag" id="cAddrFlag" value=""/>
		<input type="hidden" name="cPostCode" id="cPostCode" value=""/>
		<input type="hidden" name="cZoneCode" id="cZoneCode" value=""/>
		<input type="hidden" name="cAddress1" id="cAddress1" value=""/>
		<input type="hidden" name="cAddress2" id="cAddress2" value=""/>
		<input type="hidden" name="type" value="<%= param.get("type") %>"/>
	</form>
	<script type="text/javascript">
	var element_wrap;
	function foldDaumPostcode() {
		element_wrap = document.getElementById('zipArea');
		// iframe을 넣은 element를 안보이게 한다.
	    element_wrap.style.display = 'none';
	}

	function execDaumPostcode() {
		element_wrap = document.getElementById('zipArea');
		var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
	    new daum.Postcode({
	        oncomplete: function(data) {
	            // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

	            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	            var fullAddr = data.address; // 최종 주소 변수
	            var extraAddr = ''; // 조합형 주소 변수

	            // 기본 주소가 도로명 타입일때 조합한다.
	            if(data.addressType === 'R'){
	                //법정동명이 있을 경우 추가한다.
	                if(data.bname !== ''){
	                    extraAddr += data.bname;
	                }
	                // 건물명이 있을 경우 추가한다.
	                if(data.buildingName !== ''){
	                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                }
	                // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
	                fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
	            }
	            //전송용데이터 작성
	            if(data.userSelectedType === 'R'){
	            	$("#cAddrFlag").val("1");
	            }else{
	            	$("#cAddrFlag").val("2");
	            	
	            }
	            $("#cAddress1").val(fullAddr);
	            $("#cPostCode").val(data.postcode1 + data.postcode2);
	            $("#cZoneCode").val(data.zonecode);
	            
	            // 우편번호와 주소 정보를 해당 필드에 넣는다.
	            $("#ship_post_no").val(data.zonecode); //5자리 새우편번호 사용
	            $("#ship_addr1").val(fullAddr);

	            // iframe을 넣은 element를 안보이게 한다.
	            // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
	            element_wrap.style.display = 'none';

	            // 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
	            document.body.scrollTop = currentScroll;
	        },
	        // 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
	        onresize : function(size) {
	            element_wrap.style.height = size.height+'px';
	        },
	        width : '100%',
	        height : '100%'
	    }).embed(element_wrap);

	    // iframe을 넣은 element를 보이게 한다.
	    element_wrap.style.display = 'block';
	    initLayerPosition();
	}
	
	
	
	
	//브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
	// resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
	// 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
	function initLayerPosition(){
	    var width = 400; //우편번호서비스가 들어갈 element의 width
	    var height = 400; //우편번호서비스가 들어갈 element의 height
	    var borderWidth = 5; //샘플에서 사용하는 border의 두께
	    var scrollHeight = $(window).scrollTop();
	
	    // 위에서 선언한 값들을 실제 element에 넣는다.
	    element_wrap.style.width = width + 'px';
	    element_wrap.style.height = height + 'px';
	    element_wrap.style.border = borderWidth + 'px solid';
	    // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
	    element_wrap.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
	    element_wrap.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth + scrollHeight) + 'px';
	    //element_layer.scrollTop();
	}
	
	</script>
</html>
