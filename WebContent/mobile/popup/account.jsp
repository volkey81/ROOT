<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.product.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("환불계좌 정보 등록"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<%
	Param param = new Param(request);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	var v;
	$(function() {
		v = new ef.utils.Validator($("#orderForm"));
		v.add("lgd_rfaccountnum", {
			empty : "환불계좌를 입력하지 않았습니다.",
			format : "numeric",
			max : "100"
		});
		v.add("lgd_rfcustomername", {
			empty : "예금주를 입력하지 않았습니다.",
			max : "10"
		});
	});


	function cancelOrder() {
		if (v.validate()) {
			ajaxSubmit($("#orderForm"), function(json) {
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
		<form name="orderForm" id="orderForm" method="POST" action="/mypage/order/orderProc.jsp">
			<input type="hidden" name="mode" id="mode" value="CANCEL" />
			<input type="hidden" name="orderid" id="orderid" value="<%= param.get("orderid") %>" />
		<table class="bbsForm typeB">
			<caption>환불계좌 등록 입력폼</caption>
			<colgroup>
				<col width="70"><col width="">
			</colgroup>
			<tr>
				<th scope="row">주문번호</th>
				<td><%= param.get("orderid") %></td>
			</tr>
			<tr>
				<th scope="row">은행선택</th>
				<td>
					<select name="lgd_rfbankcode" id="lgd_rfbankcode" title="">
						<option value="02">산업은행</option>
						<option value="03">기업은행</option>
						<option value="05">외환은행</option>
						<option value="06">국민은행</option>
						<option value="07">수협</option>
						<option value="11">농협</option>
						<option value="20">우리은행</option>
						<option value="23">제일은행</option>
						<option value="27">씨티은행</option>
						<option value="31">대구은행</option>
						<option value="32">부산은행</option>
						<option value="34">광주은행</option>
						<option value="35">제주은행</option>
						<option value="37">전북은행</option>
						<option value="39">경남은행</option>
						<option value="45">새마을금고</option>
						<option value="48">신협</option>
						<option value="71">우체국</option>
						<option value="81">하나은행</option>
						<option value="88">신한은행</option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">계좌번호</th>
				<td><input type="text" name="lgd_rfaccountnum" id="lgd_rfaccountnum" style="width:100%" title="계죄번호"></td>
			</tr>
			<tr>
				<th scope="row">예금주</th>
				<td>
					<input type="text" name="lgd_rfcustomername" id="lgd_rfcustomername" style="width:100%" title="예금주">
					<p class="text fontTypeA"><b>* 입력하신 계좌의 예금주명과 정확히 일치해야 합니다.</b></p>
				</td>
			</tr>
		</table>
		</form>
		<div class="btnArea">
			<span><a href="javascript:hidePopupLayer()" class="btnTypeA sizeL">취소</a></span>
			<span><a href="javascript:cancelOrder()" class="btnTypeB sizeL">등록</a></span>
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