<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="com.efusioni.stone.common.SystemChecker"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import ="java.util.*,java.text.SimpleDateFormat"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%
	String referer = request.getHeader("Referer");
	System.out.println("referer ---------------------- " + referer);

		request.setAttribute("Depth_1", new Integer(2));
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma", "no-store");
        response.setHeader("Cache-Control", "no-cache");
        Param param = new Param(request);
        
        String reJoin      = Utils.safeHTML(param.get("reJoin", "N"));
        String id          = "MIU002";													//회원사 ID
        String reqNum      = "";														//요청번호
        String retUrl      = "23" + request.getScheme() + "://" + request.getServerName() + "/auth/sciIpinPopup.jsp?screenCd=";
        String srvNo       = "";											   		    //서비스번호	
		if (SystemChecker.isReal()) {
	        srvNo = "034001";	
		}else{
	        srvNo = "032003";
		}
        if(reJoin.equals("Y")){
        	retUrl = retUrl + "reJoin&reJoinFlg=Y";//결과 수신 URL
        }else{
        	retUrl = retUrl + "join&reJoinFlg=N";//결과 수신 URL
        }
    	String exVar       = "0000000000000000";                                        // 복호화용 임시필드
		String curDate = Utils.getTimeStampString("yyyyMMddHHmmss");
    	String reqInfo = "";
    	String joinUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/joinStep3.jsp";
		int numLength = 6;
    	
		String reJoinUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/memRejoin.jsp";//결과 수신 URL
		String reJoinOKUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/memRejoin2.jsp";//결과 수신 URL
		String loginUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/login.jsp?type=" + param.get("type");//결과 수신 URL
		
        // 암호화 모듈 선언
        com.sci.v2.ipin.secu.SciSecuManager seed  = new com.sci.v2.ipin.secu.SciSecuManager();
        
		//랜던 문자 길이
        java.util.Random ran = new Random();
        
        String randomStr = "";

        for (int i = 0; i < numLength; i++) {
            //0 ~ 9 랜덤 숫자 생성
            randomStr += ran.nextInt(10);
        }
        reqNum = curDate + randomStr;   
        
        //작성문자 쿠키처리
    	FrontSession fs = FrontSession.getInstance(request, response);
       	SanghafarmUtils.setCookie(response, "reqNum", reqNum, fs.getDomain(), 1800);	
        
    	// 1차 암호화
    	String encStr = "";
    	reqInfo      = reqNum+"/"+id+"/"+srvNo+"/"+exVar;  // 데이터 암호화

    	encStr              = seed.getEncPublic(reqInfo);

    	// 위변조 검증 값 등록
    	String hmacMsg = com.sci.v2.ipin.secu.hmac.SciHmac.HMacEncriptPublic(encStr);

    	// 2차 암호화
    	reqInfo  = seed.getEncPublic(encStr + "/" + hmacMsg + "/" + "00000000");  //2차암호화
    	
		if(request.getQueryString() != null || !request.getMethod().startsWith("GET") ) {
// 			response.sendRedirect(loginUrl);
		}
		
%>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="imagetoolbar" content="no">
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no">
        <meta name="title" content="">
        <meta name="publisher" content="">
        <meta name="author" content="">
        <meta name="robots" content="index,follow">
        <meta name="keywords" content="">
        <meta name="description" content="">
        <meta name="twitter:card" content="summary_large_image">
        <meta property="og:title" content="">
        <meta property="og:site_name" content="">
        <meta property="og:author" content="">
        <meta property="og:type" content="">
        <meta property="og:description" content="">
        <meta property="og:url" content="">
        <title>상하목장</title>
        <!--[if lte IE 8]>
        <script src="http://carvecat.com/js/html5.js"></script>
        <![endif]-->

        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/new_common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script src="./js/sub.js"></script>
        
        <link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
        
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script>
// gender
$('#gender > a').on('click', function() {
	$('#gender > a').removeClass('active');
	$(this).addClass('active');
	$('#genderVal').val($(this).attr('id'));
});

