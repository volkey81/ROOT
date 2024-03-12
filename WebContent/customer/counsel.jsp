<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.code.CodeService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(4));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("1:1 상담"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	CodeService code = (new CodeService()).toProxyInstance();
	
	List<Param> codeList = code.getList2("008");
	List<Param> codeList2 = code.getList2("029");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
	var v;
	var isProgress = false;

	$(function (){
		v = new ef.utils.Validator($("#counselForm"));
		v.add("title", {
			empty : "제목을 입력해주세요."
		}),
		v.add("question", {
			empty : "내용을 입력해주세요."
		});
	});
	
	function goRegist() {
		if(!isProgress) {
			if(v.validate() && confirm("등록 하시겠습니까?")){
				isProgress = true;
				$("#counselForm").submit();
			}
		}
	}
	
	function changeDevice(d) {
		if(d == '999') {
			$("#mobile_device_txt").show();
		} else {
			$("#mobile_device_txt").val("");
			$("#mobile_device_txt").hide();
		}
	}
	
	function setCate(v) {
		if(v == '005') {
			$("#mobile_device_tr").show();
		} else {
			$("#mobile_device_tr").hide();
		}
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/customer/snb.jsp" />
		<div id="contArea">
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<!-- 내용영역 -->	
			<p class="caution">문의하신 내용에 대한 답변은 <a href="/mypage/board/counsel.jsp" class="fontTypeA">마이페이지 &gt; 1:1 문의 내역</a>에서 확인하실 수 있습니다.</p>
			<form name="counselForm" id="counselForm" method="post" action="/customer/counselProc.jsp" enctype="multipart/form-data">
			<input type="hidden" name="mode" id="mode" value="CREATE" />
			<table class="bbsForm typeB">
				<caption>1:1 상담 입력폼</caption>
				<colgroup>
					<col width="130"><col width="">
				</colgroup>
				<tr>
					<th scope="row"><label for="type">* 문의유형</label></th>
					<td>
						<select name="cate" id="cate" onchange="setCate(this.value)">
<%
	for(Param code2 : codeList) {
%>
								<option value="<%= code2.get("code2")%>"
									<%= param.get("cate").equals(code2.get("code2")) ? "selected" : "" %>><%= code2.get("name2")%></option>
<%
	}
%>
						</select>
					</td>
				</tr>
				
				<tr>
					<th scope="row"><label for="title">* 제목</label></th>
					<td><input type="text" name="title" id="title" style="width:660px"></td>
				</tr>
				<tr>
					<th scope="row"><label for="cont">내용</label></th>
					<td><textarea id="question" name="question" style="width:660px;height:250px"></textarea></td>
				</tr>
				<tr>
					<th scope="row"><label for="imageName">첨부파일</label></th>
					<td>
						<p class="fileBox">
							<input type="text" id="fileText" readonly="readonly" style="width:590px">
							<span class="file btnTypeB">파일첨부<input type="file" id="image" name="image" onchange="$('#fileText').val($('#image').val())"></span>
						</p>
						<p class="fileBox">
							<input type="text" id="fileText2" readonly="readonly" style="width:590px">
							<span class="file btnTypeB">파일첨부<input type="file" id="image2" name="image2" onchange="$('#fileText2').val($('#image2').val())"></span>
						</p>
						<p class="fileBox">
							<input type="text" id="fileText3" readonly="readonly" style="width:590px">
							<span class="file btnTypeB">파일첨부<input type="file" id="image3" name="image3" onchange="$('#fileText3').val($('#image3').val())"></span>
						</p>
					</td>
				</tr>
				<tr id="mobile_device_tr" style="display:none">
					<th scope="row"><label for="type">모바일 기종</label></th>
					<td>
						<select name="mobile_device" id="mobile_device" onchange="changeDevice(this.value)">
								<option value="">해당사항 없음</option>
<%
	for(Param code2 : codeList2) {
%>
								<option value="<%= code2.get("code2")%>"><%= code2.get("name2")%></option>
<%
	}
%>
								<option value="999">직접입력</option>
						</select>
						<input type="text" name="mobile_device_txt" id="mobile_device_txt" style="width:400px;display:none">
					</td>
				</tr>
			</table>
			<div class="btnArea ac">
				<a href="#" onClick="goRegist();" class="btnTypeB">등록</a>
			</div>
			</form>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>