<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.sanghafarm.service.product.CateService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*" %>
<%
	Param param = new Param(request);
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	

	FrontSession fs = FrontSession.getInstance(request, response);
	
	CateService cate = (new CateService()).toProxyInstance();
	
	// 1차 카테고리 리스트
	List<Param> list  = cate.get1DepthList(new Param());
	// 2차 카테고리 리스트
	List<Param> list1 = cate.getSubDepthList(new Param("cate_seq", "1"));
	List<Param> list2 = cate.getSubDepthList(new Param("cate_seq", "2"));
	List<Param> list3 = cate.getSubDepthList(new Param("cate_seq", "3"));
	List<Param> list4 = cate.getSubDepthList(new Param("cate_seq", "4"));
	List<Param> list5 = cate.getSubDepthList(new Param("cate_seq", "5"));
	List<Param> list6 = cate.getSubDepthList(new Param("cate_seq", "6"));
%>
<div id="category" class="transition <%if(Depth_1 == 2 || Depth_1 == 3 || Depth_1 == 4){%>shopping<%}%>">
<%
	if(Depth_1 == 1){ 
%>
	<p class="btn"><a href="#" onclick="hideCate(); return false"><img src="/mobile/images/btn/btn_close2.png" alt="카테고리닫기"></a></p>
<%
	} else if(Depth_1 == 5){ //파머스 빌리지
%>
	<p class="btn"><a href="#" onclick="hideCate(); return false"><img src="/mobile/images/btn/btn_close3.png" alt="카테고리닫기"></a></p>
<%
	} else {
%>
	<p class="btn"><a href="#" onclick="hideCate(); return false"><img src="/mobile/images/btn/btn_close7.png" alt="카테고리닫기"></a></p>
<%
	}
%>
	<ul class="member">
<%
	if(!fs.isLogin()) {
%>
		<li class="login"><a href="javascript:fnt_login()">로그인</a></li>
		<li class="join"><a href="javascript:fnt_join()">회원가입</a></li>
<%-- <%
	if(fs.isApp() && Depth_1 == 5){ //파머스빌리지
%>
		<li class="set"><a href=""></a></li>
<%
	}
%> --%>

<%
	} else {
%>
		<li class="logout"><a href="javascript:fnt_logout()">로그아웃</a></li>
		<li class="mypage"><a href="/mobile/mypage/index.jsp">마이페이지</a></li>
<%-- <%
	if(fs.isApp() && Depth_1 == 5){ //파머스빌리지
%>
		<li class="set"><a href=""></a></li>
<%
	}
%> --%>
<%
	}

	if(fs.isApp()) {
%>
		<li class="alram"><a href="javascript:goSetting()">알림설정</a></li>
<%
	}
%>
		<%= !SystemChecker.isReal() ? SystemChecker.getCurrentName().toUpperCase() : "" %>
	</ul>
<%
	if(Depth_1 == 1 || Depth_1 == 5){ //브랜드, 빌리지
%>		
	<ul class="quickNav<%if(Depth_1!=1){%> shopping<%}%>">
<%
		if(Depth_1 == 1){ //브랜드
%>		
		<li class="reser"><a href="/mobile/brand/play/reservation/admission.jsp">체험예약</a></li>
		<li class="location"><a href="/mobile/brand/introduce/location.jsp">오시는 길</a></li>
		<li class="facility"><a href="/mobile/brand/introduce/facility.jsp">시설소개</a></li>
		
<%
		} else { //파머스빌리지
%>
		<li class="reservation"><a href="/mobile/hotel/room/reservation/date.jsp">객실예약</a></li>
		<li class="reservationList"><a href="/mobile/mypage/reservation/hotel/list.jsp">예약현황</a></li>
		<li class="promotion"><a href="/mobile/hotel/village/promotion/list.jsp">프로모션</a></li>
<%
		}
%>			
	</ul>
<%
	}
%>		
	<div class="iscrollArea"><div class="wrap">
		<ul id="gnb">
