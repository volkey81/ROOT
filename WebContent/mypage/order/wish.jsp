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
<%@ include file="/include/common.jsp" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("단골상품"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
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
<jsp:include page="/include/head.jsp" /> 
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
		
		$("#wishForm").attr("action", "<%= WEBROOT %>/mypage/wishProc.jsp");
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
		showPopupLayer('memberGate.jsp', '580', '500');
	}
	
	function submitOrder() {
		$("#wishForm").attr("action", "/order/payment.jsp");
		$("#wishForm").attr("target", "");
		$("#wishForm input[name=mode]").val("ORDER");
		$("#wishForm").submit();
	}
	

</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/mypage/snb.jsp" />
		<div id="contArea">
			<form name="wishForm" id="wishForm">
				<input type="hidden" name="mode" value="REMOVE" />
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<!-- 내용영역 -->						
			<table class="bbsList">
			<caption>단골 상품 목록</caption>
				<colgroup>
					<col width="50"><col width="126"><col width=""><col width="160"><col width="120">
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="check_all" onclick="checkAll()" title="전체선택"></th>
						<th scope="col" colspan="2">상품</th>
						<th scope="col">기본판매가</th>
						<th scope="col">관리</th>
					</tr>
				</thead>
				<tbody>
<%
	if (CollectionUtils.isNotEmpty(wishList)) {
		for(Param row : wishList) {
%>
					<tr>
						<th scope="row" class="vt"><input type="checkbox" name="pid" value="<%= row.get("pid") %>"></th>
						<td class="bln"><p class="thumb"><a href="<%= WEBROOT %>/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("thumb") %>" alt="" width="124"></a></p></td>
						<td class="bln tit pName"><a href="<%= WEBROOT %>/product/detail.jsp?pid=<%= row.get("pid") %>">
							<%= row.get("pnm") %>
<!-- 							<p class="opt">유기농 바나나 멸균우유 125ml(24개)</p> -->
						</a></td>
						<td class="last">
<%
			if (StringUtils.equals("N", row.get("sale_status")) || row.getInt("stock") == 0) {
%>
							<strong class="fontTypeB">품절</strong>
							<p class="btn"><a href="#" onclick="showPopupLayer('/popup/restock.jsp?pid=<%= row.get("pid") %>', '580'); return false" class="btnTypeC sizeS icoAlram">재입고 알림</a></p>
							
<% 
			} else { 
%>
							<p class="price">
<%
				if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
								<strike><%= Utils.formatMoney(row.get("default_price")) %></strike><br/>
<%
				}
%>
								<strong><%= Utils.formatMoney(row.get("sale_price")) %></strong>원
							</p>
<%
			} 
%>
							
						</td>
						<td class="last">
							<p class="btn">
<%
			if("Y".equals(row.get("routine_yn"))) {
%>
								<a href="#none" onclick="showPopupLayer('/popup/regularOption.jsp?pid=<%= row.get("pid") %>', '580'); return false" class="btnTypeA sizeS">구매하기</a>
<%
			} else {
%>
								<a href="#none" onclick="showPopupLayer('/popup/cart.jsp?pid=<%= row.get("pid") %>', '460'); return false" class="btnTypeA sizeS">구매하기</a>
<%
			}
%>
							</p>
						</td>
					</tr>
<%
		}
	} else {
%>
					<tr>
						<td colspan="5">+++ 조회내역이 없습니다. +++</td>
					</tr>
<%
	}
%>	
				</tbody>
			</table>
			</form>
			<div class="cartFoot">
				선택한 상품을
				<a href="javascript:void(0)" onclick="removeWish()" class="btnTypeC sizeS">삭제</a>
			</div>		
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("wish.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
			</ul>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>