//앞뒤 공백을 자른다..
String.prototype.trim = function() {
    var format = /^\s*/g;
    var str = this;
    str = str.replace(format, "");
    format = /\s*$/g;
    str = str.replace(format, "");

    return str;
};

//Id 유효성 체크
String.prototype.isid = function(){
	if(this.search(/[^A-Za-z0-9_-]/) == -1){
		return true;
	}else{
		return false;
	}
};

// 문자열이 이메일 형식인지 판별한다.
String.prototype.isEmail = function() {
    var format = /^((\w|[\-\.])+)@((\w|[\-\.])+)\.([A-Za-z]+)$/;
    return (this.search(format) > -1);
};

String.prototype.isNumeric = function() {
    var format = /^[0-9]+$/;
    return (this.search(format) > -1);
};

// 문자열의 바이트를 리턴한다.
String.prototype.getBytes = function() {
	var temp;
	var mycount = 0;

	for(var k = 0 ; k < this.length ; k++ ){
		temp = this.charAt(k);

		if( escape(temp).length > 4 ) {
			mycount += 2;
		}
		else mycount++;
	}

	return mycount;
};

//숫자를 money포맷으로 3자리씩 끊어 표현한다.
String.prototype.formatMoney = function() {
	if (!this.isNumeric()) return "0";
	return parseInt(this).toLocaleString('ko');
	
	/*
	var start = 0;
	var distance =  parseInt(this.length % 3);
	var nComma =  parseInt(this.length / 3);

	if (distance == 0){
		distance = 3;
		nComma -= 1;
	}

	var arr = new Array();
	for (var i=0; i<nComma + 1; i++) {
		arr[i] = this.substring(start, start + distance);	

		start += distance;
		distance = 3;
	}

	var sReturn = "";
	var isFirst = true;
	for (var i=0; i<arr.length; i++) {
		sReturn += (isFirst ? "" : ",") + arr[i];
		isFirst = false;
	}

	return sReturn;
	*/
};

//숫자를 money포맷으로 3자리씩 끊어 표현한다.
Number.prototype.formatMoney = function() {
//	return this.toString().formatMoney();
	return this.toLocaleString('ko');
};

String.prototype.isSSN = function() {
    var sum = 0 ;
    sum = this.charAt(0) * 2 + this.charAt(1) * 3 + this.charAt(2) * 4 + this.charAt(3) * 5 +
          this.charAt(4) * 6 + this.charAt(5) * 7 + this.charAt(6) * 8 + this.charAt(7) * 9 +
          this.charAt(8) * 2 + this.charAt(9) * 3 + this.charAt(10) * 4 + this.charAt(11) * 5;

    if (sum == "0") return false;
    else {
        sum = 11 - sum % 11 ;
        if (sum > 9) sum = sum - 10;

        if (sum == this.charAt(12)) return true;
        else return false;
    }
};

//yyyymmdd 검사
String.prototype.isDate = function() {
	if (this.length != 8) return false;

	var y = parseInt(this.substr(0, 2), 10);
	var m = parseInt(this.substr(4, 2), 10);
	var d = parseInt(this.substr(6, 2), 10);

	var limit_day;
	switch (m) {
		case 1: 
		case 3: 
		case 5: 
		case 7: 
		case 8: 
		case 10: 
		case 12: 
			limit_day = 31; 
			break;
		case 2:
			if ((y - 2008) % 4 == 0) limit_day = 29;
			else limit_day = 28;
			break;
		case 4: 
		case 6: 
		case 9: 
		case 11: 
			limit_day = 30; 
			break;
		default: 
			return false;
	}

	if (d > limit_day) return false;
	if (d < 1) return false;
	
	return true;
};

String.prototype.replaceAll = function (searchStr, replaceStr) {
    return this.split(searchStr).join(replaceStr);
}

String.prototype.replaceAll = function (searchStr, replaceStr) {
    return this.split(searchStr).join(replaceStr);
};


String.prototype.isNotEmpty = function() {
	obj = String(this);
	if(obj == null || obj == undefined || obj == 'null' || obj == 'undefined' || obj == '' ) return false;
	else return true;
};

