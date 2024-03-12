<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.service.board.KeywordService"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.product.CateService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.order.*" %>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	

	Param param = new Param(request);
	
	FrontSession fs = FrontSession.getInstance(request, response);
	CartService cart = (new CartService()).toProxyInstance();
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
	
	
	String userid = "";
	
	if(fs.isLogin()) userid = fs.getUserId();
	else userid = fs.getTempUserId();
	
	
	KeywordService keyword = (new KeywordService()).toProxyInstance();
	
	
	List<Param> keywordList = keyword.getList(new Param("POS_STA", 0, "POS_END" , Integer.MAX_VALUE, "status", "S"));
	
%>
<script>
$(function () {
	var link = document.location.href;
// 	if (getCookie("bandBanner") != "done" && link.indexOf("/brand/") < 0 ){
		showBand();
// 	}
});
var qTop;
function showBand(){
	$(".bandBanner").show();
	qTop = parseInt($("#quick").css("top"));
	$("#quick").css("top", qTop + 90);
}
function hideBand(obj){
	$(".bandBanner").slideUp(150, "easeInOutQuint");
	setCookie( obj, "done");
	$("#quick").stop().animate({top:qTop +"px"}, 150);
}

$(function(){
	if($(".typeSub ul li.card").size() > 0){
		$(".typeSub ul .insta").css("width", "173px");
	} else {
		$(".typeSub ul .insta").css("width", "347px");
	}
});
</script>
<div id="skipNav">
	<a href="#container">본문 바로가기</a>
	<a href="#gnb">메뉴 바로가기</a>
</div>
<jsp:include page="/include/banner.jsp" flush="true">
    <jsp:param name="position" value="017"/>
    <jsp:param name="POS_END" value="1"/>
</jsp:include>
<div id="header2"><div class="wrap">
	<div id="headerTop">
		<div class="topCont">
			<ul class="util">
<%
	if(!fs.isLogin()) {
%>
				<li><a href="javascript:fnt_login()">로그인</a></li>
				<li><a href="javascript:fnt_join()">회원가입</a></li>
<%
	} else {
%>
				<li><a href="javascript:fnt_logout()">로그아웃</a></li>
				<li><a href="/mypage/index.jsp">마이페이지</a></li>
<%
	}
%>
				<li><a href="/customer/faq.jsp">고객센터</a></li>
				<li class="cart"><a href="/order/cart.jsp">장바구니 <span class="num"><%= Utils.formatMoney(cart.getListCount(userid)) %></span></a></li>
			</ul>
			<!-- <p class="app"><a href="/event/170614/event.jsp">앱 다운로드</a></p> -->
		</div>
	</div>
<% if(Depth_1 == 1){ //브랜드 %>	
	<p class="logo"><a href="/brand/index.jsp"><img src="/images/layout/logo.png" alt="상하농원"></a></p>
<% } else if(Depth_1 == 2) { //쇼핑 %>	
	<p class="logo"><a href="/main.jsp"><img src="/images/layout/logo.png" alt="상하농원"></a></p>
<% } else if(Depth_1 == 5) { //파머스빌리지 %>	
	<p class="logo"><a href="/hotel/index.jsp"><img src="/images/layout/logo3.png" alt="상하농원"></a></p>
<% } %>


