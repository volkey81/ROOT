<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.member.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("나의 배송주소록"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	AddrBookService addr = (new AddrBookService()).toProxyInstance();
	
	//페이징 변수 설정
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("userid", fs.getUserId());
	
	//게시물 리스트
	List<Param> list = addr.getList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	var addrs = new Array();
	
	function setAddr() {
		if($("input[name=idx]:checked").length == 0) {
			alert("주소를 선택하세요.");
			return;
		}
		
		var idx = $("input[name=idx]:checked").val();
		
		parent.document.getElementById("ship_name").value = addrs[idx].name;
		parent.document.getElementById("ship_mobile1").value = addrs[idx].mobile1;
		parent.document.getElementById("ship_mobile2").value = addrs[idx].mobile2;
		parent.document.getElementById("ship_mobile3").value = addrs[idx].mobile3;
		parent.document.getElementById("ship_tel1").value = addrs[idx].tel1;
		parent.document.getElementById("ship_tel2").value = addrs[idx].tel2;
		parent.document.getElementById("ship_tel3").value = addrs[idx].tel3;
		parent.document.getElementById("ship_post_no").value = addrs[idx].post_no;
		parent.document.getElementById("ship_addr1").value = addrs[idx].addr1;
		parent.document.getElementById("ship_addr2").value = addrs[idx].addr2;
		
		try {
			parent.checkEarly();
		} catch(e) {}

		hidePopupLayer();
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

	function setDefault() {
		if($("input[name=seq]:checked").length == 0) {
			alert("선택된 주소가 없습니다.")
			return;
		}
		
		if(confirm("기본배송지로 변경하시겠습니까?")) {
			$("#mode").val("DEFAULT");
			$("#seq").val($("input[name=seq]:checked").val());
			ajaxSubmit($("#addrForm"), function(json) {
				alert(json.msg);
// 				document.location.reload();
			});			
		}
	}

	function showMyAddressPop(mode, seq) {
		document.location.href = "/mobile/popup/newAddress.jsp?mode=" + mode + "&seq=" + seq+"&layerId=<%=layerId%>";
	}

</script>
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<form name="addrForm" id="addrForm" action="/mobile/mypage/order/addrProc.jsp" method="POST">
			<input type="hidden" name="mode" id="mode" value="" />
			<input type="hidden" name="seq" id="seq" value="" />
		</form>
		<table class="bbsList addressList">
			<caption>배송주소선택</caption>
			<colgroup>
					<col width="80"><col width="">
			</colgroup>
			<tbody>
<%
	for(int i = 0; i < list.size(); i++) {
		Param row = list.get(i);
%>
<script>
	var addr = {
		"name" : "<%= Utils.safeHTML(row.get("name")) %>",
		"post_no" : "<%= Utils.safeHTML(row.get("post_no")) %>",
		"addr1" : "<%= Utils.safeHTML(row.get("addr1")) %>",
		"addr2" : "<%= Utils.safeHTML(row.get("addr2")) %>",
		"mobile1" : "<%= Utils.safeHTML(row.get("mobile1")) %>",
		"mobile2" : "<%= Utils.safeHTML(row.get("mobile2")) %>",
		"mobile3" : "<%= Utils.safeHTML(row.get("mobile3")) %>",
		"tel1" : "<%= Utils.safeHTML(row.get("tel1")) %>",
		"tel2" : "<%= Utils.safeHTML(row.get("tel2")) %>",
		"tel3" : "<%= Utils.safeHTML(row.get("tel3")) %>"
	};
	
	addrs[<%= i %>] = addr;
</script>
				<tr>
					<th scope="row"><input type="radio" name="idx" id="addr_<%= i %>" value="<%= i %>"> <%= Utils.safeHTML(row.get("addr_name")) %></th>
					<td class="tit">
						<p><%= Utils.safeHTML(row.get("name")) %></p>
						(<%= Utils.safeHTML(row.get("post_no")) %>) <%= Utils.safeHTML(row.get("addr1")) %> <%= Utils.safeHTML(row.get("addr2")) %><br>
						<%= Utils.safeHTML(row.get("mobile1")) %>-<%= Utils.safeHTML(row.get("mobile2")) %>-<%= Utils.safeHTML(row.get("mobile3")) %> / <%= Utils.safeHTML(row.get("tel1")) %>-<%= Utils.safeHTML(row.get("tel2")) %>-<%= Utils.safeHTML(row.get("tel3")) %>
					</td>
				</tr>
<%
	}

	if(list.size() == 0) {
%>
				<tr><td colspan="2">+++ 선택가능한 배송지가 없습니다 +++</td></tr>
<%
	}
%>
			</tbody>
		</table>
		<div class="btnArea">
			<span><a href="javascript:setAddr(1)" class="btnTypeB sizeL">선택</a></span>
			<span><a href="javascript:showMyAddressPop('CREATE_POP', '')" class="btnTypeA sizeL">신규 배송지 등록</a></span>
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