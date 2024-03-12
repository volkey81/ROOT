<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.code.*" %>
<%
	Param param = new Param(request);

	request.setAttribute("MENU_TITLE", "C".equals(param.get("rtype")) ? "교환신청" : "반품신청");
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	String layerId = request.getParameter("layerId");
	FrontSession fs = FrontSession.getInstance(request, response);
	CodeService code = (new CodeService()).toProxyInstance();
	
	List<Param> cateList = code.getList2("C".equals(param.get("rtype")) ? "012" : "013");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
	var v;

	$(function() {
		v = new ef.utils.Validator($("#returnForm"));
		
		v.add("contents", {
			"empty" : "내용을 입력해 주세요.",
			"max" : 2000
		});
	});

	function goSubmit() {
		if(v.validate()) {
			$("#returnForm").submit();
		}
	}
</script>
</head>
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
		<form name="returnForm" id="returnForm" action="refundProc.jsp" enctype="multipart/form-data" method="POST">
			<input type="hidden" name="orderid" value="<%= param.get("orderid") %>" />
			<input type="hidden" name="ship_seq" value="<%= param.get("ship_seq") %>" />
			<input type="hidden" name="rtype" value="<%= param.get("rtype") %>" />
		<table class="bbsForm typeB">
			<caption>교환 / 반품 신청 폼</caption>
			<colgroup>
				<col width="100"><col width="">
			</colgroup>
			<tr>
				<th scope="row">주문번호</th>
				<td><%= param.get("orderid") %>_<%= param.get("ship_seq") %></td>
			</tr>
			<tr>
				<th scope="row"><%= "C".equals(param.get("rtype")) ? "교환" : "반품" %>유형</th>
				<td>
					<span class="slt">
					<select name="cate" id="cate" style="width:100px;">
<%
	for(Param row : cateList) {
%>
						<option value="<%= row.get("code2") %>"><%= row.get("name2") %></option>
<%
}
%>
					</select>
					</span>
				</td>
			</tr>
			<tr>
				<th scope="row"><%= "C".equals(param.get("rtype")) ? "교환" : "반품" %>사유</th>
				<td><textarea name="contents" id="contents" style="width:430px;height:100px;"></textarea></td>
			</tr>

			<tr>
				<th scope="row">첨부파일</th>
				<td>
					<input type="file" id="attach" name="attach" style="width:430px">
				</td>
			</tr>
		</table>
		<div class="btnArea ac">
			<a href="#none" onclick="hidePopupLayer();return false;" class="btnTypeA sizeL">취소</a>
			<a href="#none" onclick="goSubmit()" class="btnTypeB sizeL"><%= "C".equals(param.get("rtype")) ? "교환" : "반품" %>신청</a>
		</div>
		</form>
	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->
<script>
//팝업높이조절
setPopup(<%=layerId%>);
</script>
</body>
</html>