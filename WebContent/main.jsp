<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="com.sanghafarm.service.board.EventService"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="com.sanghafarm.service.code.CodeService"%>
<%@page import="com.sanghafarm.service.product.CateService"%>
<%@page import="com.sanghafarm.service.board.*"%>
<%@page import="com.sanghafarm.common.*"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.board.BannerService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	// 진입페이지 쿠키
	SanghafarmUtils.setCookie(response, "LANDING_PAGE", "SHOPPING", ".sanghafarm.co.kr", 60*60*24*100);
%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(0));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String(""));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	FarmerMenuService menu = (new FarmerMenuService()).toProxyInstance();
	
	//페이징 변수 설정
	param.set("POS_STA", 0);
	param.set("POS_END", 5);
	param.set("cate", "001");

	List<Param> recipeList = menu.getList(param);
	
	CodeService code = (new CodeService()).toProxyInstance();
	
	List<Param> bestCodeList = code.getList2("022");
	List<Param> recommandCodeList = code.getList2("023");
	
	ProductService product = (new ProductService()).toProxyInstance();
	EventService event = (new EventService()).toProxyInstance();
	// 추천이벤트 리스트
	List<Param> eventList = event.getMainList(new Param("POS_STA", "0", "POS_END", "5"));

	// 신상품 리스트
