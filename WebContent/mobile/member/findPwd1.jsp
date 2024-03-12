<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="com.efusioni.stone.common.SystemChecker"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import ="java.util.*,java.text.SimpleDateFormat"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma", "no-store");
    response.setHeader("Cache-Control", "no-cache");
    Param param = new Param(request);
    
    String id      = "MIU002";													    //회원사 ID
    String reqNum      = "";														//요청번호
    String retUrl      = "23" + request.getScheme() + "://" + request.getServerName() + "/auth/sciIpinPopup.jsp?screenCd=findPwd"; //리턴URL
    String srvNo       = "";										     			//서비스번호
    String exVar       = "0000000000000000";                                        //복호화용 임시필드
	String curDate     = Utils.getTimeStampString("yyyyMMddHHmmss");                //처리시간
    String reqInfo     = "";                                                        //전송정보
    String pwdFindUrl  = request.getScheme() + "://" + request.getServerName() + "/mobile/member/findPwd2.jsp?type=" + param.get("type");//비밀번호변경URL
    String loginUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/login.jsp?type=" + param.get("type");//로그인
    String randomStr   = "";                                                        //랜덤전송번호
	int numLength = 6;                                                              //랜덤숫자
	
	if (SystemChecker.isReal()) {
        srvNo = "034003";	
	}else{
        srvNo = "032005";
	}
		
    // 암호화 모듈 선언
    com.sci.v2.ipin.secu.SciSecuManager seed  = new com.sci.v2.ipin.secu.SciSecuManager();
        
	//랜던 문자 길이
    java.util.Random ran = new Random();
        

    //0 ~ 9 랜덤 숫자 생성
    for (int i = 0; i < numLength; i++) {
        randomStr += ran.nextInt(10);
    }
    reqNum = curDate + randomStr;   
        
    //작성문자 쿠키처리
	FrontSession fs = FrontSession.getInstance(request, response);
   	SanghafarmUtils.setCookie(response, "reqNum", reqNum, fs.getDomain(), 1800);
        
    // 1차 암호화
    String encStr = "";
    reqInfo = reqNum+"/"+id+"/"+srvNo+"/"+exVar;  // 데이터 암호화
    encStr = seed.getEncPublic(reqInfo);

    // 위변조 검증 값 등록
    String hmacMsg = com.sci.v2.ipin.secu.hmac.SciHmac.HMacEncriptPublic(encStr);

    // 2차 암호화
    reqInfo  = seed.getEncPublic(encStr + "/" + hmacMsg + "/" + "00000000");  //2차암호화
		
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
    
	//휴대전화 본인인증 표시처리
	$(".accreditshow > a").on('click',function(){
		var $this = $(this);
    	var userId = $("#userId").val();
    	
    	if($(".accreditBox").css("display") == "block"){
    		$this.next().toggle();
    		return;
    	}
    	
    	//아이디 존재 확인
		if (userId == '') {
			alert("아이디를 입력해주세요.");
			return;
		}else if(userId.length < 4 || userId.length > 12 ){
			alert("영문/숫자 포함 4~12자리로 아이디를 입력해 주세요.");
			return;		
		}else{
	        if(doubleSubmitCheck()) return;
	        
	        var param = {
	        		userId : userId
	            }
	        
		    $.ajax({
		        type : "POST",
		        url : '/mobile/member/checkIdExist.jsp',
		        data : param,
		        dataType : "json",
		        success : function(data) {
		        	if(data.result == "true") {
		        		$this.next().toggle();
		        		if($("#checkall").prop("checked") == false){
			    			$("#checkall").trigger('click');		        			
			    			$("#lgipbox").hide();
		        		}
		    			pccFlg = true;
		            }else{
		                alert(data.message);
		            }
		        	doubleSubmitFlag = false;
		        }
		    });
		}
	}); 
	
	//second fold
	var joinInOn = $(".join_TTOn").closest(".jointoggleTT");
	var joinWpOn = $(".join_agmOn").closest(".jointoggleTT");
	joinInOn.next().hide();
	joinWpOn.next().hide();
	$(".join_agmOn , .join_TTOn").on('click',function(){
		$(this).closest(".jointoggleTT").toggleClass("onArrjoin");
		$(this).closest(".jointoggleTT").next("div").toggle();
	});	
	//checkbox all
	if ($("#checkall").prop("checked")) {
		$("input[name='chk']").prop("checked", true);
		$(".join_agreementView > .jointoggleTT").find("em").addClass("selected");
	}
	
	$("#checkall").click(function() {
		if ($("#checkall").prop("checked")) {
			$("input[name='chk']").prop("checked", true);
			$(".join_agreementView > .jointoggleTT").find("em").addClass("selected");
		} else {
			$("input[name='chk']").prop("checked", false);
			$(".join_agreementView > .jointoggleTT").find("em").removeClass("selected");
		}
	});
	
	$('input:checkbox[name="chk"]').click(function(){
		var allChkFlg = true;
		 $('input:checkbox[name="chk"]').each(function() {
		     if(this.checked == false){
		    	 $("#checkall").prop("checked", false); //checked 처리
		    	 allChkFlg = false;
		    	 return;
		      }
		 });
		 if(allChkFlg){
    		 $("#checkall").prop("checked", true); //checked 처리		 
		 }
	});
	
	// gender
	$('#gender > a').on('click', function() {
		$('#gender > a').removeClass('active');
		$(this).addClass('active');
		$('#genderVal').val($(this).attr('id'));
	});
    // 알뜰폰 팝업
	$('.phonInfo a').on('click', function(){
		$('.bgLayer, .phonPopLayer').show();
	});	
	$('.close a').on('click', function(){
		$('.bgLayer, .phonPopLayer').hide();
	});	  	
});		
</script>
<script type="text/javascript">

