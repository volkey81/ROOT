<%@page import="com.sanghafarm.service.board.ReviewService"%>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.order.OrderService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("주문 내역 조회"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	if(StringUtils.isEmpty(param.get("orderid"))) {
		Utils.sendMessage(out, "잘못된 경로로 접근하였습니다.");
		return;
	}
	String userId = StringUtils.EMPTY;
	if (fs.isLogin()) {
		userId = fs.getUserId();
	} else {
		userId = fs.getTempUserId();
	}
	
	param.set("userid", fs.getUserId());
	param.set("status_type", "1");
	
	// 주문/배송 현황
	OrderService order = (new OrderService()).toProxyInstance();
	// 주문 리스트
	param.set("POS_STA", 0);
	param.set("POS_END", Integer.MAX_VALUE);
	List<Param> orderList = order.getOrderList(param);
	
	
	Param info = order.getOrderMasterInfo(param.get("orderid"));
	Param shipInfo = order.getOrderShipInfo(new Param("orderid", param.get("orderid"), "ship_seq", param.get("ship_seq", "1")));
	List<Param> list = order.getOrderItemList(param.get("orderid"));
	List<Param> memoList = order.getMemoList(param.get("orderid"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
//상품평작성
function showReviewPop(orderid, shipSeq, itemSeq, pid) {
	var url = "/popup/review.jsp?orderid=" + orderid + "&ship_seq=" + shipSeq + "&item_seq=" + itemSeq + "&pid=" + pid
	showPopupLayer(url, '630');
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
			
			<p class="orderDetailHead">주문번호: <strong><%=info.get("orderid") %></strong></p>
			<table class="bbsForm typeB">
				<caption>구매자 상세 정보</caption>
				<colgroup>
					<col width="130"><col width=""><col width="130"><col width="">
				</colgroup>
				<tr>
					<th scope="row">구매자</th>
					<td><%=info.get("name") %></td>
					<th scope="row">휴대전화</th>
					<td><%=info.get("mobile1") %>-<%=info.get("mobile2") %>-<%=info.get("mobile3") %></td>
				</tr>
				<tr>
					<th scope="row">결제수단</th>
					<td><%= info.getInt("pay_amt", 0) == 0 ? "없음(전액할인)" : info.get("pay_type_name") %></td>
					<th scope="row">상태</th>
					<td><%=shipInfo.get("status_name") %></td>
				</tr>
			</table>
			<table class="bbsForm typeB">
				<caption>수취인 상세 정보</caption>
				<colgroup>
					<col width="130"><col width=""><col width="130"><col width="">
				</colgroup>
				<tr>
					<th scope="row">수취인</th>
					<td><%=shipInfo.get("ship_name") %></td>
					<th scope="row">휴대전화</th>
					<td><%=shipInfo.get("ship_mobile1") %>-<%=shipInfo.get("ship_mobile2") %>-<%=shipInfo.get("ship_mobile3") %></td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td><%= StringUtils.equals("@", shipInfo.get("ship_email")) ? "" : shipInfo.get("ship_email") %></td>
					<th scope="row">일반전화</th>
					<td><%=shipInfo.get("ship_tel1") %>-<%=shipInfo.get("tel2") %>-<%=shipInfo.get("tel3") %></td>
				</tr>
				<tr>
					<th scope="row">배송지</th>
					<td colspan="3"><%=shipInfo.get("ship_post_no") %>) <%= shipInfo.get("ship_addr1") %> <%= shipInfo.get("ship_addr2") %></td>
				</tr>
				<tr>
					<th scope="row">배송 요청사항</th>
					<td colspan="3"><%= Utils.safeHTML(shipInfo.get("ship_memo"), true) %></td>
				</tr>
				<tr>
					<th scope="row">품절옵션</th>
					<td colspan="3"><%= info.get("soldout_opt_name") %></td>
				</tr>
			</table>
			<h2 class="typeB">주문상품</h2>
			<table class="bbsList typeB">
				<caption>주문상품 목록</caption>
				<colgroup>
					<col width="136"><col width=""><col width="150">
				</colgroup>
				<tbody>
<%
	if(list.size() > 0) {
		for(Param row : list) {
			String routineDay = row.get("routine_day");
			routineDay = routineDay.replaceAll("1", "일");
			routineDay = routineDay.replaceAll("2", "월");
			routineDay = routineDay.replaceAll("3", "화");
			routineDay = routineDay.replaceAll("4", "수");
			routineDay = routineDay.replaceAll("5", "목");
			routineDay = routineDay.replaceAll("6", "금");
			routineDay = routineDay.replaceAll("7", "토");
%>
					<tr <%= "Y".equals(row.get("routine_yn")) ? "class=\"regular\"" : "" %>><!-- 정기배송일때 class="regular" -->
						<td><p class="thumb"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt="" width="94" height="104"></a></p></td>
						<td class="al pName"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
							<%= row.get("pnm") %>
							<p class="opt"><%= row.get("sub_pnm") %></p>
							<p class="btn">
<%
			if(!"".equals(row.get("review_seq"))) {
%>
								<a href="#none" class="btnTypeE sizeXS">상품평 작성완료</a>
<%
			} else if("170".equals(row.get("status"))) {
%>
								<a href="#none" onclick="showReviewPop('<%= info.get("orderid") %>', '<%= row.get("ship_seq") %>', '<%= row.get("item_seq") %>', '<%= row.get("pid") %>');return false;" class="btnTypeC sizeXS">상품평쓰기</a>
						
<%
			} else {
%>
								<a href="#none" onclick="alert('상품을 구매하시고, 배송이 완료된 회원께서 작성하실 수 있습니다.');return false;" class="btnTypeC sizeXS">상품평쓰기</a>
<%
			}
%>
							</p>
<%
			if("Y".equals(row.get("routine_yn"))) {
%>			
							<p class="cycle"><strong>정기배송상품</strong><%= row.get("routine_period") %>주마다 / <%= routineDay %>/ <%= row.get("routine_cnt") %>회 / <%= row.get("delivery_date") %></p>
<%
			}
%>
						</a></td>
						<td class="last"><%= Utils.formatMoney(row.get("qty")) %>개</td>
					</tr>
<%
		}
	}
%>
				</tbody>
			</table>
			<h2 class="typeB">결제 금액</h2>
			<div class="totalPrice">
				<span>상품 소계 <em><strong><%= Utils.formatMoney(info.getInt("tot_amt")) %></strong>원</em></span>
				<span class="math">+</span>
				<span>총 배송비 <em><strong><%= Utils.formatMoney(info.getInt("ship_amt")) %></strong>원</em></span>
				<span class="math">-</span>
				<span>총 할인 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(info.getInt("coupon_sale_amt") + info.getInt("routine_sale_amt") + info.getInt("coupon_cart_amt") + info.getInt("coupon_ship_amt") + info.getInt("point_amt") + info.getInt("giftcard_amt")) %></strong>원</em></span>
				<span class="math">=</span>
				<span class="total">총 결제 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(info.getInt("pay_amt")) %></strong>원</em></span>
			</div>
<%
	if(memoList != null && memoList.size() > 0) {
%>
			<h2 class="typeB">배송 메모</h2>
			<table class="bbsList typeB">
				<caption>배송메모 목록</caption>
				<colgroup>
					<col width="20%">
					<col width="*">
				</colgroup>
				<tbody>
<%
		for(Param row : memoList) {
%>
					<tr>
						<td><%= row.get("regist_date") %></td>
						<td class="al"><%= Utils.safeHTML(row.get("memo"), true) %></td>
					</tr>
<%
		}
%>
				</tbody>
			</table>
<%
	}
%>
			
			
			<div class="btnArea">
				<a href="./list.jsp" class="btnTypeA">목록보기</a>
			</div>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>