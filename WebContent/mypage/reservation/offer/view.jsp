<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.hotel.*,
			org.json.simple.*" %>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(6));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("스페셜오퍼 예약현황"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}

	Param param = new Param(request);
	HotelOfferService svc = new HotelOfferService();
	
	Param info = svc.getReserveInfo(param.get("orderid"));
	if(!info.get("userid").equals(fs.getUserId())) {
		Utils.sendMessage(out, "존재하지 않은 예약입니다.");
		return;
	}
	
	List<Param> list = svc.getReserveRoomList(param.get("orderid"));
	int night = SanghafarmUtils.getDateDiff(info.get("chki_date"), info.get("chot_date"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
	function sendsms() {
		$.ajax({
			method : "POST",
			url : "/ajax/hofferSms.jsp",
			data : { orderid : "<%= info.get("orderid") %>" },
			dataType : "json"
		})
		.done(function(json) {
			alert(json.msg);
		});
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/mypage/snb.jsp" />
		<div id="contArea">
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<!-- 내용영역 -->			
			<p class="orderDetailHead">
				예약번호: <strong><%= param.get("orderid") %></strong>
<%
	if("N".equals(info.get("sms_yn"))) {
%>
				<span class="rightArea">※ SMS은 1회만 발송됩니다. <a href="javascript:sendsms()" class="btnTypeB">예약번호 SMS 발송</a></span>
<%
	}
%>
			</p>
			<table class="bbsForm typeB">
				<caption>예약자 상세 정보</caption>
				<colgroup>
					<col width="130"><col width=""><col width="130"><col width="">
				</colgroup>
				<tr>
					<th scope="row">예약자</th>
					<td><%= info.get("name") %></td>
					<th scope="row">휴대전화</th>
					<td><%= info.get("mobile1") %>-<%= info.get("mobile2") %>-<%= info.get("mobile3") %></td>
				</tr>
				<tr>
					<th scope="row">결제수단</th>
					<td><%= info.getInt("pay_amt", 0) == 0 ? "없음(전액할인)" : info.get("pay_type_name") %></td>
					<th scope="row">상태</th>
					<td><%= info.get("status_name") %></td>
				</tr>
			</table>
			
			<h2 class="typeB">예약상품</h2>
			<table class="bbsForm typeB">
				<caption>예약상품 목록</caption>
				<colgroup>
					<col width="130"><col width=""><col width="130"><col width="">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">체크인</th>
						<td><%= info.get("chki_date") %></td>
						<th scope="row">체크아웃</th>
						<td><%= info.get("chot_date") %> (<%= night %>박 <%= night + 1 %>일)</td>
					</tr>
					<tr>
						<th scope="row">예약내역</th>
						<td colspan="3" class="reserInfoCheck">
							<%= info.get("pnm") %><br>
<%
	for(Param row : list) {
%>						
							성인 <%= row.get("adult") %>, 어린이 <%= row.get("child") %><br>
<%
	}
%>
						</td>
					</tr>
					<tr>
						<th scope="row">추가요청사항</th>
						<td colspan="3"><%= Utils.safeHTML2(info.get("memo"), true) %></td>
					</tr>
				</tbody>
			</table>
			<h2 class="typeB">결제 금액</h2>
			<div class="totalPrice totalPrice2 typeB">
				<span>예약 소계 <em><strong><%= Utils.formatMoney(info.get("default_amt")) %></strong>원</em></span>
				<span class="math">-</span>
				<span>쿠폰 할인 <em><strong><%= Utils.formatMoney(info.get("coupon_amt", "0")) %></strong>원</em></span>
				<span class="math">-</span>
				<span>프로모션 코드 할인 <em><strong><%= Utils.formatMoney(info.get("promocd_amt", "0")) %></strong>원</em></span>
				<span class="math">-</span>
				<span>메일 Do 포인트 <em ><strong><%= Utils.formatMoney(info.get("point_amt", "0")) %></strong>P</em></span>
				<span class="math">-</span>
				<span>기프트 카드 <em><strong><%= Utils.formatMoney(info.get("giftcard_amt", "0")) %></strong>원</em></span>
				<span class="math">-</span>
				<span>스페셜오퍼 <em><strong><%= Utils.formatMoney(info.getInt("default_amt") - info.getInt("tot_amt")) %></strong>원</em></span>
				<span class="math">=</span>
				<span class="total">총 결제 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(info.get("pay_amt")) %></strong>원</em></span>
			</div>
			<!-- 
			<h2 class="typeB">기타</h2>
			<div class="otherCont">
				홍길동 고객님 고객센터 통해서 예약 변경
			</div>
			 -->
			<div class="btnArea">
				<a href="javascript:history.back()" class="btnTypeA">목록보기</a>
			</div>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>