<% if(Depth_1 != 5){ %>	
	<form name="quickSrchForm" id="quickSrchForm" method="GET" action="/product/search.jsp" >
	<div class="quickSrch">
		<fieldset>
			<legend>상품검색</legend>
			<input type="text" name="pnm" id="pnm" value="<%= param.get("pnm")%>" onKeyPress="if (event.keyCode==13){ javascript:$('#quickSrchForm').submit()}">
			<button title="검색" ><img src="/images/layout/btn_search.png" alt="검색"></button>
		</fieldset>		
		<div class="popularSrch">
			<h2>인기검색어</h2>
			<ul>
<%
			if (CollectionUtils.isNotEmpty(keywordList)) {
				for (Param row : keywordList) {
%>
				<li><a href="/product/search.jsp?pnm=<%= row.get("keyword")%>"><%= row.get("keyword")%></a></li>
<%
				}
			}				
%>
			</ul>
		</div>
	</div>
	</form>
<% } %>	
	<jsp:include page="/include/banner.jsp" flush="true">
	    <jsp:param name="position" value="018"/>
	    <jsp:param name="POS_END" value="1"/>
	</jsp:include>
	<div id="gnb">
		<ul>	
			<li<%if(Depth_1 == 1){ %> class="on"<%} %>><a href="/brand/index.jsp"><img src="/images/layout/nav1_1.png" alt="농원"></a>
				<div class="mainNav brand">
					<p class="all"><a href="#" onclick="return false"><span>전체보기</span></a></p>
					<ul>
						<li<%if(Depth_1 == 1 && Depth_2 == 1){ %> class="on"<%} %>><p><a href="/brand/introduce/story.jsp">농원소개</a></p>
							<ul>
								<li><a href="/brand/introduce/story.jsp">상하농원은</a></li>
								<li><a href="/brand/introduce/history.jsp">걸어온길</a></li>
								<li><a href="/brand/introduce/guide.jsp">이용안내</a></li>
								<li><a href="/brand/introduce/facility.jsp">시설소개</a></li>
								<li><a href="/brand/introduce/tour.jsp">주변관광</a></li>
								<li><a href="/brand/introduce/location.jsp">오시는길</a></li>
							</ul>
						</li>
						<li<%if(Depth_1 == 1 && Depth_2 == 2){ %> class="on"<%} %>><p><a href="/brand/workshop/ham.jsp">짓다</a></p>
							<ul>
								<li><a href="/brand/workshop/ham.jsp">햄공방</a></li>
								<li><a href="/brand/workshop/fruit.jsp">과일공방</a></li>
								<li><a href="/brand/workshop/bread.jsp">빵공방</a></li>
								<li><a href="/brand/workshop/ferment.jsp">발효공방</a></li>
								<li><a href="/brand/workshop/garden.jsp">농부체험</a></li>
								<li><a href="/brand/workshop/factory.jsp">상하공장</a></li>
							</ul>
						</li>
						<li<%if(Depth_1 == 1 && Depth_2 == 3){ %> class="on"<%} %>><p><a href="/brand/play/gallery.jsp">놀다</a></p>
							<ul>
								<li><a href="/brand/play/gallery.jsp">전시관</a></li>
								<li><a href="/brand/play/experience/list.jsp">체험교실</a></li>
								<li><a href="/brand/play/animal.jsp">동물농장</a></li>
								<li><a href="/brand/play/sheep.jsp">양떼목장</a></li>
								<li><a href="/brand/play/organic.jsp">유기농목장</a></li>
								<li><a href="/brand/play/hotel.jsp">파머스빌리지</a></li>
							</ul>
						</li>
						<li<%if(Depth_1 == 1 && Depth_2 == 4){ %> class="on"<%} %>><p><a href="/brand/food/store1.jsp">먹다</a></p>
							<ul>
								<li><a href="/brand/food/store1.jsp">상하키친</a></li>
								<li><a href="/brand/food/store2.jsp">농원식당</a></li>
								<li><a href="/brand/food/store3.jsp">파머스카페 상하</a></li> 
								<li><a href="/brand/food/store4.jsp">농원상회</a></li>
								<li><a href="/brand/food/store5.jsp">파머스마켓</a></li>
							</ul>
						</li>
						<li<%if(Depth_1 == 1 && Depth_2 == 5){ %> class="on"<%} %>><p><a href="/brand/bbs/news/list.jsp">농원이야기</a></p>
							<ul>
								<li><a href="/brand/bbs/news/list.jsp">농원소식</a></li>
								<li><a href="/brand/bbs/diary/list.jsp">농부의일기</a></li>
								<li><a href="/brand/bbs/notice/list.jsp">공지사항</a></li>
								<li>
									<div class="reservationBtn">
								<a href="/brand/play/reservation/admission.jsp"><img src="/images/common/reservation.png" alt="체험교실 예약하기"></a>
							</div>
								</li>
							</ul>
							
						</li>
					</ul>
					
				</div>
			</li><!-- //안내.체험 -->
			
			
			
			<li<%if(Depth_1 == 2 || Depth_1 == 3 || Depth_1 == 4){ %> class="on"<%} %>><a href="/main.jsp"><img src="/images/layout/nav2_1.png" alt="파머스마켓"></a>
				<div class="mainNav shopping">
					<p class="all"><a href="#" onclick="return false"><span>전체보기</span></a></p>
					<ul class="cate">
<%
						if (CollectionUtils.isNotEmpty(list)) {
							List<Param> cloneList;
							int i = 1;
							for (Param listRow : list) {
								if (i < 7) {
									cloneList = new ArrayList<Param>();
									switch (listRow.getInt("cate_seq")) {
											case 1 : 
												cloneList.addAll(list1);
												break;
											case 2 : 
												cloneList.addAll(list2);
												break;
											case 3 : 
												cloneList.addAll(list3);
												break;
											case 4 : 
												cloneList.addAll(list4);
												break;
											case 5 : 
												cloneList.addAll(list5);
												break;
											case 6 : 
												cloneList.addAll(list6);
												break;
											default : break;
									}
%>
							<li><p><a href="/product/list.jsp?cate_seq=<%= listRow.get("cate_seq")%>"><%=listRow.get("cate_name") %></a></p>
<%
							if (CollectionUtils.isNotEmpty(cloneList)) {
%>
								<ul>
<%
								for (Param row : cloneList) {
%>
									<li><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq")%>"><%=row.get("cate_name") %></a></li>
<%
								}
%>
								</ul>
<%
							}
%>
							</li>
<%
								}
							i++;
							}
						}						
