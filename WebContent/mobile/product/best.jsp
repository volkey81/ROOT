<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.product.*,
				 com.sanghafarm.service.code.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	CateService cate = (new CateService()).toProxyInstance();
	ProductService product = (new ProductService()).toProxyInstance();
	CodeService code = new CodeService();
	
	//페이징 변수 설정
	int PAGE_SIZE = param.getInt("page_size", 100);
	int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("sort", "pop");
	param.set("grade_code", fs.getGradeCode());
	if (StringUtils.isNotEmpty(param.get("mode"))) {
		if (StringUtils.equals("quick", param.get("mode"))) {
			BLOCK_SIZE = 5;
		}
	}
	List<Param> list = product.getList(param);
	int totalCount = product.getListCount(param);
	
	param.remove("grade_code");
	
%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", "베스트");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>

	$(function(){
		listType = getCookie("LIST_TYPE");
		if(listType == "") listType = "1";
		changeListType(listType);
		
// 		$(".pdtListHead a:first").addClass("on");
		$(".pdtListHead a.listBtn02").click(function() {		
// 			$(".pdtListHead a").removeClass("on");
// 			$(this).addClass("on");
// 			$(".pdtList").addClass("pdtListType02");
			changeListType("2");
		});
		
		$(".pdtListHead a.listBtn01").click(function() {	
// 			$(".pdtListHead a.listBtn02").removeClass("on");
// 			$(this).addClass("on");
// 			$(".pdtList").removeClass("pdtListType02");
			changeListType("1");
		});
	});

	$(function(){

		$(".tabArea li").click(function() {		
			$(".tabArea li").removeClass("on");
			$(this).addClass("on");
			$(".movieList").hide();

			var activeTab = $(this).find("a").attr("href");
			$(activeTab).show();
			return false;
		});	
	});
	
	function changeListType(t) {
		if(t == "1") {
			$("#pdtList2").hide();
			$("#pdtList1").show();
			$(".pdtListHead a.listBtn01").addClass("on");		
			$(".pdtListHead a.listBtn02").removeClass("on");		
			listType = "1";
			setCookie("LIST_TYPE", "1");
			setListHeight($(".pdtList:not(.pdtListType02)")); //제품리스트 행간 높이 통일
		} else {
			$("#pdtList1").hide();
			$("#pdtList2").show();
			$(".pdtListHead a.listBtn02").addClass("on");		
			$(".pdtListHead a.listBtn01").removeClass("on");		
			listType = "2";
			setCookie("LIST_TYPE", "2");
		}
	}
	
	function goPage(p) {
		document.location.href="/mobile/product/list.jsp?cate_seq=<%= param.get("cate_seq") %>&type=" + listType + "&sort=<%= param.get("sort") %>&page=" + p;
	}
</script>
</head>  
<body>
<div id="wrapper" class="productPage">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1>베스트</h1>
		<div class="pdtCate typeB">
			<ul class="swiper-wrapper">
				<li class="swiper-slide<%= "".equals(param.get("cate_seq")) ? " on" : "" %>"><a href="/mobile/product/best.jsp">전체보기</a></li>
				<li class="swiper-slide<%= "78".equals(param.get("cate_seq")) ? " on" : "" %>"><a href="/mobile/product/best.jsp?cate_seq=78">농산물</a></li>
				<li class="swiper-slide<%= "79".equals(param.get("cate_seq")) ? " on" : "" %>"><a href="/mobile/product/best.jsp?cate_seq=79">계란/정육/유제품</a></li>
				<li class="swiper-slide<%= "80".equals(param.get("cate_seq")) ? " on" : "" %>"><a href="/mobile/product/best.jsp?cate_seq=80">수산물</a></li>
				<li class="swiper-slide<%= "81".equals(param.get("cate_seq")) ? " on" : "" %>"><a href="/mobile/product/best.jsp?cate_seq=81">국/반찬/요리</a></li>
				<li class="swiper-slide<%= "82".equals(param.get("cate_seq")) ? " on" : "" %>"><a href="/mobile/product/best.jsp?cate_seq=82">간편식/식사대용식</a></li>
				<li class="swiper-slide<%= "83".equals(param.get("cate_seq")) ? " on" : "" %>"><a href="/mobile/product/best.jsp?cate_seq=83">요리양념/파우더류</a></li>
				<li class="swiper-slide<%= "136".equals(param.get("cate_seq")) ? " on" : "" %>"><a href="/mobile/product/best.jsp?cate_seq=136">음료/건강</a></li>
				<li class="swiper-slide<%= "137".equals(param.get("cate_seq")) ? " on" : "" %>"><a href="/mobile/product/best.jsp?cate_seq=137">간식/과자</a></li>
			</ul>
		</div>

		<ul class="pdtList" id="pdtList1" style="display:none">
