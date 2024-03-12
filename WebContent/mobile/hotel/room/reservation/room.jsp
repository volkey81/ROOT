<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.hotel.*,
			org.json.simple.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("Depth_4", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("객실"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
	/*
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	*/

	RMSApiService api = new RMSApiService();
	JSONObject json = api.forecast(param);
	List<Param> list = api.getRoomList(param, json);
	
	if(list.size() == 0) {
		Utils.sendMessage(out, "선택하신 날짜의 숙박 가능한 객실이 없습니다.", "date.jsp");
		return;
	}
	
	int night = SanghafarmUtils.getDateDiff(param.get("chki_date"), param.get("chot_date"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp"/> 
<script>
$(function(){	
	$(window).scroll(function(){
		var groupATop = $(".choiceTop").offset().top;
		var value = $(this).scrollTop() ;

		if (value >= 108){
			$("#container").addClass("fix");
		}else if (value < 108){
			$("#container").removeClass("fix");
		}
	});
	
	
	$(".roomCont li .roomTxt .btnStyle01").click(function(){
		if(!$(this).hasClass("on")) {
			$(this).addClass("on");
			$(this).parent().next(".reservationInfo").slideDown();
			$(this).text('닫기');
			
		} else {
			$(this).removeClass("on");
			$(this).parent().next(".reservationInfo").slideUp();
			$(this).text('예약하기');
			
		}
		return false;
	});
	
	cal();
});

function dateDiff(date1, date2) {
	dt1 = new Date(date1);
	dt2 = new Date(date2);
	return Math.floor((Date.UTC(dt2.getFullYear(), dt2.getMonth(), dt2.getDate()) - Date.UTC(dt1.getFullYear(), dt1.getMonth(), dt1.getDate()) ) /(1000 * 60 * 60 * 24));
}

function setNum(knd, seq, g, d) {
	var obj = $("#" + knd + "_qty_" + seq + "_" + g);
	var tot = parseInt($("#" + knd + "_qty_" + seq + "_adult").val()) + parseInt($("#" + knd + "_qty_" + seq + "_kids").val());
	
	if(d == 'P') {
		if(tot >= parseInt($("#" + knd + "_max_prsn").val())) {
			alert("최대인원을 초과했습니다.")
		} else {
			obj.val(parseInt(obj.val()) + 1);
		}
	} else {
		if(parseInt(obj.val()) <= 0) {
			obj.val("0");
		} else {
			obj.val(parseInt(obj.val()) - 1);
		}
	}
	
	cal();
}

function setRoomNum(p) {
	var n = $("#" + p + "_qty").val();
	
	for(var i = 1; i <= $("#" + p + "_qty option").length; i++) {
		if(i <= n) {
			$("#" + p + "_qty_" + i).show();
		} else {
			$("#" + p + "_qty_" + i + "_adult").val(0);
			$("#" + p + "_qty_" + i + "_kids").val(0);
			$("#" + p + "_qty_" + i).hide();
		}
	}
	
	cal();
}

var totamt = 0;
// var room = ["A", "B", "C", "D", "E", "P", "Q"];
var room = [];
<%
	for(int i = 0; i < RMSApiService.ROOM_TYPE.length; i++) {
%>
	room.push("<%= RMSApiService.ROOM_TYPE[i] %>");
<%
	}
%>
var _addAdultAmt = <%= RMSApiService.getAddAmt(param.get("chki_date"), "A", "ADULT") %>;
var _addChildAmt = <%= RMSApiService.getAddAmt(param.get("chki_date"), "A", "CHILD") %>;
var _addGlampingAdultAmt = <%= RMSApiService.getAddAmt(param.get("chki_date"), "P", "ADULT") %>;
var _addGlampingChildAmt = <%= RMSApiService.getAddAmt(param.get("chki_date"), "P", "CHILD") %>;

function cal() {
	totamt = 0;
	var listTxt = "";
	for(var i = 0; i < room.length; i++) {
		if($("#" + room[i] + "_room_amt").val() === undefined) continue;

		var addAdultAmt = (room[i] == 'P' || room[i] == 'Q') ? _addGlampingAdultAmt : _addAdultAmt;
		var addChildAmt = (room[i] == 'P' || room[i] == 'Q') ? _addGlampingChildAmt : _addChildAmt;

		var addAdult = 0;
		var addKids = 0;
		var addAmt = 0;
		var amt = parseInt($("#" + room[i] + "_room_amt").val());;
		var basic = parseInt($("#" + room[i] + "_basic_prsn").val());
		var max = parseInt($("#" + room[i] + "_max_prsn").val());
		var roomCnt = 0;
		var txt = "";
		
		for(var j = 1; j <= $("#" + room[i] + "_qty option").length; j++) {
			var adult = parseInt($("#" + room[i] + "_qty_" + j + "_adult").val());
			var kids = parseInt($("#" + room[i] + "_qty_" + j + "_kids").val());

			if(adult + kids > 0) {
				if(adult + kids > basic) {	// 추가요금 계산
					if(adult > basic) {	// 성인만으로도 기본 초과인 경우
						addAdult += (adult - basic);
						addAmt += (addAdultAmt * (adult - basic) * <%= night %>);
						if(kids > 0) {
							addKids += kids;
							addAmt += (addChildAmt * kids * <%= night %>);
						}
					} else {
						addKids += (adult + kids - basic);
						addAmt += (addChildAmt * (adult + kids - basic) * <%= night %>);
					}
				}
				
				txt += "<li>객실 " + j + "<span>성인 " + adult + " , 어린이 " + kids + "</span></li>";
				roomCnt++;
			}
		}
		
		$("#" + room[i] + "_price1").html(addAmt.formatMoney() + "원<span>(성인 " + addAdult + ", 어린이 " + addKids + ")</span>");
		$("#" + room[i] + "_price2").html(((amt * roomCnt) + addAmt).formatMoney() + "원<span>(" + ((room[i] == 'P' || room[i] == 'Q') ? '' : '조식 및') + "VAT 포함)</span>");
		totamt += ((amt * roomCnt) + addAmt);
	}
}

function goNext() {
	cal();
	
	if(totamt == 0) {
		alert("객실을 선택하세요.");
		return;
	}
	
<%
	if(fs.isLogin()) {
%>
	$("#orderForm").submit();
<%
	} else {
%>
	showLoginPopup(".loginLayer");
<%
	}
%>
}

function showLoginPopup(obj){
	$(obj).show().addClass("on");
	$(".bgLayer").css("height", $(document).height() + "px").show();	
}

function hideLoginLayer(obj){
	$(obj).parents('.popLayer').hide().removeClass("on");
	$(".bgLayer").hide();
}

function goLogin() {
	$('#orderForm').attr('action', 'login.jsp');
	$('#orderForm').submit();
}

function goJoin() {
	$('#orderForm').attr('action', 'join.jsp');
	$('#orderForm').submit();
}

</script> 
</head>  
<body>

<div id="wrapper" class="hotelWrap">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="room styleA btnFix">
	<!-- 내용영역 -->
		<div class="reservation">
			<h2 class="animated fadeInUp delay02">예약하기</h2>
			<!-- reservationTop -->
			<jsp:include page="/mobile/hotel/room/reservation/reservationTop.jsp" />
			<!-- //reservationTop -->
		
			<!-- roomChoice -->
			<div class="roomChoice">
				<div class="choiceTop">
					<p class="choiceDate"><%= param.get("chki_date") %> - <%= param.get("chot_date") %><span>(<%= night %>박)</span></p>
					<a href="/mobile/hotel/room/reservation/date.jsp" class="reSelect ">재선택</a>
				</div>
				<!-- roomType -->
				
				<div class="choiceCont">
					<form name="orderForm" id="orderForm" action="info.jsp" method="post">
						<input type="hidden" name="chki_date" value="<%= param.get("chki_date") %>">
						<input type="hidden" name="chot_date" value="<%= param.get("chot_date") %>">
					<ul class="roomCont">
<%
	for(Param row : list) {
		if(row.getInt("forcasting_qty") > 0) {
			Param info = RMSApiService.STATIC_INFO.get(row.get("room_knd_gbcd"));
%>
						<li>
							<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_basic_prsn" id="<%= row.get("room_knd_gbcd") %>_basic_prsn" value="<%= row.get("basic_prsn") %>">
							<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_room_knd_nm" id="<%= row.get("room_knd_gbcd") %>_room_knd_nm" value="<%= row.get("room_knd_nm") %>">
							<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_max_prsn" id="<%= row.get("room_knd_gbcd") %>_max_prsn" value="<%= row.get("max_prsn") %>">
							<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_chrg_grup_gbcd" id="<%= row.get("room_knd_gbcd") %>_chrg_grup_gbcd" value="<%= fs.isStaff() ? row.get("chrg_grup_gbcd_02") : row.get("chrg_grup_gbcd_01") %>">
							<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_room_amt" id="<%= row.get("room_knd_gbcd") %>_room_amt" value="<%= fs.isStaff() ? row.get("room_amt_02") : row.get("room_amt_01") %>">
							<img src="/mobile/images/hotel/room/<%= info.get("thumb") %>" alt="" class="thum">
							<div class="roomTxt">
								<strong class="tit"><%= row.get("room_knd_nm") %></strong>
								<p class="info"><span>객실 크기 : <%= info.get("room_size") %></span><span>베드 타입 : <%= info.get("bed_type") %></span><span>기준 인원 : 기준 <%= row.get("basic_prsn") %>명 / 최대 <%= row.get("max_prsn") %>명</span></p>
								<a href="#" class="btnStyle01 sizeS">예약하기</a>
							</div>
							<div class="reservationInfo">
								<div class="txt">
									<p>숙박할 객실 수와 객실별 인원을 선택해 주세요.</p>
									<ul class="caption">
										<li>* 기준정원 이상의 추가인원 입실 시, 1인당 추가 비용이 발생합니다. <%if("Q".equals(row.get("room_knd_gbcd"))){ %>(반려견은 1실당 1마리만 입실 가능하며 추가비용 발생, 사전예약필수)<%} %></li>
										<li>* 어린이 : 36개월~만13세</li>
										<li class="color">* 최대 인원수를 초과 하시면 체크인이 불가할 수 있습니다.</li>
<%
			if("P".equals(row.get("room_knd_gbcd")) || "Q".equals(row.get("room_knd_gbcd"))) {
%>
										<li class="color">* BBQ(2인/4인 세트) 주문 또는 숯불을 이용하실 분은 추가 요청에 반드시 기재 바랍니다.</li>
<%
			}
%>
										<li class="color">* 극성수기(여름) 기간 인원추가 요금 (대인 65,000원, 소인 40,000원) 차액은 체크인 시 결제 바랍니다.</li>
									</ul>
								</div>
							
								<!-- roomNumber -->
								<div class="roomNumber">
									<div class="number">
										객실 수
										<select name="<%= row.get("room_knd_gbcd") %>_qty" id="<%= row.get("room_knd_gbcd") %>_qty" onchange="setRoomNum('<%= row.get("room_knd_gbcd") %>')" align="center">
<%
			for(int i = 1; i <= 4 && i <= row.getInt("forcasting_qty"); i++) {
%>
											<option value="<%= i %>"><%= i %></option>
<%
			}
%>
										</select>
									</div>
									<ol class="people">
<%
			for(int i = 1; i <= 4 && i <= row.getInt("forcasting_qty"); i++) {
%>
										<li id="<%= row.get("room_knd_gbcd") %>_qty_<%= i %>" style="display:<%= i > 1 ? "none" : "block" %>"><span class="type">객실 <%= i %></span>
											<ul>
												<li class="peopleNum">성인<div>
													<a href="javascript:setNum('<%= row.get("room_knd_gbcd") %>','<%= i %>','adult','N')" class="peopleNumMinus">-</a>
													<input type="text" name="<%= row.get("room_knd_gbcd") %>_qty_<%= i %>_adult" id="<%= row.get("room_knd_gbcd") %>_qty_<%= i %>_adult" value="0" min="0" readonly="readonly"> 
													<a href="javascript:setNum('<%= row.get("room_knd_gbcd") %>','<%= i %>','adult','P')" class="peopleNumPlus">+</a></div>
												</li>
												<li class="peopleNum">어린이<div>
													<a href="javascript:setNum('<%= row.get("room_knd_gbcd") %>','<%= i %>','kids','N')" class="peopleNumMinus">-</a>
													<input type="text" name="<%= row.get("room_knd_gbcd") %>_qty_<%= i %>_kids" id="<%= row.get("room_knd_gbcd") %>_qty_<%= i %>_kids" value="0" min="0" readonly="readonly"> 
													<a href="javascript:setNum('<%= row.get("room_knd_gbcd") %>','<%= i %>','kids','P')" class="peopleNumPlus">+</a></div>
												</li>
											</ul>
										</li>
<%
			}
%>
									</ol>
								</div>
								<!-- //roomNumber -->
								
								<!-- allPrice -->
								<div class="allPriceArea">
									<ul>
										<li class="allPrice">
											<strong>총 금액</strong>
											<p class="price" id="<%= row.get("room_knd_gbcd") %>_price2">0원<span>(<%= ("P".equals(row.get("room_knd_gbcd")) || "Q".equals(row.get("room_knd_gbcd"))) ? "" : "조식 및 " %>VAT 포함)</span></p>
										</li>
										<li>
											<strong>인원추가</strong>
											<p class="price" id="<%= row.get("room_knd_gbcd") %>_price1">0원<span>(성인 0, 어린이 0)</span></p>
										</li>
									</ul>
								</div>
								<!-- //allPrice -->
			
								<div class="request">
									<p class="tit">추가요청</p>
									<textarea name="<%= row.get("room_knd_gbcd") %>_note" id="<%= row.get("room_knd_gbcd") %>_note" rows="2" cols="10" placeholder="요청사항을 입력해 주세요. (최대 500자)" class="placeholder"></textarea>
									<ul class="caption">
										<li>* 요청하신 내용은 호텔 사정에 따라 반영되지 않을 수도 있으며, 별도 요금이 발생할 수도 있습니다.</li>
										<li>* 기타 궁금하신 사항은 이메일(<a href="mailto:sangha3698@maeil.com">sangha3698@maeil.com</a>) 대표전화 <a href="tel:1522-3698">1522-3698</a>로 문의해주세요.</li>
									</ul>
								</div>
							</div>
						</li>
<%
		}
	}
%>
					</ul>
					</form>
				</div>
				<!-- //roomType -->
			</div>
			<!-- //roomChoice -->
			<div class="btnArea">
				<a href="date.jsp" class="btnStyle04">이전</a><a href="javascript:goNext()" class="btnStyle03">다음</a>
			</div>
		</div>

	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<div class="loginLayer popLayer">
	<h2>로그인 안내</h2>
	<p class="text">상하농원 회원에게만 제공되는 스페셜오퍼 혜택, <br>지금 로그인하시고 예약을 완료하세요.</p>
	<p class="btn"><a href="#" onclick="goLogin(); return false" class="btnStyle03 sizeS">로그인 후 예약하기</a></p>
	<p class="text2">아직 회원이 아니세요? 지금 가입하시고 <br>스페셜오퍼를 포함한 다양한 혜택을 누려보세요.</p>
	<ul class="caution">
		<li>다양한 상품구매와 함께 쿠폰할인 혜택을 받으실 수 있습니다.</li>
		<li>회원전용의 다양한 서비스! 상품평, 이벤트 참여가 가능합니다.</li>
		<li>회원 가입을 하시면, 상하농원을 포함한 매일유업㈜의 매일 family 통합회원 온라인 서비스도 함께 이용하실 수 있습니다.</li>
	</ul>
	<p class="btn"><a href="#" onclick="goJoin(); return false" class="btnStyle03 sizeS">회원가입</a></p>
	<p class="close"><a href="#" onclick="hideLoginLayer(this); return false">닫기</a></p>
</div><!-- //로그인안내 -->

</body>
</html>