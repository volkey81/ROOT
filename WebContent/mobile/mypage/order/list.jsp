<%@page import="com.sanghafarm.service.board.ReviewService"%>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="com.efusioni.stone.common.*"%>
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
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("주문배송조회"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	FrontSession fs = FrontSession.getInstance(request, response);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	Param param = new Param(request);
	param.set("userid", fs.getUserId());
	param.set("status_type", "1");
	
	// 주문/배송 현황
	OrderService order = (new OrderService()).toProxyInstance();
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("period", param.get("period", "7"));
	// 주문 리스트
	List<Param> orderList = order.getOrderList(param);
	
	// 주문 갯수
	int totalCount = order.getOrderListCount(param);
	
	// 4일 후
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DATE, 4);
	String fourDays = Utils.getTimeStampString(cal.getTime(), "yyyy.MM.dd");
	
	int paymentWaitingCount   = 0;	// 결재대기 갯수
	int paymentCompleteCount  = 0;	// 결재완료 갯수
	int orderConfirmCount     = 0;	// 주문확인중 갯수
	int prepareCommodityCount = 0;	// 상품준비중 갯수
	int shippingCount 		  = 0;	// 배송중 갯수
	int shipCompletedCount 	  = 0;	// 배송완료 갯수
	List<Param> totalCounts = order.getOrderListIndexCount(param);
	
 	for (Param count : totalCounts) {
		switch(count.getInt("STATUS")){
			case 110 :
				paymentWaitingCount   = count.getInt("COUNT");
				break;
			case 120 :
				paymentCompleteCount  = count.getInt("COUNT");
				break;
			case 130 :
				orderConfirmCount     = count.getInt("COUNT");
				break;
			case 140 :
				prepareCommodityCount = count.getInt("COUNT");
				break;
			case 150 :
				shippingCount 		  = count.getInt("COUNT");
				break;
			case 160 :
				shipCompletedCount 	  = count.getInt("COUNT");
				break;
			default : break;
		}
	}
	
	// 8월 정기배송 특가 상품 코드
	String eventPid = Config.get("evend1.pid." + SystemChecker.getCurrentName());
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<link rel="stylesheet" type="text/css" href="/css/jquery-ui-timepicker-addon.css">
<script type="text/javascript" src="/js/timepicker/jquery-ui-timepicker-addon.js"></script>
<script type="text/javascript" src="/js/timepicker/localization/jquery-ui-timepicker-ko.js"></script>
<script type="text/javascript" src="https://pgweb.uplus.co.kr<%= SystemChecker.isReal() ? "" : ":7085" %>/WEB_SERVER/js/receipt_link.js"></script>
<script>
	$(function (){
		$("input[name='startDate']").datepicker({
            showOn: "button",
            buttonImage: "/mobile/images/btn/btn_calender.gif",
            dateFormat: 'yy-mm-dd',
            buttonImageOnly: true
        });
		$("input[name='endDate']").datepicker({
            showOn: "button",
            buttonImage: "/mobile/images/btn/btn_calender.gif",
            dateFormat: 'yy-mm-dd',
            buttonImageOnly: true
        });
		
		if ('<%=param.get("period") %>' == 7) {
			$("#week").addClass("on");
		} else if ('<%=param.get("period") %>' == 30) {
			$("#mon").addClass("on");
		} else if ('<%=param.get("period") %>' == 90) {
			$("#mon3").addClass("on");
		} else if ('<%=param.get("period") %>' == 180) {
			$("#mon6").addClass("on");
		} else {
			$("#week").addClass("on");
		}
		
			
	});
	function goMonthly(day){
		$("#period").val(day);
		$("#searchForm").submit();
		$("input[name='startDate']").val("");
		$("input[name='endDate']").val("");
	}
	
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
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<form name="orderForm" id="orderForm" method="POST" action="/mypage/order/orderProc.jsp">
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
			</form>
				<fieldset>
					<legend>기간으로 검색</legend>
					<strong>조회기간 :</strong>
					<span><a id="week" href="#" onClick="goMonthly(7); return false;" class="btnTypeA sizeS">7일</a></span>
					<span><a id="mon" href="#" onClick="goMonthly(30); return false;" class="btnTypeA sizeS">30일</a></span>
					<span><a id="mon3" href="#" onClick="goMonthly(90); return false;" class="btnTypeA sizeS">90일</a></span>
					<span><a id="mon6" href="#" onClick="goMonthly(180); return false;" class="btnTypeA sizeS">180일</a></span>
				</fieldset>
		</div>
			
		<h2 class="typeB">주문내역</h2>
		<ul class="myOrderList">
