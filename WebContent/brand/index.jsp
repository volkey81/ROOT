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

	PopupService popup = (new PopupService()).toProxyInstance();
	List<Param> popupList = popup.getList(new Param("device", "P", "position", "B"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>

<jsp:include page="/include/head.jsp" />
<script>
	$(function() {		
		
		
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
<div id="wrapper" class="newMain">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<!-- 브랜드 뉴 메인 비주얼 롤링 -->
		<div class="visualWrap">
			<jsp:include page="/brand/include/banner.jsp" flush="true">
			    <jsp:param name="position" value="030"/>
			    <jsp:param name="POS_END" value="9999"/>
			</jsp:include>
		</div>
		<div class="srmyInfo">
			<div class="useTime">
				<strong>오늘 상하농원 운영시간</strong> 
				<span class="time">09:30~21:00</span> 
				<a class="btn" href="http://www.sanghafarm.co.kr/brand/introduce/guide.jsp">자세히 보기 &gt;</a>
			</div>
			<div class="news">
				<div class="wrap">
					<h2>SANGHA NEWS<strong>상하농원 새소식</strong></h2>
					<jsp:include page="/brand/include/banner.jsp" flush="true">
					    <jsp:param name="position" value="039"/>
					    <jsp:param name="POS_END" value="9999"/>
					</jsp:include>
				</div>
			</div><!--news 슬라이드 -->
		</div><!-- //srmyInfo -->
		<jsp:include page="/brand/include/banner.jsp" flush="true">
		    <jsp:param name="position" value="041"/>
		    <jsp:param name="POS_END" value="1"/>
		</jsp:include>
		<div class="srmyCraft">
			<div class="wrap">
				<h2>SANGHA MAKERS<strong>상하농원을 만들어가는 사람들</strong></h2>
				<div class='slideContainer'>
					<div class="slide">
						<a href="/brand/workshop/ham.jsp" target="_blank">
							<img src="/images/brand/main/craft_1_1.jpg" alt="햄공방">
							<div class="cont">
								<strong>햄공방</strong>
								<p class="name">우형민 공방장</p>
								<p class="txt">건강한 재료로 만든 햄은 그 어떤<br>보양식보다도 훌륭한 건강식품이라고<br>자신있게 소개할 수 있습니다.</p>
							</div>
							<img src="/images/brand/main/craft_8.png" alt="우형민 공방장" class="thum">
						</a>
					</div>
					<div class="slide">
						<a href="/brand/workshop/fruit.jsp" target="_blank">
							<img src="/images/brand/main/craft_2_1.jpg" alt="과일공방">
							<div class="cont">
								<strong>과일공방</strong>
								<p class="name">정윤석 공방장</p>
								<p class="txt">잼,청, 말린 과일을 만드는<br> 과일공방입니다. 깐깐한 선별기준으로<br>최상급의 과일만을 사용해<br>상품을 만듭니다.</p>
							</div>
							<img src="/images/brand/main/craft_5.png" alt="정윤석 공방장" class="thum">
						</a>
					</div>
					<div class="slide">
						<a href="/brand/workshop/bread.jsp" target="_blank">
							<img src="/images/brand/main/craft_3_1.jpg" alt="빵공방">
							<div class="cont">
								<strong>빵공방</strong>
								<p class="name">박성태 공방장</p>
								<p class="txt">언제나 고소한 빵 굽는 냄새가<br>진동하는 소박하지만 넉넉한<br>엄마의 마음으로 전하고 싶습니다.</p>
							</div>
							<img src="/images/brand/main/craft_6.png" alt="박성태 공방장" class="thum">
						</a>
					</div>
					<div class="slide">
						<a href="/brand/workshop/ferment.jsp" target="_blank">
							<img src="/images/brand/main/craft_4_1.jpg" alt="발효공방">
							<div class="cont">
								<strong>발효공방</strong>
								<p class="name">양혜영 고문<br>주재원 공방장</p>
								<p class="txt">지붕 위에 옹기종기 모여있는<br>장독들을 보고 있노라면 세상을<br>다 가진것 같은 기분이 들어요. </p>
							</div>
							<img src="/images/brand/main/craft_7.png" alt="양혜영 고문 주재원 공방장" class="thum">
						</a>
					</div>
				</div>
				<div class="pageNum"><span>1</span>/4</div>
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
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
	$(".mainVisual .list").cycle({
		fx: "fade",
		speed: 800,
		timeout: 3000,
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
	
/* 	var newsSwiper = new Swiper($(".news .slideContainer"), {
		slidesPerView:3,
		spaceBetween:30,
		loop: true,
		autoplay: {
	        delay: 2500,
	        disableOnInteraction: false,
	   },
		navigation: {
	        nextEl: '.news .next',
	        prevEl: '.news .prev',
	    },	   
	}); */
	
	 $('.news .slideWrap').slick({
         initialSlide:0,
         slidesToShow:3,
         slidesToScroll:1,
         autoplay: true,
         autoplaySpeed: 2500,
         arrows:true,
         adaptiveHeight: true,
         infinite: true,
         dots: false,
         adaptiveHeight: true
     });

	 $('.srmyCraft .slideContainer').slick({
         initialSlide:0,
         slidesToShow:1,
         slidesToScroll:1,
         autoplay: true,
         autoplaySpeed: 2500,
         arrows:false,
         adaptiveHeight: true,
         infinite: true,
         dots: true,
         adaptiveHeight: true
     });
	 
	 $('.srmyCraft .slideContainer').on('beforeChange', function(event, slick, currentSlide, nextSlide){
	 	 $('.srmyCraft .pageNum span').html(nextSlide+1)
	 });
	/*  $('.slider-for').slick({
	    autoplay: false, //자동슬라이드 x
	    slidesToShow: 1, 
	    slidesToScroll: 1,
	    arrows: true,
	    fade: false,
	    asNavFor: '.slider-nav',
	    prevArrow: '.slick-prev', //prev 버튼
	    nextArrow: '.slick-next', //netx 버튼,
	     customPaging: function (i) {
             return (
               '<a>'+i+'</a>'
             );
           },
	 }); */
	
	/* craftSwiper.pagination.update = function(){
	};
	 */
	//체험프로그램예약
	setCycle(".quickReser", "scrollHorz", "", 500, 5000, "", "");
	
	function showSelect(obj){
		var $target = $(obj).parents(".selectBox");
		$target.siblings().find("ul").slideUp(50);
		$target.find("ul").slideToggle(100);
	}
	
	$(document).on("click focusin", function(e) {
		if($(".selectBox ul").is(":visible")){
			if(!($(e.target).parents(".selectBox").length)){
				$(".selectBox ul").slideUp(50);
			}
		}
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
			document.location.href="/brand/play/reservation/experience.jsp?reserve_date=" + $("#reserve_date").val() + "&exp_type=" + $("#exp_type").val();
		}
	}
	
	$(function() {
		getExpList();		
	});
	
	window.onload = function(){		
		var heightT = 0;
		$('.srmyAdventure .cont').each(function(index){
			if(heightT < $(this).height()) heightT = $(this).height();
		});
		$('.srmyAdventure .cont').css('height', heightT);		
		$('.srmyAdventure li.last').css('height', $('.srmyAdventure li').height());
	}
</script>
</body>
</html>
