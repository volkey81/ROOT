<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*" %>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	

%>
<div id="skipNav">
	<a href="#container">본문 바로가기</a>
	<a href="#gnb">메뉴 바로가기</a>
</div>
<div id="header" class="bg<%=Depth_1%>"><div class="wrap">
	<div id="util">
		<ul>
			<li><a href="javascript:fnt_login()">로그인</a></li>
			<li><a href="javascript:fnt_join()">회원가입</a></li>
			<li><a href="/customer/faq.jsp">고객센터</a></li>
			<li class="cart"><a href="/order/cart.jsp">장바구니 <span class="num"></span></a></li>
		</ul>
		<p class="app"><a href="">앱 다운로드</a></p>
	</div>
	<p class="logo"><a href="/url.html"><img src="/images/layout/logo.png" alt="상하농원"></a></p>
	<fieldset class="quickSrch">
		<legend>통합검색</legend>
		<input type="text" name="">
		<button title="검색"><img src="/images/layout/btn_search.png" alt="검색"></button>
	</fieldset>
	<%-- <jsp:include page="/include/banner.jsp" flush="true">
	    <jsp:param name="position" value="018"/>
	    <jsp:param name="POS_END" value="1"/>
	</jsp:include> --%>
	<div id="gnb">
		<ul>
			<li<%if(Depth_1 == 1){ %> class="on"<%} %>><a href="/url.html"><img src="/images/layout/nav1.png" alt="안내/체험"></a>
				<div class="mainNav brand">
					<p class="all"><a href="#brandSubNav" onclick="return false"><span>전체보기</span></a></p>
					<ul>
						<li<%if(Depth_1 == 1 && Depth_2 == 1){ %> class="on"<%} %>><a href="/brand/story/story.jsp">상하농원이란</a></li>
						<li<%if(Depth_1 == 1 && Depth_2 == 2){ %> class="on"<%} %>><a href="/brand/workshop/ham.jsp">짓다</a></li>
						<li<%if(Depth_1 == 1 && Depth_2 == 3){ %> class="on"<%} %>><a href="/brand/play/gallery.jsp">놀다</a></li>
						<li<%if(Depth_1 == 1 && Depth_2 == 4){ %> class="on"<%} %>><a href="/brand/food/">먹다</a></li>
						<li<%if(Depth_1 == 1 && Depth_2 == 5){ %> class="on"<%} %>><a href="/brand/news/list.jsp">농원이야기</a></li>
					</ul>
					<!-- <div class="subNav" id="brandSubNav">
						<ul>
							<li><a href="">1</a></li>
							<li><a href="">2</a></li>
						</ul>
					</div> -->
				</div>
			</li><!-- //안내.체험 -->
			<li<%if(Depth_1 == 2 || Depth_1 == 3 || Depth_1 == 4){ %> class="on"<%} %>><a href="/index.jsp"><img src="/images/layout/nav2.png" alt="쇼핑"></a>
				<div class="mainNav shopping">
					<p class="all"><a href="#shoppingSubNav" onclick="return false"><span>전체보기</span></a></p>
					<ul class="cate">
						<li><a href="/product/list.jsp?cate_seq=2">신선식품</a></li>
						<li><a href="/product/list.jsp?cate_seq=2">정육/계란</a></li>
						<li><a href="/product/list.jsp?cate_seq=2">가공식품</a></li>
						<li><a href="/product/list.jsp?cate_seq=2">특산물관</a></li>
						<li><a href="/product/list.jsp?cate_seq=2">상하공방</a></li>
						<li><a href="/product/list.jsp?cate_seq=2">상하목장</a></li>
					</ul>
					<ul class="type">
						<li class="regular"><a href="">정기배송</a></li>
						<li class="direct"><a href="">산지직송</a></li>
						<li class="event"><a href="/event/list.jsp">이벤트/기획전</a></li>
						<li class="discount"><a href="">할인찬스</a><img src="/images/layout/ico_sale.png" alt="SALE" class="transition"></li>
					</ul>
					<div class="subNav" id="shoppingSubNav">
						<ul>
							<li><a href="/product/list.jsp?cate_seq=2">과일/견과</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">채소</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">쌀/잡곡</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">수산/건어물</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">젊은농부 추천</a></li>
						</ul>
						<ul>
							<li><a href="/product/list.jsp?cate_seq=2">소고기</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">돼지고기</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">닭고기/계란</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">기타</a></li>
						</ul>
						<ul>
							<li><a href="/product/list.jsp?cate_seq=2">반찬/간편식</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">냉장/냉동</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">음료/차/건강</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">양념/조미</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">젊은농부 추천</a></li>
						</ul>
						<ul>
							<li><a href="/product/list.jsp?cate_seq=2">명인</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">장인</a></li>
						</ul>
						<ul>
							<li><a href="/product/list.jsp?cate_seq=2">햄공방</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">과일공방</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">빵공방</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">발효공방</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">선물세트</a></li>
						</ul>
						<ul>
							<li><a href="/product/list.jsp?cate_seq=2">유기농멸균우유</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">63저온살균우유</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">유기농냉장우유</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">유기농발효유</a></li>
							<li><a href="/product/list.jsp?cate_seq=2">카레</a></li>
						</ul>
						<ul class="type">
							<li class="regular"><a href="">정기배송</a></li>
							<li class="event"><a href="">이벤트/기획전</a></li>
							<li class="direct"><a href="">산지직송</a></li>
							<li class="discount"><a href="">할인찬스</a>
								<ul>
									<li><a href="">대용량 할인</a></li>
									<li><a href="">타임세일</a></li>
								</ul>
							</li>
						</ul>
					</div>
				</div>
			</li><!-- //쇼핑 -->
			<li><a href="" target="_blank" title="새창열림"><img src="/images/layout/nav3.png" alt="호텔"></a></li>
		</ul>
	</div>
</div></div><!-- //header -->