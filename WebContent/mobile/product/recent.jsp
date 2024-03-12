<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="com.sanghafarm.service.order.*"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.service.code.*" %>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%
	request.setAttribute("MENU_TITLE", new String("최근본상품"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
	
	FrontSession fs = FrontSession.getInstance(request, response);
	ProductService product = (new ProductService()).toProxyInstance();
	CodeService code = new CodeService();
	List<Param> recentList = (ArrayList<Param>)session.getAttribute("recentList");
	if (fs.isLogin()) {
		Param searchParam = new Param();
		searchParam.set("userid", fs.getUserId());
		searchParam.addPaging(1, 15);
		recentList = product.getRecentProduct(searchParam);
	}

	String userid = "";
	
	if(fs.isLogin()) userid = fs.getUserId();
	else userid = fs.getTempUserId();
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
function removeItem(pid) {
	$("#recentList" + pid).hide();
	
	$.ajax({
		method : "POST",
		url : "/mobile/popup/removeRecent.jsp",
		data : { pid : pid }
	});
}

//장바구니담기 완료
function addCart(orderYn) {
	showQuick()	
}

function showQuick(){
	$(".pdtQuick").slideDown(150, "easeInOutQuint");	
}
function hideQuick(){
	$(".pdtQuick").slideUp(100, "easeInOutQuint");
}

function addWish(pid, wish) {
// 	if(wish == "N") {
		$.ajax({
			method: "POST",
			url : "/mypage/wishProc.jsp",
			data : { pid : pid, mode : "CREATE" },
			cache: false,
			dataType : "json"
		})
		.done(function(json) {
			console.log(json);
			alert(json.msg);
			if(json.msg == '<%= FrontSession.LOGIN_MSG %>') {
				fnt_login('R');
			}
		});

// 	} else {
// 		if(confirm("이 상품을 단골상품에서 등록 취소하시겠습니까?")) {
// 			$.ajax({
// 				method: "POST",
// 				url : "/mypage/wishProc.jsp",
// 				data : { pid : pid, mode : "REMOVE" },
// 				cache: false,
// 				dataType : "json"
// 			})
// 			.done(function(json) {
// 				console.log(json);
// 				alert(json.msg);
// 			});
// 		}
// 	}
}

</script> 
</head>  
<body>
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<p class="backBtn"><a href="#" onclick="history.back(); return false"><img src="/mobile/images/btn/btn_close3.png" alt="이전페이지"></a></p>
	<div id="popCont">
	<!-- 내용영역 -->
		<ul class="recentList">
<% 
	int i = 0;
	if (CollectionUtils.isNotEmpty(recentList)) {
		for(Param row : recentList) {
			row.set("grade_code", fs.getGradeCode());
			row.set("userid", fs.getUserId());
			Param info = product.getInfo(row);
			
			boolean isSoldOut = ("N".equals(info.get("sale_status")) || (info.getInt("opt_cnt") == 0 && info.getInt("stock") == 0));
%>
			<li id="recentList<%= row.get("pid")%>">				
				<div class="thumb">
<%
			if (isSoldOut) {
%>
					<div class="soldOut"><div><%= code.getCode2Name("028", info.get("soldout_msg", "001")) %></div></div>
<%
			}
%>
					<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid")%>" target="_parent"><img src="<%= row.get("thumb") %>" alt="<%= row.get("pnm") %>"></a>
				</div>
				<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid")%>" target="_parent">
					<p class="tit"><%= info.get("pnm") %></p>
				</a>
				<div class="btns">
<%
			if("Y".equals(info.get("adult_auth")) && !fs.isLogin()) {
%>
					<a href="#none" onclick="showPopupLayer('/mobile/popup/noMinors.jsp'); return false" class="cart">장바구니</a>
<%
			} else if("Y".equals(info.get("adult_auth")) && !fs.isAdult()) {
%>
					<a href="#none" onclick="showPopupLayer('/mobile/member/adultCertification.jsp'); return false" class="cart">장바구니</a>
<%
			} else if("Y".equals(info.get("routine_yn"))) {
%>
					<a href="#none" onclick="showPopupLayer('/mobile/popup/regularOption.jsp?pid=<%= row.get("pid") %>'); return false" class="cart">장바구니</a>
<%
			} else {		
%>
					<a href="#none" onclick="showPopupLayer('/mobile/popup/cart.jsp?pid=<%= row.get("pid") %>'); return false" class="cart">장바구니</a>
<%
			}
%>
					<a href="#none" onclick="addWish('<%= row.get("pid") %>', '<%= info.get("wish_yn") %>');return false" class="wish">단골상품</a>
					<a href="javascript:removeItem('<%= row.get("pid") %>')" class="del">삭제</a>
				</div>
			</li>
<% 
			if(i++ >= 15) break;
		} 
	} else {
%>
			<li class="none">+++ 최근 본 상품이 없습니다. +++</li>
<%		
	}
%>		
	</ul>
	<div class="pdtQuick" style="display:none">
		<div class="priceArea" style="display:block">
			<h2>옵션선택</h2>
			<p class="close"><a href="#" onclick="hideQuick(); return false"><img src="/mobile/images/btn/btn_close3.png" alt="닫기"></a></p>
			<h3>상품명</h3>
			<div class="countArea">
				<div class="count">
					<p class="tit">옵션명</p>
					<p class="price">
						<span><strong>10,000</strong>원</span>
						<strike>50,000원</strike>
					</p>
					<p class="countNum typeB">
						<a href="#none" onclick=""><img src="/mobile/images/btn/btn_minus2.png" alt="-"></a>
						<input type="text" name="" id="" value="1">
						<a href="#none" onclick=""><img src="/mobile/images/btn/btn_plus2.png" alt="+"></a>
					</p>
				</div><!-- //count -->
			</div><!-- countArea -->
			<p class="total">총 상품 금액 <strong><span id="total_price">10,000</span></strong>원</p>
		</div><!-- //priceArea -->
		<div class="btnArea">
			<span><a href="#none" onclick="addCart('N')" class="btnTypeG sizeL fl">장바구니</a></span>
			<span><a href="#none" onclick="addCart('Y')" class="btnTypeB sizeL fl">바로구매</a></span>
		</div>
	</div><!-- //pdtQuick -->	

	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->
<script>
//팝업높이조절
setPopup(<%=layerId%>);
</script>
</body>
</html>