// 	List<Param> newList = product.getRefProductList(new Param("cate1", "025", "POS_STA", "0", "POS_END", "5", "grade_code", fs.getGradeCode()));

	PopupService popup = (new PopupService()).toProxyInstance();
	List<Param> popupList = popup.getList(new Param("device", "P", "position", "S"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script src="/js/swiper.min.4.5.1.js"></script>
<script type="text/javascript">
	$(function (){
		//goBestProduct('01');
		goRecommandProduct('01');

<%
	for(Param row : popupList) {
		if("1".equals(row.get("pop_type"))) {
%>
		//일반팝업
		if (getCookie("popup<%= row.get("seq") %>") != "done" ){
			var popHeight = <%= row.get("height") %> + 25;
			window.open('/popup/popup.jsp?seq=<%= row.get("seq") %>','popup<%= row.get("seq") %>','width=<%= row.get("width") %>, height='+popHeight+', top=<%= row.get("top") %>, left=<%= row.get("left") %>, scrollbars=no')	
		}
<%
		} else {
%>
		//레이어팝업
		if (getCookie("layerPop<%= row.get("seq") %>") != "done" ){
			var popHeight = <%= row.get("height") %> + 25;
			layerPopOpen('layerPop<%= row.get("seq") %>', '<%= row.get("top") %>', '<%= row.get("left") %>', '<%= row.get("width") %>', popHeight);
		}
<%
		}
	}
%>
	});
	
	function goBestProduct(bestCode2){
		var searchParam = {
				"cate2" : bestCode2
		}
		$.post('/ajax/bestProduct.jsp', searchParam, function(html){
			pickProduct(bestCode2, "best");
			$("#bestProduct *").remove();
			$("#bestProduct").append(html);
			var recommendSwiper = new Swiper ('.recommend .slideCont', {
				slidesPerView: 4,
				slidesPerGroup: 4,
				spaceBetween: 30,
				navigation: {
					nextEl: '.recommend .next',
					prevEl: '.recommend .prev',
				}
			});
		});	
	}
	function goRecommandProduct(recommandCode2){
		var searchParam = {
				"cate2" : recommandCode2
		}
		$.post('/ajax/recommandProduct.jsp', searchParam, function(html){
			pickProduct(recommandCode2, "recommand");
			$("#recommandProduct *").remove();
			$("#recommandProduct").append(html);
		});	
	}
	function pickProduct(cate, division) {
		$("#"+division+ " > li").removeClass("on");
		switch (cate) {
			case "01" :
				$("#"+division+ " > li:eq(0)").addClass("on");
				break;
			case "02" :
				$("#"+division+ " > li:eq(1)").addClass("on");
				break;
			case "03" :
				$("#"+division+ " > li:eq(2)").addClass("on");
				break;
			case "04" :
				$("#"+division+ " > li:eq(3)").addClass("on");
				break;
			case "05" :
				$("#"+division+ " > li:eq(4)").addClass("on");
				break;
			case "06" :
				$("#"+division+ " > li:eq(5)").addClass("on");
				break;
		}
	}
/* 	function showBand(){
		$(".bandBanner").show();
	}
	function hideBand(){
		$(".bandBanner").slideUp(150, "easeInOutQuint");
	} */

	//레이어팝업
	function layerPopOpen(obj, top, left, width, height){
		$('.'+obj).css({top:top+'px', left:left+'px', width:width+'px', height:height+'px'}).show();
	}
	
	function closePopLayer(obj){
		setCookie( obj, "done" , 1);
		$('.'+obj).css("display", "none");
	}
	
	function layerPopClose(obj){
		$('.'+obj).hide();
	}
</script>
<script type="text/javascript">
     (function(d, s) {
                var j, e = d.getElementsByTagName(s)[0], h = "https://cdn.attractt.com/embed/js/dist/embed.min.js";
                if (typeof AttracttTower === "function" || e.src === h) { return; }
                j = d.createElement(s);
                j.src = h;
                j.async = true;
                e.parentNode.insertBefore(j, e);
     })(document, "script");
</script>
</head>  
<body class="main">
<%
	for(Param row : popupList) {
		if("2".equals(row.get("pop_type"))) {
%>
<div class="mainPop layerPop<%= row.get("seq") %>">
	<div>
		<%= row.get("contents") %>
	</div>
	<p class="popFoot">
		<a href="#" onclick="layerPopClose('layerPop<%= row.get("seq") %>');return false;" class="fl">닫기</a>
		<a href="#" onclick="closePopLayer('layerPop<%= row.get("seq") %>');return false;" class="fr">오늘하루 열지않기</a>
	</p>
</div>
<%
		}
	}
%>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<jsp:include page="/include/main_banner.jsp" flush="true"> 
		    <jsp:param name="position" value="043"/>
		    <jsp:param name="POS_END" value="9999"/>
		</jsp:include>
		<div class="mainSecB"><div class="wrap">
			<h2 class="typeA">상하농원 대표상품</h2>
			<ul class="recommandTab" id="recommand">
<%
	for(Param row : recommandCodeList) {
%>
			<li <%= row.get("code2").equals(param.get("recommandCode2")) ? "class=\"on\"" : "" %>><a href="#" onClick="goRecommandProduct('<%= row.get("code2") %>'); return false;"><span><img src="/images/main/ico_newCate<%= row.get("code2") %>.png" alt=""></span><%= row.get("name2") %></a></li>
<%
	}
%>
			</ul>
			<div id="recommandProduct"></div>
			<!-- //대표상품 -->
		
			<jsp:include page="/include/main_banner.jsp" flush="true">
			    <jsp:param name="position" value="044"/>
			    <jsp:param name="POS_END" value="1"/>
			</jsp:include>
<%
	List<Param> list = product.getList(new Param("POS_STA", "0", "POS_END", "8", "sort", "date", "grade_code", fs.getGradeCode()));
		if (CollectionUtils.isNotEmpty(list)) {			
%>
			<h2 class="typeA">신상품</h2>
			<p class="more"><a href="/product/list.jsp?sort=date" class="icoMore">더보기</a></p>
			<div class="newProduct swiper-container">
				<div class="slideCont">
					<ul class="pdtList swiper-wrapper">
					<%
						int i = 1;
						for (Param row : list) {					
%>
						<li class="swiper-slide" id="new<%= i++%>"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
							<div class="thumb"><img src="<%= row.get("image1") %>" alt=""></div>
							<p class="tit"><%= row.get("pnm") %></p>
							<p class="cont"><%= row.get("summary") %></p>
<%
			if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
							<p class="discount">
								<span><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %>%</span>
								<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
							</p>
<%
			}
%>							
							<p class="price"><strong><%= StringUtils.isNotEmpty(Utils.formatMoney(row.get("sale_price"))) ? Utils.formatMoney(row.get("sale_price")) : Utils.formatMoney(row.get("default_price")) %></strong>원</p>
							<p class="icon">
								<span><%= row.get("icon") %></span>
							</p>
						</a></li>
<%
						}
%>
					</ul>
				</div>
<%
					if (list.size() > 4) {					
%>
				<input type="image" src="/images/main/btn_prev5.png" alt="이전" class="prev">
				<input type="image" src="/images/main/btn_next5.png" alt="다음" class="next">
<%
					}					
%>
			</div><!-- //신상품 -->
<%
				}			
%>
		</div></div><!-- //mainSecB(대표상품, 배너, 신상품) -->

		<div class="mainSecA"><div class="wrap">
<%
// 	list = product.getRefProductList(new Param("cate1", "041", "cate2", "001", "POS_STA", "0", "POS_END", "8", "grade_code", fs.getGradeCode()));
	list = product.getList(new Param("sort", "pop", "POS_STA", "0", "POS_END", "8", "grade_code", fs.getGradeCode()));
	if (CollectionUtils.isNotEmpty(list)) {			
%>		
			<h2 class="typeA">베스트</h2>
			<p class="more"><a href="/product/list.jsp?sort=pop" class="icoMore">더보기</a></p>
			<div class="bestProduct swiper-container">
				<div class="slideCont">
					<ul class="pdtList swiper-wrapper">
<%
		for (Param row : list) {					
%>
						<li class="swiper-slide"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
							<div class="thumb"><img src="<%= row.get("image1") %>" alt=""></div>
							<p class="tit"><%= row.get("pnm") %></p>
							<p class="cont"><%= row.get("summary") %></p>
<%
			if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
							<p class="discount">
								<span><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %>%</span>
								<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
							</p>
<%
			}
%>						
							<p class="price"><strong><%= StringUtils.isNotEmpty(Utils.formatMoney(row.get("sale_price"))) ? Utils.formatMoney(row.get("sale_price")) : Utils.formatMoney(row.get("default_price")) %></strong>원</p>
							<p class="icon">
								<span><%= row.get("icon") %></span>
							</p>
						</a></li>
<%
		}
%>
					</ul>
				</div>
<%
		if (list.size() > 4) {					
%>
				<input type="image" src="/images/main/btn_prev5.png" alt="이전" class="prev">
				<input type="image" src="/images/main/btn_next5.png" alt="다음" class="next">
<%
		}
%>
			</div><!-- //베스트 -->
<%
	}