<% 
	if (CollectionUtils.isNotEmpty(orderList)) {
		for (Param row : orderList) {
			String[] items = row.get("ITEMS").split("::", 8);
%>		
			<li>
				<div class="head">
					<p class="num"><strong><%= row.get("ORDERID") %>_<%= row.get("SHIP_SEQ") %></strong><br>주문일시 : <%= row.get("ORDER_DATE_FOR_INDEX") %></p>
					<p class="status"><%= row.get("FE_NAME") %></p>
				</div>
				<div class="content">
					<div class="tit"><%=StringUtils.isNotEmpty(items[3]) ? items[3] : "" %>
						<p class="opt"><%=StringUtils.isNotEmpty(items[4]) ? items[4] : "" %></p>
					</div>
					<p class="date">배송요청일 : <%= row.get("DELIVERY_DATE", "-") %></p>
					<p class="btn">
						<a href="view.jsp?orderid=<%= row.get("ORDERID") %>&ship_seq=<%= row.get("SHIP_SEQ") %>" class="btnTypeB sizeS">주문상세보기</a>
<%
			if(!eventPid.equals(row.get("sub_pid")) && "2,6".indexOf(row.get("DELIVERY_TYPE")) != -1 && row.get("STATUS").compareTo("120") <= 0) {
				if(row.get("DELIVERY_DATE").compareTo(fourDays) >= 0) {
%>
						<a href="#" onclick="showDatePop('<%= row.get("ORDERID") %>' ,'<%= row.get("SHIP_SEQ") %>'); return false" class="btnTypeA sizeS">날짜변경</a>
<%
				}
			}
%>					
					</p>
				</div>
<%
			if("150,160,170".indexOf(row.get("status")) != -1) {			
%>
				<div class="foot"><div class="btnArea">
<%
				if("150,160".indexOf(row.get("status")) != -1) {			
%>
					<span><a href="#none" class="btnTypeC sizeS" onclick="confirmOrder('<%= row.get("ORDERID") %>', '<%= row.get("SHIP_SEQ") %>')">구매확정</a></span>
<%
				}
				if("170".equals(row.get("status"))) {
%>
					<span><span><a href="view.jsp?orderid=<%= row.get("ORDERID") %>&ship_seq=<%= row.get("SHIP_SEQ") %>"  class="btnTypeE sizeS">상품평</a></span></span>
<%
				}
				if("150,160".indexOf(row.get("status")) != -1) {
					if("001".equals(row.get("delivery_co"))) {
%>
					<span><a href="https://service.epost.go.kr/trace.RetrieveDomRigiTraceList.comm?sid1=<%= row.get("invoice_no") %>&displayHeader=N&target=web" target="_blank" class="btnTypeE sizeS">배송조회</a></span>
<%
					} else if("004".equals(row.get("delivery_co"))) {
%>
					<span><a href="https://www.ilogen.com/m/personal/trace/<%= row.get("invoice_no").replaceAll("-", "") %>" target="_blank" class="btnTypeE sizeS">배송조회</a></span>
<%
					}
				}
%>		
				</div></div>
<%
			}				
%>
			</li>
<%
		}
	} 
%>				
		</ul>
		<!-- //내용영역 -->
		<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
		</ul>
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>