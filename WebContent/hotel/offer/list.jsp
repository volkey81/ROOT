<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.hotel.*,
			com.sanghafarm.service.code.*,
			com.sanghafarm.utils.*" %>
<%
	Param param = new Param(request);
	String gubun = param.get("gubun", "W");
	param.set("gubun", gubun);
	
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(6));
	request.setAttribute("Depth_3", "W".equals(gubun) ? new Integer(1) : new Integer(2)); //패키지: Depth_3 = 2
	request.setAttribute("MENU_TITLE", "W".equals(gubun) ? new String("Weekly특가") : new String("패키지"));
	
	HotelOfferService svc = new HotelOfferService();
	
	//게시물 리스트
	List<Param> list = svc.getList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />

</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel">
		<!-- 내용영역 -->		
		<div class="offerArea">
			<jsp:include page="/hotel/offer/tab.jsp" />
			<p class="srmy animated fadeInUp delay04">상하농원 회원에게만 제공되는<br>특별한 객실 <%= "W".equals(gubun) ? "프로모션" : "패키지" %> 상품을 만나보세요.</p>
			<ul class="list animated fadeInUp delay06">
<%
	for(Param row : list) {
%>
				<li><a href="detail.jsp?pid=<%= row.get("pid") %>&gubun=<%= gubun %>">
					<img src="<%= row.get("pc_list_img") %>" alt="">
					<p class="tit"><%= row.get("pnm") %></p>
					<p class="text"><%= row.get("summary") %></p>
					<p class="text2"><%= row.get("provide") %></p>
					<p class="price"><%= Utils.formatMoney(row.get("min_price")) %>원 ~</p>
				</a></li>
<%
	}

	if(list == null || list.size() == 0) {
%>
				<li class="none">+++ 등록된 상품이 없습니다. +++</li>
<%
	}
%>
			</ul>
			<ul class="paging animated fadeIn delay10">
<%
	/*
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(Utils.safeHTML2(param.toQueryString("list.jsp")), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
	*/
%>
			</ul>
		</div><!-- //offerArea -->
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