%>		
		</div>
		</div><!-- //mainSecA(베스트) -->

		<div class="mainSecB"><div class="wrap">
<%
	list = product.getRefProductList(new Param("cate1", "041", "cate2", "002", "POS_STA", "0", "POS_END", "8", "grade_code", fs.getGradeCode()));
	if (CollectionUtils.isNotEmpty(list)) {			
%>		
			<h2 class="typeA">추천상품</h2>
<!-- 			<p class="more"><a href="" class="icoMore">더보기</a></p> -->
			<div class="recommend swiper-container" id="bestProduct">
				<div class="slideCont">
					<ul class="pdtList swiper-wrapper">
<%
		for (Param row : list) {					
%>
						<li class="swiper-slide"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
							<div class="thumb"><img src="<%= row.get("image1") %>" alt=""></div>
							<p class="tit"><%= row.get("pnm") %></p>
							<p class="cont"><%= row.get("summary") %></p>
<%
			if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
							<p class="discount">
								<span><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %>%</span>
								<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
							</p>
<%
			}
%>						
							<p class="price"><strong><%= StringUtils.isNotEmpty(Utils.formatMoney(row.get("sale_price"))) ? Utils.formatMoney(row.get("sale_price")) : Utils.formatMoney(row.get("default_price")) %></strong>원</p>
							<p class="icon">
								<span><%= row.get("icon") %></span>
							</p>
						</a></li>
<%
		}
%>
					</ul>
				</div>
<%
		if (list.size() > 4) {					
%>
				<input type="image" src="/images/main/btn_prev5.png" alt="이전" class="prev">
				<input type="image" src="/images/main/btn_next5.png" alt="다음" class="next">
<%
		}
%>
			</div>	
<%
	}
%>
			<!-- //추천상품 -->	
		
			<jsp:include page="/include/main_banner.jsp" flush="true">
			    <jsp:param name="position" value="045"/>
			    <jsp:param name="POS_END" value="1"/>
			</jsp:include>
			
<%
	list = product.getRefProductList(new Param("cate1", "041", "cate2", "003", "POS_STA", "0", "POS_END", "8", "grade_code", fs.getGradeCode()));
	if (CollectionUtils.isNotEmpty(list)) {			
%>		
			<h2 class="typeA">정기배송</h2>
			<p class="more"><a href="/product/list.jsp?cate_seq=128" class="icoMore">더보기</a></p>
			<div class="routine swiper-container">
				<div class="slideCont">
					<ul class="pdtList swiper-wrapper">
<%
		for (Param row : list) {					
%>
						<li class="swiper-slide"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
							<div class="thumb"><img src="<%= row.get("image1") %>" alt=""></div>
							<p class="tit"><%= row.get("pnm") %></p>
							<p class="cont"><%= row.get("summary") %></p>
<%
			if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
							<p class="discount">
								<span><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %>%</span>
								<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
							</p>
<%
			}
%>						
							<p class="price"><strong><%= StringUtils.isNotEmpty(Utils.formatMoney(row.get("sale_price"))) ? Utils.formatMoney(row.get("sale_price")) : Utils.formatMoney(row.get("default_price")) %></strong>원</p>
							<p class="icon">
								<span><%= row.get("icon") %></span>
							</p>
						</a></li>
<%
		}
