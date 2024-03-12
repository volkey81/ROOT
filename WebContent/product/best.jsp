<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.product.*,
				 com.sanghafarm.service.code.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	CateService cate = (new CateService()).toProxyInstance();
	ProductService product = (new ProductService()).toProxyInstance();
	CodeService code = new CodeService();
	
	//페이징 변수 설정
	int PAGE_SIZE = param.getInt("page_size", 100);
	int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	if (StringUtils.isNotEmpty(param.get("mode"))) {
		if (StringUtils.equals("quick", param.get("mode"))) {
			BLOCK_SIZE = 5;
		}
	}
	param.addPaging(nPage, PAGE_SIZE);
	param.set("sort", "pop");
	param.set("grade_code", fs.getGradeCode());
	
	List<Param> list = product.getList(param);
	int totalCount = product.getListCount(param);
	
	param.remove("grade_code");
%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", "베스트");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<div id="container">
		<table class="pdtTabArea">
			<tr>
				<th>베스트</th>
				<td>
					<ul class="pdtTab">
						<li <%= "".equals(param.get("cate_seq")) ? "class=\"on\"" : "" %>><a href="/product/best.jsp">전체보기</a></li>
						<li <%= "78".equals(param.get("cate_seq")) ? "class=\"on\"" : "" %>><a href="/product/best.jsp?cate_seq=78">농산물</a></li>
						<li <%= "79".equals(param.get("cate_seq")) ? "class=\"on\"" : "" %>><a href="/product/best.jsp?cate_seq=79">계란/정육/유제품</a></li>
						<li <%= "80".equals(param.get("cate_seq")) ? "class=\"on\"" : "" %>><a href="/product/best.jsp?cate_seq=80">수산물</a></li>
						<li <%= "81".equals(param.get("cate_seq")) ? "class=\"on\"" : "" %>><a href="/product/best.jsp?cate_seq=81">국/반찬/요리</a></li>
						<li <%= "82".equals(param.get("cate_seq")) ? "class=\"on\"" : "" %>><a href="/product/best.jsp?cate_seq=82">간편식/식사대용식</a></li>
						<li <%= "83".equals(param.get("cate_seq")) ? "class=\"on\"" : "" %>><a href="/product/best.jsp?cate_seq=83">요리양념/파우더류</a></li>
						<li <%= "136".equals(param.get("cate_seq")) ? "class=\"on\"" : "" %>><a href="/product/best.jsp?cate_seq=136">음료/건강</a></li>
						<li <%= "137".equals(param.get("cate_seq")) ? "class=\"on\"" : "" %>><a href="/product/best.jsp?cate_seq=137">간식/과자</a></li>
					</ul>
				</td>
			</tr>
		</table>
		
		<ul class="pdtList">
<%
	for(Param row : list) {
		boolean isSoldOut = ("N".equals(row.get("sale_status")) || (row.getInt("opt_cnt") == 0 && row.getInt("stock") == 0));
%>					
			<li>
				<a href="detail.jsp?pid=<%= row.get("pid") %>">
					<div class="thumb">
<%
			if (isSoldOut) {
%>
			<div class="soldOut"><div><%= code.getCode2Name("028", row.get("soldout_msg", "001")) %></div></div>
<%
			}
%>
						<img src="<%= row.get("image1") %>" alt="<%= row.get("pnm") %>">
					</div>
					<p class="tit"><%= row.get("pnm") %></p>
					<p class="cont"><%= row.get("summary") %></p>
<%
		if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
				<p class="discount">
					<span><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %>%</span>
					<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
				</p>
<%
		}
%>
				<p class="price"><strong><%= Utils.formatMoney(row.get("sale_price")) %></strong>원</p>
				</a>
				<p class="icon">
					<span><%= row.get("icon") %></span>
<%-- <%
		String[] icons = row.get("icons").split(",");
		for(int i = 0; i < icons.length; i++) {
			if(!"".equals(icons[i])) {
%>
					<img src="/images/product/ico<%= icons[i] %>.gif" alt="">
<%
			}
		}
%> --%>
				</p>
<%-- 				<p class="btn">
<%
	if (isSoldOut) {
%>
	<a href="#" onclick="showPopupLayer('/popup/restock.jsp?pid=<%= row.get("pid") %>', '580'); return false"><img src="/images/btn/btn_noti.png" alt="재입고 알림"></a>
<%
	} else {
		if("Y".equals(row.get("adult_auth")) && !fs.isLogin()) {
%>
					<a href="#" onclick="showPopupLayer('/popup/noMinors.jsp', '450'); return false"><img src="/images/btn/btn_cart.png" alt="장바구니에 담기"></a>
<%
		} else if("Y".equals(row.get("adult_auth")) && !fs.isAdult()) {
%>
					<a href="#" onclick="showPopupLayer('/mobile/member/adultCertification.jsp', '450'); return false"><img src="/images/btn/btn_cart.png" alt="장바구니에 담기"></a>
<%
		} else if("Y".equals(row.get("routine_yn"))) {
%>
					<a href="#" onclick="showPopupLayer('/popup/regularOption.jsp?pid=<%= row.get("pid") %>', '580'); return false"><img src="/images/btn/btn_cart.png" alt="장바구니에 담기"></a>
<%
		} else {	
%>
					<a href="#" onclick="showPopupLayer('/popup/cart.jsp?pid=<%= row.get("pid") %>', '460'); return false"><img src="/images/btn/btn_cart.png" alt="장바구니에 담기"></a>
<%
			}
		}
%>
				</p> --%>
			</li>
<%
	}

	if(totalCount == 0) {
%>
			<li class="none"><img src="/images/product/noList.png" alt="상품 준비중입니다. 고객님 조금만 기다려주세요! 농부의 땀과 진심을 담은 상품을 준비하고 있습니다."></li>
<%
	}
%>
		</ul>
		<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeToShop(out);
	}
%>
		</ul>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
setListHeight(".pdtList", 4);
</script>
</body>
</html>