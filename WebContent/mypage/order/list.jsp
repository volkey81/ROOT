<%@page import="com.sanghafarm.service.board.ReviewService"%>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="com.efusioni.stone.common.Config"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="java.util.Calendar"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.order.OrderService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/common.jsp" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("주문배송조회"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	FrontSession fs = FrontSession.getInstance(request, response);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	Param param = new Param(request);
	param.set("userid", fs.getUserId());
	param.set("status_type", "1");
	
// 	param.set("startDate", param.get("startDate").replaceAll("&#45;", "-"));
// 	param.set("endDate", param.get("endDate").replaceAll("&#45;", "-"));
	
	// 주문/배송 현황
	OrderService order = (new OrderService()).toProxyInstance();
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	
	// 주문 리스트
	List<Param> orderList = order.getOrderList(param);
	
	// 주문 갯수
	int totalCount = order.getOrderListCount(param);
	
	// 4일 후
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DATE, 4);
	String fourDays = Utils.getTimeStampString(cal.getTime(), "yyyy.MM.dd");
	
	// 8월 정기배송 특가 상품 코드
	String eventPid = Config.get("evend1.pid." + SystemChecker.getCurrentName());
	
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<link rel="stylesheet" type="text/css" href="/css/jquery-ui-timepicker-addon.css">
<script type="text/javascript" src="/js/timepicker/jquery-ui-timepicker-addon.js"></script>
<script type="text/javascript" src="/js/timepicker/localization/jquery-ui-timepicker-ko.js"></script>
<script type="text/javascript" src="https://pgweb.uplus.co.kr<%= SystemChecker.isReal() ? "" : ":7085" %>/WEB_SERVER/js/receipt_link.js"></script>
<script>
	$(function (){
		$("input[name='startDate']").datepicker({
            showOn: "button",
            buttonImage: "/images/btn/btn_calender.gif",
            dateFormat: 'yy-mm-dd',
            buttonImageOnly: true
        });
		$("input[name='endDate']").datepicker({
            showOn: "button",
            buttonImage: "/images/btn/btn_calender.gif",
            dateFormat: 'yy-mm-dd',
            buttonImageOnly: true
        });
		
	});
	function goMonthly(beforeMonth){
		
		var today = new Date();
		var tY = today.getFullYear();
		var tM = (today.getMonth() + 1);
		var tD = today.getDate();
		if(tM<10) tM = "0" + tM;
		if(tD<10) tD = "0" + tD;
		var fullDay = tY + "-" + tM + "-" + tD;
		
		var user_date = new Date();
		var uY = user_date.getFullYear();
		var uM;
		if ((user_date.getMonth() + 1) <= beforeMonth) {
			uY = uY - 1;
			uM = 12 + (user_date.getMonth() + 1) - beforeMonth; 
		} else {
			uM = (user_date.getMonth() + 1) - beforeMonth;	
		}
		var uD = user_date.getDate();
		if(uM<10) uM = "0" + uM;
		if(uD<10) uD = "0" + uD;
		var before = uY + "-" + uM + "-" + uD; 
		
		$("input[name='startDate']").val(before);
		$("input[name='endDate']").val(fullDay);
		$("#searchForm").submit();
	}
	
	//상품평작성
	function showReviewPop(orderid, shipSeq, itemSeq, pid) {
		var url = "/popup/review.jsp?orderid=" + orderid + "&ship_seq=" + shipSeq + "&item_seq=" + itemSeq + "&pid=" + pid
		showPopupLayer(url, '630');
	}
	//교환반품신청
	function showRefundPop(rtype, orderid, shipSeq) {
		var url ='/popup/refund.jsp?rtype=' + rtype + "&orderid=" + orderid + "&ship_seq=" + shipSeq;
		showPopupLayer(url, '630');
	}
	//배송요청일변경
	function showDatePop(orderid, shipSeq) {
		showPopupLayer('/popup/deliveryDate.jsp?orderid=' + orderid + "&ship_seq=" + shipSeq, '580');
	}
	//환불계좌
	function showAccountPop(orderid) {
		showPopupLayer('/popup/account.jsp?orderid=' + orderid, '580');
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
				} else if(payType == "008") {
					var status = "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,width=420,height=540";
					var url = "https://mms.cnspay.co.kr/trans/retrieveIssueLoader.do?TID="+json.tid+"&type=0";
					window.open(url,"popupIssue",status);
				} else {
					showReceiptByTID(json.lgd_mid, json.lgd_tid, json.authdata);	
				}
			} else {
				alert("영수증 출력에 오류가 발생했습니다.");
			}
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
		<form name="orderForm" id="orderForm" method="POST" action="orderProc.jsp">
			<input type="hidden" name="mode" id="mode" />
			<input type="hidden" name="orderid" id="orderid" />
			<input type="hidden" name="ship_seq" id="ship_seq" />
			<input type="hidden" name="item_seq" id="item_seq" />
		</form>
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<!-- 내용영역 -->
			<div class="dateSrch">
				<form name="searchForm" id="searchForm">
					<input type="hidden" name="period" id="period" />
					<fieldset>
						<legend>기간, 상품명으로 검색</legend>
						<p class="cal">
							<strong>기간</strong>
							<input type="text" id="startDate" name="startDate" title="시작일" value="<%= Utils.safeHTML(param.get("startDate")) %>" readonly><!-- <img name="startDate" src="/images/btn/btn_calender.gif" alt="달력"> -->
							<span>~</span>
							<input type="text" id="endDate" name="endDate" title="종료일" value="<%= Utils.safeHTML(param.get("endDate")) %>" readonly><!-- <img name="endDate" src="/images/btn/btn_calender.gif" alt="달력"> -->
						</p>
						<p class="monthly">
							<strong>최근</strong>		
							<a href="#" onClick="goMonthly(1); return false;" class="btnTypeA">1개월</a>
							<a href="#" onClick="goMonthly(3); return false;" class="btnTypeA">3개월</a>
							<a href="#" onClick="goMonthly(6); return false;" class="btnTypeA">6개월</a>
						</p>
						<p class="name">
							<label for="pName">상품명</label>
							<input type="text" name="pName" id="pName" value="<%= Utils.safeHTML2(param.get("pName")) %>">
						</p>
						<p class="btn"><a href="javascript:$('#searchForm').submit()" class="btnTypeB">조회</a></p>
					</fieldset>
				</form>
			</div>
			
			<ul class="caution">
				<li>[결제완료]이전 단계일 경우, [주문배송조회] 페이지 내 직접 취소 가능합니다.<br>
				[상품준비중] 단계일 경우, 생산 및 배송이 시작되어 주문취소가 불가합니다.</li>
				<li>주문 상품의 부분취소는 불가합니다. 전체 주문취소 후 재구매 해주세요.</li>
				<li>배송완료 후 2~3일 후 구매확정 상태로 자동 전환 됩니다.</li>
			</ul>
			<table class="bbsList">
				<caption>주문배송 내역 목록</caption>
				<colgroup>
					<col width="180"><col width=""><col width="130"><col width="110"><col width="110">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">주문일시/주문번호</th>
						<th scope="col">주문내역</th>
						<th scope="col">배송요청일</th>
						<th scope="col">상태</th>
						<th scope="col">관리</th>
					</tr>
				</thead>
				<tbody>
					<tbody>
