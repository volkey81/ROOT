<%@page import="com.sanghafarm.service.board.ReviewService"%>
<%@page import="com.efusioni.stone.common.SystemChecker"%>
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
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
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
	
	Param info = order.getOrderMasterInfo(param.get("orderid"));
	Param shipInfo = order.getOrderShipInfo(new Param("orderid", param.get("orderid"), "ship_seq", param.get("ship_seq", "1")));
	List<Param> list = order.getOrderItemList(param.get("orderid"));
	List<Param> memoList = order.getMemoList(param.get("orderid"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
//상품평작성
function showReviewPop(orderid, shipSeq, itemSeq, pid) {
	var url = "/mobile/popup/review.jsp?orderid=" + orderid + "&ship_seq=" + shipSeq + "&item_seq=" + itemSeq + "&pid=" + pid
	showPopupLayer(url);
}
//교환반품신청
function showRefundPop(rtype, orderid, shipSeq) {
	var url ='/mobile/popup/refund.jsp?rtype=' + rtype + "&orderid=" + orderid + "&ship_seq=" + shipSeq;
	showPopupLayer(url);
}
//배송요청일변경
function showDatePop(orderid, shipSeq) {
	showPopupLayer('/mobile/popup/deliveryDate.jsp?orderid=' + orderid + "&ship_seq=" + shipSeq);
}
//환불계좌
function showAccountPop(orderid) {
	showPopupLayer('/mobile/popup/account.jsp?orderid=' + orderid);
}
function cancelOrder(orderid, payType, status) {
	if(confirm("취소하시겠습니까?")) {
		$("#orderid").val(orderid);
		$("#mode").val("CANCEL");

		if(payType == '003' && status != '110') {
			showAccountPop(orderid);
		} else {
			ajaxSubmit($("#orderForm"), function(json) {
				alert(json.msg);
				document.location.reload();
			});
		}
	}
}

function confirmOrder(orderid, shipSeq) {
	$("#orderid").val(orderid);
	$("#ship_seq").val(shipSeq);
	$("#mode").val("CONFIRM");

	ajaxSubmit($("#orderForm"), function(json) {
		alert(json.msg);
		document.location.reload();
	});
}

function showReceipt(orderid, payType) {
	$.getJSON("payinfo.jsp?orderid=" + orderid + "&pay_type=" + payType, function(json) {
		if(json.result) {
			if(payType == "005") {
				var status = "toolbar=no,location=directories=status=yes,menubar=scrollbars=resizable=width=420,height=540";
				var url = "https://mms.cnspay.co.kr/trans/retrieveIssueLoader.do?TID="+json.tid+"&type=0";
				window.open(url, "popupIssue", status);
			} else if(payType == "006") {
				var url = "https://<%= SystemChecker.isReal() ? "" : "alpha-" %>bill.payco.com/outseller/receipt/" + json.order_no;
				window.open(url, "RECEIPT", "width=500,height=700");
			} else {
				showReceiptByTID(json.lgd_mid, json.lgd_tid, json.authdata);	
			}
		} else {
			alert("영수증 출력에 오류가 발생했습니다.");
		}
	});
}
<%
if(fs.isApp() && "android".equals(fs.getAppOS())){
%>
function sendFileData(orgName, image, division){
	var params = {
			"image": image,
			"orgName" : orgName,
			"board" : "01"
	}
	$.ajax({
	  type: "POST",
	  url: "/mobile/popup/appProc.jsp",
	  dataType:'json',
	  contentType: "application/x-www-form-urlencoded; charset=utf-8",
	  data: params,
	  success: function(data) {
		  if(data.isOk == "true"){
			  var ifra = document.getElementById("iframePopLayer113").contentWindow;
			  ifra.sendData(division, data.imagename);
		  } else {
			  alert(data.msg);  
		  }
		},
		error: function(data) {
			alert(data.msg);
		} 
	});
}
<%
}
%>
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->
		<form name="orderForm" id="orderForm" method="POST" action="/mypage/order/orderProc.jsp">
			<input type="hidden" name="mode" id="mode" />
			<input type="hidden" name="orderid" id="orderid" />
			<input type="hidden" name="ship_seq" id="ship_seq" />
			<input type="hidden" name="item_seq" id="item_seq" />
		</form>
		<h2 class="typeA"><a href="#" onclick="showTblDetail(this); return false" class="icoFold db">주문자 정보</a></h2>
		<table class="bbsForm typeB tblDetail">
			<caption>주문자 상세 정보</caption>
			<colgroup>
				<col width="90"><col width="">
			</colgroup>
			<thead>
				<tr>
					<th scope="row">주문번호</th>
					<td><%=info.get("orderid") %></td>
				</tr>
			</thead>
			<tbody style="display:none;">
				<tr>
					<th scope="row">구매자</th>
					<td><%=info.get("name") %></td>
				</tr>
				<tr>
					<th scope="row">휴대전화</th>
					<td><%=info.get("mobile1") %>-<%=info.get("mobile2") %>-<%=info.get("mobile3") %></td>
				</tr>
				<tr>
					<th scope="row">결제수단</th>
					<td><%= info.getInt("pay_amt", 0) == 0 ? "없음(전액할인)" : info.get("pay_type_name") %></td>
				</tr>
				<tr>
					<th scope="row">상태</th>
					<td><%=shipInfo.get("status_name") %></td>
				</tr>
				<tr>
					<th scope="row">품절옵션</th>
					<td><%= info.get("soldout_opt_name") %></td>
				</tr>
			</tbody>
		</table>
		
		<h2 class="typeA"><a href="#" onclick="showTblDetail(this); return false" class="icoFold db">수취인 정보</a></h2>
		<table class="bbsForm typeB tblDetail">
			<caption>수취인 상세 정보</caption>
			<colgroup>
				<col width="90"><col width="">
			</colgroup>
			<thead>
				<tr>
					<th scope="row">수취인</th>
					<td><%=shipInfo.get("ship_name") %></td>
				</tr>
			</thead>
			<tbody style="display:none;">
				<tr>
					<th scope="row">휴대전화</th>
					<td><%=shipInfo.get("ship_mobile1") %>-<%=shipInfo.get("ship_mobile2") %>-<%=shipInfo.get("ship_mobile3") %></td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td><%= StringUtils.equals("@", shipInfo.get("ship_email")) ? "" : shipInfo.get("ship_email") %></td>
				</tr>
				<tr>
					<th scope="row">일반전화</th>
					<td><%=shipInfo.get("ship_tel1") %>-<%=shipInfo.get("tel2") %>-<%=shipInfo.get("tel3") %></td>
				</tr>
				<tr>
					<th scope="row">배송지</th>
					<td><%=shipInfo.get("ship_post_no") %>) <%= shipInfo.get("ship_addr1") %> <%= shipInfo.get("ship_addr2") %></td>
				</tr>
				<tr>
					<th scope="row">배송 요청사항</th>
					<td><%= Utils.safeHTML(shipInfo.get("ship_memo"), true) %></td>
				</tr>
			</tbody>
		</table>
		
		<h2 class="typeA">주문상품</h2>
		<div class="orderPdtList typeB">
			<ul>
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
			String[] items = shipInfo.get("ITEMS").split("::", 8);
%>			
				<li <%= "Y".equals(row.get("routine_yn")) ? "class=\"regular\"" : "" %>>
					<p class="thumb"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt=""></a></p>
					<div class="content">
						<div class="tit"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
							<%= row.get("pnm") %>
							<p class="opt"><%= row.get("sub_pnm") %></p>
							<p class="btn">
<%
			if(!"".equals(row.get("review_seq"))) {
%>
								<a class="btnTypeE sizeXS">상품평 작성완료</a>
<%
			} else if("170".equals(row.get("status"))) {
%>
								<a href="#none" onclick="showReviewPop('<%= info.get("orderid") %>', '<%= row.get("ship_seq") %>', '<%= row.get("item_seq") %>', '<%= row.get("pid") %>');return false;" class="btnTypeC sizeXS">상품평쓰기</a>
<%
			} else {
%>
								<a href="#none" onclick="javascript:alert('상품을 구매하시고, 배송이 완료된 회원께서 작성하실 수 있습니다.');" class="btnTypeC sizeXS">상품평쓰기</a>
<%
			}
%>
							</p>	
						</a></div>
						<p class="cnt"><strong><%= Utils.formatMoney(row.get("qty")) %></strong>개</p>	
					</div>
<%
			if("Y".equals(row.get("routine_yn"))) {
%>			
					<div class="foot">
						<p class="cycle"><strong>정기배송상품</strong><%= row.get("routine_period") %>주마다 / <%= routineDay %>/ <%= row.get("routine_cnt") %>회 / <%= row.get("delivery_date") %></p>
					</div>	
<%
			}
%>
				</li>
<%
		}
	}
