<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="com.sanghafarm.service.order.*"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="java.util.*,
				 com.efusioni.stone.utils.*"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%
	request.setAttribute("MENU_TITLE", new String("최근본상품"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
	
	FrontSession fs = FrontSession.getInstance(request, response);
	ProductService product = (new ProductService()).toProxyInstance();
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
			url : "removeRecent.jsp",
			data : { pid : pid }
		});
	}
</script> 
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<ul class="recentList">
<% 
	int i = 0;
	if (CollectionUtils.isNotEmpty(recentList)) {
		for(Param row : recentList) {
			if(i++ >= 15) break;
%>
			<li id="recentList<%= row.get("pid")%>">
				<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid")%>" target="_parent"><img src="<%= row.get("thumb") %>" alt=""></a>
				<p class="btn"><a href="javascript:removeItem('<%= row.get("pid") %>')"><img src="/mobile/images/btn/btn_delete.png" alt="삭제"></a></p>
			</li>
<% 
		} 
	} else {
%>
			<li class="none">+++ 최근 본 상품이 없습니다. +++</li>
<%		
	}
%>		
	</ul>	
	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->
<script>
//팝업높이조절
setPopup(<%=layerId%>);
</script>
</body>
</html>