%>
					</ul>
				</div>
<%
		if (list.size() > 4) {					
%>
				<input type="image" src="/images/main/btn_prev5.png" alt="이전" class="prev">
				<input type="image" src="/images/main/btn_next5.png" alt="다음" class="next">
<%
		}
%>
			</div><!-- //정기배송 -->			
<%
	}
%>	
		
<%
	list = product.getRefProductList(new Param("cate1", "041", "cate2", "004", "POS_STA", "0", "POS_END", "8", "grade_code", fs.getGradeCode()));
	if (CollectionUtils.isNotEmpty(list)) {			
%>		
			<h2 class="typeA">친환경</h2>
			<p class="more"><a href="/product/list.jsp?cate_seq=119" class="icoMore">더보기</a></p>
			<div class="eco swiper-container">
				<div class="slideCont">
					<ul class="pdtList swiper-wrapper">
<%
		for (Param row : list) {					
%>
						<li class="swiper-slide"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
							<div class="thumb"><img src="<%= row.get("image1") %>" alt=""></div>
							<p class="tit"><%= row.get("pnm") %></p>
							<p class="cont"><%= row.get("summary") %></p>
<%
			if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
							<p class="discount">
								<span><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %>%</span>
								<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
							</p>
<%
			}
%>						
							<p class="price"><strong><%= StringUtils.isNotEmpty(Utils.formatMoney(row.get("sale_price"))) ? Utils.formatMoney(row.get("sale_price")) : Utils.formatMoney(row.get("default_price")) %></strong>원</p>
							<p class="icon">
								<span><%= row.get("icon") %></span>
							</p>
						</a></li>
<%
		}
%>
					</ul>
				</div>
<%
		if (list.size() > 4) {					
%>
				<input type="image" src="/images/main/btn_prev5.png" alt="이전" class="prev">
				<input type="image" src="/images/main/btn_next5.png" alt="다음" class="next">
<%
		}
%>
			</div><!-- //친환경 -->
		</div>
<%
	}
%>
		</div><!-- //mainSecB(추천,배너, 정기,친환경) -->

<%
	list = product.getRefProductList(new Param("cate1", "041", "cate2", "005", "POS_STA", "0", "POS_END", "8", "grade_code", fs.getGradeCode()));
	if (CollectionUtils.isNotEmpty(list)) {			
%>			
		<div class="mainSecA"><div class="wrap">	
			<h2 class="typeA">로컬푸드</h2>
			<p class="more"><a href="/product/list.jsp?cate_seq=120" class="icoMore">더보기</a></p>
			<div class="region swiper-container">
				<div class="slideCont">
					<ul class="pdtList swiper-wrapper">
<%
		for (Param row : list) {					
%>
						<li class="swiper-slide"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
							<div class="thumb"><img src="<%= row.get("image1") %>" alt=""></div>
							<p class="tit"><%= row.get("pnm") %></p>
							<p class="cont"><%= row.get("summary") %></p>
<%
			if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
							<p class="discount">
								<span><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %>%</span>
								<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
							</p>
<%
			}
%>						
							<p class="price"><strong><%= StringUtils.isNotEmpty(Utils.formatMoney(row.get("sale_price"))) ? Utils.formatMoney(row.get("sale_price")) : Utils.formatMoney(row.get("default_price")) %></strong>원</p>
							<p class="icon">
								<span><%= row.get("icon") %></span>
							</p>
						</a></li>
<%
		}
%>
					</ul>
				</div>
<%
		if (list.size() > 4) {					
%>
				<input type="image" src="/images/main/btn_prev5.png" alt="이전" class="prev">
				<input type="image" src="/images/main/btn_next5.png" alt="다음" class="next">
<%
		}
%>
			</div><!-- //지역상생 -->			
		</div>
<%
	}
%>
		</div><!-- //mainSecA(지역상생) -->		
		<div class="mainSecB"><div class="wrap">		
