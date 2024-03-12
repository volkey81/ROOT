<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.member.AddrBookService"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/common.jsp" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("배송주소록"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	AddrBookService addr = (new AddrBookService()).toProxyInstance();

	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", Integer.MAX_VALUE);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("userid", fs.getUserId());
	
	//게시물 리스트
	List<Param> addrList = addr.getList(param);
	//게시물 갯수
	int totalCount = addr.getListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
//배송지 수정 등록
	function showMyAddressPop(mode, seq) {
		var url = "<%= WEBROOT %>/mobile/popup/newAddress.jsp?mode=" + mode + "&seq=" + seq;
		showPopupLayer(url);
	}
	
	function removeAddr(seq) {
		if(confirm("삭제하시겠습니까?")) {
			$("#mode").val("REMOVE");
			$("#seq").val(seq);
			ajaxSubmit($("#addrForm"), function(json) {
				alert(json.msg);
				document.location.reload();
			});			
		}
	}
	
	function setDefault(seq) {
		if ($("#seq").val() != "" && $("#seq").val() != null) {
			if(confirm("기본배송지로 변경하시겠습니까?")) {
				$("#mode").val("DEFAULT");
				ajaxSubmit($("#addrForm"), function(json) {
					alert(json.msg);
					document.location.reload();
				});			
			}
		} else {
			alert("배송지를 선택해주세요.");
		}
	}
	function setDefaultValue(seq){
		$("#seq").val(seq);
	}
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<form name="addrForm" id="addrForm" action="addrProc.jsp" method="POST">
			<input type="hidden" name="mode" id="mode" value="" />
			<input type="hidden" name="seq" id="seq" value="" />
		</form>
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->						
		<p class="headText">고객님께서 사용중인 배송 주소 목록 입니다.</p>
		<table class="bbsList addressList">
			<caption>배송주소선택</caption>
			<colgroup>
					<col width="80"><col width="">
			</colgroup>
			<tbody>
<%
	for(Param row : addrList) {
%>
				<tr>
					<th scope="row">
					<% if (StringUtils.equals("Y", row.get("default_yn"))) { %>
						<span class="fontTypeA fs">[기본배송지]</span><br>
						<% } %>
						<input type="radio" name="seq" id="addr1" value="<%= row.get("seq") %>" <%= "Y".equals(row.get("default_yn")) ? "checked" : "" %> onClick="setDefaultValue(<%= row.get("seq") %>);">
						<label for="addr1"><%= Utils.safeHTML2(row.get("addr_name")) %></label>
					</th>
					<td class="tit">
						<p><%= Utils.safeHTML2(row.get("name")) %></p>
						(<%= Utils.safeHTML2(row.get("post_no")) %>) <%= Utils.safeHTML2(row.get("addr1")) %> <%= Utils.safeHTML2(row.get("addr2")) %><br>
						<%= Utils.safeHTML2(row.get("mobile1")) %>-<%= Utils.safeHTML2(row.get("mobile2")) %>-<%= Utils.safeHTML2(row.get("mobile3")) %> / <%= Utils.safeHTML2(row.get("tel1")) %>-<%= Utils.safeHTML2(row.get("tel2")) %>-<%= Utils.safeHTML2(row.get("tel3")) %>
						<p class="btn">
							<a href="#" onclick="showMyAddressPop('MODIFY', '<%= row.get("seq") %>');return false;" class="btnTypeC sizeS">수정</a>
							<a href="#" onclick="removeAddr('<%= row.get("seq") %>')" class="btnTypeC sizeS">삭제</a>
						</p>
					</td>
				</tr>
<%
	}

	if(totalCount == 0) {
%>
				<tr><td colspan="2">+++ 선택가능한 배송지가 없습니다 +++</td></tr>
<%
	}
%>
					
			</tbody>
		</table>
		<div class="btnArea">
			<span><a href="#" onClick="setDefault(); return false;" class="btnTypeB">기본 배송지로 선택</a></span>
			<span><a href="#" onclick="showMyAddressPop('CREATE', ''); return false;" class="btnTypeA">신규 배송지 등록</a></span>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>