<% 
	if (CollectionUtils.isNotEmpty(orderList)) {
		for (Param row : orderList) {
			String[] items = row.get("ITEMS").split("::", 8);
%>
					<tr>
						<th scope="row"><%= row.get("ORDER_DATE_FOR_INDEX") %><p class="fs"><a href="view.jsp?orderid=<%= row.get("ORDERID") %>&ship_seq=<%= row.get("SHIP_SEQ") %>" class="fontTypeC">(<%= row.get("ORDERID") %>_<%= row.get("SHIP_SEQ") %>)</a></p></th>
						<td class="tit pName"><%=StringUtils.isNotEmpty(items[3]) ? items[3] : "" %><p class="opt"><%=StringUtils.isNotEmpty(items[4]) ? items[4] : "" %>
						</td>
						<td><%= row.get("DELIVERY_DATE", "-") %>
<%
		if(!eventPid.equals(row.get("sub_pid")) && "2,6".indexOf(row.get("DELIVERY_TYPE")) != -1 && row.get("STATUS").compareTo("120") <= 0) {
			if(row.get("DELIVERY_DATE").compareTo(fourDays) >= 0) {
%>
							<p class="btn"><a href="#" onclick="showDatePop('<%= row.get("ORDERID") %>' ,'<%= row.get("SHIP_SEQ") %>'); return false" class="btnTypeC sizeXS">배송요청일변경</a></p>
<%
			}
		}
%>
						</td>
						<td><%= row.get("FE_NAME") %><br/>
<%
		if("150,160".indexOf(row.get("status")) != -1) {
			if("001".equals(row.get("delivery_co"))) {
%>
							<a href="https://service.epost.go.kr/trace.RetrieveDomRigiTraceList.comm?sid1=<%= row.get("invoice_no") %>&displayHeader=N" target="_blank" class="btnTypeC sizeXS">조회</a>
<%
			} else if("004".equals(row.get("delivery_co"))) {
%>
							<a href="https://www.ilogen.com/web/personal/trace/<%= row.get("invoice_no").replaceAll("-", "") %>" target="_blank" class="btnTypeC sizeXS">조회</a>
<%
			}
		}
%>
</td>
						<td>
<%
		if(StringUtils.equals("Y", row.get("IS_CANCELABLE"))) {
%>
							<p class="btn"><a href="#none" class="btnTypeC sizeXS" onclick="cancelOrder('<%= row.get("ORDERID") %>', '<%= row.get("PAY_TYPE") %>', '<%= row.get("STATUS") %>')">주문취소</a></p>
<%
		}
		if(!"0".equals(row.get("pay_amt")) && StringUtils.equals("170", row.get("STATUS"))) {
			if("007,009".indexOf(row.get("pay_type")) == -1) {
%>
							<p class="btn"><a href="#none" class="btnTypeA sizeXS" onclick="showReceipt('<%= row.get("ORDERID") %>', '<%= row.get("pay_type") %>')">영수증</a></p>
<%
			}
		}
		if("160".indexOf(row.get("STATUS")) != -1) {
%>
							<p class="btn"><a href="#none" class="btnTypeC sizeXS" onclick="showRefundPop('C', '<%= row.get("ORDERID") %>', '<%= row.get("SHIP_SEQ") %>'); return false;">교환</a></p>
							<p class="btn"><a href="#none" class="btnTypeC sizeXS" onclick="showRefundPop('R', '<%= row.get("ORDERID") %>', '<%= row.get("SHIP_SEQ") %>'); return false;">반품</a></p>
<%
		}
		if("150,160".indexOf(row.get("status")) != -1) {
%>
							<p class="btn"><a href="#none" class="btnTypeC sizeXS" onclick="confirmOrder('<%= row.get("ORDERID") %>', '<%= row.get("SHIP_SEQ") %>')">구매확정</a></p>
<%
		}
		if("170".equals(row.get("status"))) {
%>
						<p class="btn"><a href="view.jsp?orderid=<%= row.get("ORDERID") %>&ship_seq=<%= row.get("SHIP_SEQ") %>"  class="btnTypeC sizeXS">상품평</a></p>
<%
		}
%>
						</td>
					</tr>
<%
		}
	} else {
%>					
					<tr><td colspan="5">+++ 주문배송내역이 없습니다 +++</td></tr>
<%  } %>
				</tbody>
			</table>
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(Utils.safeHTML(param.toQueryString("list.jsp")), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
			</ul>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>