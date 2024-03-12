<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.sanghafarm.service.code.*,
			com.efusioni.stone.utils.*" %>
<%
	request.setAttribute("Depth_1", new Integer(4));
	request.setAttribute("Depth_2", new Integer(7));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("입점/제휴문의"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	CodeService code = new CodeService();
	List<Param> cateList = code.getList2("042");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 

</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->	
		<div class="cautionBox">
			<p class="caution">해당 상품의 담당자가 답변 예정입니다.<br>상황에 따라 늦어질 수 있으니 빠른 답변을 원하실 경우 <a href="tel:1522-3698">1522-3698</a> 으로 문의 부탁드립니다.</p>
		</div>
		<form name="writeForm" id="writeForm" action="/customer/partnershipProc.jsp" method="POST">
		<input type="hidden" name="mode" id="mode" value="CREATE" />
		<table class="bbsForm typeB">
			<caption>입점/제휴문의 입력폼</caption>
			<colgroup>
				<col width="85"><col width="">
			</colgroup>
			<tr>
					<th scope="row">이메일</th>
					<td><input type="text" name="email" style="width:100%"></td>
				</tr>
				<tr>
					<th scope="row">담당자명</th>
					<td><input type="text" name="name" style="width:100%"></td>
				</tr>
				<tr>
					<th scope="row">담당자<br>연락처</th>
					<td><input type="text" name="tel" style="width:100%"></td>
				</tr>
				<tr>
					<th scope="row">담당자<br>이메일</th>
					<td><input type="text" name="email2" style="width:100%"></td>
				</tr>
				<tr>
					<th scope="row">업체명</th>
					<td><input type="text" name="name2" style="width:100%"></td>
				</tr>
				<tr>
					<th scope="row">업체주소</th>
					<td><input type="text" name="addr" style="width:100%"></td>
				</tr>
				<tr>
					<th scope="row">홈페이지주소</th>
					<td><input type="text" name="home" style="width:100%"></td>
				</tr>
				<tr>
					<th scope="row">상품카테고리</th>
					<td>
						<select name="cate" style="width:100%" onchange="setCate2(this.value)">
<%
	for(Param row : cateList) {
%>
							<option value="<%= row.get("code2") %>"><%= row.get("name2") %></option>
<%
	}
%>
						</select><br>
						<input type="text" name="cate2" style="width:100%;margin-top:5px;display:none"><!-- 기타 선택시 노출 -->
					</td>
				</tr>
				<tr>
					<th scope="row">입점제안상품<br><span class="fs">(입점 제안 상품명 및 상품 특징에 대한 상세한 설명)</span></th>
					<td><textarea name="content" style="width:100%;height:200px"></textarea></td>
				</tr>
		</table>
		<div class="btnArea">
			<span><a href="javascript:goRegist();" class="btnTypeB">등록</a></span>
		</div>
		</form>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
<script>
	var v;
	var isProgress = false;

	$(function () {
		v = new ef.utils.Validator($("#writeForm"));
		v.add("email", {
			empty : "이메일을 입력해주세요."
		});
		v.add("name", {
			empty : "이름을 입력해주세요."
		});
		v.add("tel", {
			empty : "연락처를 입력해주세요."
		});
		v.add("email2", {
			empty : "담당자 이메일을 입력해주세요."
		});
		v.add("name2", {
			empty : "업체명을 입력해주세요."
		});
		v.add("addr", {
			empty : "업체주소를 입력해주세요."
		});
	});
	
	function goRegist() {
		if(!isProgress) {
			if(v.validate()) {
				if(confirm("등록 하시겠습니까?")) {
					isProgress = true;
					$("#writeForm").submit();
 				}
			}
		}
	}

	function setCate2(v) {
		if(v == '007') {
			$("input[name=cate2]").show();
		} else {
			$("input[name=cate2]").hide();
		}
	}
</script>
</html>