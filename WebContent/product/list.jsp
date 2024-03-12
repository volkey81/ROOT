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
	
	List<Param> cateList = new ArrayList<Param>();
	Param cateInfo = new Param();
	Param pcateInfo = new Param();
	String pCateSeq = "";
	
	if (StringUtils.isNotEmpty(param.get("cate_seq"))) {
		cateInfo = cate.getInfo(param.getInt("cate_seq"));
		if(cateInfo.getInt("p_cate_seq") == 0) {	// 1dept
			pCateSeq = param.get("cate_seq");
			cateList = cate.getSubDepthList(param);
			pcateInfo = cateInfo;
		} else {
			pCateSeq = cateInfo.get("p_cate_seq");
			cateList = cate.getSubDepthList(new Param("cate_seq", cateInfo.get("p_cate_seq")));
			pcateInfo = cate.getInfo(cateInfo.getInt("p_cate_seq"));
		}
	}
	
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
	param.set("grade_code", fs.getGradeCode());
	
	List<Param> list = product.getList(param);
	int totalCount = product.getListCount(param);
	
	param.remove("grade_code");
	String cateName = "";
	if (StringUtils.equals("pop", param.get("sort"))
			&& StringUtils.equals("quick", param.get("mode"))) {
		cateName = "베스트 상품";
	} else if (StringUtils.equals("date", param.get("sort"))
				&& StringUtils.equals("quick", param.get("mode"))) {
		cateName = "신상품";
	}
%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", StringUtils.isEmpty(cateInfo.get("cate_name")) ? cateName  : cateInfo.get("cate_name"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
	function goList() {
		//document.location.href="/product/list.jsp?cate_seq=<%= param.get("cate_seq") %>&sort=" + $("#sort").val() + "&page_size=<%= PAGE_SIZE %>&cate_name=<%= param.get("cate_name") %>&mode=<%= param.get("mode") %>";
		document.location.href="/product/list.jsp?cate_seq=<%= param.get("cate_seq") %>&sort=" + $("#sort").val() + "&page_size=<%= PAGE_SIZE %>";
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<%-- <ul id="location">
		<li><a href="/">홈</a></li>
<%
	String[] path = cateInfo.get("path").split(">");
	for(int i = 1; i < path.length; i++) {
%>
		<li><%= path[i] %></li>
<%
	}
%>
	</ul> --%>
	<div id="container">
	<!-- 내용영역 -->
		<%-- <div class="visual">
<%
	if (StringUtils.equals("pop", param.get("sort"))
			&& StringUtils.equals("quick", param.get("mode"))) {		
%>
			<img src="/images/product/visual_best.JPG" alt="">
<%
	} else if (StringUtils.equals("date", param.get("sort"))
			&& StringUtils.equals("quick", param.get("mode"))) {		
%>
			<img src="/images/product/visual_new.jpg" alt="">
<%
	} else  {		
%>
			<img src="/images/product/visual<%=pCateSeq %>.jpg?t=<%=System.currentTimeMillis()%>" alt="">
<%
	}		
%>
		</div> --%>
<%
		if (StringUtils.isEmpty(param.get("mode"))) {
%>
		<table class="pdtTabArea">
			<tr>
				<th><%= StringUtils.isNotEmpty(param.get("cate_seq")) ? pcateInfo.get("cate_name") : ("date".equals(param.get("sort")) ? "신상품" : "베스트") %></th>
				<td>
					<ul class="pdtTab">
						<li <%= pCateSeq.equals(param.get("cate_seq")) ? "class=\"on\"" : "" %>><a href="/product/list.jsp?cate_seq=<%= pCateSeq %>">전체보기</a></li>
<%
	int idx = 0;
	for(Param row : cateList) {
		if(pCateSeq.equals("4") && idx++ == 3) out.println("<br />");
%>
						<li <%= row.get("cate_seq").equals(param.get("cate_seq")) ? "class=\"on\"" : "" %>><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
					</ul>
				</td>
			</tr>
		</table>
		
<%
		}
%>
		<div class="pdtListHead" style="display:<%= "".equals(param.get("cate_seq")) ? "none" : "" %>">
			<%-- <p class="text">총 <span class="fontTypeA"><%= Utils.formatMoney(totalCount) %></span>개의 상품이 판매중입니다.</p>
			<select name="page_size" id="page_size" onchange="goList()" title="목록 갯수 설정">
				<option value="8" <%= 8 == param.getInt("page_size", 8) ? "selected" : "" %>>8개씩 보기</option>
				<option value="16" <%= 16 == param.getInt("page_size") ? "selected" : "" %>>16개씩 보기</option>
				<option value="32" <%= 32 == param.getInt("page_size") ? "selected" : "" %>>32개씩 보기</option>
			</select> --%>
			<select name="sort" id="sort" onchange="goList()" title="제품 정렬 방법 선택" class="defaultSelect" style="width:110px">
				<option value="rec" <%= "rec".equals(param.get("sort")) ? "selected" : "" %>>추천순</option>
				<option value="pop" <%= "pop".equals(param.get("sort")) ? "selected" : "" %>>인기순</option>
				<option value="date" <%= "date".equals(param.get("sort")) ? "selected" : "" %>>신상품순</option>
			</select>
		</div>
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