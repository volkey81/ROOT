<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.hotel.*" %>
<%
	/*
	String today = Utils.getTimeStampString("yyyyMMddHHmm");
	String sdate = SystemChecker.isReal() ? "202207271300" : "202207261300";
	String edate = SystemChecker.isReal() ? "202207271800" : "202207261600";
	
	if(today.compareTo(sdate) >= 0 && today.compareTo(edate) <= 0) {
		System.out.println("============================== 공사중 ====================");
		response.sendRedirect("/servicestop.jsp");
		return;
	}
	*/

	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("Depth_4", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("객실"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	RMSApiService api = new RMSApiService();
	HotelReserveService svc = new HotelReserveService();
	
	/*
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	*/
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp"/> 
</head>  
<body>
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
		data : { year : year, month : month },
		cache: false,
		dataType : "html"
	})
	.done(function(html) {
		$("#calendar2").empty().html(html);

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
		$('.checkIn .date').text($("#chki_date").val());
		$('.checkOut .date').text("");
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
				$('.checkOut .date').text($("#chot_date").val());
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
		$('.checkOut .date').text($("#chot_date").val());
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
	} else if($("#chot_date").val() == "") {
		alert("체크아웃 날짜를 선택하세요.");
	} else {
		$("#orderForm").submit();
	}
} 

function layerShow(obj){
	var popTop = $(document).scrollTop() +100;
	$('.bgLayer').show();
	$(obj).show();
	if($(obj).height() < $(window).height()){
		$(obj).css({
			'left': '0', 'top': '50%', 'margin-top': '-' + ($(obj).height()+20) / 2 + 'px'
		})
	} else {
		$(obj).css({
			'left': '0', 'top': '0', 'height': '100%', 'overflow-y': 'auto'
		})
	}
	$(obj).addClass("on");

	var cSwiper = new Swiper($(".calendarWrap .slideCont"), {
		slidesPerView: 1,
		spaceBetween: 15,
		prevButton: $(".calendarWrap .prev"),
		nextButton: $(".calendarWrap .next"),
		onSlideChangeEnd: function(swiper){	
			var idx = swiper.activeIndex;
		}
	})
}

function layerClose(obj){
	$('.bgLayer').hide();
	$(obj).hide();
}
</script>
<div id="wrapper" >
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="room">
	<!-- 내용영역 -->
		<div class="reservation">
			<h2 class="animated fadeInUp delay02">예약하기</h2>
			<!-- reservationTop -->
			<jsp:include page="/mobile/hotel/room/reservation/reservationTop.jsp" />
			<!-- //reservationTop -->
			
			<p class="topTxt animated fadeInUp delay06">파머스빌리지에서<br>청정한 자연 속 <br>소박한 휴식을 누리세요</p>
			<div class="reservationSearch">
				<table class="listStyleA">
					<colgroup>
						<col width="25%">
						<col width="*">
					</colgroup>
					<tr>
						<th scope="col">체크인</th>
						<td class="checkIn">
							<a href="#none" onclick="layerShow('#calendar'); return false" class="btnCalendar" style="display:none">
								<div class="date dateTxt">날짜를 선택해 주세요.</div>
								<img src="/mobile/images/hotel/room/ico_calendar.png" alt="달력">
							</a>
						</td>
					</tr>
					<tr>
						<th scope="col">체크아웃</th>
						<td class="checkOut"><div class="date dateTxt"></div></td>
					</tr>
					<tr>
						<th scope="col">숙박일</th>
						<td class="dateNam dateTxt"></td>
					</tr>
				</table>
				
			</div>
			<div class="btnArea">
				<a href="javascript:goNext()" class="btnStyle01 sizeL">검색</a>
				<!-- <a href="#none" onclick="showPopupLayer('/mobile/hotel/room/reservation/noRoom.jsp'); return false"  class="btnStyle01">검색</a> 객실이 없을경우 -->
			</div>
		</div>
	
	<!-- //내용영역 -->
	</div><!-- //container -->
	
	<div class="calendarWrap" id="calendar" style="display:none;">
		<form name="orderForm" id="orderForm" action="room.jsp" method="post">
			<input type="hidden" id="chki_date" name="chki_date">
			<input type="hidden" id="chot_date" name="chot_date">
		</form>
		<div class="calendar" id="calendar2"><!-- slideCont 제거 -->
		</div>
		<a href="#none" onclick="layerClose('#calendar'); return false"  class="btnClose"><img src="/mobile/images/btn/btn_close6.png" alt="닫기"></a>	
		<p class="btn"><a href="#" onclick="layerClose('#calendar'); return false" class="btnStyle01 sizeS">선택</a></p>		
		<div class="caution">
			<span>00</span> 예약가능 |  <span class="disable">00</span> 예약 불가능 | <span class="choice">00</span> 선택한 날짜
			<p class="txt">예약 마감시 프론트(063-563-6611) 및 파머스빌리지 상담게시판을 통하여 대기 신청을 하실수 있습니다.</p>
			<p class="txt2">당일부터 일주일간 예약은 <br>‘스페셜오퍼-Weekly특가’에서 특별한 혜택을 만나보세요.</p>
		</div>	
	</div>	
	<div class="bgLayer"></div>	
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>