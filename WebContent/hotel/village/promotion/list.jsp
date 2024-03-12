<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.hotel.*,
			com.sanghafarm.service.code.*,
			com.sanghafarm.utils.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(6));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("빌리지 소개"));

	Param param = new Param(request);
	HotelPromotionService svc = new HotelPromotionService();
	CodeService code = new CodeService();
	
	//검색파라미터 쿠키 저장
	param.keepQuery(response);
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 6);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	//게시물 리스트
	List<Param> list = svc.getList(param);
	//게시물 갯수
	int totalCount = svc.getListCount(param);
	
	List<Param> cateList = code.getList2("034");
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />

</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel village">
		<!-- 내용영역 -->
		<jsp:include page="/hotel/offer/tab.jsp" />
		<div class="villageTop">
			<p class="animated fadeInUp delay02">파머스빌리지에서 준비한<br>특별한 프로모션을 만나보세요.</p>
			<ul class="promotionTab animated fadeInUp delay02">
				<li <%= "".equals(param.get("cate")) ? "class=\"on\"" : "" %>><a href="list.jsp">전체</a></li>
<%
	for(Param row : cateList) {
%>
				<li <%= row.get("code2").equals(param.get("cate")) ? "class=\"on\"" : "" %>><a href="list.jsp?cate=<%= row.get("code2") %>"><%= row.get("name2") %></a></li>
<%
	}
%>
			</ul>
		</div>	
		<div class="promotionWrap">
			<ul class="promotionList">
<%
	if(list.size() > 0){
		for(Param row : list) {
			String url = "1".equals(row.get("content_type")) ? "view.jsp?seq=" + row.get("seq") : row.get("pc_url");
%>
				<li class="animated fadeInUp"><a href="<%= url %>">
					<p class="thumb"><img src="<%= row.get("pc_list_img") %>" alt=""></p>
					<p class="tit"><%= row.get("title") %></p>
					<p class="date"><%= row.get("start_date").substring(0, 10) %> ~ <%= row.get("end_date").substring(0, 10) %></p>
					<p class="ico ico<%= Integer.parseInt(row.get("cate")) %>"><%= row.get("cate_name") %></p>
					</a>
				</li>
<%
		}
	} else {
%>
				<li class="animated fadeInUp none">** 현재 해당 프로모션이 없습니다. **</li>
<%
	}
%>
			</ul>
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
			</ul>
		</div>

		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