<%
	if(Depth_1 == 1){ //브랜드
%>		
			<li<%if(Depth_2 == 1){ %> class="on"<%} %>><p><a href="/mobile/brand/story/story.jsp" onclick="return false">농원소개</a><span class="icoFold<%if(Depth_2 == 1){ %> on<%} %>"></span></p>
				<ul>
					<li<%if(Depth_2 == 1 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mobile/brand/introduce/story.jsp">상하농원은</a></li>
					<li<%if(Depth_2 == 1 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mobile/brand/introduce/history.jsp">걸어온길</a></li>
					<li<%if(Depth_2 == 1 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mobile/brand/introduce/guide.jsp">이용안내</a></li>
					<li<%if(Depth_2 == 1 && Depth_3 == 4){ %> class="on"<%} %>><a href="/mobile/brand/introduce/facility.jsp">시설소개</a></li>
					<li<%if(Depth_2 == 1 && Depth_3 == 5){ %> class="on"<%} %>><a href="/mobile/brand/introduce/tour.jsp">주변관광</a></li>
					<li<%if(Depth_2 == 1 && Depth_3 == 6){ %> class="on"<%} %>><a href="/mobile/brand/introduce/location.jsp">오시는길</a></li>
				</ul>
			</li>
			<li<%if(Depth_2 == 2){ %> class="on"<%} %>><p><a href="/mobile/brand/workshop/ham.jsp" onclick="return false">짓다 #볼거리</a><span class="icoFold<%if(Depth_2 == 2){ %> on<%} %>"></span></p>
				<ul>
					<li<%if(Depth_2 == 2 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mobile/brand/workshop/ham.jsp">햄공방</a></li>
					<li<%if(Depth_2 == 2 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mobile/brand/workshop/fruit.jsp">과일공방</a></li>
					<li<%if(Depth_2 == 2 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mobile/brand/workshop/bread.jsp">빵공방</a></li>
					<li<%if(Depth_2 == 2 && Depth_3 == 4){ %> class="on"<%} %>><a href="/mobile/brand/workshop/ferment.jsp">발효공방</a></li>
					<%-- <li<%if(Depth_2 == 2 && Depth_3 == 6){ %> class="on"<%} %>><a href="/mobile/brand/workshop/factory.jsp">상하공장</a></li> --%>
					<li<%if(Depth_2 == 2 && Depth_3 == 7){ %> class="on"<%} %>><a href="/mobile/brand/workshop/oil.jsp">참기름공방</a></li>
					<li<%if(Depth_2 == 2 && Depth_3 == 8){ %> class="on"<%} %>><a href="/mobile/brand/workshop/cheese.jsp">치즈공방</a></li>
				</ul>
			</li>
			<li<%if(Depth_2 == 3){ %> class="on"<%} %>><p><a href="/mobile/brand/play/gallery.jsp" onclick="return false">놀다 #즐길거리</a><span class="icoFold<%if(Depth_2 == 3){ %> on<%} %>"></span></p>
				<ul>
					<li<%if(Depth_2 == 3 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mobile/brand/play/gallery.jsp">전시관</a></li>
					<li<%if(Depth_2 == 3 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mobile/brand/play/experience/list.jsp">체험교실</a></li>
					<li<%if(Depth_2 == 3 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mobile/brand/play/animal.jsp">동물농장</a></li>
					<li<%if(Depth_2 == 3 && Depth_3 == 4){ %> class="on"<%} %>><a href="/mobile/brand/play/sheep.jsp">양떼목장</a></li>
					<li<%if(Depth_2 == 3 && Depth_3 == 5){ %> class="on"<%} %>><a href="/mobile/brand/play/organic.jsp">젖소목장</a></li>
					<li<%if(Depth_2 == 3 && Depth_3 == 8){ %> class="on"<%} %>><a href="/mobile/brand/play/farm.jsp">스마트팜</a></li>
					<li<%if(Depth_2 == 3 && Depth_3 == 7){ %> class="on"<%} %>><a href="/mobile/brand/play/hotel.jsp">파머스빌리지</a></li>
					<%-- <li<%if(Depth_2 == 3 && Depth_3 == 6){ %> class="on"<%} %>><a href="/mobile/brand/play/reservation/admission.jsp">예약하기</a></li>  --%>
					
				</ul>
			</li>
			<li<%if(Depth_2 == 4){ %> class="on"<%} %>><p><a href="/mobile/brand/food/store1.jsp" onclick="return false">먹다 #먹거리</a><span class="icoFold<%if(Depth_2 == 4){ %> on<%} %>"></span></p>
				<ul>
					<li<%if(Depth_2 == 4 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mobile/brand/food/store1.jsp">상하키친</a></li>
					<li<%if(Depth_2 == 4 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mobile/brand/food/store2.jsp">농원식당</a></li>
					<li<%if(Depth_2 == 4 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mobile/brand/food/store3.jsp">파머스카페 상하</a></li>
					<%-- <li<%if(Depth_2 == 4 && Depth_3 == 4){ %> class="on"<%} %>><a href="/mobile/brand/food/store4.jsp">농원상회</a></li> --%>
					<li<%if(Depth_2 == 4 && Depth_3 == 5){ %> class="on"<%} %>><a href="/mobile/brand/food/store5.jsp">파머스마켓</a></li>
					<%-- <li<%if(Depth_2 == 4 && Depth_3 == 6){ %> class="on"<%} %>><a href="/mobile/brand/food/store6.jsp">브랜드샵</a></li> --%>
				</ul>
			</li>
			<li<%if(Depth_2 == 5){ %> class="on"<%} %>><p><a href="/mobile/brand/news/list.jsp" onclick="return false">농원이야기</a><span class="icoFold<%if(Depth_2 == 5){ %> on<%} %>"></span></p>
				<ul>
					<li<%if(Depth_2 == 5 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mobile/brand/bbs/news/list.jsp">농원소식</a></li>
					<li<%if(Depth_2 == 5 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mobile/brand/bbs/diary/list.jsp">농부의일기</a></li>
					<li<%if(Depth_2 == 5 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mobile/brand/bbs/notice/list.jsp">공지사항</a></li>
				</ul>
			</li>
<%
	} else if(Depth_1 == 5){ //파머스빌리지
%>
			<li><p><a href="/mobile/hotel/room/reservation/date.jsp" onclick="return false">예약</a><span class="icoFold"></span></p>
				<ul>
					<li><a href="/mobile/hotel/room/reservation/date.jsp">객실</a></li>
					<li><a href="/mobile/hotel/offer/list.jsp">스페셜오퍼</a></li>
					<li><a href="/mobile/brand/play/experience/list.jsp">입장&체험</a></li>
				</ul>
			</li>
			<li<%if(Depth_2 == 2){ %> class="on"<%} %>><p><a href="/mobile/hotel/room/index.jsp" onclick="return false">객실예약</a><span class="icoFold<%if(Depth_2 == 2){ %> on<%} %>"></span></p>
				<ul>
					<li<%if(Depth_2 == 2 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mobile/hotel/room/index.jsp">전체보기</a></li>
					<li<%if(Depth_2 == 2 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mobile/hotel/room/suite.jsp">파머스빌리지</a></li>
					<li<%if(Depth_2 == 2 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mobile/hotel/room/glamping.jsp">파머스글램핑</a></li>
					<%-- <li<%if(Depth_2 == 2 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mobile/hotel/room/suite.jsp">룸 &amp; 스위트</a></li>
					<li<%if(Depth_2 == 2 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mobile/hotel/room/group.jsp">단체 룸</a></li> --%>					
					<li<%if(Depth_2 == 2 && Depth_3 == 4){ %> class="on"<%} %>><a href="/mobile/hotel/room/reservation/date.jsp">예약하기</a></li>
				</ul>
			</li>
			<li<%if(Depth_2 == 3){ %> class="on"<%} %>><p><a href="/mobile/hotel/dining/breakfast.jsp" onclick="return false">다이닝</a><span class="icoFold<%if(Depth_2 == 3){ %> on<%} %>"></span></p>
				<ul>
					<li<%if(Depth_2 == 3 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mobile/hotel/dining/breakfast.jsp">파머스테이블</a></li>
					<li<%if(Depth_2 == 3 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mobile/hotel/dining/lounge.jsp">웰컴라운지</a></li>
					<li<%if(Depth_2 == 3 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mobile/hotel/dining/restaurant.jsp">농원식당</a></li>
					<li<%if(Depth_2 == 3 && Depth_3 == 4){ %> class="on"<%} %>><a href="/mobile/hotel/dining/kitchen.jsp">상하키친</a></li>
				</ul>
			</li>
			<li<%if(Depth_2 == 6){ %> class="on"<%} %>><p><a href="/mobile/hotel/offer/list.jsp" onclick="return false">스페셜오퍼</a><span class="icoFold<%if(Depth_2 == 4){ %> on<%} %>"></span></p>
				<ul>
					<li<%if(Depth_2 == 6 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mobile/hotel/offer/list.jsp">Weekly특가</a></li>
					<li<%if(Depth_2 == 6 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mobile/hotel/offer/list.jsp?gubun=P">패키지</a></li>
					<li<%if(Depth_2 == 6 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mobile/hotel/village/promotion/list.jsp">프로모션</a></li>
				</ul>
			</li>
			<li<%if(Depth_2 == 4){ %> class="on"<%} %>><p><a href="/mobile/hotel/wedding/wedding.jsp" onclick="return false">웨딩&amp;세미나</a><span class="icoFold<%if(Depth_2 == 4){ %> on<%} %>"></span></p>
				<ul>
					<li<%if(Depth_2 == 4 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mobile/hotel/wedding/wedding.jsp">웨딩&amp;연회</a></li>
					<li<%if(Depth_2 == 4 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mobile/hotel/wedding/seminar.jsp">세미나</a></li>
				</ul>
			</li>
			<li<%if(Depth_2 == 5){ %> class="on"<%} %>><p><a href="/mobile/hotel/enjoy/farm.jsp" onclick="return false">즐길거리</a><span class="icoFold<%if(Depth_2 == 5){ %> on<%} %>"></span></p>
				<ul>
					<li<%if(Depth_2 == 5 && Depth_3 == 7){ %> class="on"<%} %>><a href="/mobile/hotel/enjoy/farm.jsp">상하농원</a></li>
					<%--<li<%if(Depth_2 == 5 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mobile/hotel/enjoy/experience.jsp">시즌체험</a></li>--%>
					<li<%if(Depth_2 == 5 && Depth_3 == 6){ %> class="on"<%} %>><a href="/mobile/hotel/enjoy/spa.jsp">노천스파</a></li>
					<li<%if(Depth_2 == 5 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mobile/hotel/enjoy/pool.jsp">수영장</a></li>
					<li<%if(Depth_2 == 5 && Depth_3 == 5){ %> class="on"<%} %>><a href="/mobile/hotel/enjoy/healthcare.jsp">셀렉스헬스케어</a></li>
					<li<%if(Depth_2 == 5 && Depth_3 == 4){ %> class="on"<%} %>><a href="/mobile/hotel/enjoy/campaign.jsp">에코기부참여</a></li>
				</ul>
			</li>
			<li<%if(Depth_2 == 1){ %> class="on"<%} %>><p><a href="/mobile/hotel/village/introduction.jsp" onclick="return false">빌리지 소개</a><span class="icoFold<%if(Depth_2 == 1){ %> on<%} %>"></span></p>
				<ul>
					<li<%if(Depth_2 == 1 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mobile/hotel/village/introduction.jsp">소개</a></li>
					<li<%if(Depth_2 == 1 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mobile/hotel/village/location.jsp">오시는길</a></li>
					<%--<li<%if(Depth_2 == 1 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mobile/hotel/village/floor.jsp">층별안내</a></li>--%>
					<li<%if(Depth_2 == 1 && Depth_3 == 4){ %> class="on"<%} %>><a href="/mobile/hotel/village/notice/list.jsp">문의사항</a></li>
				</ul>
			</li>

<%
	} else { //쇼핑
%>
			<li class="brandNav">
				<ul>
					<li><a href="/mobile/product/list.jsp?cate_seq=118">상하<span>브랜드관</span></a></li>
					<li><a href="/mobile/product/list.jsp?cate_seq=120">로컬푸드</a></li>
					<li><a href="/mobile/product/list.jsp?cate_seq=119">친환경</a></li>
					<li><a href="/mobile/product/list.jsp?cate_seq=128">정기배송</a></li>
				</ul>
			</li>
			<li <%= "4".equals(param.get("cate_seq")) ? "class='on'" : "" %>><p><a href="/mobile/product/list.jsp?cate_seq=4">설 선물세트</a><span class="icoFold"></span></p>
				<ul>
<%
	List<Param> subList = cate.getSubDepthList(new Param("cate_seq", "4"));
	for(Param row : subList) {
%>
					<li ><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
				</ul>
			</li>
			<!-- 
			<li <%= "150".equals(param.get("cate_seq")) ? "class='on'" : "" %>><p><a href="/mobile/product/list.jsp?cate_seq=150">선물세트</a><span class="icoFold"></span></p>
				<ul>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "150"));
	for(Param row : subList) {
%>
					<li ><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
				</ul>
			</li>
			 -->
			<li <%= "166".equals(param.get("cate_seq")) ? "class='on'" : "" %>><p><a href="/mobile/product/list.jsp?cate_seq=166">국내산 과일</a><span class="icoFold"></span></p>
				<ul>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "166"));
	for(Param row : subList) {
%>
					<li ><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
				</ul>
			</li>
			<!-- 
			<li <%= "165".equals(param.get("cate_seq")) ? "class='on'" : "" %>><p><a href="/mobile/product/list.jsp?cate_seq=165">국내산 채소</a><span class="icoFold"></span></p>
				<ul>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "165"));
	for(Param row : subList) {
%>
					<li ><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
				</ul>
			</li>
			 -->
			<li <%= "79".equals(param.get("cate_seq")) ? "class='on'" : "" %>><p><a href="/mobile/product/list.jsp?cate_seq=79">계란/정육/유제품</a><span class="icoFold"></span></p>
				<ul>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "79"));
	for(Param row : subList) {
%>
					<li ><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
				</ul>
			</li>
			<li <%= "80".equals(param.get("cate_seq")) ? "class='on'" : "" %>><p><a href="/mobile/product/list.jsp?cate_seq=80">수산물</a><span class="icoFold"></span></p>
				<ul>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "80"));
	for(Param row : subList) {
%>
					<li ><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
				</ul>
			</li>
			<li <%= "81".equals(param.get("cate_seq")) ? "class='on'" : "" %>><p><a href="/mobile/product/list.jsp?cate_seq=81">국/반찬/요리</a><span class="icoFold"></span></p>
				<ul>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "81"));
	for(Param row : subList) {
%>
					<li ><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
				</ul>
			</li>
			<li <%= "82".equals(param.get("cate_seq")) ? "class='on'" : "" %>><p><a href="/mobile/product/list.jsp?cate_seq=82">간편식/식사대용식</a><span class="icoFold"></span></p>
				<ul>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "82"));
	for(Param row : subList) {
%>
					<li ><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
				</ul>
			</li>
			<li <%= "83".equals(param.get("cate_seq")) ? "class='on'" : "" %>><p><a href="/mobile/product/list.jsp?cate_seq=83">요리양념/파우더류</a><span class="icoFold"></span></p>
				<ul>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "83"));
	for(Param row : subList) {
%>
					<li ><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
				</ul>
			</li>
			<li <%= "136".equals(param.get("cate_seq")) ? "class='on'" : "" %>><p><a href="/mobile/product/list.jsp?cate_seq=136">음료/건강</a><span class="icoFold"></span></p>
				<ul>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "136"));
	for(Param row : subList) {
%>
					<li ><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
				</ul>
			</li>
			<li <%= "137".equals(param.get("cate_seq")) ? "class='on'" : "" %>><p><a href="/mobile/product/list.jsp?cate_seq=137">간식/과자</a><span class="icoFold"></span></p>
				<ul>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "137"));
	for(Param row : subList) {
%>
					<li ><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
				</ul>
			</li>
			<li <%= "163".equals(param.get("cate_seq")) ? "class='on'" : "" %>><p><a href="/mobile/product/list.jsp?cate_seq=163">쌀/잡곡</a><span class="icoFold"></span></p>
				<ul>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "163"));
	for(Param row : subList) {
%>
					<li ><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
				</ul>
			</li>
			<li <%= "164".equals(param.get("cate_seq")) ? "class='on'" : "" %>><p><a href="/mobile/product/list.jsp?cate_seq=164">견과/건채소/건버섯</a><span class="icoFold"></span></p>
				<ul>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "164"));
	for(Param row : subList) {
%>
					<li ><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
				</ul>
			</li>
<%		
	}
%>		
		</ul>
<%
	if(Depth_1 != 1 && Depth_1 != 5){ //쇼핑에서만
		if(Utils.getTimeStampString(new Date(), "yyyyMMddHHmmss").compareTo("20180101000000") >= 0) {
%>		
			<jsp:include page="/mobile/include/main_banner.jsp" flush="true">
			    <jsp:param name="position" value="051"/>
			    <jsp:param name="POS_END" value="1"/>
			</jsp:include>
			<jsp:include page="/mobile/include/main_banner.jsp" flush="true">
			    <jsp:param name="position" value="052"/>
			    <jsp:param name="POS_END" value="1"/>
			</jsp:include>
<%
		}
	} 
%>	

<%
	if(Depth_1 != 5){ 
%>
	
		<p class="bann">
<%
	if(Depth_1 == 1){ //브랜드
%>	
			<a href="/mobile/main.jsp"><img src="/mobile/images/layout/bann_shopping.jpg" alt="쇼핑몰 바로가기"></a>		
<%
		if(fs.isApp()) {
%>
			<!-- <a href="/mobile/hotel/index.jsp?target=web"><img src="/mobile/images/layout/bann_hotel.jpg" alt="파머스빌리지 바로가기"></a> -->
			<a href="/mobile/hotel/index.jsp"><img src="/mobile/images/layout/bann_hotel.jpg" alt="파머스빌리지 바로가기"></a> 
<%
		} else {
%>
			<a href="/mobile/hotel/index.jsp"><img src="/mobile/images/layout/bann_hotel.jpg" alt="파머스빌리지 바로가기"></a>
<%
		}
	} else {
%>			
			<!-- <a href="/mobile/brand/index.jsp"><img src="/mobile/images/layout/bann_brand.jpg" alt="상하농원 브랜드 바로가기"></a>
			<a href="/mobile/brand/play/reservation/admission.jsp"><img src="/mobile/images/layout/bann_brand2.jpg" alt="농원 예약하기"></a> -->
<%
		if(fs.isApp()) {
%>
			<!-- <a href="/mobile/hotel/index.jsp?target=web"><img src="/mobile/images/layout/bann_hotel.jpg" alt="파머스빌리지 바로가기"></a> -->
			<!-- <a href="/mobile/hotel/index.jsp"><img src="/mobile/images/layout/bann_hotel.jpg" alt="파머스빌리지 바로가기"></a> -->
<%
		} else {
%>
			<!-- <a href="/mobile/hotel/index.jsp"><img src="/mobile/images/layout/bann_hotel.jpg" alt="파머스빌리지 바로가기"></a> -->
<%
		}
	}
%>					
		</p>
<%	
	}
%>

<%
	if(Depth_1 == 5){ //파머스빌리지
%>
		<p class="bann">
			<a href="/mobile/main.jsp"><img src="/mobile/images/layout/bann_shopping_2.jpg" alt="쇼핑몰 바로가기"></a>	
			<a href="/mobile/brand/index.jsp"><img src="/mobile/images/layout/bann_brand_2.jpg" alt="파머스빌리지 바로가기"></a>			
		</p>
		<ul class="bann">
			<li><a href="/mobile/customer/hotelCounsel.jsp">파머스 빌리지 상담</a></li>
			<li><a href="tel:1522-3698">고객센터 전화</a></li>
<!-- 			<li><a href="/mobile/customer/payment/list.jsp">개인결제</a></li> -->
		</ul>

<%
		
	}
%>

<%
	if(Depth_1 == 1){ 
%>
		<ul class="customer">
			<li class="tel"><a href="javascript:_serviceCenterTel();">고객센터 전화</a></li>
			<li class="counsel"><a href="/mobile/customer/counsel.jsp">1:1문의</a></li>
			<li class="counsel"><a href="/mobile/customer/hotelCounsel.jsp">파머스빌리지 상담</a></li>
<!-- 			<li class="counsel"><a href="/mobile/customer/payment/list.jsp">개인결제</a></li>			 -->
		</ul>
<%
	} 
%>		
<%
	if(Depth_1 == 2 || Depth_1 == 3 || Depth_1 == 4){ //쇼핑에서만
%>	
		<ul class="sns">			
			<li class="kakao"><a href="https://pf.kakao.com/_zfxaVd?target=web" target="_blank" title="새창열림">카카오톡 친구맺기</a></li>
			<li class="instagram"><a href="https://www.instagram.com/sanghafarm/" target="_blank" title="새창열림">인스타그램</a></li>
		</ul>
		<ul class="customer2">
			<li class="faq"><a href="/mobile/customer/faq.jsp">FAQ</a></li>
			<li class="qna"><a href="/mobile/customer/counsel.jsp">1:1문의</a></li>
			<li class="center"><a href="javascript:_serviceCenterTel();">고객센터</a></li>
			<li class="counsel"><a href="/mobile/customer/hotelCounsel.jsp">파머스빌리지 상담</a></li>	
		</ul>
<%
	}
%>		
	</div></div><!-- //iscrollArea -->
	<script>
		var _serviceCenterTel = function(){
			location.href = "tel:1522-3698";
		}
	</script>
</div><!-- //category -->