<%
	for(Param row : list) {
		boolean isSoldOut = ("N".equals(row.get("sale_status")) || (row.getInt("opt_cnt") == 0 && row.getInt("stock") == 0));
%>					
			<li><div class="wrap">
				<div class="thumb">
<%
			if (isSoldOut) {
%>
					<div class="soldOut"><div><%= code.getCode2Name("028", row.get("soldout_msg", "001")) %></div></div>
<%
			}
%>
					<a href="detail.jsp?pid=<%= row.get("pid") %>&cate_seq=<%= param.get("cate_seq")%>"><img src="<%= row.get("image1") %>" alt="<%= row.get("pnm") %>"></a>
				</div>
				<a href="detail.jsp?pid=<%= row.get("pid") %>">
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
					<p class="price"><strong><%= Utils.formatMoney(row.get("sale_price")) %></strong>원</p>
					<p class="icon">
						<span><%= row.get("icon") %></span>
					</p>
				</a>
			</div></li>
<%
	}

	if(totalCount == 0) {
%>
			<li class="none"><img src="/mobile/images/product/noList.png" alt="상품 준비중입니다. 고객님 조금만 기다려주세요! 농부의 땀과 진심을 담은 상품을 준비하고 있습니다."></li>
<%
	}
%>
		</ul>
		<ul class="paging">
<%
	if(totalCount > 0){
		MobilePaging paging = new MobilePaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
// 		MobilePaging paging = new MobilePaging("javascript:goPage('[page]')", totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeToShop(out);
	}
%>
		</ul>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
setSwiper($(".pdtCate")); //스위퍼 기능 유무 셋팅
setSwiper($(".tabTypeA")); //스위퍼 기능 유무 셋팅

var swiperID = [".pdtCate", ".tabTypeA"];
if(!$(swiperID[0]).find(".swiper-wrapper").hasClass("noSwiper")){
	var pSwiper = new Swiper($(swiperID[0]), {
		slidesPerView: 'auto',
		onSlideChangeEnd: function(swiper){	
			var idx = swiper.activeIndex;
		}
	});
	$(swiperID[0]).find(".swiper-slide").each(function(){
		if($(this).hasClass("on")){
			pSwiper.slideTo($(this).index(), 0);			
		}
	});
}
if(!$(swiperID[1]).find(".swiper-wrapper").hasClass("noSwiper")){
	var cSwiper = new Swiper($(swiperID[1]), {
		slidesPerView: 'auto',
		onSlideChangeEnd: function(swiper){	
			var idx = swiper.activeIndex;
		}
	});
	$(swiperID[1]).find(".swiper-slide").each(function(){
		if($(this).hasClass("on")){
			cSwiper.slideTo($(this).index(), 0);			
		}
	});
}
var tabTop;
$(window).on("load", function(){
	tabTop = $(".tabTypeA").offset().top;
}).on("scroll", function(){
	if(tabTop < ($(window).scrollTop() + $("#header").height() + parseInt($(".pdtCate").css("height")))){
		if(!$("#wrapper").hasClass("tabFix")){
			$("#wrapper").addClass("tabFix");
		}
	} else {
		if($("#wrapper").hasClass("tabFix")){
			$("#wrapper").removeClass("tabFix");	
		}
	}
});
</script>
</body>
</html>