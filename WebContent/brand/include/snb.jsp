<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<div id="snbBrand">
<%
	if(Depth_2 == 1){
%>
	<ul class="menu01">
		<li<%if(Depth_2 == 1 && Depth_3 == 1){ %> class="on"<%} %>><a href="/brand/introduce/story.jsp">상하농원은</a></li>
		<li<%if(Depth_2 == 1 && Depth_3 == 2){ %> class="on"<%} %>><a href="/brand/introduce/history.jsp">걸어온 길</a></li>
		<li<%if(Depth_2 == 1 && Depth_3 == 3){ %> class="on"<%} %>><a href="/brand/introduce/guide.jsp">이용안내</a></li>
		<li<%if(Depth_2 == 1 && Depth_3 == 4){ %> class="on"<%} %>><a href="/brand/introduce/facility.jsp">시설소개</a></li>
		<li<%if(Depth_2 == 1 && Depth_3 == 5){ %> class="on"<%} %>><a href="/brand/introduce/tour.jsp">주변관광</a></li>
		<li<%if(Depth_2 == 1 && Depth_3 == 6){ %> class="on"<%} %>><a href="/brand/introduce/location.jsp">오시는길</a></li>
	</ul>
<%
	} else if(Depth_2 == 2){
%>	
	<ul class="menu02">
		<li<%if(Depth_2 == 2 && Depth_3 == 1){ %> class="on"<%} %>><a href="/brand/workshop/ham.jsp">햄공방</a></li>
		<li<%if(Depth_2 == 2 && Depth_3 == 2){ %> class="on"<%} %>><a href="/brand/workshop/fruit.jsp">과일공방</a></li>
		<li<%if(Depth_2 == 2 && Depth_3 == 3){ %> class="on"<%} %>><a href="/brand/workshop/bread.jsp">빵공방</a></li>
		<li<%if(Depth_2 == 2 && Depth_3 == 4){ %> class="on"<%} %>><a href="/brand/workshop/ferment.jsp">발효공방</a></li>
		<%-- <li<%if(Depth_2 == 2 && Depth_3 == 5){ %> class="on"<%} %>><a href="/brand/workshop/garden.jsp">농부체험</a></li> --%>
		<%-- <li<%if(Depth_2 == 2 && Depth_3 == 6){ %> class="on"<%} %>><a href="/brand/workshop/factory.jsp">상하공장</a></li> --%>
		<li<%if(Depth_2 == 2 && Depth_3 == 7){ %> class="on"<%} %>><a href="/brand/workshop/oil.jsp">참기름공방</a></li>
		<li<%if(Depth_2 == 2 && Depth_3 == 8){ %> class="on"<%} %>><a href="/brand/workshop/cheese.jsp">치즈공방</a></li>
	</ul>
<%
	} else if(Depth_2 == 3){
%>	
	<ul class="menu03">
		<li<%if(Depth_2 == 3 && Depth_3 == 1){ %> class="on"<%} %>><a href="/brand/play/gallery.jsp">전시관</a></li>
		<li<%if(Depth_2 == 3 && Depth_3 == 2){ %> class="on"<%} %>><a href="/brand/play/experience/list.jsp">체험교실</a></li>
		<li<%if(Depth_2 == 3 && Depth_3 == 3){ %> class="on"<%} %>><a href="/brand/play/animal.jsp">동물농장</a></li>
		<li<%if(Depth_2 == 3 && Depth_3 == 4){ %> class="on"<%} %>><a href="/brand/play/sheep.jsp">양떼목장</a></li>
		<li<%if(Depth_2 == 3 && Depth_3 == 5){ %> class="on"<%} %>><a href="/brand/play/organic.jsp">젖소목장</a></li>
		<li<%if(Depth_2 == 3 && Depth_3 == 8){ %> class="on"<%} %>><a href="/brand/play/farm.jsp">스마트팜</a></li>
		<li<%if(Depth_2 == 3 && Depth_3 == 7){ %> class="on"<%} %>><a href="/brand/play/hotel.jsp">파머스빌리지</a></li>
		<li<%if(Depth_2 == 3 && Depth_3 == 6){ %> class="on"<%} %>><a href="/brand/play/reservation/admission.jsp">예약하기</a></li>
	</ul>
<%
	} else if(Depth_2 == 4){
%>	
	<ul class="menu04">
		<li<%if(Depth_2 == 4 && Depth_3 == 1){ %> class="on"<%} %>><a href="/brand/food/store1.jsp">상하키친</a></li>
		<li<%if(Depth_2 == 4 && Depth_3 == 2){ %> class="on"<%} %>><a href="/brand/food/store2.jsp">농원식당</a></li>
		<li<%if(Depth_2 == 4 && Depth_3 == 3){ %> class="on"<%} %>><a href="/brand/food/store3.jsp">파머스카페 상하</a></li>
		<%-- <li<%if(Depth_2 == 4 && Depth_3 == 4){ %> class="on"<%} %>><a href="/brand/food/store4.jsp">농원상회</a></li> --%>
		<li<%if(Depth_2 == 4 && Depth_3 == 5){ %> class="on"<%} %>><a href="/brand/food/store5.jsp">파머스마켓</a></li>
		<%-- <li<%if(Depth_2 == 4 && Depth_3 == 6){ %> class="on"<%} %>><a href="/brand/food/store6.jsp">브랜드샵</a></li> --%>
	</ul>
<%
	} else if(Depth_2 == 5){
%>	
	<ul class="menu05">
		<li<%if(Depth_2 == 5 && Depth_3 == 1){ %> class="on"<%} %>><a href="/brand/bbs/news/list.jsp">농원소식</a></li>
		<li<%if(Depth_2 == 5 && Depth_3 == 2){ %> class="on"<%} %>><a href="/brand/bbs/diary/list.jsp">농부의일기</a></li>
		<li<%if(Depth_2 == 5 && Depth_3 == 3){ %> class="on"<%} %>><a href="/brand/bbs/notice/list.jsp">공지사항</a></li>
	</ul>
<%
	}
%>
	<!-- <h1><%=MENU_TITLE %></h1> -->
</div>