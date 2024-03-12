<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.efusioni.stone.utils.*,
				com.sanghafarm.service.product.*"%>
<%@page import="java.util.*"%>
<%@page import="com.sanghafarm.service.board.KeywordService"%>
<%@page import="com.sanghafarm.common.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	Param param = new Param(request);
	KeywordService keyword = (new KeywordService()).toProxyInstance();
	ProductService product = (new ProductService()).toProxyInstance();

	List<Param> keywordList = keyword.getList(new Param("POS_STA", 0, "POS_END" , Integer.MAX_VALUE, "status", "S"));
	List<Param> crtList = new ArrayList<Param>();
	FrontSession fs = FrontSession.getInstance(request, response);
	if(fs.isLogin()) {
		crtList = keyword.getMemKeywordList((new Integer(fs.getUserNo())).longValue());
	}

	param.addPaging(1, 6);
	param.set("sort", "pop");
	param.set("grade_code", fs.getGradeCode());
	List<Param> bestList = product.getList(param);
%>
<script>
$(function(){
	$(".listCont").hide();
	$(".pdtListTab li:first").addClass("on");
	$(".listCont:first").show();
	$(".pdtListTab li").click(function() {		
		$(".pdtListTab li").removeClass("on");
		$(this).addClass("on");
		$(".listCont").hide();

		var activeTab = $(this).find("a").attr("href");
		$(activeTab).show();
		return false;
	});	
	
	$(".searchForm input").click(function() {		
		$(".searchBg").show();
	});	
	$(".searchBg").click(function() {		
		$(this).hide();
	});
	
	/* $(".searchForm .prevBtn").click(function() {		
		$("#topSrch").removeClass("");
		$(".bgLayer").hide();
		$("#wrapper").css("position", "absolute");
	}); */
	$("#topSrch .best .pdtList li").width((window.innerWidth - 60) / 2)
	var bestSwiper = new Swiper($(".best .slideCont"), {
		slidesPerView: 'auto',
	});
	
});

function hideSrch(){
	$("#topSrch").removeClass("on");
	$(".bgLayer").hide();
	$("#wrapper").css("position", "absolute");
}

function removeKeyword(obj, keyword) {
	$.ajax({
		method : "POST",
		url : "/ajax/removeKeyword.jsp",
		data : { keyword : keyword },
		dataType : "json"
	})
	.done(function(json) {
		$(obj).parent().remove();
// 		alert($("#recentList").children().length);
		if($("#recentList").children().length == 0) {
			$("#recentList").html("<li class=\"none\"><img src=\"/mobile/images/product/blt_recentNone.png\" alt=\"\">최근검색어가 없습니다.</li>");
		}
	});
}
</script>
<div id="topSrch">
	<div class="searchForm">
	<a href="#" onclick="hideSrch(); return false" class="prevBtn"><img src="/mobile/images/btn/btn_back3.png" alt="이전" ></a>
	<form name="quickSrchForm" id="quickSrchForm" method="GET" action="/mobile/product/search.jsp" >
		<input type="text" name="pnm" id="pnm" value="<%= Utils.safeHTML(param.get("pnm")) %>" onKeyPress="if (event.keyCode==13){ javascript:$('#quickSrchForm').submit()}" placeholder="검색어를 입력해주세요">	
		<a href="javascript:$('#quickSrchForm').submit()" class="btnSrch"><img src="/mobile/images/layout/btn_search.png" alt="검색"></a>
		</form>
	</div><!-- //searchForm -->
	
	<div class="searchList">
		<h2 class="typeA">추천 검색어</h2>		
		<div class="result">
			<ul id="popularityList">
<%
			int i = 0;
			for(Param row : keywordList) {
				i++;
%>
				<li <%= i <= 3 ? "class=\"popularity\"" : "" %>>
					<a href="/mobile/product/search.jsp?pnm=<%= row.get("keyword")%>"><%= row.get("keyword")%></a>
				</li>
<%
			}				
%>
			</ul>
		</div>
		
		<h2 class="typeA">베스트 상품</h2>
		<p class="more"><a href="/mobile/product/list.jsp?sort=pop" class="icoMore2">더보기</a></p>
		<div class="best swiper-container">
				<div class="slideCont">
					<ul class="pdtList swiper-wrapper">
<%
	for(Param row : bestList) {
%>
						<li class="swiper-slide"><div class="wrap">
							<div class="thumb">
								<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("image1") %>" alt="상하농원 공방혼합세트 B"></a>					
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
								<p class="price"><strong><%= Utils.formatMoney(row.get("sale_price")) %></strong>원</p>								
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
			</div><!-- //베스트 상품 -->	
	</div>
	
	
	<span class="searchBg"></span>
	
	<!-- <a href="#" onclick="hideSrch(); return false;" class="btnClose"><img src="/mobile/images/btn/btn_close2.png" alt="닫기"></a> -->
</div><!-- //h_search -->