var CBA_window;              //팝업창
var doubleSubmitFlag = false;//이중처리 방지 플레그

//아이핀 인증 
function ipinClick() {
	var userId = $("#userId").val();
	var $window = window;
	if (userId == '') {
		alert("아이디를 입력해주세요.");
		return;
	}else if(userId.length < 4 || userId.length > 12 ){
		alert("영문/숫자 포함 4~12자리로 아이디를 입력해 주세요.");
		return;		
	}else{
        if(doubleSubmitCheck()) return;
        
        var param = {
        		userId : userId
            }
        
	    $.ajax({
	        type : "POST",
	        url : '/mobile/member/checkIdExist.jsp',
	        data : param,
	        dataType : "json",
	        success : function(data) {
	        	if(data.result == "true") {
	                CBA_window = $window.open('', 'IPINWindow', 'width=450, height=500, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=300, top=200' );
	              	if( CBA_window == null) {
	               	  alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
	             	 }
	              	
	              	document.reqCBAV2IpinForm.retUrl.value = "<%=retUrl%>&reqIdIpin=" + $("#userId").val();
	          	    document.reqCBAV2IpinForm.action = 'https://ipin.siren24.com/i-PIN/jsp/ipin_j10.jsp';
	          	    document.reqCBAV2IpinForm.target = 'IPINWindow';
	          	    document.reqCBAV2IpinForm.submit(); 	
	            }else{
	                alert(data.message);
	            }
	        	doubleSubmitFlag = false;
	        }
	    });
	
	}
}    

/***************************************
 * 휴대폰 인증 - 인증번호 요청
 **************************************/
function pccAuth() {

    if (pccValidation()) {

        var certDate = "<%= curDate%>"; 
        var reqNum = "<%=reqNum %>";
        
        if(doubleSubmitCheck()) return;
        
        //필수
        var param = {
            name : $('#name').val(),
            gender : $('#genderVal').val(),
            birth : $('#birth').val(),
            fgnGbn : $('#fgnGbn').val(),
            hpno : $('#hpno').val(),
            hpcorp : $('#hpcorp').val(),
            certDate: certDate,
            reqNum : reqNum
        } 
        
        $.ajax({
            type : "POST",
            url : '/auth/sciPccCheck.jsp',
            dataType : "json",
            data : param,
            success : function(data) {
                alert(data.message);
                if(data.result == "true") {
                    $('.lgipbox').show();
                    $('#send').hide();
                    $('#retry').show();
                    $('#certi').show();
                    $('#reqPccInfo').val(data.certMsg);
                    $('#confirmSeq').val("01");
                }                    
                doubleSubmitFlag = false;
            }
        });
    }
}

/***************************************
 * 휴대폰 인증 - 인증번호 재요청
 **************************************/
function pccRetry() {
	
	if(doubleSubmitCheck()) return;
	
    if($('#confirmSeq').val() >= 3) {
        alert("인증번호 재요청은 2회만 가능합니다.");
        return false;
    }
    
    var param = {
        reqPccInfo : $('#reqPccInfo').val(),
        confirmSeq : $('#confirmSeq').val()
    }

    $.ajax({
        type : "POST",
        url : '/auth/sciPccRetry.jsp',
        data : param,
        dataType : "json",
        success : function(data) {
        	alert(data.message);
        	if(data.result == "true") {
                SetTime = 180;
                alert("인증번호를 발송하였습니다.\n인증번호를 입력해주세요.");
                $('#confirmSeq').val(data.confirmSeq);
                $('#reqPccInfo').val(data.reqInfo);
            }
        	doubleSubmitFlag = false;
        }
    });
}

