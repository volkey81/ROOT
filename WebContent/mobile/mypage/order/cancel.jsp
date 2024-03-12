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
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}

	OrderService order = (new OrderService()).toProxyInstance();
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 999);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("userid", fs.getUserId());
	param.set("status_type", "2");
	param.set("period", param.get("period", "7"));
	//게시물 리스트
	List<Param> orderList = order.getOrderList(param);
	//게시물 갯수
	int totalCount = order.getOrderListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<link rel="stylesheet" type="text/css" href="/css/jquery-ui-timepicker-addon.css">
<script type="text/javascript" src="/js/timepicker/jquery-ui-timepicker-addon.js"></script>
<script type="text/javascript" src="/js/timepicker/localization/jquery-ui-timepicker-ko.js"></script>
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
		$("input[name='startDate']").val("");
		$("input[name='endDate']").val("");
		$("#searchForm").submit();
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->
		<div class="dateSrch">
		<form name="searchForm" id="searchForm">
			<input type="hidden" name="period" id="period" />
			<fieldset>
				<legend>기간으로 검색</legend>
				<strong>조회기간</strong>
				<span><a id="week" href="#" onClick="goMonthly(7); return false;" class="btnTypeA sizeS">7일</a></span>			
				<span><a id="mon" href="#" onClick="goMonthly(30); return false;" class="btnTypeA sizeS">1개월</a></span>
				<span><a id="mon3" href="#" onClick="goMonthly(90); return false;" class="btnTypeA sizeS">3개월</a></span>
				<span><a id="mon6" href="#" onClick="goMonthly(180); return false;" class="btnTypeA sizeS">6개월</a></span>
			</fieldset>
		</form>
		</div>
		
		<h2 class="typeA">주문취소/교환/반품 내역</h2>
		<ul class="myOrderList">
<%
	if (CollectionUtils.isNotEmpty(orderList)) {
		for(Param row : orderList) {
			String[] items = row.get("ITEMS").split("::", 7);
%>
			<li>
				<div class="head">
					<p class="num"><strong><a href="view.jsp?orderid=<%= row.get("ORDERID") %>&ship_seq=<%= row.get("SHIP_SEQ") %>"><%= row.get("ORDERID") %>_<%= row.get("SHIP_SEQ") %></a></strong><br>주문일시 : <%= row.get("ORDER_DATE_FOR_INDEX") %></p>
					<p class="status"><%= row.get("FE_NAME") %></p>
				</div>
				<div class="content">
					<div class="tit"><%=StringUtils.isNotEmpty(items[3]) ? items[3] : "" %>
						<p class="opt"><%=StringUtils.isNotEmpty(items[3]) ? items[4] : "" %>
					</div>
					<p class="date"><%= Utils.formatMoney(row.getInt("SUM_AMT") + row.getInt("SHIP_AMT")) %>원 / <%= Utils.formatMoney(row.get("SUM_QTY")) %>개</p>
				</div>
			</li>
<%
		}
	} else {
%>
			<li class="none">+++ 주문취소/교환/반품 내역이 없습니다 +++</li>
<%
	}
%>			
		</ul>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>