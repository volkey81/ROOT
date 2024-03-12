<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.code.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(6));
	request.setAttribute("Depth_4", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("예약하기"));
%>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	CodeService code = (new CodeService()).toProxyInstance();
	List<Param> list = code.getList2("026");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />  
<script>
	var v;

	$(function(){
		v = new ef.utils.Validator($("#reserveForm"));
		
		v.add("group_nm", {
			"empty" : "단체명을 입력해 주세요.",
			"max" : 20
		});
		v.add("mobile2", {
			"empty" : "휴대폰번호를 입력해 주세요.",
			"format" : "numeric",
			"max" : 4
		});
		v.add("mobile3", {
			"empty" : "휴대폰번호를 입력해 주세요.",
			"format" : "numeric",
			"max" : 4
		});
		v.add("exp_num", {
			"empty" : "체험인원을 입력해 주세요.",
			"max" : 6,
			"format" : "numeric"
		});
		v.add("see_num", {
			"empty" : "참관인원을 입력해 주세요.",
			"max" : 6,
			"format" : "numeric"
		});

		efuSlider('.calenderArea', 1, 0, '', 'once');	
	});	

	function step1(obj, date) {
		$(".calenderArea .choice").removeClass("choice");
		$(obj).parent().addClass("choice");
		
		$("#reserve_date").val(date);
		
		$.ajax({
			method : "POST",
			url : "expList1.jsp",
			data : { date : date },
			dataType : "html"
		})
		.done(function(html) {
			$("#exp_type").empty().html("<option value=''>선택없음</option>");
			$("#exp_type").append($.trim(html));
		});
	}
	
	function proc() {
		if(v.validate()) {
			if($("#reserve_date").val() == "") {
				alert("예약일자를 선택하세요.");
				return;
			}
			
			if(!$("#agree1").prop("checked")) {
				alert("취소/환불 규정에 대한 동의는 필수입니다.");
				return;
			}

			if(!$("#agree2").prop("checked")) {
				alert("예약내역동의는 필수입니다.");
				return;
			}

			ajaxSubmit($("#reserveForm"), function(json) {
				alert(json.msg);
				if(json.result) {
					document.location.href="/";
				}
			});
		}
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container" class="group">
	<!-- 내용영역 -->
		<jsp:include page="/brand/play/reservation/subNav.jsp" />
		<div class="ac"><p class="reserSrmy">20인 이상의 단체 방문자는 추가적인 할인혜택이 적용됩니다. 방문 계획을 남겨주시면, 전화를 통해 예약을 확정합니다.</p></div>
		<div class="calenderHead">
			<h2 class="typeA"><strong class="num">01</strong> 날짜 선택</h2>
			<p class="datePoint today">오늘 날짜</p>
			<p class="datePoint choice">선택일</p>
			<p class="datePoint disable">예약 불가능</p>
		</div>
		<div class="calenderArea">
			<div class="slideCont">
				<ul>
<%
	Calendar today = Calendar.getInstance();
	Calendar diffDay = Calendar.getInstance();
	diffDay.add(Calendar.DATE, 1);
	
	Calendar cal = Calendar.getInstance();
	
	for(int j = 0; j < 3; j++) {
		cal.set(Calendar.DATE, 1);
%>
					<li class="sec">
						<h3><%= (new SimpleDateFormat("MMMMMMMMM", java.util.Locale.US)).format(cal.getTime()) %><br><strong><%= (new SimpleDateFormat("MM", java.util.Locale.US)).format(cal.getTime()) %></strong></h3>
						<div class="calender">
							<ol class="week">
								<li>일</li>
								<li>월</li>
								<li>화</li>
								<li>수</li>
								<li>목</li>
								<li>금</li>
								<li>토</li>
							</ol>
							<ol class="day">
<%
		for(int i = 1; i < cal.get(Calendar.DAY_OF_WEEK); i++) { 
%>
								<li></li>
<%
	}

		while(true) {
			if(cal.compareTo(today) == 0) {
%>
							<li class="today"><a href="#none"><%= cal.get(Calendar.DATE) %></a></li>
<%			
			} else if(cal.compareTo(diffDay) <= 0) {
%>
							<li class="disable"><a href="javascript:void(0)"><%= cal.get(Calendar.DATE) %></a></li>
<%
			} else {
%>
							<li><a href="#none" onclick="step1(this, '<%= Utils.getTimeStampString(cal.getTime(), "yyyy.MM.dd") %>'); return false;"><%= cal.get(Calendar.DATE) %></a></li>
<%			
			}
			
			if(cal.get(Calendar.DATE) == cal.getActualMaximum(Calendar.DATE)) break;
			cal.add(Calendar.DATE, 1);
		}
%>
							</ol>
						</div><!-- //calender -->
					</li><!-- //sec -->
<%
		cal.add(Calendar.MONTH, 1);
	}
%>
				</ul>
			</div><!-- //slideCont -->
			<input type="image" src="/images/btn/btn_prev2.png" alt="이전달" class="prev">
			<input type="image" src="/images/btn/btn_next2.png" alt="다음달" class="next">
		</div><!-- //calenderArea -->
		
		<form name="reserveForm" id="reserveForm" method="post" action="reserveProc.jsp">
			<input type="hidden" name="reserve_date" id="reserve_date" />
		<h2 class="typeA"><strong class="num">02</strong> 예약자 정보</h2>
		<div class="groupOption">
			<span>농원 내 식당을 이용할 계획이면 체크해주세요.</span>
			<input type="checkbox" name="kitchen_yn" id="groupOpt1" value="Y"><label for="groupOpt1">농원식당</label>
			<input type="checkbox" name="other_yn" id="groupOpt2" value="Y"><label for="groupOpt2">상하키친</label>
		</div>
		<table class="bbsForm">
			<caption>예약자 정보입력 폼</caption>
			<colgroup>
				<col width="90"><col width=""><col width="90"><col width="">
			</colgroup>
			<tr>
				<th scope="row">체험<br>프로그램</th>
				<td colspan="3">
					<select name="exp_type" id="exp_type" title="프로그램 선택">
						<option value="">선택없음</option>
					</select>
					<ul class="caution">
						<li>20명 이상 이용 시에만 단체가격의 적용이 가능합니다.</li>
						<li>웹사이트 예약 접수 후 유선을 통한 예약 확정이 필요합니다. (예약 후 3일 이내 해피콜 예정)</li>
						<li>단체 도시락 식사가 가능한 실내 시설이 없습니다. 도시락 지참 시 참고 바랍니다.</li>
						<li>단체 체험 취소는 일주일 전까지만 가능합니다.</li>
					</ul>
				</td>
			</tr>
			<tr>
				<th scope="row">단체명</th>
				<td><input type="text" name="group_nm" id="group_nm" title="단체명" style="width:200px"></td>
				<th scope="row">체험인원</th>
				<td>
					<input type="text" name="exp_num" id="exp_num" title="체험인원" class="ar" style="width:50px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;명
					<strong class="tit">참관인원</strong> <input type="text" name="see_num" id="see_num" title="참관인원" class="ar" style="width:50px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;명
				</td>
			</tr>
			<tr>
				<th scope="row">연락처</th>
				<td>
					<select name="mobile1" id="mobile1" title="연락처 첫자리" style="width:80px">
<%
	for(String mobile : SanghafarmUtils.MOBILES) {
%>
								<option value="<%= mobile %>" <%= mobile.equals(fs.getMobile1()) ? "selected" : "" %>><%= mobile %></option>
<%
	}
%>
					</select>&nbsp;-
					<input type="text" name="mobile2" id="mobile2" value="<%= fs.getMobile2() %>" title="연락처 가운데자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="text" name="mobile3" id="mobile3" value="<%= fs.getMobile3() %>" title="연락처 뒷자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
				</td>
				<th scope="row">연령대</th>
				<td>
					<select name="age" id="age" title="연령대 선택">
<%
	for(Param row : list) {
%>
						<option value="<%= row.get("code2") %>"><%= row.get("name2") %></option>
<%
	}
%>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">기타문의</th>
				<td colspan="3"><textarea name="content" style="width:950px;height:80px"></textarea></td>
			</tr>
		</table>
		<!-- //step2 예약자정보 -->
				
		<h2 class="typeA">이용 동의</h2>
		<div class="agreeChk">
	 		<div class="section">
	 			<h3><input type="checkbox" name="agree1" id="agree1"><label for="agree1">취소/환불 규정에 대한 동의</label></h3>
	 			<div class="cont"><div class="scr">
					기후상황, 개인사유 등에 따른 일정변경으로 인한 손해에 대해서는 상하농원에서 책임지지 않습니다. 취소/환불 규정에 동의 하시겠습니까?<br><br>
					<ul>
						<li>이용 7일 전까지 취소 수수료 없음</li>
						<li>이용 7일 전 ~ 당일 체험시작 20분 전까지 3set에 한해 수량 변경 가능</li>
						<li>식사 예약 수량은 당일 10시 이전까지 인원의 10%내외에 한해 수량 변경 가능</li>
					</ul>
	 			</div></div>
	 		</div>
	 		<div class="section">
	 			<h3><input type="checkbox" name="agree2" id="agree2"><label for="agree2">예약내역 동의</label></h3>
	 			<div class="cont"><div class="scr">
					예약할 상품의 상품명, 사용일자 및 시간, 상품가격을 확인했습니다. (전자상거래법 제 8조 2항) 예약에 동의하시겠습니까?<br><br>
					<ul>
						<li>상하농원 단체 체험은 20인 이상에 한해 예약이 가능합니다.</li>
						<li>체험 시작 이후에는 입장이 제한됩니다. (체험시작 20분 전까지 매표소 도착)</li>
						<li>40명 이상 단체의 경우 추가 포장시간이 2시간까지 소요될 수 있습니다.</li>
						<li>동물농장의 먹이주기 체험은 별도 예약이 불가합니다.</li>
						<li>도시락 식사가 가능한 실내 장소는 별도 제공하지 않습니다.</li>
					</ul>
	 			</div></div>
	 		</div>
	 	</div><!--//이용동의 -->
	 	
	 	<div class="btnArea">
	 		<a href="javascript:proc()" class="btnTypeA sizeXL">상담 등록</a>
	 	</div>
	 	</form>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					