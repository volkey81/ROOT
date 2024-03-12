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
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("문의사항"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	HotelNoticeService svc = new HotelNoticeService();
	CodeService code = new CodeService();
	
	//검색파라미터 쿠키 저장
	param.keepQuery(response);

	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	//게시물 리스트
	List<Param> list = svc.getList(param);
	//게시물 갯수
	int totalCount = svc.getListCount(param);

	List<Param> cateList = code.getList2("035");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp"/> 
<script>
	$(function (){
	})
</script>
</head>  
<body>

<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="village">
		<!-- 내용영역 -->
		<h2 class="animated fadeInUp delay02">문의사항</h2>
		<ul class="listStyleC">
		

<% 
if(list.size() > 0){
	for(Param row : list) {
%>
			<li class="animated fadeIn"><a href="view.jsp?seq=<%= row.get("seq") %>&cate=<%= param.get("cate") %>&keyword=<%= param.get("keyword") %>">
				<p class="kind"><span class="tit <%= "001".equals(row.get("cate")) ? "norice" : "pr" %>Icon"><%= row.get("cate_name") %></span><span class="date"><%= row.get("wdate").substring(0, 10) %></span></p><!-- 공지일경우 class="tit01" -->
				<p class="txt"><%= row.get("title") %></p>
			</a></li>
<%
		}
	} else {
%>
				<li class="animated fadeInUp none">**게시물이 없습니다.**</li>
<%
	}
%>
			
		</ul>
		<ul class="paging animated fadeIn delay10">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
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