/***************************************
 * 휴대폰 인증 - 인증번호 확인
 **************************************/
function pccSendAuthNum() {
    var pccNum = $('#reqPccNum').val();
    
    if(doubleSubmitCheck()) return;
  
    if (pccNum != '' && pccNum.length == 6) {
        var param = {
            reqPccInfo : $('#reqPccInfo').val(),
            confirmSeq : $('#confirmSeq').val(),
            screenCd : "findPwd",
            smsnum : pccNum,
            userId : $('#userId').val()
        }
    
        $.ajax({
            type : "POST",
            url : '/auth/sciPccResult.jsp',
            dataType : "json",
            data : param,
            success : function(data) {
            	if(data.result == "true") {
//                     $("#reqId").val($('#userId').val());
                    $("#findPwdForm input[name=reqId]").val($('#userId').val());
                    $("#findPwdForm").submit(); 
                }else{
                	alert(data.message);
                	location.href = "<%=loginUrl%>"
                }
            	doubleSubmitFlag = false;
            }
        });
         
    } else {
        alert("6자리 인증번호를 입력해주세요.");
    }
}

//에러체크 
function pccValidation() {

    // 본인인증 약관 동의
    var check = true;
    $('.join_agreementView').find('input').each(function(){
        if(!$(this).prop('checked')) {
        	check = false;
        }
    });
    
    if(!check) {
        alert("본인인증 약관에 동의해주세요.");
        return false;            
    }

    var birthRegExp = /[12][0-9]{3}[01][0-9][0-3][0-9]/; // YYYYMMDD
    var phoneRegExp = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})([0-9]{3,4})([0-9]{4})$/;

    var name = $("#name").val();

    // 이름
    if (name == '') {
    	alert("이름을 입력해주세요.");
        $("#name").focus();
        return false;
    }

    // 생년월일
    if ($("#birth").val() == '' || !birthRegExp.test($("#birth").val()) ) {
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

    // 성별
    if($('#genderVal').val() == undefined || $('#genderVal').val() == '') {
        alert("남/여 구분을 선택해 주세요.");
        $("#genderVal").focus();
        return false;
    }

    // 휴대폰 번호
    if ($("#hpno").val() == '') {
    	alert("휴대폰번호를 형식에 맞춰 입력해주세요");
        $("#hpno").focus();
        return false;
    } else {
        if (!phoneRegExp.test($("#hpno").val())) {
        	alert("입력정보에 오류가 있습니다.");
            $("#hpno").focus();
            return false;
        }
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

//14세미만 가입제한
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
	<%-- <jsp:include page="/mobile/include/header.jsp" /> --%>
	<!-- 알뜰폰 팝업 -->
	<div class="bgLayer"></div>
	<div class="phonPopLayer">
		<p class="close"><a href="javascript:;"><img src="/mobile/images/btn/btn_close3.png" alt="닫기"></a></p>
		<img src="/mobile/images/member/phonPop.jpg" alt="" />
	</div>	
	<div class="loginHead">
		<img src="/mobile/images/member/head.jpg" alt="" />
	</div> 	
	<div id="container">
	<!-- 내용영역 -->
	<div class="logInTop lgPop">
		<strong>비밀번호 찾기</strong>
<% 
	if(!"web".equals(param.get("type"))){
%>		
		<jsp:include page="/mobile/member/memberClose.jsp" />
<%
	}
%>
	</div>
	<div class="mmwrap joininner">
		<strong class="lg_resting_St">비밀번호 찾기를 위한 안전한 본인인증 단계</strong>
		<p class="lg_resting_P">본인인증 시 제공되는 정보는 해당 인증기관에서<br />직접수집하며 인증 이외의 용도로 이용되지 않습니다.</p>
		
		<form name="input_form">
			<table class="joinForm">
				<caption>비밀번호 찾기를 위한 본인인증에 대한 내용</caption>
				<tbody>
					<tr>
						<td>
							<input type="text" id="userId" value="" style="width:100%" placeholder="*아이디" maxlength="12">
							<p class="warn">영문/숫자 포함 4-12자</p>
						</td>
					</tr>				
				</tbody>
			</table>
		</form>
	
		<div class="accreditlist" style="margin-top:30px;">
			<ul>
				<li class="accreditshow">
					<a class="btnFirst" id="pcc" href="javascript:void(0);">휴대전화 본인인증</a>
					<div class="accreditBox" style="display:block">
						<form name="input_form">
							<div class="joinconfirm">
								<!-- 동의 S -->
								<div class="join_agreement">
									<div class="jointoggleTT onArrjoin">
										<div class="chkBox">
											<label class="chk_style1">
												<em class="selected">
													<input type="checkbox" id="checkall" value="Y">
												</em>
												<span><b>본인인증 약관에 전체 동의합니다.</b></span>
											</label>
										</div>
										<a href="javascript:void(0);" class="join_agmOn"></a>
									</div>
									<div class="join_agreementView">
										<div class="jointoggleTT onArrjoin">
											<div class="chkBox">
												<label class="chk_style1">
													<em class="selected">
														<input type="checkbox" name="chk" id="personalInfo" value="Y">
													</em>
													<span>개인정보 이용동의<b>(필수)</b></span>
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
														<input type="checkbox" name="chk" id="specialNum" value="Y">
													</em>
													<span>고유식별번호 처리 동의<b>(필수)</b></span>
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
														<input type="checkbox" name="chk" id="serviceAgree">
													</em>
													<span>서비스 이용약관 동의<b>(필수)</b></span>
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
														<input type="checkbox" name="chk" id="mobileCorpAgree">
													</em>
													<span>통신사 이용 약관 동의<b>(필수)</b></span>
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
								</div>
							</div>
						</form>
							
						<ul class="lg_wrapIpst">
							<li>
								<div class="jiPHcols">
									<div class="lg_wipbox">
										<label class="lgipbox">
											<input type="text" id="name" name="name" placeholder="이름" maxlength="12">
										</label>
									</div>
									<label class="lgipbox">
										<select id="fgnGbn" name="fgnGbn" style="width: 26%;">
											<option value="1" title="내국인">내국인</option>
											<option value="2" title="외국인">외국인</option>
										</select>
									</label>
								</div>
							</li>
							<li>
								<div class="jiPHcols">
									<div class="lg_wipbox">
										<label class="lgipbox">
											<input type="tel" id="birth" name = "birth" maxlength="8" placeholder="생년월일 (8자리)" onKeyPress="return isNumberPressed(this)">
										</label>
									</div>
									<div class="lg_Abtn" id="gender">
										<a href="javascript:void(0);" id="M">남</a>
										<a href="javascript:void(0);" id="F">여</a>
										<input type="hidden" id="genderVal" name ="genderVal">
									</div>
								</div>
							</li>
							<li>
								<div class="jiPhone">
									<label class="lgipbox">
									<select id="hpcorp" name="cellCorp">
										<option value="SKT">SKT</option>
										<option value="KTF">KT</option>
										<option value="LGT">LGU+</option>
										<option value="SKM">SK 알뜰폰</option>
								        <option value="KTM">KT 알뜰폰</option>
								        <option value="LGM">LG 알뜰폰</option>
									</select>
									</label>
									<label class="lgipbox">
										<input type="tel" id="hpno" maxlength="11" placeholder="-없이 입력하세요." onKeyPress="return isNumberPressed(this)">
									</label>
									<a href="javascript:void(0);" id="send" onclick="pccAuth();">인증요청</a>
									<a href="javascript:void(0);" id="retry" onclick="pccRetry();" style="display: none;">재전송</a>
								</div>
							</li>
							<li id="certi" hidden="hidden">
								<div class="jiPhoneC">
									<div class="lg_wipbox">
										<label class="lgipbox">
											<input type="tel" maxlength="6" id="reqPccNum" onKeyPress="return isNumberPressed(this)">
										</label>
									</div>
									<a href="javascript:void(0);" onclick="pccSendAuthNum();">인증하기</a>
								</div>
							</li>
						</ul>
						<p class="phonInfo">알뜰폰 사업자 확인<a href="#"><img src="/mobile/images/member/ico_checkup.png" alt="" /></a></p>
					</div>					
				</li>
				<!-- <li><a class="btnFirst" id="ipin" href="javascript:void(0);" onclick="ipinClick();">아이핀 인증</a></li> -->
			</ul>
		</div>
	</div>
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
    <form name="mobileForm" method="post">
        <input type="hidden" name="reqPccInfo" id="reqPccInfo" value="">
        <input type="hidden" name="confirmSeq" id="confirmSeq" value="">
        <input type="hidden" name="reqId" id="reqId" value="">
    </form>
    
    <form name="findPwdForm" id="findPwdForm" method="post" action="<%=pwdFindUrl%>">
        <input type="hidden" name="reqId" id="reqId" value="">
    </form>
    
    <form name="reqCBAV2IpinForm" method="post" action="https://ipin.siren24.com/i-PIN/jsp/ipin_j10.jsp">
        <input type="hidden" name="reqInfo" value="<%=reqInfo %>" />
        <input type="hidden" name="retUrl" value="<%=retUrl %>" />
    </form>
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
</html>
