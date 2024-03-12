<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.order.OrderService"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/common.jsp" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("주문취소/교환/반품"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}

	OrderService order = (new OrderService()).toProxyInstance();
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("userid", fs.getUserId());
	param.set("status_type", "2");
	
	//게시물 리스트
	List<Param> orderList = order.getOrderList(param);
	//게시물 갯수
	int totalCount = order.getOrderListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<link rel="stylesheet" type="text/css" href="/css/jquery-ui-timepicker-addon.css">
<script type="text/javascript" src="/js/timepicker/jquery-ui-timepicker-addon.js"></script>
<script type="text/javascript" src="/js/timepicker/localization/jquery-ui-timepicker-ko.js"></script>
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
			<div class="dateSrch cancel">
			<form name="searchForm" id="searchForm">
				<input type="hidden" name="period" id="period" />
				<fieldset>
					<legend>기간, 상품명으로 검색</legend>
					<p class="cal">
						<strong>기간</strong>
						<input type="text" name="startDate" title="시작일" value="<%=param.get("startDate") %>" readonly>
						<span>~</span>
						<input type="text" name="endDate" title="종료일" value="<%=param.get("endDate") %>" readonly>
					</p>
					<p class="monthly">
						<strong>최근</strong>
						<a href="#" onClick="goMonthly(1); return false;" class="btnTypeA">1개월</a>
						<a href="#" onClick="goMonthly(3); return false;" class="btnTypeA">3개월</a>
						<a href="#" onClick="goMonthly(6); return false;" class="btnTypeA">6개월</a>
					</p>
					<p class="name">
						<label for="pName">상품명</label>
						<input type="text" name="pName" id="pName" value="<%= param.get("pName")%>">
					</p>
					<p class="btn"><a href="javascript:$('#searchForm').submit()" class="btnTypeB">조회</a></p>
				</fieldset>
			</form>
			</div>
			
			<table class="bbsList">
				<caption>주문취소/교환/반품 내역 목록</caption>
				<colgroup>
					<col width="180"><col width=""><col width="140"><col width="120">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">주문일시/주문번호</th>
						<th scope="col">주문내역</th>
						<th scope="col">최종결제금액 /수량</th>
						<th scope="col">상태</th>
					</tr>
				</thead>
				<tbody>
<%
	if (CollectionUtils.isNotEmpty(orderList)) {
		for(Param row : orderList) {
			String[] items = row.get("ITEMS").split("::", 7);
%>
					<tr>
						<th scope="row"><%= row.get("ORDER_DATE_FOR_INDEX") %><p class="fs"><a href="view.jsp?orderid=<%= row.get("ORDERID") %>" class="fontTypeC">(<%= row.get("ORDERID") %>_<%= row.get("SHIP_SEQ") %>)</a></p></th>
						<td class="tit pName"><%=StringUtils.isNotEmpty(items[3]) ? items[3] : "" %><p class="opt"><%=StringUtils.isNotEmpty(items[3]) ? items[4] : "" %></p></td>
						<td><%= Utils.formatMoney(row.getInt("SUM_AMT") + row.getInt("SHIP_AMT")) %>원 / <%= Utils.formatMoney(row.get("SUM_QTY")) %>개</td>
						<td><%= row.get("FE_NAME") %></td>
					</tr>
<%
		}
	} else {
%>
							<tr><td colspan="4">+++ 주문취소/교환/반품 내역이 없습니다 +++</td></tr>
<%
	}
%>
					
				</tbody>
			</table>
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("cancel.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
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