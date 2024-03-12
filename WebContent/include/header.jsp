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

	/*
	// 1차 카테고리 리스트
 	List<Param> list  = cate.get1DepthList(new Param());
	// 2차 카테고리 리스트
	List<Param> list1 = cate.getSubDepthList(new Param("cate_seq", "78"));
	List<Param> list2 = cate.getSubDepthList(new Param("cate_seq", "2"));
	List<Param> list3 = cate.getSubDepthList(new Param("cate_seq", "3"));
	List<Param> list4 = cate.getSubDepthList(new Param("cate_seq", "4"));
	List<Param> list5 = cate.getSubDepthList(new Param("cate_seq", "5"));
	List<Param> list6 = cate.getSubDepthList(new Param("cate_seq", "6"));
	*/
	
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
<div id="header2" <% if(Depth_1 == 2){%>class="shopping"<%} %>>
	<div class="wrap">
		<div id="headerTop">
			<div class="topCont">
				<ul class="util">
                    <li><a href="/brand/bbs/jobnotice/story1.jsp" style="color:#59621D;font-weight: 600;">인재채용</a></li>
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
					<li class="cart"><a href="/order/cart.jsp">장바구니 <span class="num" id="cartCount">0</span></a></li>
				</ul>
				<!-- <p class="app"><a href="/event/170614/event.jsp">앱 다운로드</a></p> -->
			</div>
		</div>
	<% if(Depth_1 == 1){ //브랜드 %>	
		<p class="logo"><a href="/brand/index.jsp"><img src="/images/layout/logo3.png" alt="상하농원"></a></p>
	<% } else if(Depth_1 == 5) { //파머스빌리지 %>	
		<p class="logo"><a href="/hotel/index.jsp"><img src="/images/layout/logo3.png" alt="상하농원"></a></p>
	<% } else { %>	
		<p class="logo"><a href="/main.jsp"><img src="/images/layout/logo3.png" alt="상하농원"></a></p>
	<% } %>
	
	
<%-- 	<% if(Depth_1 != 5){ %>	
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
	<% } %>	 --%>
<%
	if(Depth_1 == 2){ //파머스마켓
%>		
	<jsp:include page="/include/banner.jsp" flush="true">
	    <jsp:param name="position" value="018"/>
	    <jsp:param name="POS_END" value="1"/>
	</jsp:include>

<%
	}
