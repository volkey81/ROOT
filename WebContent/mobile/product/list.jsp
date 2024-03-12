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
	
	List<Param> cateList = new ArrayList<Param>();
	String pCateSeq = "";
	Param cateInfo = new Param();
	Param pcateInfo = new Param();
	
	if (StringUtils.isNotEmpty(param.get("cate_seq"))) {
		cateInfo = cate.getInfo(param.getInt("cate_seq"));
		
		if(cateInfo.getInt("p_cate_seq") == 0) {	// 1dept
			pCateSeq = param.get("cate_seq");
			cateList = cate.getSubDepthList(param);
			pcateInfo = cateInfo;
		} else {
			pCateSeq = cateInfo.get("p_cate_seq");
			cateList = cate.getSubDepthList(new Param("cate_seq", cateInfo.get("p_cate_seq")));
			pcateInfo = cate.getInfo(cateInfo.getInt("p_cate_seq"));
		}
	}
	
	// 1차 카테고리 리스트
	List<Param> depthList  = cate.get1DepthList(new Param());
	
	//페이징 변수 설정
	int PAGE_SIZE = param.getInt("page_size", 100);
	int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("grade_code", fs.getGradeCode());
	if (StringUtils.isNotEmpty(param.get("mode"))) {
		if (StringUtils.equals("quick", param.get("mode"))) {
			BLOCK_SIZE = 5;
		}
	}
	List<Param> list = product.getList(param);
	int totalCount = product.getListCount(param);
	
	param.remove("grade_code");
	
	Param rootCateParam = new Param();
	if (StringUtils.isNotEmpty(param.get("cate_seq")) && StringUtils.isEmpty(param.get("mode"))
			&& !StringUtils.equals("quick", param.get("mode"))) {
		if (StringUtils.isNotEmpty(param.get("cate_seq"))) {
			rootCateParam = product.getPidForRootCateseq(param.getInt("cate_seq"));
		} else {
			int cateSeq = product.getCateSeqForPid(param.get("pid"));
			rootCateParam = product.getPidForRootCateseq(cateSeq);
		}
	}
%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", StringUtils.isEmpty(cateInfo.get("cate_name")) ? param.get("cate_name") : cateInfo.get("cate_name"));
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

	function goList() {
		document.location.href="/mobile/product/list.jsp?cate_seq=<%= param.get("cate_seq") %>&sort=" + $("#sort").val() + "&page_size=<%= PAGE_SIZE %>";
	}

</script>
</head>  
<body>
<div id="wrapper" class="productPage">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1><%= StringUtils.isNotEmpty(param.get("cate_seq")) ? pcateInfo.get("cate_name") : ("date".equals(param.get("sort")) ? "신상품" : "베스트") %></h1>
		<%-- <div class="pdtCate">
			<ul class="swiper-wrapper">
<%
				if (CollectionUtils.isNotEmpty(depthList)) {
					int i = 1;
					for (Param listRow : depthList) {
						if (i > 6) {
							break;
						}
%>
				<li class="swiper-slide <%= StringUtils.equals(listRow.get("cate_seq"), rootCateParam.get("cate_seq")) ? "on" : ""%>"><a href="list.jsp?cate_seq=<%= listRow.get("cate_seq")%>"><%=listRow.get("cate_name") %></a></li>
<%
					i++;
					}
				}
%>
			</ul>
		</div> --%>
<%
		if (StringUtils.isNotEmpty(param.get("cate_seq"))) {
%>
		<div class="pdtCate typeB">
			<ul class="swiper-wrapper">
				<li class="swiper-slide<%= pCateSeq.equals(param.get("cate_seq")) ? " on" : "" %>"><a href="/mobile/product/list.jsp?cate_seq=<%= pCateSeq %>">전체보기</a></li>
<%
	for(Param row : cateList) {
%>
				<li class="swiper-slide<%= row.get("cate_seq").equals(param.get("cate_seq")) ? " on" : "" %>"><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
			</ul>
		</div>
<%
	}
%>

		<div class="pdtListHead2" style="display:<%= "".equals(param.get("cate_seq")) ? "none" : "" %>">
			<select name="sort" id="sort" onchange="goList()" title="제품 정렬 방법 선택">
				<option value="rec" <%= "rec".equals(param.get("sort")) ? "selected" : "" %>>추천순</option>
				<option value="pop" <%= "pop".equals(param.get("sort")) ? "selected" : "" %>>인기순</option>
				<option value="date" <%= "date".equals(param.get("sort")) ? "selected" : "" %>>신상품순</option>
			</select>
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