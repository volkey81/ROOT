<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.board.*,
			com.sanghafarm.service.hotel.*" %>
<%
	// 진입페이지 쿠키
	SanghafarmUtils.setCookie(response, "LANDING_PAGE", "HOTEL", ".sanghafarm.co.kr", 60*60*24*100);
%>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(0));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("파머스빌리지"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	PopupService popup = new PopupService();
	List<Param> popupList = popup.getList(new Param("device", "M", "position", "C"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp"/> 
<link rel="stylesheet" href="/mobile/css/swiper.min.css">
<script>
$(function() {	
	var vSwiper = new Swiper($(".mainVisual"), {
		slidesPerView: 1,
		loop: true,
		autoplay: 3000,
		paginationElement: 'li',
		paginationClickable: true
	});
	
	var vSwiper = new Swiper($(".promotionSlide"), {
		slidesPerView: 1,
		prevButton: $(".promotionSlide .prev"),
		nextButton: $(".promotionSlide .next"),
		loop: false,
		pagination: $(".promotionSlide .swiperNav"),
		paginationElement: 'li',
		paginationClickable: true
	});
	
	var vSwiper = new Swiper($(".galleryCon1"), {
		slidesPerView: 1,
		prevButton: $(".galleryCon1 .prev"),
		nextButton: $(".galleryCon1 .next"),
		loop: false,
		onSlideChangeEnd: function(swiper){	
			var nowNum = swiper.activeIndex +1;
			$(".galleryCon1").find(".slideNum .nowNum").html("0"+nowNum);	
		}

	});
	var vSwiper = new Swiper($(".galleryCon2"), {
		slidesPerView: 1,
		prevButton: $(".galleryCon2 .prev"),
		nextButton: $(".galleryCon2 .next"),
		loop: false,
		onSlideChangeEnd: function(swiper){	
			var nowNum = swiper.activeIndex +1;
			$(".galleryCon2").find(".slideNum .nowNum").html("0"+nowNum);	
		}

	});
	var vSwiper = new Swiper($(".galleryCon3"), {
		slidesPerView: 1,
		prevButton: $(".galleryCon3 .prev"),
		nextButton: $(".galleryCon3 .next"),
		loop: false,
		onSlideChangeEnd: function(swiper){	
			var nowNum = swiper.activeIndex +1;
			$(".galleryCon3").find(".slideNum .nowNum").html("0"+nowNum);	
		}
	});

	//galleryTab
	$(".galleryCont").hide();
	$(".tabArea li:first").addClass("on").show();
	$(".galleryCont:first").show();
	$(".tabArea li").click(function() {		
		$(".tabArea li").removeClass("on");
		$(this).addClass("on");
		$(".galleryCont").hide();
	
		var activeTab = $(this).find("a").attr("href");
		$(activeTab).show();
		return false;	
	});
	
	$(function() {			
		galleryInit('room');
		galleryInit('dinning');
		galleryInit('facility');
	});

	//갤러리
	function galleryInit(id){
		var slideState = true;
		var D_id = $("#" + id);
		var D_slide = D_id.find("li.swiper-slide");
		var D_slideSize = D_slide.size();
		var D_slideFirst = D_id.find("li.swiper-slide:first");
		
		D_id.find(".allNum").html("0"+ D_slideSize);
		
		
		
		/* D_id.find(".control a").click(function() {		
			var nowNum = D_id.find(".swiper-slide-active").attr("num"); 			
			D_id.find(".slideNum .nowNum").html(nowNum);		
		}); */
	}

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
</head>  
<body>
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

<div id="wrapper" class="hotel">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="main">
		<!-- 내용영역 -->
		<div class="mainVisual">
			<ul class="swiper-wrapper">
				<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
				    <jsp:param name="position" value="008"/>
				    <jsp:param name="POS_END" value="10"/>
				</jsp:include>
			</ul>
		</div>
		<!-- promotion -->
		<div class="promotionWrap">
			<h2><img src="/mobile/images/hotel/main/promotion.png" alt="PROMOTION"></h2>
			<div class="promotionSlide">
				<ul class="swiper-wrapper">
<%
	HotelPromotionService promotion = new HotelPromotionService();
	
	//페이징 변수 설정
	param.addPaging(1, 10);
	
	//게시물 리스트
	List<Param> list = promotion.getList(param);
	
	int i = 1;
	for(Param row : list) {
		String no = i < 10 ? "0" + i : "" + i;
		String url = "1".equals(row.get("content_type")) ? "/hotel/village/promotion/view.jsp?seq=" + row.get("seq") : row.get("pc_url");
%>
					<li class="swiper-slide">
						<a href="<%= url %>">
						<img src="<%= row.get("mobile_banner") %>" alt="">
						<div class="txtArea">
							<p class="tit"><%= row.get("title") %></p>
							<p class="txt"><%= row.get("summary") %></p>
							<p class="date"><%= row.get("start_date").substring(0, 10) %> - <%= row.get("end_date").substring(0, 10) %></p>
							<span class="ico"><img src="/mobile/images/hotel/main/promotionIco<%= row.get("cate") %>.png" alt=""></span>
						</div>	
						</a>	
					</li>
<%
		i++;
	}
%>
				</ul>
				<input type="image" src="/mobile/images/btn/btn_prev6.png" alt="이전" class="prev control">
				<ul class="swiperNav">
				</ul>
				<input type="image" src="/mobile/images/btn/btn_next6.png" alt="다음" class="next control">
			</div>
		</div>
		<!-- //promotion -->
		
		<!-- galleryArea -->
		<div class="galleryArea">
			<h2><img src="/mobile/images/hotel/main/galleryTit.png" alt="GALLERY"></h2>
			<ul class="tabArea">
				<li class="on"><a href="#room">ROOM</a></li>
				<li><a href="#dinning">DINNING</a></li>
				<li><a href="#facility">FACILITY</a></li>
			</ul>
			<div class="galleryWrap">
				<div class="galleryCont galleryCon1" id="room">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum"></span>
					</div>	
					<ul class="swiper-wrapper">
						<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
						    <jsp:param name="position" value="009"/>
						    <jsp:param name="POS_END" value="5"/>		
						</jsp:include>
					</ul>		
					<div class="control">
						<a href="" class="prev"><img src="/mobile/images/btn/btn_prev6.png" alt="이전"></a>
						<a href="" class="next"><img src="/mobile/images/btn/btn_next7.png" alt="다음"></a>
					</div>
				</div>
				
				<div class="galleryCont galleryCon2" id="dinning">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum"></span>
					</div>	
					<ul class="swiper-wrapper">
						<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
						    <jsp:param name="position" value="010"/>
						    <jsp:param name="POS_END" value="5"/>		
						</jsp:include>
					</ul>	
					<div class="control">
						<a href="" class="prev"><img src="/mobile/images/btn/btn_prev6.png" alt="이전"></a>
						<a href="" class="next"><img src="/mobile/images/btn/btn_next7.png" alt="다음"></a>
					</div>	
				</div>
				
				<div class="galleryCont galleryCon3" id="facility">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum"></span>
					</div>	
					<ul class="swiper-wrapper">
						<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
						    <jsp:param name="position" value="011"/>
						    <jsp:param name="POS_END" value="5"/>		
						</jsp:include>
					</ul>	
					<div class="control">
						<a href="" class="prev"><img src="/mobile/images/btn/btn_prev6.png" alt="이전"></a>
						<a href="" class="next"><img src="/mobile/images/btn/btn_next7.png" alt="다음"></a>
					</div>	
				</div>
			</div>
		</div>
		<!-- //galleryArea -->
		
		<!-- sangha --> 
		<div class="sangha">
			<h2><img src="/mobile/images/hotel/main/sanghaTit.png" alt="자연과 함께하는 즐거움 상하농원"></h2>
			<ul>
				<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
				    <jsp:param name="position" value="012"/>
				    <jsp:param name="POS_END" value="1"/>		
				</jsp:include>
				<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
				    <jsp:param name="position" value="013"/>
				    <jsp:param name="POS_END" value="1"/>		
				</jsp:include>
				<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
				    <jsp:param name="position" value="014"/>
				    <jsp:param name="POS_END" value="1"/>		
				</jsp:include>
			</ul>
		</div>
		<!-- //sangha -->
		
		
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>