<%
		if (CollectionUtils.isNotEmpty(recipeList)) {
%>
			<h2 class="typeA">레시피</h2>
			<p class="more"><a href="/recipe/list.jsp" class="icoMore">더보기</a></p>
			<div class="recipe swiper-container">
				<div class="slideCont">
					<ul class="recipeMainList swiper-wrapper">
<%
						int i = 0;
						for (Param recipe : recipeList) {
%>
						<li class="swiper-slide"><a href="/recipe/view.jsp?seq=<%= recipe.get("seq") %>">
							<p class="thumb"><img src="<%= recipe.get("banner_img") %>" alt=""></p>
							<p class="tit"><span><%= recipe.get("title") %></span></p>
							<p class="tag">
<%
							recipe.set("grade_code", fs.getGradeCode());
							List<Param> recipeProductList = menu.getProductList(recipe);
							for(Param row : recipeProductList) {
%>
								<a href="/product/detail.jsp?pid=<%= row.get("pid") %>"># <%= row.get("pnm") %></a><br>
<%
							}
%>
							</p>
							<input type="hidden" name="recipeSeq<%= i%>" id="recipeSeq<%= i%>" value="<%= recipe.get("seq") %>">
						</a></li>
<%
						i++;
						}					
%>
					</ul>
				</div>
<%
					if (recipeList.size() > 3) {				
%>
				<input type="image" src="/images/main/btn_prev5.png" alt="이전" class="prev">
				<input type="image" src="/images/main/btn_next5.png" alt="다음" class="next">
<%
					}				
%>
			</div>
			<!-- //레시피 -->
<%
		}
%>
		<jsp:include page="/include/main_banner.jsp" flush="true">
		    <jsp:param name="position" value="046"/>
		    <jsp:param name="POS_END" value="1"/>
		</jsp:include>
		</div></div><!-- //mainSecA(레시피, 배너) -->
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script src="/js/jquery.imgpreload.js"></script>
<script>
$(".mainVisual .list").cycle({
	fx: "fade",
	speed: 800,
	timeout: 5000,
	slideExpr : "li",
	pause : 1,
	fit:1,
	width: "100%",
	prev : $(".mainVisual .prev"),
	next : $(".mainVisual .next"),
	pager : $(".mainVisual .nav"),
	activePagerClass: 'on',
	pagerAnchorBuilder: function(idx) {
		idx = idx+1;
        return '<li><a href="#visual'+idx+'">'+ idx +'</a></li>'; 
    }
});

var newSwiper = new Swiper ('.newProduct .slideCont', {
	slidesPerView: 4,
	slidesPerGroup: 4,
	spaceBetween: 30,
	navigation: {
		nextEl: '.newProduct .next',
		prevEl: '.newProduct .prev',
	}
});

var bestSwiper = new Swiper ('.bestProduct .slideCont', {
	slidesPerView: 4,
	slidesPerGroup: 4,
	spaceBetween: 30,
	navigation: {
		nextEl: '.bestProduct .next',
		prevEl: '.bestProduct .prev',
	}
});

var recommendSwiper = new Swiper ('.recommend .slideCont', {
	slidesPerView: 4,
	slidesPerGroup: 4,
	spaceBetween: 30,
	navigation: {
		nextEl: '.recommend .next',
		prevEl: '.recommend .prev',
	}
});

var routineSwiper = new Swiper ('.routine .slideCont', {
	slidesPerView: 4,
	slidesPerGroup: 4,
	spaceBetween: 30,
	navigation: {
		nextEl: '.routine .next',
		prevEl: '.routine .prev',
	}
});

var ecoSwiper = new Swiper ('.eco .slideCont', {
	slidesPerView: 4,
	slidesPerGroup: 4,
	spaceBetween: 30,
	navigation: {
		nextEl: '.eco .next',
		prevEl: '.eco .prev',
	}
});

var regionSwiper = new Swiper ('.region .slideCont', {
	slidesPerView: 4,
	slidesPerGroup: 4,
	spaceBetween: 30,
	navigation: {
		nextEl: '.region .next',
		prevEl: '.region .prev',
	}
});

var recipeSwiper = new Swiper ('.recipe .slideCont', {
	slidesPerView: 3,
	slidesPerGroup: 3,
	spaceBetween: 47,
	navigation: {
		nextEl: '.recipe .next',
		prevEl: '.recipe .prev',
	}
});
</script>
</body>
</html>
