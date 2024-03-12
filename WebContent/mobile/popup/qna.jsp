<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.product.*,
				 com.sanghafarm.service.code.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("상품 Q&A 작성"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	ProductService product = (new ProductService()).toProxyInstance();
	CodeService code = (new CodeService()).toProxyInstance();
	
	Param info = product.getInfo(param);
	List<Param> cateList = code.getList2("009");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	var v;
	
	$(function() {
		v = new ef.utils.Validator($("#qnaForm"));
		v.add("title", {
			empty : "제목을 입력하세요.",
			max : "100"
		})
		.add("question", {
			empty : "질문 내용을 입력하세요.",
			max : "2000"
		});
	});

	function goSubmit() {
		if(v.validate()) {
			ajaxSubmit($("#qnaForm"), function(json) {
				alert(json.msg);
				if(json.result) {
					parent.document.location.reload();
				}
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
		<form name="qnaForm" id="qnaForm" action="/popup/qnaProc.jsp" method="post">
			<input type="hidden" name="pid" value="<%= param.get("pid") %>" />
		<p class="text">지금 보시는 상품에 관한 문의 사항을 작성합니다.</p>
		<table class="bbsForm typeB">
			<caption>상품 Q&A 작성폼</caption>
			<colgroup>
				<col width="75"><col width="">
			</colgroup>
			<tr>
				<th scope="row">상품명</th>
				<td><%= info.get("pnm") %></td>
			</tr>
			<tr>
				<th scope="row">작성자</th>
				<td><%= fs.getUserId() %>(<%= fs.getUserNm() %>)</td>
			</tr>
			<tr>
				<th scope="row">카테고리</th>
				<td>
					<select name="cate" id="cate" title="카테고리 선택">
<%
	for(Param row : cateList) {
%>
						<option value="<%= row.get("code2") %>"><%= row.get("name2") %></option>
<%
	}
%>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">질문제목</th>
				<td><input type="text" name="title" id="title" title="질문제목" style="width:100%"></td>
			</tr>
			<tr>
				<th scope="row">비밀글여부</th>
				<td><input type="checkbox" name="secret_yn" value="Y" id="secret"><label for="secret" class="fontTypeA fb">체크하시면 비밀글이 되어 작성자와 관리자만 열람할 수 있습니다.</label></td>
			</tr>
			<tr>
				<th scope="row">질문내용</th>
				<td><textarea name="question" id="question" style="width:100%;height:80px" title="질문내용"></textarea></td>
			</tr>
		</table>
		<div class="btnArea">
			<span><a href="#none" onclick="hidePopupLayer(); return false" class="btnTypeA sizeL">취소</a></span>
			<span><a href="#none" onclick="goSubmit(); return false" class="btnTypeB sizeL">등록</a></span>
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