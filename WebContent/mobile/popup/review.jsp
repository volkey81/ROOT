<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.sanghafarm.service.board.ReviewService"%>
<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("MENU_TITLE", new String("상품평 작성"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
	
	FrontSession fs = FrontSession.getInstance(request, response);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	Param param = new Param(request);
	ProductService product = (new ProductService()).toProxyInstance();
	ReviewService review = (new ReviewService()).toProxyInstance();
			
	Param info = new Param();
	Param productInfo = new Param();
	String mode = "CREATE";
	if(!"".equals(param.get("seq"))) {
		param.set("userid", fs.getUserId());
		info = review.getInfo(param);
		productInfo = product.getInfo(new Param("pid", info.get("pid")));
		mode = "MODIFY";
	} else {
		if (StringUtils.isEmpty(param.get("pid"))) {
			Utils.sendMessage(out, "잘못된 경로로 접근하였습니다.");
			return;
		}
		param.set("grade_code", fs.getGradeCode());
		productInfo = product.getInfo(param);
	}
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
	var v;
	$(function() {
<%
	if(!fs.isLogin()) {
%>
		alert("로그인이 필요합니다.");
		hidePopupLayer();
<%
	}
%>
		v = new ef.utils.Validator($("#reviewForm"));
		
		v.add("title", {
			"empty" : "제목을 입력해 주세요.",
			"max" : 100
		});
		v.add("contents", {
			"empty" : "내용을 입력해 주세요.",
			"max" : 2000
		});
	});
	
	function goSubmit() {
		if(v.validate()) {
			$(".btnArea").hide();
			$("#reviewForm").submit();
		}
	}
	
<%
	if(fs.isApp() && "android".equals(fs.getAppOS())){
%>
	function appGetFile(division){
		try{
			window.sanghafarmJSInterface.openFileChooseWithCallBack(division); //파일선택시 콜백함수
		}catch(e){ }
	}
	function sendData(division, imageName) {
		$("#file" + division).val(imageName);
		$("#imgName" + division).val(imageName);
	}
<%
	}
%>
	
	
</script>
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<p class="text">상품평을 등록합니다.</p>
		<form name="reviewForm" id="reviewForm" method="POST" action="reviewProc.jsp" enctype="multipart/form-data">
			<input type="hidden" name="mode" value="<%= mode %>" />
			<input type="hidden" name="seq" value="<%= param.get("seq") %>" />
			<input type="hidden" name="orderid" value="<%= param.get("orderid") %>" />
			<input type="hidden" name="ship_seq" value="<%= param.get("ship_seq") %>" />
			<input type="hidden" name="item_seq" value="<%= param.get("item_seq") %>" />
			<input type="hidden" name="pid" value="<%= param.get("pid") %>" />
		<table class="bbsForm typeB">
			<caption>상품평 작성폼</caption>
			<colgroup>
				<col width="75"><col width="">
			</colgroup>
			<tr>
				<th scope="row">상품명</th>
				<td><%= productInfo.get("pnm") %></td>
			</tr>
			<tr>
				<th scope="row">작성자</th>
				<td><%= fs.getUserId() %>(<%= fs.getUserNm() %>)</td>
			</tr>
			<tr>
				<th scope="row">별점</th>
				<td>
					<select name="score" id="score" title="별점 선택">
						<option value="5" <%= "5".equals(info.get("score")) ? "selected" : "" %>>★★★★★</option>
						<option value="4" <%= "4".equals(info.get("score")) ? "selected" : "" %>>★★★★☆</option>
						<option value="3" <%= "3".equals(info.get("score")) ? "selected" : "" %>>★★★☆☆</option>
						<option value="2" <%= "2".equals(info.get("score")) ? "selected" : "" %>>★★☆☆☆</option>
						<option value="1" <%= "1".equals(info.get("score")) ? "selected" : "" %>>★☆☆☆☆</option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">제목</th>
				<td><input type="text" name="title" id="title" title="제목" style="width:100%" value="<%= info.get("title") %>"></td>
			</tr>
<%
	if(fs.isApp() && "android".equals(fs.getAppOS())){
%>
			<tr>
				<th scope="row">사진첨부</th>
				<td>
					<p class="fileBox">
						<input type="text" id="file1" readonly="readonly">
						<span class="file btnTypeB sizeS">파일첨부<input type="file" id="img1" name="img1" onclick='appGetFile(1); return false;' onchange="$('#file1').val($('#img1').val())"></span>
						<input type="hidden" name="img1_org" value="<%= info.get("img1") %>">
						<input type="hidden" name="imgName1" id="imgName1" value="">
					</p>
					<p class="fileBox">
						<input type="text" id="file2"  readonly="readonly">
						<span class="file btnTypeB sizeS">파일첨부<input type="file" id="img2" name="img2" onclick='appGetFile(2); return false;' onchange="$('#file2').val($('#img2').val())"></span>
						<input type="hidden" name="img2_org" value="<%= info.get("img2") %>">
						<input type="hidden" name="imgName2" id="imgName2" value="">
					</p>
				</td>
			</tr>		
<%
	} else {
%>
			<tr>
				<th scope="row">사진첨부</th>
				<td>
					<p class="fileBox">
						<input type="text" id="file1" readonly="readonly">
						<span class="file btnTypeB sizeS">파일첨부<input type="file" id="img1" name="img1" onchange="$('#file1').val($('#img1').val())"></span>
						<input type="hidden" name="img1_org" value="<%= info.get("img1") %>">
					</p>
					<p class="fileBox">
						<input type="text" id="file2" readonly="readonly">
						<span class="file btnTypeB sizeS">파일첨부<input type="file" id="img2" name="img2" onchange="$('#file2').val($('#img2').val())"></span>
						<input type="hidden" name="img2_org" value="<%= info.get("img2") %>">
					</p>
				</td>
			</tr>
<%
	}
%>
			<tr>
				<th scope="row">본문</th>
				<td><textarea name="contents" id="contents" style="width:100%;height:80px" title="본문"><%= info.get("contents") %></textarea></td>
			</tr>
		</table>
		</form>
		<div class="btnArea">
			<span><a href="#" onclick="hidePopupLayer(); return false" class="btnTypeA sizeL">취소</a></span>
			<span><a href="#" onclick="goSubmit(); return false" class="btnTypeB sizeL"><%= StringUtils.equals("CREATE", mode) ? "등록" : "수정"%></a></span>
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