%>
		<div id="gnb">
			<ul>	
				<li<%if(Depth_1 == 1){ %> class="on"<%} %>><a href="/brand/index.jsp"><img src="/images/layout/nav1_1.png" alt="농원"></a>
					<div class="mainNav brand">
						<ul>
							<li<%if(Depth_1 == 1 && Depth_2 == 1){ %> class="on"<%} %>><a href="/brand/introduce/story.jsp">농원소개</a>
								<ul>
									<li><a href="/brand/introduce/story.jsp">상하농원은</a></li>
									<li><a href="/brand/introduce/history.jsp">걸어온길</a></li>
									<li><a href="/brand/introduce/guide.jsp">이용안내</a></li>
									<li><a href="/brand/introduce/facility.jsp">시설소개</a></li>
									<li><a href="/brand/introduce/tour.jsp">주변관광</a></li>
									<li><a href="/brand/introduce/location.jsp">오시는길</a></li>
								</ul>
							</li>
							<li<%if(Depth_1 == 1 && Depth_2 == 2){ %> class="on"<%} %>><a href="/brand/workshop/ham.jsp">짓다</a>
								<ul>
									<li><a href="/brand/workshop/ham.jsp">햄공방</a></li>
									<li><a href="/brand/workshop/fruit.jsp">과일공방</a></li>
									<li><a href="/brand/workshop/bread.jsp">빵공방</a></li>
									<li><a href="/brand/workshop/ferment.jsp">발효공방</a></li>
									<li><a href="/brand/workshop/factory.jsp">상하공장</a></li>
								</ul>
							</li>
							<li<%if(Depth_1 == 1 && Depth_2 == 3){ %> class="on"<%} %>><a href="/brand/play/gallery.jsp">놀다</a>
								<ul>
									<li><a href="/brand/play/gallery.jsp">전시관</a></li>
									<li><a href="/brand/play/experience/list.jsp">체험교실</a></li>
									<li><a href="/brand/play/animal.jsp">동물농장</a></li>
									<li><a href="/brand/play/sheep.jsp">양떼목장</a></li>
									<li><a href="/brand/play/organic.jsp">젖소목장</a></li>
									<li><a href="/brand/play/hotel.jsp">파머스빌리지</a></li>
								</ul>
							</li>
							<li<%if(Depth_1 == 1 && Depth_2 == 4){ %> class="on"<%} %>><a href="/brand/food/store1.jsp">먹다</a>
								<ul>
									<li><a href="/brand/food/store1.jsp">상하키친</a></li>
									<li><a href="/brand/food/store2.jsp">농원식당</a></li>
									<li><a href="/brand/food/store3.jsp">파머스카페 상하</a></li> 
									<li><a href="/brand/food/store4.jsp">농원상회</a></li>
									<li><a href="/brand/food/store5.jsp">파머스마켓</a></li>
									<!-- <li><a href="/brand/food/store6.jsp">브랜드샵</a></li> -->
								</ul>
							</li>
							<li<%if(Depth_1 == 1 && Depth_2 == 5){ %> class="on"<%} %>><a href="/brand/bbs/news/list.jsp">농원이야기</a>
								<ul>
									<li><a href="/brand/bbs/news/list.jsp">농원소식</a></li>
									<li><a href="/brand/bbs/diary/list.jsp">농부의일기</a></li>
									<li><a href="/brand/bbs/notice/list.jsp">공지사항</a></li>
									<li>
										<div class="reservationBtn">
											<a href="/brand/play/reservation/admission.jsp"><img src="/images/common/reservation.png" alt="체험교실 예약하기" style="width:124px;"></a>
										</div>
									</li>
								</ul>
							</li>
						</ul>
						<%if(Depth_1 == 1){ %>
							<span id="gnbOverBar"></span>
						<%} %>
					</div>
				</li><!-- //안내.체험 -->
				
				
				
				<li<%if(Depth_1 == 2 || Depth_1 == 3 || Depth_1 == 4){ %> class="on"<%} %>><a href="/main.jsp"><img src="/images/layout/nav2_1.png?ver=1" alt="파머스마켓"></a>
					<div class="mainNav shopping">
						<ul>
							<li class="all"><a href="#" onclick="return false"><span>전체 카테고리</span></a>
								<div class="sub">
									<ul>
										<li><a href="/product/list.jsp?cate_seq=4">설 선물세트</a></li>
										<li><a href="/product/list.jsp?cate_seq=118">상하브랜드관</a></li>
										<li><a href="/product/list.jsp?cate_seq=160">상하파머스</a></li>
<!-- 										<li><a href="/product/list.jsp?cate_seq=150">선물세트</a></li> -->
										<li><a href="/product/list.jsp?cate_seq=120">로컬푸드</a></li>
										<li><a href="/product/list.jsp?cate_seq=119">친환경</a></li>
										<li><a href="/product/list.jsp?cate_seq=128">정기배송</a></li>
									</ul>
									<ul class="cate">									
										<!-- 
										<li><a href="/product/list.jsp?cate_seq=4">설 선물세트</a>
<%
	List<Param> subList = cate.getSubDepthList(new Param("cate_seq", "4"));
	if(subList.size() > 0) {
%>
											<ul>
<%
		for(Param row : subList) {
%>
												<li><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
		}
%>
											</ul>
<%
	}
%>		
										</li>
										 -->	
										<li><a href="/product/list.jsp?cate_seq=166">국내산 과일</a>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "166"));
	if(subList.size() > 0) {
%>
											<ul>
<%
		for(Param row : subList) {
%>
												<li><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
		}
%>		
											</ul>
<%
	}
%>		
										</li>	
										<!-- 
										<li><a href="/product/list.jsp?cate_seq=165">국내산 채소</a>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "165"));
	if(subList.size() > 0) {
%>
											<ul>
<%
		for(Param row : subList) {
%>
												<li><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
		}
%>		
											</ul>
<%
	}
%>		
										</li>
										 -->	
										<li><a href="/product/list.jsp?cate_seq=79">계란/정육/유제품</a>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "79"));
	if(subList.size() > 0) {
%>
											<ul>
<%
		for(Param row : subList) {
%>
												<li><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
		}
%>		
											</ul>
<%
	}
%>		
										</li>	
										<li><a href="/product/list.jsp?cate_seq=80">수산물</a>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "80"));
	if(subList.size() > 0) {
%>
											<ul>
<%
		for(Param row : subList) {
%>
												<li><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
		}
%>		
											</ul>
<%
	}
