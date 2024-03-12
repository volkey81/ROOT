<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.order.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(6));
	request.setAttribute("MENU_TITLE", new String("예약하기"));
%>
<%
	Param param = new Param(request);
	TicketOrderService svc = (new TicketOrderService()).toProxyInstance();
	List<Param> list = svc.getOrderItemListByModerid(param.get("morderid"));
	Param info = new Param();
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container" class="complete">
	<!-- 내용영역 -->
		<p class="reservationTit">예약하기</p>
		<div class="completeWrap">
			<p class="tit"><span>온라인 예약을 이용해 주셔서 감사합니다.</span>예약이 완료되었습니다.</p>
			<div class="reservationNum">
				<p class="num">예약번호 : <span><%= param.get("morderid") %></span></p>
				<ul>
					<li>예약번호 및 예약확인 링크는 문자로 안내드립니다.</li>
					<li>고객문의 <strong>1522-3698</strong></li>
				</ul>
			</div>
			<div class="completeCont">
				<h2>01 예약 세부 정보</h2>
				<table>
					<colgroup>
						<col width="33%">
						<col width="*">
						<col width="33%">
					</colgroup>
					<thead>
						<tr>
							<th scope="col" class="lineNone">이용예정일</th>
							<th scope="col">예약내용</th>
							<th scope="col">권종</th>
						</tr>
					</thead>
					<tbody>
<%
	for(int i = 0; i < list.size(); i++) {
		Param row = list.get(i);
%>
						<tr>
<%
		if(i == 0) {
			info = row.copy();
%>
							<td rowspan="<%= list.size() %>" class="lineNone"><%= row.get("reserve_date") %></td>
<%
		}
%>
							<td>
								<%= row.get("ticket_name") %>
<%
		if("01".equals(row.get("ticket_div"))) {
			 out.println("( 종일 )");
		} else {
			out.println("( " + row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) + " )");
		}
%>
							</td>
							<td><%= row.get("ticket_nm") %> ( <%= row.get("qty") %>장 )</td>
						</tr>
<%
	}
%>
					</tbody>
				</table>
			</div>
			<div class="completeCont cont02">
				<h2>02 고객 정보</h2>
				<table>
					<colgroup>
						<col width="20%">
						<col width="30%"> 
						<col width="20%">
						<col width="30%">
					</colgroup>
					<tr>
						<th scope="col" class="lineNone">성명</th>
						<td><%= info.get("name") %></td>
						<th scope="col">연락처</th>
						<td><%= info.get("mobile1") %>-<%= info.get("mobile2") %>-<%= info.get("mobile3") %></td>
					</tr>
					<tr>
						<th scope="col" class="lineNone">이메일</th>
						<td colspan="3"><%= info.get("email") %></td>
					</tr>
				</table>
			</div>
			
			<div class="completeCont cont03">
				<h2>03 결제정보</h2>
				<div class="totalPrice">
					<div class="totalPriceInfo">
						<h3>결제 정보</h3>
						<ul>
							<li>총 요금 합계<span class="price"><span class="fontTypeF"><%= Utils.formatMoney(info.get("tot_amt")) %></span>원</span></li>
							<li>쿠폰할인<span class="price"><span><%= Utils.formatMoney(info.get("coupon_amt", "0")) %></span>원</span></li>
							<li>Maeil Do 포인트<span class="price"><span><%= Utils.formatMoney(info.get("point_amt", "0")) %></span>p</span></li>
							<li>기프트 카드<span class="price"><span><%= Utils.formatMoney(info.get("giftcard_amt", "0")) %></span>원</span></li>
							<li>결제 수단<span class="price"><span><%= info.getInt("pay_amt", 0) == 0 ? "없음(전액할인)" : info.get("pay_type_name") %></span>결제</span></li>
						</ul>
						<p class="lastPrice">최종 결제액 <em><strong class="fontTypeA" id="pay_amt_txt"><%= Utils.formatMoney(info.get("pay_amt", "0")) %></strong>원</em></p>
					</div>
				</div>
				<div class="btnArea">
			 		<a href="/brand/" class="btnTypeA btnHotel sizeXL">상하농원 홈 이동</a>
			 		<a href="/mypage/reservation/list.jsp" class="btnTypeA sizeXL">예약 현황 이동</a>
			 	</div>
			</div>
		</div>

	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					