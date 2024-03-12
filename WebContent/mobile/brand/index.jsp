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
	<div id="container" class="newMain"><!-- 내용영역 -->
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
			<ul class="swiperNav"></ul>
		<%
			}	
		%>
		</div>
	
		<div class="srmyInfo">
			<div class="useTime">
				<strong>오늘 상하농원 운영시간</strong> 
				<span class="time">09:30~21:00</span> 
			</div>
			<div class="news">
				<div class="wrap">
					<h2>SANGHA NEWS<strong>상하농원 새소식</strong></h2>
					<jsp:include page="/brand/include/banner.jsp" flush="true">
					    <jsp:param name="position" value="039"/>
					    <jsp:param name="POS_END" value="9999"/>
					</jsp:include>
					<div class="slideInfo">
						<ul class="swiperNav"></ul><div class="pageNum"><span>1</span>/4</div>
					</div>
				</div>
			</div><!--news 슬라이드 -->
		</div><!-- //srmyInfo -->
		<jsp:include page="/brand/include/banner.jsp" flush="true">
		    <jsp:param name="position" value="042"/>
		    <jsp:param name="POS_END" value="1"/>
		</jsp:include>
		<div class="srmyCraft">
			<div class="wrap">
				<h2>SANGHA MAKERS<strong>상하농원을 만들어가는 사람들</strong></h2>
				<div class='slideContainer'>
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<a href="/mobile/brand/workshop/ham.jsp" target="_blank">
								<img src="/images/brand/main/craft_1_1.jpg" alt="햄공방">
								<div class="cont">
									<img src="/mobile/images/brand/main/craft_8.png" alt="우형민 공방장" class="thum">
									<strong>햄공방</strong>
									<p class="name">우형민 공방장</p>
									<p class="txt">건강한 재료로 만든 햄은 그 어떤 보양식보다도 훌륭한 건강식품이라고 자신있게 소개할 수 있습니다.</p>
								</div>
							</a>
						</div>
						<div class="swiper-slide">
							<a href="/mobile/brand/workshop/fruit.jsp" target="_blank">
								<img src="/images/brand/main/craft_2_1.jpg" alt="과일공방">
								<div class="cont">
									<img src="/mobile/images/brand/main/craft_5.png" alt="정윤석 공방장" class="thum">
									<strong>과일공방</strong>
									<p class="name">정윤석 공방장</p>
									<p class="txt">잼,청, 말린 과일을 만드는 과일공방입니다. 깐깐한 선별기준으로 최상급의 과일만을 사용해 상품을 만듭니다.</p>
								</div>
							</a>
						</div>
						<div class="swiper-slide">
							<a href="/mobile/brand/workshop/bread.jsp" target="_blank">
								<img src="/images/brand/main/craft_3_1.jpg" alt="빵공방">
								<div class="cont">
									<img src="/mobile/images/brand/main/craft_6.png" alt="박성태 공방장" class="thum">
									<strong>빵공방</strong>
									<p class="name">박성태 공방장</p>
									<p class="txt">언제나 고소한 빵 굽는 냄새가 진동하는 소박하지만 넉넉한 엄마의 마음으로 전하고 싶습니다.</p>
								</div>
							</a>
						</div>
						<div class="swiper-slide">
							<a href="/mobile/brand/workshop/ferment.jsp" target="_blank">
								<img src="/images/brand/main/craft_4_1.jpg" alt="발효공방">
								<div class="cont">
									<img src="/mobile/images/brand/main/craft_7.png" alt="양혜영 고문, 주재원 공방장" class="thum">
									<strong>발효공방</strong>
									<p class="name">양혜영 고문<br>주재원 공방장</p>
									<p class="txt">지붕 위에 옹기종기 모여있는 장독들을 보고 있노라면 세상을 다 가진것 같은 기분이 들어요.</p>
								</div>		
							</a>					
						</div>
					</div>
					<div class="slideBtn">
						<div class="prev"></div>
						<div class="next"></div>
					</div>
					<div class="slideInfo">
						<ul class="swiperNav"></ul><div class="pageNum"><span>1</span>/4</div>
					</div>
				</div>
			</div>
		</div><!-- //srmyChef -->
		
		<div class="srmyAdventure">
			<div class="wrap">
				<h2>SANGHA + ADVENTURE<strong>상하를 더 느끼고 싶다면</strong></h2>
				<jsp:include page="/brand/include/banner.jsp" flush="true">
				    <jsp:param name="position" value="040"/>
				    <jsp:param name="POS_END" value="9999"/>
				</jsp:include>
			</div>
		</div><!-- //내용영역 -->
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
	//메인비쥬얼
	$(function(){
		
		if($(".mainVisual li").size() > 1){
			var vSwiper = new Swiper($(".mainVisual"), {
				slidesPerView: 1,
				prevButton: $(".mainVisual .prev"),
				nextButton: $(".mainVisual .next"),
				loop: true,
				pagination: $(".mainVisual .swiperNav"),
				paginationElement: 'li',
				paginationClickable: true
			});
		}
		//체험프로그램예약
		/* var rSwiper = new Swiper($(".quickReser .slideCont"), {
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
		}
		$(document).on("click focusin touchstart", function(e) {
			if($(".selectBox ul").is(":visible")){
				if(!($(e.target).parents(".selectBox").length)){
					$(".selectBox ul").slideUp(50);
				}
			}
		}); */
		
		//농원소식
		/* var vSwiper = new Swiper($(".newsSrmy .slideCont"), {
			slidesPerView: 1,
			pagination: $(".newsSrmy .swiperNav"),
			paginationElement: 'li',
			paginationClickable: true
		}); */
		
		//농원 새소식
		var newsSwiper = new Swiper($(".news .slideContainer"), {
			wrapperClass : 'slideWrap',
			slidesPerView:1,
			spaceBetween:'3%',
			loop:true,
			prevButton: $(".news .prev"),
			nextButton: $(".news .next"),
			pagination: $(".news .swiperNav"),
			paginationElement: 'li',
			paginationClickable: true,
			onInit: function(e){
				var realIndex = parseInt($('.news .swiper-slide-active').attr('data-swiper-slide-index'))+1;
				$(".news .pageNum").html('<span>' + realIndex + '</span>/' + e.bullets.length);			
			},
			onSlideChangeEnd : function(e){
				var realIndex = parseInt($('.news .swiper-slide-active').attr('data-swiper-slide-index'))+1;
				$(".news .pageNum span").html(realIndex);				
			},
		}); 
		
		$(".news .slideWrap").addClass('swiper-wrapper');
		//공방장소개
		var craftSwiper = new Swiper($(".srmyCraft .slideContainer"), {
			slidesPerView:1,
			loop:true,
			prevButton: $(".srmyCraft .prev"),
			nextButton: $(".srmyCraft .next"),
			pagination: $(".srmyCraft .swiperNav"),
			paginationElement: 'li',
			paginationClickable: true,
			onInit: function(e){
				var realIndex = parseInt($('.srmyCraft .swiper-slide-active').attr('data-swiper-slide-index'))+1;
				$(".srmyCraft .pageNum").html('<span>' + realIndex + '</span>/' + e.bullets.length);			
			},
			onSlideChangeEnd : function(e){
				var realIndex = parseInt($('.srmyCraft .swiper-slide-active').attr('data-swiper-slide-index'))+1;
				$(".srmyCraft .pageNum span").html(realIndex);				
			}
		});
		
	});
	
	//체험 프로그램
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
	
	<%-- $(function() {
		$("#reserve_date_txt").text("<%= reserveDateTxt %>");
		getExpList();
	}); --%>
</script>
</body>
</html>
