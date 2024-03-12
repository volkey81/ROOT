<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="com.sanghafarm.service.order.OrderService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("MENU_TITLE", new String("배송요청일 변경"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
	
	Param param = new Param(request);
	OrderService order = (new OrderService()).toProxyInstance();
	ProductService product = (new ProductService()).toProxyInstance();

	param.set("item_seq", "1");
	Param info = order.getOrderItemInfo(param); 
	List<Param> list = product.getDeliveryDayList(info.get("pid"));
	String days = "";
	for(Param row : list) {
		days += row.get("day") + ",";
	}
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script type="text/javascript">
$(function() {
	var days = "<%= days %>";
	$("input[name='delivery_date']").datepicker({
		minDate : +4,
		maxDate : "+3M",
        showOn: "button",
        dateFormat: 'yy.mm.dd',
        buttonImage: "/mobile/images/btn/btn_calender.gif",
        buttonImageOnly: true,
        beforeShowDay : function(date){
			var day = date.getDay() + 1;
			return [days.indexOf(day) != -1];
		}
    });
});

function goSubmit() {
	if(confirm("배송요청일을 변경하시겠습니까?")) {
		ajaxSubmit($("#dateForm"), function(json) {
			alert(json.msg);
			parent.document.location.reload();
		});
	}
}
</script>
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<form name="dateForm" id="dateForm" action="/mypage/order/orderProc.jsp" method="post">
			<input type="hidden" name="mode" value="DELIVERY_DATE" />
			<input type="hidden" name="orderid" value="<%= param.get("orderid") %>" />
			<input type="hidden" name="ship_seq" value="<%= param.get("ship_seq") %>" />
			<input type="hidden" name="org_date" value="<%= info.get("delivery_date") %>" />
		
		<p class="text">기존에 등록된 배송 요청일을 변경합니다.</p>
		<table class="bbsForm typeB">
			<caption>배송요청일 변경 입력폼</caption>
			<colgroup>
				<col width="100"><col width="">
			</colgroup>
			<tr>
				<th scope="row">상품명</th>
				<td><%= info.get("pnm") %></td>
			</tr>
			<tr>
				<th scope="row">기존 요청일</th>
				<td class="fontTypeA"><%= info.get("delivery_date") %></td>
			</tr>
			<tr>
				<th scope="row">변경 요청일</th>
				<td>
					<input type="text" name="delivery_date" value="<%= info.get("delivery_date") %>" style="width:100px;margin-right:-1px" readonly>
				</td>
			</tr>
		</table>
		</form>
		<div class="btnArea">
			<span><a href="#" onclick="hidePopupLayer();return false" class="btnTypeA sizeL">취소</a></span>
			<span><a href="#" onclick="goSubmit();return false" class="btnTypeB sizeL">확인</a></span>
		</div>
	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->
<script>
//팝업높이조절
setPopup(<%=layerId%>);
</script>
</body>
</html>