String.prototype.isEmpty = function() {
	return this.isNotEmpty();
};

String.prototype.validateCardNum = function() {
	if(typeof this == 'undefined' || this.isEmpty()){
		return false;
	} else {
		var cardnum = this.replace(/[ -]/g,'');
        var match = /^(?:(94[0-9]{14})|(4[0-9]{12}(?:[0-9]{3})?)|(5[1-5][0-9]{14})|(6(?:011|5[0-9]{2})[0-9]{12})|(3[47][0-9]{13})|(3(?:0[0-5]|[68][0-9])[0-9]{11})|((?:2131|1800|35[0-9]{3})[0-9]{11}))$/.exec(cardnum);

       	return match;
	}
};

//input field에 숫자만 넣어야 할경우에  onKeyPress이벤트에서 호출한다..
//사용예 : <input type=text name="aField" onKeyPress="return isNumberPressed()">
function isNumberPressed() {
 return !(event.keyCode < 48 || event.keyCode > 57);
}

// null과 빈문자열을 디폴트 처리
function nevl(str, sDefault) {
	if (str == null || str == undefined || str.trim() == "") {
		return sDefault;
	}
	else {
		return str;
	}
}

/* Korean initialisation for the jQuery calendar extension. */
if ($.datepicker != null) {
	jQuery(function($){
		$.datepicker.regional['ko'] = {
			closeText: '닫기',
			prevText: '이전달',
			nextText: '다음달',
			currentText: '오늘',
			monthNames: ['1월(JAN)','2월(FEB)','3월(MAR)','4월(APR)','5월(MAY)','6월(JUN)',
			'7월(JUL)','8월(AUG)','9월(SEP)','10월(OCT)','11월(NOV)','12월(DEC)'],
			monthNamesShort: ['1월(JAN)','2월(FEB)','3월(MAR)','4월(APR)','5월(MAY)','6월(JUN)',
			'7월(JUL)','8월(AUG)','9월(SEP)','10월(OCT)','11월(NOV)','12월(DEC)'],
			dayNames: ['일','월','화','수','목','금','토'],
			dayNamesShort: ['일','월','화','수','목','금','토'],
			dayNamesMin: ['일','월','화','수','목','금','토'],
			weekHeader: 'Wk',
			dateFormat: 'yy.mm.dd',
			firstDay: 0,
			isRTL: false,
			showMonthAfterYear: true,
			yearSuffix: '년'};
		$.datepicker.setDefaults($.datepicker.regional['ko']);
		$.datepicker.setDefaults({
			showOn: "button",
			buttonImage: "/sanghafarmShop/images/btn/btn_calendar.gif",
			buttonImageOnly: true,
			buttonText: ""
		});
	});	
}
/**
*	14세 미만 체크
*	Y :  14세 이상, N : 14세 미만, I : 생년월일 날짜 오류(없는날짜)
*/
function isMoreThan14age(strBirtyDay)
{
     var u_year;
     var u_month;
     var u_day;
     var v_age;
     var v_today = new Date();
     
     u_year = strBirtyDay.substring(0, 4)
     u_month = strBirtyDay.substring(4, 6);
     u_day = strBirtyDay.substring(6);
     var rVal = isValidDate(u_year, u_month, u_day );

     if( rVal == 'N' ) return 'I';
     else if( rVal == 'Y' ){
         v_age = v_today.getFullYear()*1 - u_year*1;
         if( u_month*1 > (v_today.getMonth*1+1) ){
             v_age -= 1; 
         }     
         else if( u_month*1 == (v_today.getMonth()*1+1) && u_day*1 > v_today.getDate()*1 ){
             v_age -= 1;
         }
     }
     if( v_age < 14 ) return 'N';
     else return 'Y';
}
/**
 * 비밀번호 유효성 검사
 */