%>
					</ul>
								
					<ul class="type">
						<li class="regular"><a href="/product/list.jsp?cate_seq=36">정기배송</a></li>
						<li class="direct"><a href="/product/list.jsp?cate_seq=37">산지직송</a></li>
						<li class="event"><a href="/event/list.jsp">이벤트/기획전</a></li>
						<li class="discount"><a href="/product/list.jsp?cate_seq=38">할인찬스</a><img src="/images/layout/ico_sale.png" alt="SALE" class="transition"></li>
					</ul>
					<div class="typeSub">
						<ul>
							<li class="regular"><a href="/product/list.jsp?cate_seq=36">정기배송</a></li>
							<li class="event"><a href="/event/list.jsp">이벤트/기획전</a></li>
							<li class="direct"><a href="/product/list.jsp?cate_seq=37">산지직송</a></li>
							<li class="discount"><a href="/product/list.jsp?cate_seq=38">할인찬스</a>
								<ul>
									<li><a href="/product/list.jsp?cate_seq=39">대용량 할인</a></li>
									<li><a href="/product/list.jsp?cate_seq=40">타임세일</a></li>
								</ul>
							</li>
							<li class="insta"><a href="/customer/insta.jsp">인스타그램<span>#상하농원 #상하맘 #유기농</span></a></li>
<%
	if(Utils.getTimeStampString(new Date(), "yyyyMMddHHmmss").compareTo("20180101000000") >= 0) {
%>
							<li class="card"><a href="/product/list.jsp?cate_seq=49">현대카드 프로모션<span>the Black, the Purple</span></a></li> 
<%
	}
%>
						</ul>
						<!-- <p class="insta"><a href="/customer/insta.jsp">상하농원 인스타그램</a></p> -->
					</div>
					
				</div>
			</li><!-- //쇼핑 -->
			<li<%if(Depth_1 == 5){ %> class="on"<%} %>><a href="/hotel/index.jsp"><img src="/images/layout/nav3_1.png" alt="파머스빌리지"></a>
				<div class="mainNav village" id="villageGnb">
					
					<ul>
						<li<%if(Depth_1 == 5 && Depth_2 == 1){ %> class="on"<%} %>><a href="/hotel/village/introduction.jsp">빌리지 소개</a>
							<ul>
								<li><a href="/hotel/village/introduction.jsp">소개</a></li>
								<li><a href="/hotel/village/location.jsp">오시는길</a></li>
								<li><a href="/hotel/village/floor.jsp">층별안내</a></li>
								<li><a href="/hotel/village/notice/list.jsp">공지사항</a></li>
								<li><a href="/hotel/village/promotion/list.jsp">프로모션</a></li>
							</ul>
						</li>
						<li<%if(Depth_1 == 5 && Depth_2 == 2){ %> class="on"<%} %>><a href="/hotel/room/index.jsp">객실</a>
							<ul>
								<li><a href="/hotel/room/index.jsp">전체보기</a></li>
								<li><a href="/hotel/room/suite.jsp">파머스빌리지</a></li>
								<li><a href="/hotel/room/glamping.jsp">파머스글램핑</a></li>
								<li><a href="/hotel/room/reservation/date.jsp">예약하기</a></li>
							</ul>
						</li>
						<li<%if(Depth_1 == 5 && Depth_2 == 3){ %> class="on"<%} %>><a href="/hotel/dining/breakfast.jsp">다이닝</a>
							<ul>
								<li><a href="/hotel/dining/breakfast.jsp">파머스테이블</a></li>
								<li><a href="/hotel/dining/lounge.jsp">웰컴라운지</a></li>
							</ul>
						</li>
						<li<%if(Depth_1 == 5 && Depth_2 == 4){ %> class="on"<%} %>><a href="/hotel/wedding/wedding.jsp">웨딩&amp;이벤트</a>
							<ul>
								<li><a href="/hotel/wedding/wedding.jsp">웨딩&amp;연회</a></li>
								<li><a href="/hotel/wedding/seminar.jsp">세미나</a></li>
							</ul>
						</li>
						<li<%if(Depth_1 == 5 && Depth_2 == 5){ %> class="on"<%} %>><a href="/hotel/enjoy/garden.jsp">즐길거리</a>
							<ul>
								<li><a href="/hotel/enjoy/garden.jsp">정원</a></li>
								<li><a href="/hotel/enjoy/experience.jsp">체험교실</a></li>
							</ul>				
						</li>
					</ul>
					<span id="gnbOverBar"></span>
	
				</div>
			</li>
		</ul>
	</div>
</div></div><!-- //header -->