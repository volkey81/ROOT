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
	request.setAttribute("Depth_4", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("객실"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");

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
<jsp:include page="/mobile/include/head.jsp"/> 
</head>  
<body>
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
		String s = "<li class='reservationList'>";
		s += "<dl id='room_list_" + room + "'>";
		s += "<dt>" + row.get("room_knd_nm") + "</dt>";
		s += "<dd>객실 " + seq++ + " 성인" + row.get("pers_adlt") + ", 어린이 " + row.get("pers_kids") + "</dd>";
		s += "</dl>";
		s += "<dl><dt class='request'>추가 요청사항</dt>";
		s += "<dd>" + row.get("rem_cntn") + "</dd></dl>";
		s += "</li>";
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
<div id="wrapper" >
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="room">
	<!-- 내용영역 -->
		<div class="reservation">
			<h2 class="animated fadeInUp delay02">예약하기</h2>
			<div class="completeArea">
				<div class="top">
					<p class="tit">예약이 완료되었습니다.</p>
					<p class="num">예약번호 : <span><%= info.get("intg_resv_no") %></span></p>
				</div>
				<ul class="caption">
					<li>예약정보는 고객정보에 입력한 연락처로 SMS 발송됩니다.</li>
					<li>고객문의 1522-3698</li>
				</ul>
				<h3>01 예약자 정보</h3>
				<table>
					<colgroup>
						<col width="30%">
						<col width="*">
					</colgroup>
					<tr>
						<th scope="col">예약자</th>
						<td><%= info.get("name") %></td>
					</tr>
					<tr>
						<th scope="col">휴대전화</th>
						<td><%= info.get("mobile1") %>-<%= info.get("mobile2") %>-<%= info.get("mobile3") %></td>
					</tr>
					<tr>
						<th scope="col">결제수단</th>
						<td><%= info.getInt("pay_amt", 0) == 0 ? "없음(전액할인)" : info.get("pay_type_name") %></td>
					</tr>
					<tr>
						<th scope="col">상태</th>
						<td>결제완료</td>
					</tr>
				</table>
				<h3>02 예약 상품</h3>
				<table>
					<colgroup>
						<col width="30%">
						<col width="*">
					</colgroup>
					<tr>
						<th scope="col">체크인</th>
						<td><%= info.get("chki_date") %></td>
					</tr>
					<tr>
						<th scope="col">체크아웃</th>
						<td><%= info.get("chot_date") %> (<%= SanghafarmUtils.getDateDiff(info.get("chki_date"), info.get("chot_date")) %>박)</td>
					</tr>
					<tr>
						<th scope="col">예약완료</th>
						<td>
							<ul class="roomList" id="room_list">
							</ul>
						</td>
					</tr>
				</table>								
				<h3>03 총 결제금액</h3>
				<table class="allPriceList">
					<colgroup>
						<col width="40%">
						<col width="*">
					</colgroup>
					<tr>
						<th scope="col">예약 소계</th>
						<td><div><span><%= Utils.formatMoney(info.get("tot_amt")) %>원</span></div></td>
					</tr>
					<tr>
						<th scope="col">쿠폰 할인</th>
						<td><div><span>-<%= Utils.formatMoney(info.get("coupon_amt")) %>원</span></div></td>
					</tr>
					<tr>
						<th scope="col">프로모션 코드 할인</th>
						<td><div><span>-<%= Utils.formatMoney(info.get("promocd_amt")) %>원</span></div></td>
					</tr>
					<tr>
						<th scope="col">매일 Do 포인트</th>
						<td><div><span>-<%= Utils.formatMoney(info.get("point_amt")) %>P</span></div></td>
					</tr>
					<tr>
						<th scope="col">기프트 카드</th>
						<td><div><span>-<%= Utils.formatMoney(info.get("giftcard_amt")) %>원</span></div></td>
					</tr>
					<tr>
						<th scope="col">총 할인액</th>
						<td><div><span>-<%= Utils.formatMoney(info.getInt("coupon_amt") + info.getInt("promocd_amt") + info.getInt("point_amt") + info.getInt("giftcard_amt")) %>원</span></div></td>
					</tr>
				</table>
				<div class="allPriceTxt">
					<strong>총 결제금액</strong>
					<p class="price"><%= Utils.formatMoney(info.get("pay_amt")) %><span>원</span></p>
				</div>
				<div class="btnArea">
					<a href="/mobile/hotel/index.jsp" class="btnStyle02 sizeM">메인으로</a>
					<a href="/mobile/mypage/reservation/hotel/list.jsp" class="btnStyle01 sizeM">예약 내역 조회</a>
				</div>
			</div>			
		</div>
		<div class="bannerArea">
			<a href="/mobile/brand/play/reservation/admission.jsp"><img src="/mobile/images/hotel/room/banner.jpg" alt="자연과 더 가까이, 상하농원 체험교실. 예약하기"></a>	
		</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body> 
</html>