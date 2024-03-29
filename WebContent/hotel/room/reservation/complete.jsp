<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.hotel.*,
			com.sanghafarm.utils.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("객실"));

	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	HotelReserveService svc = new HotelReserveService();
	
	Param info = svc.getHreserveInfo(param.get("orderid"));
	List<Param> list = svc.getHreserveRoomList(param.get("orderid"));
	
	if(info == null || !info.get("userid").equals(fs.getUserId())) {
		Utils.sendMessage(out, "잘못된 접근입니다.");
		return;
	}
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
	$(function() {
		setRoomList();
	});

	function setRoomList() {
<%
	String room = "";
	int seq = 1;
	for(Param row : list) {
		if(!room.equals(row.get("room_knd_gbcd"))) {
			room = row.get("room_knd_gbcd");
			seq = 1;
			String s = "<div class='reservationList'>";
			s += "<dl id='room_list_" + room + "'>";
			s += "<dt>" + row.get("room_knd_nm") + "</dt>";
			s += "<dd>객실 " + seq++ + " 성인" + row.get("pers_adlt") + ", 어린이 " + row.get("pers_kids") + "</dd>";
			s += "</dl>";
			s += "<dl><dt class='request'>추가 요청사항</dt>";
			s += "<dd>" + row.get("rem_cntn") + "</dd></dl>";
			s += "</div>";
%>
		$("#room_list").append("<%= s %>");
<%
		} else {
			String s = "<dd>객실 " + seq++ + " 성인" + row.get("pers_adlt") + ", 어린이 " + row.get("pers_kids") + "</dd>";
%>
		$("#room_list_<%= room %>").append("<%= s %>");
<%
		}
	}
%>
	}
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel room complete">
		<!-- 내용영역 -->		
		<div class="reservation">
			<!-- reservationTop -->
			<jsp:include page="/hotel/room/reservation/reservationTop.jsp" />
			<!-- //reservationTop -->
		
			<!-- customerInfo -->
			<div class="reservationCont">
				<div class="endTxt">
					<p>예약이 완료되었습니다.<span>예약번호 : <%= info.get("intg_resv_no") %></span></p>
				</div>
				<ul class="caption">
					<li>* 예약정보는 고객정보에 입력한 연락처로 SMS 발송됩니다.</li>
					<li>* 고객문의 1522-3698</li>
				</ul>
				<!-- infoCont -->
				<div class="infoCont">
					<div class="cont">
						<h2>01. 예약자 정보</h2>
						<table>
							<colgroup>
								<col width="15%">
								<col width="35%">
								<col width="15%">
								<col width="35%">
							</colgroup>
							<tr>
								<th scope="col">예약자</th>
								<td><%= info.get("name") %></td>
								<th scope="col">휴대전화</th>
								<td><%= info.get("mobile1") %>-<%= info.get("mobile2") %>-<%= info.get("mobile3") %></td>
							</tr>
							<tr>
								<th scope="col">결제수단</th>
								<td><%= info.getInt("pay_amt", 0) == 0 ? "없음(전액할인)" : info.get("pay_type_name") %></td>
								<th scope="col">상태</th>
								<td>결제완료</td>
							</tr>
						</table>
					</div>
					<div class="cont">
						<h2>02. 예약 내역</h2>
						<table>
							<colgroup>
								<col width="15%">
								<col width="35%">
								<col width="15%">
								<col width="35%">
							</colgroup>
							<tr>
								<th scope="col">체크인</th>
								<td><%= info.get("chki_date") %></td>
								<th scope="col">체크아웃</th>
								<td><%= info.get("chot_date") %>(<%= SanghafarmUtils.getDateDiff(info.get("chki_date"), info.get("chot_date")) %>박)</td>
							</tr>
							<tr>
								<th scope="col">예약내역</th>
								<td colspan="3" id="room_list">
								</td>
							</tr>
						</table>
					</div>			
				</div>
				<!-- //infoCont -->
			
				<!-- choiceInfoWrap -->
				<div class="choiceInfoWrap">
					<h2>03. 총 결제금액</h2>
					<!-- choiceInfo -->
					<div class="choiceInfo">
						<div class="top">
							<ul>
								<li>예약 소계<span><%= Utils.formatMoney(info.get("tot_amt")) %>원</span></li>
								<li>쿠폰 할인<span>-<%= Utils.formatMoney(info.get("coupon_amt")) %>원</span></li>
								<li>프로모션 코드 할인<span>-<%= Utils.formatMoney(info.get("promocd_amt")) %>원</span></li>
								<li>매일 Do 포인트<span>-<%= Utils.formatMoney(info.get("point_amt")) %>원</span></li>
								<li>키프트 카드<span>-<%= Utils.formatMoney(info.get("giftcard_amt")) %>원</span></li>
							</ul>
						</div>
						<div class="bottom">
							<ul>
								<li class="discount">총 할인액<span>-<%= Utils.formatMoney(info.getInt("coupon_amt") + info.getInt("promocd_amt") + info.getInt("point_amt") + info.getInt("giftcard_amt")) %>원</span></li>
								<li>최종 결제액<span><%= Utils.formatMoney(info.get("pay_amt")) %>원</span></li>
							</ul>
						</div>
						<div class="choiceInfoBtn">
							<a href="/hotel/index.jsp" class="btnStyle02">메인으로</a><a href="/mypage/reservation/hotel/list.jsp" class="btnStyle01">예약 내역 조회</a>
						</div>
					</div>
					<!-- //choiceInfo -->
				</div>
				<!-- //choiceInfoWrap -->
			</div>
			<!-- //customerInfo -->
			<div class="banner">
				<a href="/brand/play/reservation/admission.jsp" target="_blank"><img src="/images/hotel/room/completeBanner.jpg" alt="자연과 더 가까이, 상하농원 체험교실"></a>
			</div>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
