<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.hotel.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(6));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("Weekly특가"));
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
	HotelOfferService svc = new HotelOfferService();
	
	Param info = svc.getInfo(param.get("pid"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
//달력 체크
var startIdx;
var endIdx;
var $startMonth, $endMonth, startMonthIdx, endMonthIdx; 
var D_date, D_this, autoEndDate = false, isStart = false, isEnd = false
var visibleEnd = true

$(function(){	
	var d = new Date();
	var year = d.getFullYear();
	var month = d.getMonth() + 1;
	getCalendar(year, month);
});

function getCalendar(year, month) {
	console.log(year, month);
	$.ajax({
		type: "POST",
		url : "calendar.jsp",
		data : { pid: '<%= param.get("pid") %>', year : year, month : month },
		cache: false,
		dataType : "html"
	})
	.done(function(html) {
		$("#calendar").empty().html(html);

		$(".monthArea .day li a").off("click")
		$(".monthArea .day li a").on("click", function(i){	
			D_date = $(".monthArea .day li");
			D_this = $(this).parent();
			console.log(isStart)
			if(!isStart){
				if(!D_this.hasClass("disable")){
					setStartDate()
				} else {
					console.log('시작날짜가 disable')
					reset()
				}
			} else {
				if(autoEndDate){
					checkEndDate('manual')
				} else {
					checkEndDate('auto')
				}
			}
			return false
		})	
		
		$(".btnCalendar").show();
		//parent.$(".popReserLayer .layer, .popReserLayer .layer iframe").height($(document).height());
		//$(".offerReserLayer").height($(document).height())
		parent.$(".popReserLayer").css("opacity", "1");
	});
}

function setStartDate(){
	if(!D_date.hasClass("end")){
		console.log('시작날짜')
		isStart = true
		$startMonth = D_this.parents(".monthArea");
		startMonthIdx = $startMonth.index();
		startIdx = D_this.index();
		D_this.addClass("start");
		var y = D_this.attr("today").substring(0,4)
		var m = D_this.attr("today").substring(4,6)
		var d = D_this.attr("today").substring(6,8)
		var nextY = D_this.attr("next").substring(0,4)
		var nextM = D_this.attr("next").substring(4,6)
		var nextD = D_this.attr("next").substring(6,8)

		$("#chki_date").val(y + "." + m + "." + d);
		$('.checkIn').text($("#chki_date").val());
		$('.checkOut').text("");
		$('.dateNam').text("").hide();
		$("#chot_date").val("");
		if(!D_this.next("li").is(":visible")){
			if($startMonth.next(".monthArea").is(":visible")){
				$startMonth.next(".monthArea").find(".day li:not(.empty)").each(function(i){
					if(i==0){
						console.log('다음날 자동 선택(다음달)')
						$(this).find("a").trigger("click");//끝나는날짜 +1일 자동선택
					}
				})
			} else {
				console.log('다음달없음')
				$("#chot_date").val(nextY + "." + nextM + "." + nextD);
				$('.checkOut').text($("#chot_date").val());
			}
		} else {
			console.log('다음날 자동 선택(같은달)')
			D_this.next("li").find("a").trigger("click");//끝나는날짜 +1일 자동선택
		}
	} else {
		console.log('수동이후엔 재시작')
		reStart(D_this)
	}
}

function setEndDate(opt){
	if(isEnd){
		//console.log('수동이후엔 재시작')
		//reStart(D_this)
	} else {
		D_this.addClass("end");
		/* var y = D_this.parents(".monthArea").find("h2 .year").text();
		var m = D_this.parents(".monthArea").find("h2 .monthNum").text();
		var d = parseInt(D_this.find("a").text()) < 10 ? "0" + D_this.find("a").text() : D_this.find("a").text(); */

		var y = D_this.attr("today").substring(0,4)
		var m = D_this.attr("today").substring(4,6)
		var d = D_this.attr("today").substring(6,8)
		
		$("#chot_date").val(y + "." + m + "." + d);
		$('.checkOut').text($("#chot_date").val());
		$('.dateNam').text("(" + dateDiff($('#chki_date').val(), $('#chot_date').val()) + "박)").show();

		if(startMonthIdx == endMonthIdx) {
			$(".monthArea").eq(startMonthIdx).find(".day li").each(function(j){
				if(startIdx < j && endIdx > j){
					$(this).removeClass("end").addClass("on")
				}
			});
		} else {
			$(".monthArea").each(function(i){
				if(i == startMonthIdx){
					$(".monthArea").eq(startMonthIdx).find(".day li").each(function(j){
						if(startIdx < j){
							$(this).removeClass("end").addClass("on")
						}
					});		
				}
				if(i == endMonthIdx){
					$(".monthArea").eq(endMonthIdx).find(".day li").each(function(j){
						if(endIdx > j && !$(this).hasClass("empty")){
							$(this).removeClass("end").addClass("on")
						}
					});	
				}
				if(i > startMonthIdx && i < endMonthIdx) {
					$(this).find(".day li").not(".empty").addClass("on");
				}
			});			
		}
	}
	if(opt == 'manual'){ //수동
		autoEndDate = false
		isEnd = true
		isStart = false
		console.log('수동 setEndDate')
	} else { //자동
		autoEndDate = true
		isEnd = false
		console.log('자동 setEndDate')
	}		
	
	$('.date').show();
	getPriceInfo();
}

function checkEndDate(opt){
	$endMonth = D_this.parents(".monthArea");
	endMonthIdx = $endMonth.index();
	endIdx = D_this.index();
	if(startMonthIdx < endMonthIdx || (startMonthIdx == endMonthIdx && startIdx <  endIdx )){
		if(startMonthIdx < endMonthIdx){
			$startMonth.find(".day li").each(function(i){
				if(startIdx <= i){
					if($(this).before().hasClass('disable')){
						visibleEnd = false
						return false
					} else {
						$endMonth.find(".day li").each(function(i){
							if(endIdx > i){
								if($(this).before().hasClass('disable')){
									visibleEnd = false
									return false
								} else {
									visibleEnd = true									
								}
							}
						});									
					}
				}
			});
			
		} else {						
			$endMonth.find(".day li").each(function(i){
				if(startIdx < i && endIdx > i){
					if($(this).before().hasClass('disable')){
						visibleEnd = false
						return false
					} else {
						visibleEnd = true									
					}
				}
			});
		}
		if(visibleEnd) {
			setEndDate(opt)
		} else {
			console.log('중간에 불가능한 날짜가 있다 - 재시작')
			reStart(D_this)
		}
		
	} else{
		//alert("끝나는 날짜는 시작 날짜보다 이전이거나 같을 수 없습니다.");
		reset();
	}
}

function reset(){
	console.log('리셋')
	$('.date').hide();
	isStart = false
	isEnd = false
	autoEndDate = false
	visibleEnd = true
	$(".monthArea .day li").removeClass("start").removeClass("end").removeClass("on");
}

function reStart(obj){
	reset();
	obj.find("a").trigger("click");
}

function dateDiff(date1, date2) {
	dt1 = new Date(parseInt(date1.substring(0, 4)), parseInt(date1.substring(5, 7)) - 1, parseInt(date1.substring(8, 10)));
	dt2 = new Date(parseInt(date2.substring(0, 4)), parseInt(date2.substring(5, 7)) - 1, parseInt(date2.substring(8, 10)));
	return Math.floor((Date.UTC(dt2.getFullYear(), dt2.getMonth(), dt2.getDate()) - Date.UTC(dt1.getFullYear(), dt1.getMonth(), dt1.getDate()) ) /(1000 * 60 * 60 * 24));
}

function goNext() {
	if($("#chki_date").val() == "") {
		alert("체크인 날짜를 선택하세요.");
		return;	
	}
	
	if($("#chot_date").val() == "") {
		alert("체크아웃 날짜를 선택하세요.");
		return;
	} 
	
	for(var i = 1; i <= $('#qty').val(); i++) {
		if($('#adult' + i).val() === '0' && $('#child' + i).val() === '0') {
			alert("인원을 선택하세요.");
			return;
		}
	}
	
<%
	if(fs.isLogin()) {
%>
	$("#reserveForm").submit();
<%
	} else {
%>
	parentShowPopup(".loginLayer");
<%
	}
%>
} 

$(function() {
    $("input[name='selRoomNum']").on("change", function(){
        $(".selArea a").text($(this).val());
        $(".selArea .list").stop().slideToggle(50);
    });
});

$(document).on("click", function(e) {
	$(".selArea .list").each(function(){
		var target = $(this)
		if(target.is(":visible")){
			if(!($(e.target).parents(".selArea").length)){
				target.hide()
			}
		}
	})
});

function parentShowPopup(obj){
	parent.$(obj).show().addClass("on");
	parent.$(".bgLayer").css("height", $(document).height() + "px").show();	
}


function getPriceInfo() {
// 	console.log($('#chki_date').val(), $('#chot_date').val());
	jQuery.ajaxSettings.traditional = true;
	$.ajax({
		method : "POST",
		url : "/hotel/offer/priceInfo.jsp",
		data : $("#reserveForm").serialize(),
		dataType : "json"
	})
	.done(function(json) {
// 		console.log(json);
		$('#price').val(json.price);
		$('#adult_price').val(json.adult_price);
		$('#child_price').val(json.child_price);
		$('#avail_qty').val(json.qty);
		$('#default_price').val(json.default_price);
		$('#default_adult_price').val(json.default_adult_price);
		$('#default_child_price').val(json.default_child_price);
		
		$('#qty').empty();
		for(var i = 1; i <= json.qty; i++) {
			$('#qty').append('<option value="' + i + '">' + i + '</option>');
		}
		setRoomNum();
	});
}

function setRoomNum() {
// 	console.log('qty', $('#qty').val());
	$('.people').empty();
	for(var i = 1; i <= $('#qty').val(); i++) {
		var li = $('#addRoom').val().replace(/##NO##/g, i);
		$('.people').append(li);
	}
	
	cal();
}

function setNum(no, gubun, dir) {
	if($('#chki_date').val() == '') {
		alert("예약 일자를 선택하세요.");
		return;
	}
	
	if(dir == 'P') {
		var persons = parseInt($('#adult' + no).val()) + parseInt($('#child' + no).val());
// 		console.log(persons);
		if(persons == <%= info.get("max_capa") %>) {
			alert("최대 정원은 <%= info.get("max_capa") %>명입니다.");
		} else {
			$('#' + gubun + no).val(parseInt($('#' + gubun + no).val()) + 1);
		}		
	} else {
		var min = gubun === 'adult' ? 1 : 0;
		if(parseInt($('#' + gubun + no).val()) > min) {
			$('#' + gubun + no).val(parseInt($('#' + gubun + no).val()) - 1);
		}
	}
	
	cal();
}

function cal() {
	var qty = $('#qty').val();
	// 금액 계산
	var defaultPrice = parseInt($('#default_price').val()) * qty;
	var price = parseInt($('#price').val()) * qty;
	
	var adult = 0;
	var child = 0;
	
	for(var i = 1; i <= qty; i++) {
		var _adult = parseInt($('#adult' + i).val());
		var _child = parseInt($('#child' + i).val());
		var _total = _adult + _child;

		// 추가요금
		if(_total > <%= info.get("capa") %>) {
			if(_adult > <%= info.get("capa") %>) {	
				// 성인 추가요금
				defaultPrice += (_adult - <%= info.get("capa") %>) * parseInt($('#default_adult_price').val());
				price += (_adult - <%= info.get("capa") %>) * parseInt($('#adult_price').val());

				// 어린이 추가요금
				defaultPrice += _child * parseInt($('#default_child_price').val());
				price += _child * parseInt($('#child_price').val());
			} else {	
				// 어린이 추가요금
				defaultPrice += (_total - <%= info.get("capa") %>) * parseInt($('#default_child_price').val());
				price += (_total - <%= info.get("capa") %>) * parseInt($('#child_price').val());
			}
		}
		
		adult += _adult;
		child += _child;
	}

// 	$('.checkIn').html();
// 	$('.checkOut').html();
	$('.room').html('객실 ' + qty);
	$('.adult').html('성인 ' + adult);
	$('.kids').html('어린이 ' + child);
	$('.original').html(defaultPrice.formatMoney());
	$('#totPrice').html(price.formatMoney());
}

function goLogin() {
	$('#reserveForm').attr('action', 'login.jsp');
	$('#reserveForm').submit();
}

function goJoin() {
	$('#reserveForm').attr('action', 'join.jsp');
	$('#reserveForm').submit();
}

function checkMemoLength() {
	var memo = $('textarea[name=memo]').val();
	var maxlength = 500;
	if(memo.length > maxlength) {
		alert("500자 이내로 작성해 주세요.");
		$('textarea[name=memo]').val(memo.substring(0, maxlength));
		$('textarea[name=memo]').focus();
	}
}

</script> 
</head>  
<body>
	<div class="offerReserLayer">
		<form id="reserveForm" name="reserveForm" method="post" action="info.jsp" target="_parent">
			<input type="hidden" name="gubun" value="<%= info.get("gubun") %>">
			<input type="hidden" id="pid" name="pid" value="<%= param.get("pid") %>">
			<input type="hidden" id="chki_date" name="chki_date" value="">
			<input type="hidden" id="chot_date" name="chot_date" value="">
			<input type="hidden" id="price" name="price" value="0">
			<input type="hidden" id="adult_price" name="adult_price" value="0">
			<input type="hidden" id="child_price" name="child_price" value="0">
			<input type="hidden" id="avail_qty" name="avail_qty" value="0">
			<input type="hidden" id="default_price" name="default_price" value="0">
			<input type="hidden" id="default_adult_price" name="default_adult_price" value="0">
			<input type="hidden" id="default_child_price" name="default_child_price" value="0">
		<div class="offerReserDate">
			<div class="calendarWrap">
				<div class="calendar" id="calendar">
				</div>
			</div>	
			<div class="caution">
				<span>00</span> 예약가능 |  <span class="disable">00</span> 예약 불가능 | <span class="choice">00</span> 선택한 날짜
			</div>	
		</div><!-- //reservationDate -->
		<div class="offerReserDetail">
			<div class="roomNumber2">
				<div class="number">
					<h2>객실 수</h2>
					<select name="qty" id="qty" onchange="setRoomNum()">
						<option value="1">1</option>
					</select>
				</div>
				<p class="caution">어린이 : 36개월~만13세</p>
				<ol class="people">
					<li><span class="type">객실 1</span>
						<ul>
							<li class="peopleNum">
								<span>성인</span>
								<a href="javascript:setNum('1','adult','N')" class="peopleNumMinus"><img src="/images/btn/btn_minus3.png" alt="-"></a>
								<input type="text" name="adult1" id="adult1" value="1" min="1" readonly> 
								<a href="javascript:setNum('1','adult','P')" class="peopleNumPlus"><img src="/images/btn/btn_plus3.png" alt="+"></a>
							</li>
							<li class="peopleNum">
								<span>어린이</span>
								<a href="javascript:setNum('1','child','N')" class="peopleNumMinus"><img src="/images/btn/btn_minus3.png" alt="-"></a>
								<input type="text" name="child1" id="child1" value="0" min="0" readonly> 
								<a href="javascript:setNum('1','child','P')" class="peopleNumPlus"><img src="/images/btn/btn_plus3.png" alt="+"></a>
							</li>
						</ul>
					</li>
				</ol>
			</div><!-- //roomNumber -->
			<h2>추가 요청</h2>
			<textarea name="memo" placeholder="요청사항을 입력해주세요. (최대 500자)" onkeyup="checkMemoLength()"><%= info.get("memo") %></textarea>
			<ul class="caution">
				<li>요청하신 내용은 호텔 사정에 따라 반영되지 않을 수도 있으며, 별도 요금이 발생할 수도 있습니다.</li>
				<li>기타 궁금하신 사항은 이메일(sangha3698@maeil.com) 또는 대표전화 1522-3698로 문의해주세요.</li>
			</ul>
		</div><!-- //detail -->
		</form>
		<div class="choiceSrmy">
			<p class="date" style="display:none">
				<span class="checkIn"></span> ~
				<span class="checkOut"></span>
				<span class="dateNam"></span> |
				<span class="room">객실 0</span>
				<span class="adult">성인 0</span>
				<span class="kids">어린이 0</span>
			</p>
			<p class="price">
				<span class="text">총 예상금액</span> <span class="original">0원</span> <strong id="totPrice">0</strong>원 <span class="sub">(VAT포함)</span>
			</p>
			<div class="btn">
				<a href="#" onclick="parent.hideReserLayer(); return false" class="btnStyle03">이 전</a>
				<a href="javascript:goNext()" class="btnStyle01">다 음</a>
			</div>
		</div>
	</div>

	<textarea id="addRoom" style="display:none">
		<li><span class="type">객실 ##NO##</span>
			<ul>
				<li class="peopleNum">
					<span>성인</span>
					<a href="javascript:setNum('##NO##','adult','N')" class="peopleNumMinus"><img src="/images/btn/btn_minus3.png" alt="-"></a>
					<input type="text" name="adult##NO##" id="adult##NO##" value="1" min="1" readonly> 
					<a href="javascript:setNum('##NO##','adult','P')" class="peopleNumPlus"><img src="/images/btn/btn_plus3.png" alt="+"></a>
				</li>
				<li class="peopleNum">
					<span>어린이</span>
					<a href="javascript:setNum('##NO##','child','N')" class="peopleNumMinus"><img src="/images/btn/btn_minus3.png" alt="-"></a>
					<input type="text" name="child##NO##" id="child##NO##" value="0" min="0" readonly> 
					<a href="javascript:setNum('##NO##','child','P')" class="peopleNumPlus"><img src="/images/btn/btn_plus3.png" alt="+"></a>
				</li>
			</ul>
		</li>
	</textarea>
</body>
</html>