</script>
<script type="text/javascript">

    var CBA_window;
    var height_pop = 550;
    var timeId;
    var SetTime = 180; // 최초 설정 시간(기본 : 초)
    var doubleSubmitFlag = false;

    //아이핀 인증 
    function ipinClick() {
        CBA_window = window.open('', 'IPINWindow', 'width=450, height=500, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=300, top=200' );
          if( CBA_window == null) {
             alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
          } 
        
        document.reqCBAV2IpinForm.action = 'https://ipin.siren24.com/i-PIN/jsp/ipin_j10.jsp';
        document.reqCBAV2IpinForm.target = 'IPINWindow';
        document.reqCBAV2IpinForm.submit(); 
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
                        //TimerStart();
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
                screenCd : "join",
                smsnum : pccNum,
                reJoinFlg : "<%=reJoin %>"
            }
        
            $.ajax({
                type : "POST",
                url : '/auth/sciPccResult.jsp',
                dataType : "json",
                data : param,
                success : function(data) {
                	if(data.result == "true") {
                    	alert(data.message);
                        $("#dupInfo").val(data.di);
                        $("#connInfoVer").val(data.ciVer);
                        $("#connInfo").val(data.ci);
                        $("#birth").val(data.birth);
                        $("#input_form").submit(); 
                    }else if(data.result == "reJoin"){
                    	location.href = "<%=reJoinUrl%>"
                    }else if(data.result == "reJoinComplete"){
                    	location.href = "<%=reJoinOKUrl%>"
                    }else if(data.result == "falseJoin"){
                    	alert(data.message);
                    	location.href = "<%=loginUrl%>"
                    }else{
                    	alert(data.message);
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
    
    function errorMsg(cd) {
        var msg = ""
        
        return msg;
    }
    
    function msg_time() { // 1초씩 카운트
        var s = SetTime % 60;
        if(s < 10){
            s = "0"+s;
        }
         // 남은 시간 계산
        var m = Math.floor(SetTime / 60) + ":" + s; 
        $('#countdown').text(m); // div 영역에 보여줌
        $('#countdown').css('color','red');
        SetTime--; // 1초씩 감소
        if (SetTime <= 0) { // 시간이 종료 되었으면..
            alert("인증에 실패하였습니다.\n재인증 해주십시요.");
            clearInterval(timeId); // 타이머 해제
            location.reload();
        }
    }
    
    function TimerStart() {
        if(SetTime > -1) {
            timeId = setInterval('msg_time()', 1000);
        }
    };
    
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
    
    function setCheck(obj) {
    	if($(obj).prop('checked')) {
    		$(".accreditlist").show();
    	} else {
    		$(".accreditlist").hide();
    	}
    }
</script>
        
    </head>
    <body>
        <div class="header_g">
            <div class="header_wrap">
                <a href="" class="gnb_logo"><span class="g_alt">상하농원</span></a>
                <div class="gnb_menu">
                    <a href="">고창상하농원</a>
                    <a href="">짓다</a>
                    <a href="">놀다</a>
                    <a href="">먹다</a>
                    <button class="btn_allmenu">전체메뉴</button>
                </div>
            </div>
        </div>
        <div class="body_wrap">
            <div class="content_wrap">
                <div class="step_title">회원가입</div>
                <div class="step_wrap">
                    <div class="step_item act pre">
                        <p>01</p>
                        <b>약관동의</b>
                    </div>
                    <div class="step_item act">
                        <p>02</p>
                        <b>정보입력</b>
                    </div>
                    <div class="step_item">
                        <p>03</p>
                        <b>완료</b>
                    </div>
                </div>
                <form action="">
                    <section class="page_section">
                        <div class="section_title on">
                            휴대폰 번호를 입력해주세요
                        </div>
                        <div class="section_content">
                         <div class="conLine">
                                <p class="conLine_title">이름</p>
                                <input type="text"  id="name" name="name" placeholder="이름" maxlength="45" class="input_g input_medium">
                            </div>
                            <label class="conLine">
										<select id="fgnGbn" name="fgnGbn" style="width: 26%;">
											<option value="1" title="내국인">내국인</option>
											<option value="2" title="외국인">외국인</option>
										</select>
									</label>
                             <div class="conLine">
                                <p class="conLine_title">생일</p>
                                <input type="text" id="birth" name = "birth" maxlength="8" placeholder="19880227형식의 8자리 숫자로 입력" onKeyPress="return isNumberPressed(this)" class="input_g input_medium">                                
                            </div>
                              <div class="conLine" id="gender">
                              <p class="conLine_title">성별</p>
										<a href="javascript:void(0);" id="M">남</a>
										<a href="javascript:void(0);" id="F">여</a>
									<input type="hidden" id="genderVal" name ="genderVal">
								</div>
                            <div class="conLine">
                                <p class="conLine_title">휴대폰 번호</p>
                                <select id="hpcorp" name="cellCorp">
										<option value="SKT">SKT</option>
										<option value="KTF">KT</option>
										<option value="LGT">LGU+</option>
										<option value="SKM">SK 알뜰폰</option>
								        <option value="KTM">KT 알뜰폰</option>
								        <option value="LGM">LG 알뜰폰</option>
								</select>
                                <input type="tel" id="hpno" name="hpno" maxlength="11" placeholder="-없이 입력하세요." onKeyPress="return isNumberPressed(this)" class="input_g input_medium">
                                	<a href="javascript:void(0);" id="send" onclick="pccAuth();">인증요청</a>
									<a href="javascript:void(0);" id="retry" onclick="pccRetry();" style="display: none;">재전송</a>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title">인증 번호</p>
                                <input type="text" maxlength="6" id="reqPccNum" onKeyPress="return isNumberPressed(this)" class="input_g input_large input_check check_on">
                                <a href="javascript:void(0);" onclick="pccSendAuthNum();">인증하기</a>
                            </div>
                        </div>
                        <div class="divLine mt40"></div>

                        <div class="section_title on">
                            아이디와 비밀번호를 입력해주세요
                        </div>
                        <div class="section_content">
                            <div class="conLine">
                                <p class="conLine_title">아이디</p>
                                <input type="text" placeholder="영문(소문자), 숫자로 4~16자 이내" class="input_g input_large input_check check_error">
                                <span class="checkMsg">아이디는 영문(소문자), 숫자로 4~16자 이내로 입력해주세요.</span>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title">비밀번호</p>
                                <input type="text" placeholde="영문, 숫자, 특수문자 포함 8자 이상" class="input_g input_large input_check check_on">
                                <span class="checkMsg">사용할 수 있는 비밀번호 입니다.</span>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title">비밀번호 확인</p>
                                <input type="text" placeholder="비밀번호 재입력" class="input_g input_large input_check check_error">
                                <span class="checkMsg">비밀번호가 일치하지 않습니다.</span>
                            </div>
                        </div>
                        <div class="divLine mt40"></div>

                        <div class="section_title on">
                            이메일 주소와 생년월일을 입력해주세요.
                        </div>
                        <div class="section_content">
                            <div class="conLine">
                                <p class="conLine_title required"><span>*</span>이메일주소</p>
                                <input type="text" placeholder="이메일 주소" class="input_g input_medium mr10">
                                <span class="conLine_content">@</span>
                                <input type="text" class="input_g input_medium ml10">
                                <select name="" id="" class="select_g select_medium ml10">
                                    <option value="">직접입력</option>
                                </select>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required"><span>*</span>생년월일</p>
                                <input type="text" placeholder="YYYY-MM-DD" class="input_g input_large">
                            </div>
                        </div>
                        <div class="divLine mt40"></div>
                    </section>
                    <div class="btn_area mt40">
                        <button class="btn_submit btn_disabled">다음</button>
                    </div>
                </form>
            </div>
        </div>
        <div class="footer_g">
            <div class="footer_wrap flex_wrap">
                <p class="fotter_logo"><img src="./image/footer_logo.png" alt=""></p>
                <div class="footer_info">
                    <div class="info_link">
                        <a href="">입점/제휴문의</a>
                        <a href="">이용약관</a>
                        <a href="">개인정보취급방침</a>
                        <a href="">고객센터</a>
                        <a href="">윤리 HOT-LINE</a>
                    </div>
                    <div class="info_company">
                        <div>전라북도 고창군 상하면 상하농원길 11-23  |  대표 : 최승우  |  개인정보 보호 책임자 : 최승우  |  사업자등록번호 : 415-86-00211</div>
                        <div>통신판매업신고번호 : 제2016-4780085-30-2-00015호  |  상담이용시간 : 09:30~18:00  |  농원운영시간 : 연중무휴 09:30~21:00</div>
                    </div>
                    <div class="info_extra">
                        <p>상하농원(유)은 매일유업(주)과의 제휴를 통해 공동으로 서비스를 운영하고 있습니다.</p>
                        <p>@ 2021 SANGHA FARM CO. ALL RIGHTS RESERVED</p>
                    </div>
                </div>
                <div class="footer_btn flex_wrap">
                    <div class="btn_wrap flex_wrap">
                        <p>상하농원 <br>앱 다운로드</p>
                        <div>
                            <p class="btn_and">안드로이드</p>
                            <p class="btn_ios">iOS</p>
                        </div>
                    </div>
                    <div class="footer_contact">
                        <div class="contact_cs"><b>고객센터</b><span>1522-3698</span></div>
                        <div class="contact_res"><b>빌리지예약</b><span>063-563-6611</span></div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            $(".section_title").click(function() {
                $(this).next(".section_content").stop().slideToggle(300);
                $(this).toggleClass('on').siblings().removeClass('on');
                $(this).next(".section_content").siblings(".section_content").slideUp(300); // 1개씩 펼치기
            });
           
        </script>
    </body>
</html>