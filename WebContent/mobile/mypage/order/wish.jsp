<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.order.WishListService"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("단골상품"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	WishListService wish = (new WishListService()).toProxyInstance();
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("userid", fs.getUserId());
	param.set("grade_code", fs.getGradeCode());
	
	//게시물 리스트
	List<Param> wishList = wish.getList(param);
	//게시물 갯수
	int totalCount = wish.getListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	function checkAll() {
		var b = $("input[name='check_all']").prop("checked");
		$("input[name='pid']").each(function(){
			$(this).prop("checked", b);
		});
	}
	
	function removeWish() {
		if($("input[name='pid']:checked").length == 0) {
			alert("선택된 상품이 없습니다.");
			return;
		}
		
		$("#wishForm").attr("action", "/mypage/wishProc.jsp");
		$("#wishForm").attr("target", "");
		$("#wishForm input[name=mode]").val("REMOVE");
	
		ajaxSubmit($("#wishForm"), function(json) {
			alert(json.msg);
			if(json.result) {
				document.location.reload();
			}
		});
	}
	function order() {
<%
		if(fs.isLogin()) {
%>
			submitOrder();
<%
		} else {
%>
			showMemberPop();
<%
		}
%>	
	}
	//회원 비회원 선택
	function showMemberPop() {
		showPopupLayer('/mobile/popup/memberGate.jsp');
	}
	
	function submitOrder() {
		$("#wishForm").attr("action", "/mobile/order/payment.jsp");
		$("#wishForm").attr("target", "");
		$("#wishForm input[name=mode]").val("ORDER");
		$("#wishForm").submit();
	}
	

</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<form name="wishForm" id="wishForm">
			<input type="hidden" name="mode" value="REMOVE" />
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->	
		<div class="bbsHead">
			<div class="cartBtn">
				선택한 상품을
				<a href="javascript:void(0)" onclick="removeWish()" class="btnTypeC sizeXS">삭제</a>
			</div>
		</div>
		
		<div class="wishList">
			<div class="head">
				<input type="checkbox" name="check_all" onclick="checkAll()" id="allCheck"><label for="allCheck">전체선택</label>
			</div>
			<ul>			
<%
	if (CollectionUtils.isNotEmpty(wishList)) {
		for(Param row : wishList) {
%>
				<li>
					<p class="chk"><input type="checkbox" name="pid" value="<%= row.get("pid") %>"></p>
					<p class="thumb"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("thumb") %>" alt=""></a></p>
					<div class="content">
						<div class="tit"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
							<%= row.get("pnm") %>
						</a></div>
						<% if (StringUtils.equals("N", row.get("sale_status")) || row.getInt("stock") == 0) {%>
						<p class="price"><em>품절</em> <a href="#" onclick="showPopupLayer('/mobile/popup/restock.jsp?pid=<%= row.get("pid") %>'); return false" class="btnTypeC sizeXS icoAlram">재입고 알림</a></p>
						<% } else { %>
						<p class="price">
<%
		if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
							<strike><%= Utils.formatMoney(row.get("default_price")) %></strike>
<%
		}
%>
							<strong><%= Utils.formatMoney(row.get("sale_price")) %></strong>원
						</p>						
						<% } %>
						<div class="btnArea">
<%
		if("Y".equals(row.get("routine_yn"))) {
%>
							<span><a href="#none" onclick="showPopupLayer('/mobile/popup/regularOption.jsp?pid=<%= row.get("pid") %>'); return false" class="btnTypeA sizeS">구매하기</a></span>
<%
		} else {
%>
							<span><a href="#none" onclick="showPopupLayer('/mobile/popup/cart.jsp?pid=<%= row.get("pid") %>'); return false" class="btnTypeA sizeS">구매하기</a></span>
<%
		}
%>
						</div>	
					</div>
				</li>
<%
		}
	} else {
%>
				<li class="none">+++ 조회내역이 없습니다. +++</li>
<%
	}
%>					
			</ul>
		</div>
		</form>	
		<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("wish.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
		</ul>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>