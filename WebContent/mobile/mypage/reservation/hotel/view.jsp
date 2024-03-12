<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.hotel.*,
			org.json.simple.*" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("예약 내역 조회"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<%
	Param param = new Param(request);
	RMSApiService rms = new RMSApiService();
	HotelReserveService svc = new HotelReserveService();
	
	JSONObject json = rms.detail(param);
	JSONArray list = (JSONArray) json.get("RSV_LIST");
	JSONObject info = (JSONObject) list.get(0); 
	Param p = svc.getHreserveInfoByResno(param.get("intg_resv_no"));
	String mobile = info.get("PHONO").toString().substring(0, 3); 
	if(info.get("PHONO").toString().length() == 10) {
		mobile += "-" + info.get("PHONO").toString().substring(3, 6);
		mobile += "-" + info.get("PHONO").toString().substring(6, 10);
	} else {
		mobile += "-" + info.get("PHONO").toString().substring(3, 7);
		mobile += "-" + info.get("PHONO").toString().substring(7, 11);
	}
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	function sendsms() {
		$.ajax({
			method : "POST",
			url : "/ajax/hotelSms.jsp",
			data : { intg_resv_no : "<%= param.get("intg_resv_no") %>" },
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
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<h1 class="typeA"><%=MENU_TITLE %></h1>
<%
	if("R".equals(info.get("RESV_ST_GBCD"))) {
%>
		<div class="btnArea">
			※ SMS은 1회만 발송됩니다. <a href="javascript:sendsms()" class="btnTypeA resNumBtn">예약번호 SMS 발송</a>
		</div>
<%
	}
%>
		<!-- 내용영역 -->	
		<h2 class="typeB">예약자 정보</h2>		
		<table class="bbsForm typeB">
			<caption>예약자 상세 정보</caption>
			<colgroup>
				<col width="90"><col width="">
			</colgroup>
			<tr>
				<th scope="row">예약번호</th>
				<td><%= param.get("intg_resv_no") %></td>
			</tr>
			<tr>
				<th scope="row">예약자</th>
				<td><%= info.get("GUS_NM") %></td>
			</tr>
			<tr>
				<th scope="row">휴대전화</th>
				<td><%= mobile %></td>
			</tr>
			<tr>
				<th scope="row">결제수단</th>
				<td><%= p.getInt("pay_amt", 0) == 0 ? "없음(전액할인)" : p.get("pay_type_name") %></td>
			</tr>
			<tr>
				<th scope="row">상태</th>
				<td>
<%
	if("R".equals(info.get("RESV_ST_GBCD"))) out.println("예약완료");
	else if("I".equals(info.get("RESV_ST_GBCD"))) out.println("이용완료");
	else if("C".equals(info.get("RESV_ST_GBCD"))) out.println("예약취소");
%>					
				</td>
			</tr>
		</table>
			
		<h2 class="typeB">예약상품</h2>
		<table class="bbsForm typeB">
			<caption>예약 상품 상세 정보</caption>
			<colgroup>
				<col width="90"><col width="">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">체크인</th>
					<td><%= info.get("CHKI_DATE").toString().substring(0, 4) %>.<%= info.get("CHKI_DATE").toString().substring(4, 6) %>.<%= info.get("CHKI_DATE").toString().substring(6, 8) %></td>
				</tr>
				<tr>
					<th scope="row">체크아웃</th>
					<td><%= info.get("CHOT_DATE").toString().substring(0, 4) %>.<%= info.get("CHOT_DATE").toString().substring(4, 6) %>.<%= info.get("CHOT_DATE").toString().substring(6, 8) %> (<%= info.get("LODG_CNT") %>박 <%= Integer.parseInt((String) info.get("LODG_CNT")) + 1 %>일)</td>
				</tr>
				<tr>
					<th scope="row" rowspan="2">예약내역</th>
					<td class="roomInfoCheck">
<%
	for(int i = 0; i < list.size(); i++) {
		JSONObject row = (JSONObject) list.get(i);
%>						
						<strong><%= row.get("ROOM_KND_NM") %></strong>
						<span class="ind">성인 <%= row.get("PERS_ADLT") %>, 어린이 <%= row.get("PERS_KIDS") %></span>
						<p>
							<strong>추가 요청사항</strong> 
							<span class="ind"><%= Utils.nvl((String)row.get("REM_CNTN")) %></span>
						</p>
<%
	}
%>
					</td>
				</tr>
			</tbody>
		</table>
		<h2 class="typeB">결제 금액</h2>
		<div class="totalPrice totalPrice2 typeB">
			<p>예약 소계 <em><strong><%= Utils.formatMoney(p.get("tot_amt")) %></strong>원</em></p>
			<p>쿠폰 할인 <em><strong><%= Utils.formatMoney(p.get("coupon_amt")) %></strong>원</em></p>
			<p>프로모션 코드 할인 <em><strong><%= Utils.formatMoney(p.get("promocd_amt")) %></strong>원</em></p>
			<p>매일 Do 포인트<em><strong><%= Utils.formatMoney(p.get("point_amt")) %></strong>원</em></p>
			<p>기프트 카드 <em><strong><%= Utils.formatMoney(p.get("giftcard_amt")) %></strong>원</em></p>
			<p class="total">총 결제 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(p.get("pay_amt")) %></strong>원</em></p>
		</div>
		<!-- 
		<h2 class="typeB">기타</h2>
		<div class="otherCont">
			홍길동 고객님 고객센터 통해서 예약 변경ㄹㄴ아머린어라ㅣㅇㄴㄹ
		</div>
		 -->
		<div class="btnArea">
			<span><a href="javascript:history.back()" class="btnTypeB">목록보기</a></span>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>