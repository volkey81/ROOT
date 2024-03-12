<%@page import="com.sanghafarm.service.board.FarmerMenuService"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.sanghafarm.service.board.*"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*" %>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%
	// 진입페이지 쿠키
	SanghafarmUtils.setCookie(response, "LANDING_PAGE", "BRAND", ".sanghafarm.co.kr", 60*60*24*100);
%>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(0));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("브랜드"));
	Param param = new Param(request);
	// 주문/배송 현황
	BannerService banner = (new BannerService()).toProxyInstance();
	
	FarmerMenuService farmerMenu = (new FarmerMenuService()).toProxyInstance();
	
	List<Param> farmerMenuList = farmerMenu.getList(new Param("POS_STA", 0, "POS_END", 5, "cate", "003"));
	
	PopupService popup = (new PopupService()).toProxyInstance();
	List<Param> popupList = popup.getList(new Param("device", "M", "position", "B"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<link rel="stylesheet" href="/mobile/css/swiper.min.css?t=<%=System.currentTimeMillis()%>">
<script>
	$(function() {
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

	//레이어팝업
	function layerPopOpen(obj){
		$('.'+obj).add(".bgLayer").show();
		$('html,body').css("overflow", "hidden");
	}
	function closePopLayer(obj){
		setCookie( obj, "done" , 1);
		layerPopClose(obj);
		$('html,body').css("overflow", "visible");
	}
	function layerPopClose(obj){
		$('.'+obj).add(".bgLayer").hide();
		$('html,body').css("overflow", "visible");
	}
</script>
</head>  
<body class="main">
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
	<div class="mainVisual">
		<ul class="list swiper-wrapper">
	<%
	List<Param> visualList = banner.getList(new Param("POS_STA", 0 , "POS_END", Integer.MAX_VALUE, "position", "037"));
			if (CollectionUtils.isNotEmpty(visualList)) {
				int i = 1;
				for (Param row : visualList) {
	%>
			<li class="swiper-slide" id="visual<%= i++%>"><a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="<%=row.get("banner_img") %>" alt=""></a></li>
	<%
				}
			}
	%>
		</ul>
	<% 
		if (visualList.size() > 1) {	
	%>
		<div class="control">
			<input type="image" src="/mobile/images/main/btn_prev.png" alt="이전" class="prev">
			<input type="image" src="/mobile/images/main/btn_next.png" alt="다음" class="next">
		</div>
	<%
		}
		if (CollectionUtils.isNotEmpty(visualList)) {
	%>
		<ul class="swiperNav">
		</ul>
	<%
		}	
	%>
	</div>
		
 		
		<div class="quickReser">
<%-- <%
	List<Param> expList = banner.getList(new Param("POS_STA", 0 , "POS_END", Integer.MAX_VALUE, "position", "038"));
	// 브랜드 뉴 모바일 체험상품
		if (CollectionUtils.isNotEmpty(expList)) {
%>
	<div class="slideCont">
		<ul class="list swiper-wrapper">
<%
			for (Param row : expList) {		
%>
			<li class="swiper-slide"><a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="<%=row.get("banner_img") %>" alt=""></a></li>
<%
			}
%>
		</ul>
<%
		if (expList.size() > 1) {		
%>
		<input type="image" src="/mobile/images/brand/main/btn_prev.gif" alt="이전" class="prev">
		<input type="image" src="/mobile/images/brand/main/btn_next.gif" alt="다음" class="next">
<%
		}
%>
	</div>
<%
	} 
%> --%>
			<div class="field">
				<h2>상하농원 체험 프로그램</h2>
				<div class="selectBox">
					<p class="tit"><a href="#" onclick="showSelect(this); return false" id="reserve_date_txt">체험날짜 선택</a></p>
					<ul>
<%
	Calendar cal = Calendar.getInstance();
	String reserveDate = "";
	String reserveDateTxt = "";
	for(int i = 0; i < 20; i++) {
		if(i < 7 && cal.get(Calendar.DAY_OF_WEEK) == 7) {
			reserveDate = Utils.getTimeStampString(cal.getTime(), "yyyy.MM.dd");
			reserveDateTxt = (new SimpleDateFormat("yyyy년 MM월 dd일 (E)", java.util.Locale.KOREA)).format(cal.getTime()); 
		}
%>
						<li><a href="#none" alt="<%= Utils.getTimeStampString(cal.getTime(), "yyyy.MM.dd") %>" onclick="selectReserveDate(this)"><%= (new SimpleDateFormat("yyyy년 MM월 dd일 (E)", java.util.Locale.KOREA)).format(cal.getTime()) %></a></li>
<%		
		cal.add(Calendar.DATE, 1);
	}
%>
					</ul>
				</div>
				<div class="selectBox">
					<p class="tit"><a href="#" onclick="showSelect(this); return false" id="exp_type_txt">체험프로그램 선택</a></p>
					<ul id="exp_type_list">
					</ul>
				</div>
				<input type="hidden" name="reserve_date" id="reserve_date" value="<%= reserveDate %>" />
				<input type="hidden" name="exp_type" id="exp_type" />
				<a href="javascript:goReserve()" class="btnTypeB">예약하기</a>
			</div>
			
			<div class="list">
				<h2>농원소식</h2>
<%
		List<Param> newList = banner.getList(new Param("POS_STA", 0 , "POS_END", Integer.MAX_VALUE, "position", "035"));
		if (CollectionUtils.isNotEmpty(newList)) {
			for (Param row : newList) {
%>
				<li><a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="<%=row.get("banner_img") %>" alt="" ></a></li>
<%
			}
		}
%>
<!-- 				<img src="/mobile/images/brand/main/bannerThum.jpg" alt="" > -->
				
			</div>
		</div><!-- //quickReser -->
					
<%-- 		<div class="newsSrmy">			
			<div class="slideCont">
				<ul class="list swiper-wrapper">
<%
					if (CollectionUtils.isNotEmpty(farmerMenuList)) {
						int i = 1;
						for (Param row : farmerMenuList) {		
%>
					<li class="swiper-slide" id="news<%= i++%>"><a href="/mobile/brand/bbs/news/view.jsp?seq=<%= row.get("seq")%>">
						<p class="tit"><%= row.get("title")%></p>
						<p class="cont"><%= row.get("summary")%></p>
						<p class="thumb"><img src="<%= row.get("banner_img")%>" alt=""></p>
					</a></li>
<%						}
					}					
%>
				</ul>
			</div>
			<ul class="swiperNav">
			</ul>		
		</div> --%>
		
		<div class="srmyChef">
			<h2>공방을 책임지고 있는<span>상하농원 공방장을 소개합니다</span></h2>
			<div class="slideCont">
				<ul class="swiper-wrapper">
					<li class="swiper-slide"><a href="/mobile/brand/workshop/ham.jsp">
						<p class="thumb"><img src="/mobile/images/brand/main/thumb_chef1.jpg" alt="이태리 공방장"></p>
						<p class="tit"><img src="/mobile/images/brand/main/ico_main2.gif" alt="">햄공방</p>
						<p class="txt">건강한 재료로 만든 햄은 그 어떤 보양식보다도 훌륭한 건강식품입니다</p>
					</a></li>
					<li class="swiper-slide"><a href="/mobile/brand/workshop/fruit.jsp">
						<p class="thumb"><img src="/mobile/images/brand/main/thumb_chef2.jpg" alt="조용준 공방장"></p>
						<p class="tit"><img src="/mobile/images/brand/main/ico_main3.gif" alt="">과일공방</p>
						<p class="txt">잼, 청, 말린 과일을 만드는 공방이에요. 놀라운 경험이 될 것입니다</p>
					</a></li>
					<li class="swiper-slide"><a href="/mobile/brand/workshop/bread.jsp">
						<p class="thumb"><img src="/mobile/images/brand/main/thumb_chef3_1.jpg" alt="장시영 공방장"></p>
						<p class="tit"><img src="/mobile/images/brand/main/ico_main4.gif" alt="">빵공방</p>
						<p class="txt">언제나 고소한 빵 굽는 냄새가 진동하는 소박하지만 넉넉한 엄마의 마음을 전하고 싶습니다</p>
					</a></li>
					<li class="swiper-slide"><a href="/mobile/brand/workshop/ferment.jsp">
						<p class="thumb"><img src="/mobile/images/brand/main/thumb_chef4.jpg" alt="김병천 공방장"></p>
						<p class="tit"><img src="/mobile/images/brand/main/ico_main5.gif" alt="">발효공방</p>
						<p class="txt">지붕 위에 옹기종기 모여있는 장독들을 보고 있노라면 세상을 다 가진 것 같은 기분이 들어요. 꼭 느껴보세요</p>
					</a></li>
				</ul>
			</div>
		</div><!-- //srmyChef -->
		
		<div class="bannArea">			
			<ul>
<%
	List<Param> midList = banner.getList(new Param("POS_STA", 0 , "POS_END", 1, "position", "031"));
	// 브랜드 뉴 중간 컨텐츠 1/4 
	if (CollectionUtils.isNotEmpty(midList)) {
%>	
	<li><a href="<%=midList.get(0).get("link") %>" target="<%=midList.get(0).get("target") %>"><img src="<%=midList.get(0).get("banner_img") %>" alt="" width="274"></a></li>
<%
	}
	// 브랜드 뉴 중간 컨텐츠 2/4
	midList = banner.getList(new Param("POS_STA", 0 , "POS_END", 1, "position", "032"));
	if (CollectionUtils.isNotEmpty(midList)) {
%>
	<li><a href="<%=midList.get(0).get("link") %>" target="<%=midList.get(0).get("target") %>"><img src="<%=midList.get(0).get("banner_img") %>" alt="" width="274"></a></li>
<%
		}
	// 브랜드 뉴 중간 컨텐츠 3/4
	midList = banner.getList(new Param("POS_STA", 0 , "POS_END", 1, "position", "033"));
	if (CollectionUtils.isNotEmpty(midList)) {
%>
	<li><a href="<%=midList.get(0).get("link") %>" target="<%=midList.get(0).get("target") %>"><img src="<%=midList.get(0).get("banner_img") %>" alt="" width="274"></a></li>
<%
		}
	// 브랜드 뉴 중간 컨텐츠 4/4
	midList = banner.getList(new Param("POS_STA", 0 , "POS_END", 1, "position", "034"));
	if (CollectionUtils.isNotEmpty(midList)) {
%>
	<li>
		<a href="<%=midList.get(0).get("link") %>" target="<%=midList.get(0).get("target") %>"><img src="<%=midList.get(0).get("banner_img") %>" alt="" width="274"></a>
	</li>
<%
	}
%>
			</ul>
			
		</div><!-- bannArea -->
		
		<div class="srmyKitchen">
			<h2><img src="/mobile/images/brand/main/logo_kitchen2.png" alt=""></h2>
			<p class="text"><span>내 손으로 조물조물!</span><br>직접 만들어 더욱 맛있게! 더욱 즐겁게!</p>
<%
List<Param> ketchenList = banner.getList(new Param("POS_STA", 0 , "POS_END", Integer.MAX_VALUE, "position", "036"));
if (CollectionUtils.isNotEmpty(ketchenList)) {
%>

	<div class="slideCont">
		<ul class="swiper-wrapper">
<%
		for (Param row : ketchenList) {		
%>
			<li class="swiper-slide"><a href="<%=row.get("link") %>" target="<%=row.get("target") %>"><img src="<%=row.get("banner_img") %>" alt=""></a></li>
<%
		}			
%>
		</ul>
	</div>
	<ul class="swiperNav">
	</ul>
<% } %>			
		</div><!-- //srmyKitchen -->
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
	//메인비쥬얼
	var vSwiper = new Swiper($(".mainVisual"), {
		slidesPerView: 1,
		prevButton: $(".mainVisual .prev"),
		nextButton: $(".mainVisual .next"),
		loop: true,
		pagination: $(".mainVisual .swiperNav"),
		paginationElement: 'li',
		paginationClickable: true
	});
	
	//체험프로그램예약
	var rSwiper = new Swiper($(".quickReser .slideCont"), {
		slidesPerView: 1,
		prevButton: $(".quickReser .slideCont .prev"),
		nextButton: $(".quickReser .slideCont .next"),
		onSlideChangeEnd: function(swiper){	
			var idx = swiper.activeIndex;
		}
	});
	function showSelect(obj){
		var $target = $(obj).parents(".selectBox");
		$target.siblings().find("ul").slideUp(50);
		$target.find("ul").slideToggle(100);
		
		/*
		$target.find("li a").on("click", function(){
			$target.find(".tit a").text($(this).text());
			$target.find("ul").slideUp(50);
			return false;
		});
		*/
	}
	$(document).on("click focusin touchstart", function(e) {
		if($(".selectBox ul").is(":visible")){
			if(!($(e.target).parents(".selectBox").length)){
				$(".selectBox ul").slideUp(50);
			}
		}
	});
	
	//농원소식
	var vSwiper = new Swiper($(".newsSrmy .slideCont"), {
		slidesPerView: 1,
		pagination: $(".newsSrmy .swiperNav"),
		paginationElement: 'li',
		paginationClickable: true
	});
	
	//공방장소개
	var cSwiper = new Swiper($(".srmyChef .slideCont"), {
		slidesPerView: 'auto',
	    spaceBetween: 5,		
		onSlideChangeEnd: function(swiper){	
			var idx = swiper.activeIndex;
		}
	});
	var wHeight = 0;
	$(".srmyChef .slideCont li img").imgpreload(function(){
		var $this = $(this).parents("li");
		if(wHeight < $this.height()){
			wHeight = $this.height();
		}
		$(".srmyChef .slideCont li").height(wHeight);
	});
	
	//상하키친
	var cSwiper = new Swiper($(".srmyKitchen .slideCont"), {
		slidesPerView: 1,	
		pagination: $(".srmyKitchen .swiperNav"),
		paginationElement: 'li',
		paginationClickable: true
	});

	function selectReserveDate(obj) {
		$("#reserve_date").val($(obj).attr("alt"));
		
		var $target = $(obj).parents(".selectBox");
		$("#reserve_date_txt").text($(obj).text());
		$target.find("ul").slideUp(50);

		getExpList();

		return false;
	}
	
	function selectExpType(obj) {
		$("#exp_type").val($(obj).attr("alt"));
		
		var $target = $(obj).parents(".selectBox");
		$("#exp_type_txt").text($(obj).text());
		$target.find("ul").slideUp(50);
		return false;
	}
	
	function getExpList() {
		$("#exp_type_txt").text("체험프로그램 선택");
		$.ajax({
			method : "POST",
			url : "/ajax/expList1.jsp",
			data : { date : $("#reserve_date").val() },
			dataType : "html"
		})
		.done(function(html) {
			$("#exp_type_list").empty().html($.trim(html));
		});
	}

	function goReserve() {
		if($("#reserve_date").val() == '') {
			alert("체험날짜를 선택하세요.");
		} else if($("#exp_type").val() == '') {
			alert("체험프로그램을 선택하세요.");
		} else {
			document.location.href="/mobile/brand/play/reservation/experience.jsp?reserve_date=" + $("#reserve_date").val() + "&exp_type=" + $("#exp_type").val();
		}
	}
	
	$(function() {
		$("#reserve_date_txt").text("<%= reserveDateTxt %>");
		getExpList();
	});
</script>
</body>
</html>
