<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.product.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("재입고 알림"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	ProductService product = (new ProductService()).toProxyInstance();
	param.set("grade_code", fs.getGradeCode());
	Param info = product.getInfo(param);
	List<Param> optList = product.getOptionList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
	var v;
	
	$(function() {
		//Validation
		v = new ef.utils.Validator($("#restockForm"));
		v.add("name", {
			empty : "성명을 입력하세요.",
			max : "20"
		});
		v.add("mobile", {
			empty : "휴대전화를 입력하세요.",
			format : "numeric",
			max : "15"
		});
	});
	
	function checkAll() {
		var b = $("input[name='check_all']").prop("checked");
		$("input[name='pid']").each(function(){
			$(this).prop("checked", b);
		});
	}
	
	function goSumbit() {
		if($("input[name='pid']:checked").length == 0) {
			alert("선택된 상품이 없습니다.");
			return;
		}
		
		if (v.validate()) {
			if(!$("input[name='agree']").prop("checked")) {
				alert("개인정보 수집 및 이용에 대한 동의가 필요합니다.");
				return;
			}

			ajaxSubmit($("#restockForm"), function(json) {
				if(json.result) {
					alert(json.msg);
					hidePopupLayer();
				} else {
					alert(json.msg);
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
		<form name="restockForm" id="restockForm" action="restockProc.jsp" method="post">
		<div class="restockForm">
			<p class="text">선택하신 상품이 재입고 되면, 휴대폰 SMS로 알려드립니다.</p>
			<table class="bbsList">
				<caption>재입고 알림 상품 선택</caption>
				<colgroup>
					<col width="80"><col width="">
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="check_all" onclick="checkAll()" title="전체선택"></th>
						<th scope="col">상품</th>
					</tr>
				</thead>
				<tbody>
<%
	if("N".equals(info.get("sale_status")) || info.getInt("stock") == 0) {
%>
					<tr>
						<th scope="row"><input type="checkbox" name="pid" value="<%= info.get("pid") %>" id="pid_<%= info.get("pid") %>"></th>
						<td class="tit"><label for="pid_<%= info.get("pid") %>"><%= info.get("pnm") %></label></td>
					</tr>
<%
	}

	if(!"Y".equals(info.get("routine_yn")) && optList.size() > 0) {
		for(Param row : optList) {
			if("N".equals(row.get("sale_status")) || row.getInt("stock") == 0) {
%>
					<tr>
						<th scope="row"><input type="checkbox" name="pid" value="<%= row.get("opt_pid") %>" id="pid_<%= row.get("opt_pid") %>"></th>
						<td class="tit"><label for="pid_<%= row.get("opt_pid") %>"><%= row.get("opt_pnm") %></label></td>
					</tr>
<%
			}
		}
	}
%>
				</tbody>
			</table>
			<fieldset>
				<legend>연락처</legend>
				<p><label for="uname">성명</label><input type="text" name="name" id="uname" maxlength="20" value="<%= fs.getUserNm() %>"></p>
				<p><label for="phone">휴대전화</label><input type="text" name="mobile" id="phone" value="<%= fs.getMobile1() %><%= fs.getMobile2() %><%= fs.getMobile3() %>" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" maxlength="15"></p>
			</fieldset>
		</div>
		<h2 class="typeC">개인정보 수집 및 이용에 대한 동의</h2>
		<input type="checkbox" name="agree" id="agree"><label for="agree">동의합니다.</label>
		<div class="agreeArea"><div class="scr">
			<jsp:include page="/order/agree2.jsp" />
		</div></div>
		<div class="btnArea">
			<a href="#none" onclick="goSumbit();" class="btnTypeB sizeL">상품 재입고 알림 신청</a>
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