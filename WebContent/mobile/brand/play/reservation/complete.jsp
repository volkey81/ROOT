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
<jsp:include page="/mobile/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="reservationWrap">
	<!-- 내용영역 -->
		<div class="reserComplete">
			온라인 예약을 이용해 주셔서 감사합니다.
			<strong>예약이 완료되었습니다.</strong>
			<div class="info">
				<p class="reserNum">예약번호: <%= param.get("morderid") %></p>
				<ul class='caution'>
					<li>예약번호 및 예약확인 링크는 문자로 안내드립니다.</li>
					<li>고객문의 1522-3698</li>
				</ul>
			</div>
		</div>
		<div class="reserForm">
			<h2 class="typeA"><strong class="num">01</strong> 예약 세부 정보</h2>
			<table class="reserDetail">
				<caption>예약 상세내역</caption>
				<colgroup>
					<col width="33"><col width="33"><col width="33">
				</colgroup>
				<tbody>
					<tr>
						<th scope="col">이용예정일</th>
						<th scope="col">예약내용</th>
						<th scope="col">권종</th>
					</tr>
<%
	for(int i = 0; i < list.size(); i++) {
		Param row = list.get(i);
%>
				 	<tr>
<%
		if(i == 0) {
			info = row.copy();
%>
						<td rowspan="<%= list.size() %>"><%= row.get("reserve_date") %></td>
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
<%
	}
%>
					</tr>
				</tbody>
			</table>			
			<h2 class="typeA"><strong class="num">02</strong> 고객 정보</h2>
			<table class="subscriberDetail">
				<caption>예약자 정보 상세내역</caption>
				<colgroup>
					<col width="70"><col width="">
				</colgroup>
				<tr>
					<th scope="row">성명</th>
					<td><%= info.get("name") %></td>
				</tr>
				<tr>
					<th scope="row">휴대전화</th>
					<td><%= info.get("mobile1") %>-<%= info.get("mobile2") %>-<%= info.get("mobile3") %></td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td><%= info.get("email") %></td>
				</tr>
			</table>
			
			<!-- //step2 예약상품 -->
			<h2 class="typeA"><strong class="num">03</strong> 결제정보</h2>
			<div class="resultPrice">
				<dl>
					<dt>총 요금 합계</dt><dd><span><%= Utils.formatMoney(info.get("tot_amt")) %></span>원</dd>
					<dt>쿠폰 할인</dt><dd><span><%= Utils.formatMoney(info.get("coupon_amt", "0")) %></span>원</dd>
					<dt>Maeil Do포인트</dt><dd><span><%= Utils.formatMoney(info.get("point_amt", "0")) %></span>p</dd>
					<dt>기프트 카드</dt><dd><span><%= Utils.formatMoney(info.get("giftcard_amt", "0")) %></span>원</dd>
					<dt>결제 수단</dt><dd><span class="fontTypeE"><%= info.getInt("pay_amt", 0) == 0 ? "없음(전액할인)" : info.get("pay_type_name") %></span> 결제</dd>
					<dt class="lastPrice">최종 결제액 </dt><dd><strong class="fontTypeA"><%= Utils.formatMoney(info.get("pay_amt", "0")) %></strong>원</dd>
				</dl>
			</div>
			<div class="btnArea ac">
		 		<span><a href="/mobile/brand/index.jsp" class="btnTypeB sizeL">파머스 빌리지 홈 이동</a></span>
		 		<span><a href="/mobile/mypage/reservation/list.jsp" class="btnTypeA sizeL">예약 현황 이동</a></span>
		 	</div>
		</div><!-- //reserForm -->
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					