%>
			</ul>
		</div>
		
		<div class="totalPrice">
			<p>상품 소계 <em><strong><%= Utils.formatMoney(info.getInt("tot_amt")) %></strong>원</em></p>
			<p>총 배송비 <em><strong><%= Utils.formatMoney(info.getInt("ship_amt")) %></strong>원</em></p>
			<p>총 할인 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(info.getInt("coupon_sale_amt") + info.getInt("routine_sale_amt") + info.getInt("coupon_cart_amt") + info.getInt("coupon_ship_amt") + info.getInt("point_amt") + info.getInt("giftcard_amt")) %></strong>원</em></p>
			<p class="total">총 결제 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(info.getInt("pay_amt")) %></strong>원</em></p>
		</div>
<%
	if(memoList != null && memoList.size() > 0) {
%>

		<h2 class="typeA">배송메모</h2>
		<div class="deliveryMemo typeB">
			<ul>
<%
		for(Param row : memoList) {
%>
				<li><span><%= row.get("regist_date") %></span><%= Utils.safeHTML(row.get("memo"), true) %></li>
<%
		}
%>
			</ul>
		</div>
<%
	}
%>
		
		<div class="btnArea">
<%
	if(StringUtils.equals("Y", info.get("IS_CANCELABLE"))) {
%>
			<span><a href="#none" class="btnTypeC sizeS" onclick="cancelOrder('<%= info.get("ORDERID") %>', '<%= info.get("PAY_TYPE") %>', '<%= shipInfo.get("STATUS") %>')">주문취소</a></span>
<%
	}
	if("160".indexOf(shipInfo.get("STATUS")) != -1) {
%>
			<span><a href="#none" class="btnTypeE sizeS" onclick="showRefundPop('C', '<%= info.get("ORDERID") %>', '<%= shipInfo.get("SHIP_SEQ") %>'); return false;">교환신청</a></span>
			<span><a href="#none" class="btnTypeE sizeS" onclick="showRefundPop('R', '<%= info.get("ORDERID") %>', '<%= shipInfo.get("SHIP_SEQ") %>'); return false;">반품신청</a></span>
<%
	}
%>			
		</div>
		<p class="caution typeB">결제영수증 정보는 PC용 사이트에서 가능합니다.</p>
		<div class="btnArea">			
			<span><a href="./list.jsp" class="btnTypeB">목록보기</a></span>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>