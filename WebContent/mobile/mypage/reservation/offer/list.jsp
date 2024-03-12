<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.hotel.*,
			org.json.simple.*" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("스페셜오퍼 예약현황"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	HotelOfferService svc = new HotelOfferService();
	
	Param param = new Param(request);
	param.set("userid", fs.getUserId());

	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	List<Param> list = svc.getReserveList(param);
	int totalCount = svc.getReserveListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
	function cancelOrder(orderid) {
		if(confirm("취소하시겠습니까?")) {
			$("#orderid").val(orderid);
			$("#mode").val("CANCEL");
	
			ajaxSubmit($("#orderForm"), function(json) {
				alert(json.msg);
				document.location.reload();
			});
		}
	}
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<form name="orderForm" id="orderForm" method="POST" action="/mypage/reservation/offer/orderProc.jsp">
		<input type="hidden" name="mode" id="mode" />
		<input type="hidden" name="orderid" id="orderid" />
	</form>
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->
		<div class="cautionBox">
			<ul class="caution">
				<li>모든 예약은 당사의 사정에 의해 변경될 수 있습니다.</li>
				<li>예약 취소 수수료는 아래와 같습니다.
					<ul>
						<li><p class="tit">(극)성수기/패키지</p>
							<ul>
								<li>투숙예정일 15일 전까지 취소한 경우 예약금액 전액 환불</li>
								<li>투숙예정일 14~8일 전까지 취소한 경우 예약금액의 10% 환불</li>
							</ul>
						</li>
						<li><p class="tit">비&nbsp;수&nbsp;기</p>
							<ul>
								<li>투숙예정일 8일 전까지 취소한 경우 예약금액 전액 환불</li>
							</ul>
						 </li>
						 <li><p class="tit">공&nbsp;통</p>
						 	<ul>
						 		<li>투숙예정일 7~4일 전까지 취소한 경우 예약금액의 50% 환불</li>
						 		<li>투숙예정일 3일 전~당일 취소(No-show포함) 예약금액 환불 없음</li>
						 	</ul>
						 </li>
					</ul>
				</li>
				<li>단, ‘취소불가’와 같이 상품에 별도 취소수수료 규정이 있는 경우 이에 따라 환불됩니다.	</li>
				<li>투숙예정일 8일 전 까지만 온라인 취소 가능하며, 이후에는 프론트(063-563-6611)로 연락 주십시오.</li>
			</ul>
		</div>
		
		<h2 class="typeB">예약내역</h2>
		<ul class="myOrderList">
<%
	if(totalCount > 0) {
		for(Param row : list) {
%>
			<li>
				<div class="head">
					<p class="num"><a href="view.jsp?orderid=<%= row.get("orderid") %>"><strong><%= row.get("orderid") %></strong> (<%= row.get("order_date") %>)</a></p>
					<p class="status"><%= row.get("status_name") %></p>
				</div>
				<div class="content">
					<div class="tit"><a href="view.jsp?orderid=<%= row.get("orderid") %>"><%= row.get("pnm") %></a></div>
					<p class="date">일정 : <%= row.get("chki_date") %> ~ <%= row.get("chot_date") %></p>
					<p class="btn">
<%
			if("Y".equals(row.get("cancelable"))) {
%>
						<a href="javascript:cancelOrder('<%= row.get("orderid") %>')" class="btnTypeA sizeS">예약취소</a>
<%
			}
%>						
					</p>
				</div>
			</li>
<%
		}
	} else {
%>
			<li class="none">+++ 예약내역이 없습니다 +++</li>
<%
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