function chkValidPasswd(passwd){
	if(passwd.length < 6){
		alert("비밀번호는 최소 6자 이상입니다.");
		return false;
	}

	//생성 항목 포함 갯수
	//2개 항목이상 10자리 이상
	//3개 항목이상 8자리 이상
	var validCount = 0;		
	
	//대문자 포함 여부
	if(passwd.search(/[a-z]+/) > -1){
		validCount	+=	1;
	}
	
	//소문자 포함 여부
	if(passwd.search(/[A-Z]+/) > -1){
		validCount	+=	1;
	}
	
	//숫자 포함 여부
	if(passwd.search(/[0-9]+/) > -1){
		validCount	+=	1;
	}
	
	//특수문자 포함 여부
	if(passwd.search(/[~!@\#$%<>^&*\()\-=+_\']/) > -1 ){
		validCount	+=	1;
	}
	
	if(validCount <= 1){
		alert("비밀번호는 대문자, 소문자, 숫자, 특수문자들중 최소한 2가지 항목이 포함되어야합니다.");
		return false;
	}else if(validCount == 2){
		if(passwd.length < 6){
			alert("비밀번호는 대문자, 소문자, 숫자, 특수문자들중 2가지 항목이 포함된경우 최소 6자이상 등록해주세요.");
			return false;
		} 
	}else if(validCount >= 3){
		if(passwd.length < 6){
			alert("비밀번호는 대문자, 소문자, 숫자, 특수문자들중 3가지 항목이상 포함된경우 최소 6자이상 등록해주세요.");
			return false;
		} 
	}
	
	var chr_pass_0;
	var chr_pass_1;
	var SamePass_0 = 0; //동일문자 카운트
	var SamePass_1 = 0; //연속성(+) 카운드
	var SamePass_2 = 0; //연속성(-) 카운드

	for(var i = 0;i < passwd.length;i++){
		chr_pass_0 = passwd.charAt(i);
		chr_pass_1 = passwd.charAt(i+1);
		chr_pass_2 = passwd.charAt(i+2);

		//동일문자 카운트
		if(chr_pass_0 == chr_pass_1){
			SamePass_0 = SamePass_0 + 1
		} 

		//연속성(+) 카운드
		if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1){
			SamePass_1 = SamePass_1 + 1
		} 

		//연속성(-) 카운드
		if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1){
			SamePass_2 = SamePass_2 + 1
		} 
	} //for

	if(SamePass_0 > 3){
		alert("동일문자를 3번 이상 사용할 수 없습니다.");
		return false;
	} 

	if(SamePass_1 > 0 || SamePass_2 > 0 ){
		alert("연속된 문자열(123 또는 321, abc, cba 등)을\n 3자 이상 사용 할 수 없습니다.");
		return false;
	} 

	return true;
}

function ajaxSubmit(form, callback) {
	var isJQueryObject = form instanceof jQuery;
	var jForm = (isJQueryObject ? form : $(form));

	var formData = jForm.serialize();

	/*action 페이지에서는 결과 json을 출력해야 한다. 예 {"isOk" : true, "msg" : "등록되었습니다."}*/
	$.ajax({
		type : "POST",
		url : jForm.attr("action"),
		data : formData,
		dataType : "json",
		success : function(result) {
			callback(result);
		},
		fail : function() {
			callback({isOk : false, msg : "서버오류가 발생했습니다."});
		}
	});
}

/*구글 크롬의로 디버깅시, 타부라우저의 console 객체 스킵*/
if (!window.console) console = {};
console.log = console.log || function(){};
console.warn = console.warn || function(){};
console.error = console.error || function(){};
console.info = console.info || function(){};

function RepString(source,be_word,af_word){
	var slen = source.length;
	var wlen = be_word.length;

	if ( source.length == 0) {
		return source;
	}
	if ( be_word.length == 0 ) {
		return source;
	}

	var after_source='';

	for (var i=0; i < slen;i++){
		var tmp =source.substring(i,i+wlen);
		var tmp_2 = source.substring(i,i+1);
		if ( tmp == be_word ) {
			after_source = after_source + af_word;
			i = (i+wlen)-1;
		}
		else {
			after_source = after_source +tmp_2;
		}
   }
   return after_source;
}

