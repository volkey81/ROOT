<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="com.sanghafarm.service.board.EventService"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="com.sanghafarm.service.code.CodeService"%>
<%@page import="com.sanghafarm.service.product.CateService"%>
<%@page import="com.sanghafarm.service.board.*"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.board.BannerService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.sanghafarm.common.*"%>
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
	
	// 1차 카테고리 리스트
	CateService cate = (new CateService()).toProxyInstance();
	List<Param> depthList  = cate.get1DepthList(new Param());

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
// 	List<Param> newList = product.getRefProductList(new Param("cate1", "025", "POS_STA", "0", "POS_END", "5"));

	PopupService popup = (new PopupService()).toProxyInstance();
	List<Param> popupList = popup.getList(new Param("device", "M", "position", "S"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script src="/js/swiper.min.4.5.1.js"></script>
<script type="text/javascript">
	$(function (){
// 		goBestProduct('01');
		goRecommandProduct('01');
		showBand();	
		
		setSwiper($(".pdtCate")); //스위퍼 기능 유무 셋팅		
		if(!$(".pdtCate").find(".swiper-wrapper").hasClass("noSwiper")){
			var pSwiper = new Swiper($(".pdtCate"), {
				slidesPerView: 'auto',
				onSlideChangeEnd: function(swiper){	
					var idx = swiper.activeIndex;
				}
			});
		}
		
		var vSwiper = new Swiper($(".mainVisual"), {
			slidesPerView: 1,
			loop: true,
			autoplay: 5000,
			pagination: {
				el: $(".mainVisual .page"),
				type: "fraction",
			},
		});

		$(".recommandTab li").width(Math.round((window.innerWidth - 120) / 4))
		$(":not(.recommendPdt) .pdtList li").width((window.innerWidth - 60) / 2)
		
		var recommandSwiper = new Swiper($(".recommandTab .slideCont"), {
			slidesPerView: 'auto',
			spaceBetween: 20,
			initialSlide: $(".recommandTab li.on").index()
		});

		var sSwiper = new Swiper($(".specialSrmy"), {
			slidesPerView: 1,
			pagination: {
				el: $(".specialSrmy .swiperNav"),
				bulletElement: "li",
				clickable: true
			},
			navigation: {
				nextEl: $(".specialSrmy").find(".next"),
				prevEl: $(".specialSrmy").find(".prev"),
			}
		});
		
		
		var newSwiper = new Swiper($(".newProduct .slideCont"), {
			slidesPerView: 'auto',
		});

		var bestSwiper = new Swiper($(".bestProduct .slideCont"), {
			slidesPerView: 'auto',
		});

		var recommendSwiper = new Swiper ('.recommend .slideCont', {
			slidesPerView: 'auto',
		});

		var routineSwiper = new Swiper ('.routune .slideCont', {
			slidesPerView: 'auto',
		});
			
		var ecoSwiper = new Swiper ('.eco .slideCont', {
			slidesPerView: 'auto',
		});

		var regionSwiper = new Swiper ('.region .slideCont', {
			slidesPerView: 'auto',
		});

		var recipeSwiper = new Swiper ('.recipePdt .slideCont', {
			slidesPerView: 'auto',
		});

<%
	for(Param row : popupList) {
		if("2".equals(row.get("pop_type"))) {
%>
		//레이어팝업
		if (getCookie("layerPop<%= row.get("seq") %>") != "done" ){
			layerPopOpen('layerPop<%= row.get("seq") %>');
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
		$.post('/mobile/ajax/bestProduct.jsp', searchParam, function(html){
			pickProduct(bestCode2, "best");
			$("#bestProduct *").remove();
			$("#bestProduct").append(html);
		});	
	}
	function goRecommandProduct(recommandCode2, self){
		var searchParam = {
				"cate2" : recommandCode2
		}
		$.post('/mobile/ajax/recommandProduct.jsp', searchParam, function(html){
			pickProduct(recommandCode2, "recommand");
			$("#recommandProduct *").remove();
			$("#recommandProduct").append(html);
			
			$(self).parents("li").addClass("on").siblings().removeClass("on");
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
		}
	}
	function showBand(){
		$(".bandBanner").show();
	}
	function hideBand(){
		$(".bandBanner").slideUp(150, "easeInOutQuint");
	}
	
	function recipeAfter(idx){
		var searchParam = {
				"seq" : $("#recipeSeq" + idx).val()
		}
		$.post('/mobile/ajax/recipeProductList.jsp', searchParam, function(html){
			$(".recipePdt").html(html);

			var recipeSwiper = new Swiper ('.recipePdt .slideCont', {
				slidesPerView: 'auto',
			});
		});	
	}

	//레이어팝업
	function layerPopOpen(obj){
		$('.'+obj).add(".bgLayer").show();
		$('html, body').css("overflow", "hidden");
	}
	function closePopLayer(obj){
		setCookie( obj, "done" , 1);
		layerPopClose(obj);
		$('html, body').css("overflow", "visible");
	}
	function layerPopClose(obj){
		$('.'+obj).add(".bgLayer").hide();
		$('html, body').css("overflow", "visible");
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
<body class="main" class="overflow:hidden;">
<%
	for(Param row : popupList) {
		if("2".equals(row.get("pop_type"))) {
%>
<div class="mainPop <%= "Y".equals(row.get("mfull_yn")) ? "full" : "" %> layerPop<%= row.get("seq") %>">
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
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="pdtCate">
			<ul class="swiper-wrapper">
				<li class="swiper-slide"><a href="/mobile/product/list.jsp?cate_seq=160"><img src="/mobile/images/layout/logo_farmers.png" alt="상하파머스"></a></li>
				<li class="swiper-slide"><a href="/mobile/product/list.jsp?cate_seq=118">상하 브랜드관</a></li>
				<li class="swiper-slide"><a href="/mobile/product/list.jsp?sort=date">신상품</a></li>
				<li class="swiper-slide"><a href="/mobile/product/best.jsp">베스트</a></li>
				<li class="swiper-slide"><a href="/mobile/product/list.jsp?cate_seq=128">정기배송</a></li>
				<li class="swiper-slide"><a href="/mobile/product/list.jsp?cate_seq=38">알뜰상품</a></li>
			</ul>
		</div>
		<jsp:include page="/mobile/include/main_banner.jsp" flush="true">
		    <jsp:param name="position" value="047"/>
		    <jsp:param name="POS_END" value="9999"/>
		</jsp:include>
		
		<div class="mainSec">
			<h2 class="typeA">상하농원 대표상품</h2>
			<div class="recommandTab swiper-container">
				<div class="slideCont">
					<ul class="swiper-wrapper" id="recommand">
<%
	for(Param row : recommandCodeList) {
%>
				
						<li class="swiper-slide <%= row.get("code2").equals(param.get("recommandCode2")) ? "on" : "" %>"><a href="#" onClick="goRecommandProduct('<%= row.get("code2") %>', this); return false;"><span><img src="/mobile/images/main/ico_newCate<%= row.get("code2") %>.png" alt=""></span><%= row.get("name2") %></a></li>
<%
	}
%>
					</ul>
				</div>
			</div>
			<div class="recommendPdt" id="recommandProduct"></div>
		
			<jsp:include page="/mobile/include/main_banner.jsp" flush="true">
			    <jsp:param name="position" value="048"/>
			    <jsp:param name="POS_END" value="1"/>
			</jsp:include>
			
<%
	List<Param> list = product.getList(new Param("POS_STA", "0", "POS_END", "8", "sort", "date", "grade_code", fs.getGradeCode()));
	if (CollectionUtils.isNotEmpty(list)) {			
%>
			<h2 class="typeA">신상품</h2>
			<p class="more"><a href="/mobile/product/list.jsp?sort=date" class="icoMore2">더보기</a></p>
			<div class="newProduct swiper-container">
				<div class="slideCont">
					<ul class="pdtList swiper-wrapper">
<%
		for (Param row : list) {					
%>
						<li class="swiper-slide"><div class="wrap">
							<div class="thumb">
								<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("image1") %>" alt="<%= row.get("pnm") %>"></a>					
							</div>
							<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
								<p class="tit"><%= row.get("pnm") %></p>
<%
			if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
								<p class="discount">
									<span><strong><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %></strong>%</span>
									<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
								</p>
<%
			}
%>					
								<p class="price"><strong><%= StringUtils.isNotEmpty(Utils.formatMoney(row.get("sale_price"))) ? Utils.formatMoney(row.get("sale_price")) : Utils.formatMoney(row.get("default_price")) %></strong>원</p>								
								<p class="icon">
									<span><%= row.get("icon") %></span>
								</p>
							</a>		
						</div></li>
<%
		}
%>
					</ul>
				</div>
			</div><!-- //신상품 -->
<%
	}
%>	
		</div><!-- //mainSec(대표상품, 배너, 신상품) -->
		
		<div class="mainSec mainSecB">			
<%
	list = product.getList(new Param("POS_STA", "0", "POS_END", "8", "sort", "pop", "grade_code", fs.getGradeCode()));
	if (CollectionUtils.isNotEmpty(list)) {			
%>		
			<h2 class="typeA">베스트</h2>
			<p class="more"><a href="/mobile/product/list.jsp?sort=pop" class="icoMore2">더보기</a></p>
			<div class="bestProduct swiper-container">
				<div class="slideCont">
					<ul class="pdtList swiper-wrapper">
<%
		for (Param row : list) {					
%>
						<li class="swiper-slide"><div class="wrap">
							<div class="thumb">
								<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("image1") %>" alt="<%= row.get("pnm") %>"></a>					
							</div>
							<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
								<p class="tit"><%= row.get("pnm") %></p>
<%
			if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
								<p class="discount">
									<span><strong><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %></strong>%</span>
									<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
								</p>
<%
			}
%>					
								<p class="price"><strong><%= StringUtils.isNotEmpty(Utils.formatMoney(row.get("sale_price"))) ? Utils.formatMoney(row.get("sale_price")) : Utils.formatMoney(row.get("default_price")) %></strong>원</p>								
								<p class="icon">
									<span><%= row.get("icon") %></span>
								</p>
							</a>		
						</div></li>
<%
		}
%>
					</ul>
				</div>
			</div><!-- //베스트 -->
<%
	}
%>	
		</div><!-- //mainSecB(베스트) -->
		
		<div class="mainSec">
<%
	list = product.getRefProductList(new Param("cate1", "041", "cate2", "002", "POS_STA", "0", "POS_END", "8", "grade_code", fs.getGradeCode()));
	if (CollectionUtils.isNotEmpty(list)) {			
%>		
			<h2 class="typeA">추천상품</h2>
<!-- 			<p class="more"><a href="" class="icoMore2">더보기</a></p> -->
			<div class="recommend swiper-container">
				<div class="slideCont" id="bestProduct">
					<ul class="pdtList swiper-wrapper">
<%
		for (Param row : list) {					
%>
						<li class="swiper-slide"><div class="wrap">
							<div class="thumb">
								<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("image1") %>" alt="<%= row.get("pnm") %>"></a>					
							</div>
							<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
								<p class="tit"><%= row.get("pnm") %></p>
<%
			if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
								<p class="discount">
									<span><strong><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %></strong>%</span>
									<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
								</p>
<%
			}
%>					
								<p class="price"><strong><%= StringUtils.isNotEmpty(Utils.formatMoney(row.get("sale_price"))) ? Utils.formatMoney(row.get("sale_price")) : Utils.formatMoney(row.get("default_price")) %></strong>원</p>								
								<p class="icon">
									<span><%= row.get("icon") %></span>
								</p>
							</a>		
						</div></li>
<%
		}
%>
					</ul>
				</div>
			</div>			
<%
	}
%>
			<jsp:include page="/mobile/include/main_banner.jsp" flush="true">
			    <jsp:param name="position" value="049"/>
			    <jsp:param name="POS_END" value="1"/>
			</jsp:include>
					
<%
	list = product.getRefProductList(new Param("cate1", "041", "cate2", "003", "POS_STA", "0", "POS_END", "8", "grade_code", fs.getGradeCode()));
	if (CollectionUtils.isNotEmpty(list)) {			
%>		
			<h2 class="typeA"><span>정기배송</span></h2>
			<p class="more"><a href="/mobile/product/list.jsp?cate=128" class="icoMore2">더보기</a></p>
			<div class="routine swiper-container">
				<div class="slideCont">
					<ul class="pdtList swiper-wrapper">
<%
		for (Param row : list) {					
%>
						<li class="swiper-slide"><div class="wrap">
							<div class="thumb">
								<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("image1") %>" alt="<%= row.get("pnm") %>"></a>					
							</div>
							<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
								<p class="tit"><%= row.get("pnm") %></p>
<%
			if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
								<p class="discount">
									<span><strong><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %></strong>%</span>
									<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
								</p>
<%
			}
%>					
								<p class="price"><strong><%= StringUtils.isNotEmpty(Utils.formatMoney(row.get("sale_price"))) ? Utils.formatMoney(row.get("sale_price")) : Utils.formatMoney(row.get("default_price")) %></strong>원</p>								
								<p class="icon">
									<span><%= row.get("icon") %></span>
								</p>
							</a>		
						</div></li>
<%
		}
%>
					</ul>
				</div>
			</div><!-- //<span>정기배송</span> -->	
<%
	}
%>					

<%
	list = product.getRefProductList(new Param("cate1", "041", "cate2", "004", "POS_STA", "0", "POS_END", "8", "grade_code", fs.getGradeCode()));
	if (CollectionUtils.isNotEmpty(list)) {			
%>		
			<h2 class="typeA">친환경</h2>
			<p class="more"><a href="/mobile/product/list.jsp?cate=119" class="icoMore2">더보기</a></p>
			<div class="eco swiper-container">
				<div class="slideCont">
					<ul class="pdtList swiper-wrapper">
<%
		for (Param row : list) {					
%>
						<li class="swiper-slide"><div class="wrap">
							<div class="thumb">
								<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("image1") %>" alt="<%= row.get("pnm") %>"></a>					
							</div>
							<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
								<p class="tit"><%= row.get("pnm") %></p>
<%
			if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
								<p class="discount">
									<span><strong><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %></strong>%</span>
									<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
								</p>
<%
			}
%>					
								<p class="price"><strong><%= StringUtils.isNotEmpty(Utils.formatMoney(row.get("sale_price"))) ? Utils.formatMoney(row.get("sale_price")) : Utils.formatMoney(row.get("default_price")) %></strong>원</p>								
								<p class="icon">
									<span><%= row.get("icon") %></span>
								</p>
							</a>		
						</div></li>
<%
		}
%>
					</ul>
				</div>
			</div><!-- //친환경 -->
<%
	}
%>			
		</div><!-- //mainSec (추천상품, 배너, <span>정기배송</span>, 친환경) -->
		
		<div class="mainSec mainSecB">
<%
	list = product.getRefProductList(new Param("cate1", "041", "cate2", "005", "POS_STA", "0", "POS_END", "8", "grade_code", fs.getGradeCode()));
	if (CollectionUtils.isNotEmpty(list)) {			
%>		
			<h2 class="typeA">로컬푸드</h2>
			<p class="more"><a href="/mobile/product/list.jsp?cate=120" class="icoMore2">더보기</a></p>
			<div class="region swiper-container">
				<div class="slideCont">
					<ul class="pdtList swiper-wrapper">
<%
		for (Param row : list) {					
%>
						<li class="swiper-slide"><div class="wrap">
							<div class="thumb">
								<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("image1") %>" alt="<%= row.get("pnm") %>"></a>					
							</div>
							<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
								<p class="tit"><%= row.get("pnm") %></p>
<%
			if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
								<p class="discount">
									<span><strong><%= (row.getInt("default_price") - row.getInt("sale_price")) * 100 / row.getInt("default_price") %></strong>%</span>
									<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
								</p>
<%
			}
%>					
								<p class="price"><strong><%= StringUtils.isNotEmpty(Utils.formatMoney(row.get("sale_price"))) ? Utils.formatMoney(row.get("sale_price")) : Utils.formatMoney(row.get("default_price")) %></strong>원</p>								
								<p class="icon">
									<span><%= row.get("icon") %></span>
								</p>
							</a>		
						</div></li>
<%
		}
%>
					</ul>
				</div>
			</div><!-- //지역상생 -->
<%
	}
%>
		</div><!-- //mainSecB (지역상생) -->	
		
		<div class="mainSec">
<%
		if (CollectionUtils.isNotEmpty(recipeList)) {
%>
			<h2 class="typeA">레시피</h2>
			<p class="more"><a href="/mobile/recipe/list.jsp" class="icoMore2">더보기</a></p>
<%
		}
%>
			<div class="recipePdt swiper-container">
				<div class="slideCont">
					<ul class="list swiper-wrapper">
<%
					int i = 0;
					for (Param recipe : recipeList) {
%>					
						<li class="swiper-slide"><a href="/mobile/recipe/view.jsp?seq=<%= recipe.get("seq") %>">
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
			</div><!-- //recipePdt -->
			
			<jsp:include page="/mobile/include/main_banner.jsp" flush="true">
			    <jsp:param name="position" value="050"/>
			    <jsp:param name="POS_END" value="1"/>
			</jsp:include>
		</div><!-- //mainSec (레시피, 배너) -->
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
