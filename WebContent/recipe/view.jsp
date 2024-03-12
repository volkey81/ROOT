<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.board.FarmerMenuService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("레시피"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FarmerMenuService menu = (new FarmerMenuService()).toProxyInstance();

	param.set("cate", "001");
	Param info = menu.getInfo(param);
	Param prev = menu.getPrevInfo(param);
	Param next = menu.getNextInfo(param);
	menu.modifyHit(param);
	List<Param> productList = menu.getProductList(param.get("seq"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<ul id="location">
		<li><a href="/">홈</a>
		<li>레시피</li>
	</ul>
	<div id="container">
	<!-- 내용영역 -->
		<div class="recipeView">
			<div class="head">
				<h1><%= info.get("title") %></h1>
				<p class="text"><%= info.get("summary") %></p>
			</div>
			<div class="content">
				<%= info.get("contents") %>
			</div>
		</div><!-- //recipeView -->
		<div class="relativeArea">
			<h2>본 레시피에 사용된 상하농원 제품입니다.</h2>
			<div class="list">
				<div class="slideCont">
					<ul class="swiper-wrapper">
<%
					for(Param row : productList) {
						
%>
					<li class="swiper-slide"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
						<p class="thumb"><img src="<%= row.get("thumb") %>" alt=""></p>
						<p class="tit"><%= row.get("pnm") %></p>
					</a></li>
					
<%
					}
%>
					</ul>
				</div>
<%
				if (productList.size() > 4) {
%>
				<input type="image" src="/images/btn/btn_prev.png" alt="이전" class="prev">
				<input type="image" src="/images/btn/btn_next.png" alt="다음" class="next">
<%
				}				
%>
			</div>
		</div><!-- //relativeArea -->
		<div class="btnArea">
			<a href="list.jsp" class="btnTypeB sizeL">목록</a>
		</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
<%
	if (productList.size() > 4) {
%>
<script>
var rSwiper = new Swiper($(".relativeArea .slideCont"), {
	slidesPerView: 4,
    spaceBetween: 30,
	prevButton: $(".relativeArea .prev"),
	nextButton: $(".relativeArea .next"),
	loop: true
});
</script>
<%
	}
%>
</body>
</html>