%>		
										</li>	
										<li><a href="/product/list.jsp?cate_seq=81">국/반찬/요리</a>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "81"));
	if(subList.size() > 0) {
%>
											<ul>
<%
		for(Param row : subList) {
%>
												<li><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
		}
%>		
											</ul>
<%
	}
%>		
										</li>	
										<li><a href="/product/list.jsp?cate_seq=82">간편식/식사대용식</a>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "82"));
	if(subList.size() > 0) {
%>
											<ul>
<%
		for(Param row : subList) {
%>
												<li><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
		}
%>		
											</ul>
<%
	}
%>		
										</li>	
										<li><a href="/product/list.jsp?cate_seq=83">요리양념/파우더류</a>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "83"));
	if(subList.size() > 0) {
%>
											<ul>
<%
		for(Param row : subList) {
%>
												<li><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
		}
%>		
											</ul>
<%
	}
%>		
										</li>
										<li><a href="/product/list.jsp?cate_seq=136">음료/건강</a>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "136"));
	if(subList.size() > 0) {
%>
											<ul>
<%
		for(Param row : subList) {
%>
												<li><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
		}
%>		
											</ul>
<%
	}
%>		
										</li>
										<li><a href="/product/list.jsp?cate_seq=137">간식/과자</a>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "137"));
	if(subList.size() > 0) {
%>
											<ul>
<%
		for(Param row : subList) {
%>
												<li><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
		}
%>		
											</ul>
<%
	}
%>		
										</li>
										<li><a href="/product/list.jsp?cate_seq=163">쌀/잡곡</a>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "163"));
	if(subList.size() > 0) {
%>
											<ul>
<%
		for(Param row : subList) {
%>
												<li><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
		}
%>
											</ul>
<%
	}
%>		
										</li>
										<li><a href="/product/list.jsp?cate_seq=164">견과/건채소/건버섯</a>
<%
	subList = cate.getSubDepthList(new Param("cate_seq", "164"));
	if(subList.size() > 0) {
%>
											<ul>
<%
		for(Param row : subList) {
%>
												<li><a href="/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
		}
%>		
											</ul>
<%
	}
%>		
										</li>
									</ul>
								</div>
							</li>
							<li><a href="/product/list.jsp?cate_seq=118">상하브랜드관</a></li>
							<li><a href="/product/list.jsp?sort=date">신상품</a></li>
							<li><a href="/product/best.jsp">베스트</a></li>
							<li><a href="/product/list.jsp?cate_seq=38">알뜰상품</a></li>
							<li><a href="/product/list.jsp?cate_seq=160"><img src="/images/layout/logo_farmers.png?ver=1" alt="상하파머스"></a></li>
						</ul>
						<form name="quickSrchForm" id="quickSrchForm" method="GET" action="/product/search.jsp" >
						<div class="quickSrch">
							<fieldset>
								<legend>상품검색</legend>
								<input type="text" name="pnm" id="pnm" value="<%= Utils.safeHTML(param.get("pnm")) %>" onKeyPress="if (event.keyCode==13){ javascript:$('#quickSrchForm').submit()}">
								<button title="검색" ><img src="/images/layout/btn_search.png" alt="검색"></button>
							</fieldset>	
						</div>
						</form>
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
							<li<%if(Depth_1 == 5 && Depth_2 == 5){ %> class="on"<%} %>><a href="/hotel/enjoy/pool.jsp">즐길거리</a>
								<ul>
									<li><a href="/hotel/enjoy/pool.jsp">수영장</a></li>
									<li><a href="/hotel/enjoy/garden.jsp">정원</a></li>
									<li><a href="/hotel/enjoy/experience.jsp">체험교실</a></li>
									<li><a href="/hotel/enjoy/campaign.jsp">환경보호캠페인</a></li>
									<li><a href="/hotel/enjoy/healthcare.jsp">헬스케어존</a></li>
									<li><a href="/hotel/enjoy/spa.jsp">스파</a></li>
								</ul>				
							</li>
						</ul>						
						<%if(Depth_1 == 5){ %>
							<span id="gnbOverBar"></span>
						<%} %>		
					</div>
				</li>
			</ul>
		</div>
	</div>
</div><!-- //header -->
<script>
	$(function() {
		getCartCount();
	});

	function getCartCount() {
		$.getJSON("/ajax/cartCount.jsp", function(data) {
			$("#cartCount").html(data.count);
		});
	}
</script>