function isRelationalCategory(apath, bpath) {
	if (apath > bpath) {
		isRelational = (parseInt(apath.indexOf(bpath)) >= 0);
	}
	else {
		isRelational = (parseInt(bpath.indexOf(apath)) >= 0);
	}
	
	return isRelational;
}

function checkTFSDPType(obj, type, fn_yn){
	if(fn_yn == "Y"){
		if(type == "1"){
			$("input[name='mall_yn']").attr("checked", false);
			$("input[name='staff_yn']").attr("checked", false);
			/*if($("input[name='mall_yn']").is(":checked") || $("input[name='staff_yn']").is(":checked")){
				alert("전시구분은 하나만 선택가능합니다.");
				$(obj).attr("checked", false);
				return;
			}*/					
		}else if(type == "2"){
			$("input[name='brand_yn']").attr("checked", false);
			$("input[name='staff_yn']").attr("checked", false);		
			/*if($("input[name='brand_yn']").is(":checked") || $("input[name='staff_yn']").is(":checked")){
				alert("전시구분은 하나만 선택가능합니다.");
				$(obj).attr("checked", false);
				return;
			}*/
		}else if(type == "3"){
			$("input[name='brand_yn']").attr("checked", false);
			$("input[name='mall_yn']").attr("checked", false);		
			/*if($("input[name='brand_yn']").is(":checked") || $("input[name='mall_yn']").is(":checked")){
				alert("전시구분은 하나만 선택가능합니다.");
				$(obj).attr("checked", false);
				return;
			}*/
		}
	}else{
		if(type == "1"){
			$("input[name='mall_yn']").attr("checked", false);
			$("input[name='staff_yn']").attr("checked", false);
		}else if(type == "2"){
			$("input[name='brand_yn']").attr("checked", false);
			$("input[name='staff_yn']").attr("checked", false);		
		}else if(type == "3"){
			$("input[name='brand_yn']").attr("checked", false);
			$("input[name='mall_yn']").attr("checked", false);		
		}		
	}	
	
}

function getAnswerList(page, pageSize, qSeq, boardCd){
	var params = {
			page : page,
			pageSize : pageSize,
			question_seq : qSeq,
			board_cd : boardCd
	}
	
	$.post("/common/answer/list.jsp", params, function(returnData){
		if(returnData != ""){
			$("#AnswerList").html(returnData);
		}
	});
}

function disableScreen() {
	$("body").append("<div class='bgLayer'><img src='/images/loading.gif'></div>");
	$(".bgLayer").css("height", $(document).height() + "px").show();	
	$(".bgLayer img").css("top", (parseInt($(window).height()/2) + parseInt($(window).scrollTop()) - 50) + "px");
	$(".bgLayer img").css("left", (parseInt($(window).width()/2) + parseInt($(window).scrollLeft()) - 50) + "px");
}

function enableScreen() {
	$(".bgLayer").remove();
}

function confirmLogin() {
	if(confirm("로그인이 필요합니다.\n로그인 하시겠습니까?")) {
		fnt_login();
	}
} 

function onlyNumber(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 || keyID == 9 ) 
		return;
	else
		return false;
}

function removeChar(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		event.target.value = event.target.value.replace(/[^0-9]/g, "");
}

function setCookie( name, value, expiredays){
	var todayDate = new Date();
    todayDate.setDate( todayDate.getDate() + expiredays );
    if(expiredays != null){
    	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";";
    } else {
    	document.cookie = name + "=" + escape( value ) + "; path=/; ";
    }
    
}

function getCookie(name)
{
	var nameOfCookie = name + "=";
	var x = 0;
	while (x <= document.cookie.length)
	{
		var y = (x+nameOfCookie.length);
		if (document.cookie.substring(x, y) == nameOfCookie) {
			if ((endOfCookie=document.cookie.indexOf( ";", y )) == -1) endOfCookie = document.cookie.length;
			return unescape(document.cookie.substring(y, endOfCookie ));
		}
		x = document.cookie.indexOf(" ", x) + 1;
		if (x == 0) break;
	}
	return "";
}
