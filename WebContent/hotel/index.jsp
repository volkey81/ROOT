<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.board.*,
			com.sanghafarm.service.hotel.*,
			com.sanghafarm.utils.*" %>
<%
	// 진입페이지 쿠키
	SanghafarmUtils.setCookie(response, "LANDING_PAGE", "HOTEL", ".sanghafarm.co.kr", 60*60*24*100);
%>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(0));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("호텔"));

	Param param = new Param(request);
	
	PopupService popup = (new PopupService()).toProxyInstance();
	List<Param> popupList = popup.getList(new Param("device", "P", "position", "C"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>

$(function() {	
	//visual
	setVisualHeight();
	$(window).resize(function(){
		setVisualHeight();
	})
	if($('.visualWrap .visual').size() > 1){
		$('.visualWrap').slick({
			slidesToShow: 1,
			slidesToScroll: 1,
			dots: false,
			//autoplay: true,
			focusOnSelect: false,
			arrows: false,
			cssEase : 'cubic-bezier(0.74, 0.01, 0.21, 0.99)'
		});
		visualSlickNext();
		$('.visualWrap')
		.on('afterChange', function(event, slick, currentSlide){
			visualSlickNext();
		});
	} else {
		if($('.visualWrap .visual video').length > 0) {
			var D_activeSlick = $(".visualWrap .visual");
			var D_video = D_activeSlick.find("video");
			D_video[0].play();
			D_video.on("ended", function () {
				D_video[0].pause();
				D_video[0].currentTime = 0;
				D_video[0].play();
			});
		}
	}
	
	//roomType
	 $(window).scroll(function(){
		var value = $(this).scrollTop() ;
		var promotionTop = $(".section01").offset().top - 500;			
		if (value > promotionTop){
			//$(".section01").addClass("block");
			$(".promotionImg").css({
				"left" : "2%"
			});
			$(".promotionImg>span.bg").css({
				"width" : "0"
			});
			$(".main .section01 .txtArea").css({
				"left" : "55%"
			});
		}
	}) 
	
	function visualSlickNext(){
		var D_activeSlick = $(".visualWrap .slick-active"); 
		if(D_activeSlick.find("video").size() > 0){
			var D_video = D_activeSlick.find("video");
			D_video[0].play();
			D_video.on("ended", function(){
				$('.visualWrap').slick('slickNext');	
				D_video[0].pause();
				D_video[0].currentTime = 0;
			});
		} else {
			setTimeout(function(){
				$('.visualWrap').slick('slickNext');	
			}, 3000)
		}
	}
	
	//promotion
	$('.section01 .cont').slick({
		slidesToShow: 1,
		slidesToScroll: 1,
		dots: true,
		focusOnSelect: false,
		arrows: true,
		prevArrow: $('.section01 .prev'),
		nextArrow: $('.section01 .next'),
		customPaging: function(slider, i) {
			return $('<button type="button" />').text("" + Number(i + 1));
        }
	});

	$(".section01 button").click(function() {		
		$(".section01").toggleClass("bg01");
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
		$(activeTab).fadeIn(800);
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
		
		if(D_slideSize == 2){
			var temp = D_id.find("ul").html();
			D_id.find("ul").append(temp);
			D_slide = D_id.find("li.swiper-slide");
			D_slideSize = D_slide.size();
		}
		
		D_slide.bind("mouseenter focusin", function(e){
			if($(this).hasClass("next")){
				D_id.addClass("on");
			}
			//$(this).find(".galleryName ").addClass("over");
		})
		
		.bind("mouseleave focusout" , function(){
			D_id.removeClass("on");
			//$(this).find(".galleryName ").removeClass("over");
		});
		
		D_slideFirst.addClass("on").next().addClass("next");
		
		D_slide.click(function(e) {
			if($(this).hasClass("next")){
				slideMove();
				e.preventDefault();
			}
		});
	
		var slideMove = function(){
			if(slideState){
				slideState = false;
				var D_slideOn = D_id.find(".on");
				var D_slideNext = D_id.find(".next");
				var D_slideOut = D_id.find(".out");
				var D_slideOnIdx = D_slideOn.index() ;
				D_slideNext.find(".galleryName").css({
					"left" : "15%",
					"width" : "232px"
				})
				D_slideNext.css({
					"left" : "0" 
				});
				setTimeout(function(){
					D_slideNext.find(".galleryName").removeAttr("style");
					D_slideOn.removeClass("on");
					D_slideNext.addClass("on").removeClass("next");
					D_slideOn.removeAttr("style");
					D_slideNext.removeAttr("style");
				},500)
				
				
				var nowNum = D_slideNext.attr("num"); 
				D_id.find(".nowNum").html(nowNum);
				
				if(D_slideNext.next().size() > 0){
					D_slideNext.next().addClass("next");
				} else {
					D_slideFirst.addClass("next");
				}
				
				setTimeout(function(){
					D_id.find(".out").removeClass();
					slideState = true;
				}, 500)
			}
		}
	}

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

function setVisualHeight(){
	var gap = 182;
	var topHeight = $("#header2").height();
	var winHeight = $(window).height();
	var visualSize = winHeight - topHeight - gap;
	$("#visualWrap").height(visualSize);
	//wrapSize(20,7);
}

function wrapSize(w, h){
	var obj = $("#visualWrap .visual video").add("#visualWrap .visual img");
	var wrapW = $("#visualWrap").width();
	var wrapH = $("#visualWrap").height();
	var content_w = Math.floor(wrapH*w / h);
	var content_h = Math.floor(wrapW*h / w);
	
	if (wrapH > content_h ){
		obj.css({
			"position" : "absolute",
			"height" : wrapH + "px",
			"width" : content_w + "px",
			"top" : "0",
			"left" : "50%",
			"margin-top" : "0",
			"margin-left" : -(content_w/2) + "px",
		})
	} else if  (wrapW > content_w ) {
		obj.css({
			"position" : "absolute",
			"height" : content_h + "px", 
			"width" : wrapW + "px",
			"top" : "50%",
			"left" : "0",
			"margin-top" : -(content_h/2) + "px",
			"margin-left" : "0",
		})
	}
} 


function imgSort(obj){
	var $obj = $(obj);
	//console.log($obj.find(".thum").size());
	$obj.find(".visual").each(function(){
		var $parent  = $(this);
		var $img = $(this).find(".sort");
			var imgWidth = $img.width(); 
			var imgHeight = $img.height();
			
			if($parent.width() > imgWidth && $parent.height() > imgHeight){
				$img.addClass("imgVm");
			}
			if(imgWidth < imgHeight){
				$img.css({
					"position" : "absolute",
					"left" : "0",
					"top" : "50%",
					"margin-top" : - (imgHeight / 2) + "px"
				});
			} else if(imgWidth > imgHeight){
				$img.css({
					"max-width" : "none",
					"height" : "100%"
				});
				imgWidth = $img.width();
				imgHeight = $img.height();
				$img.css({
					"position" : "absolute",
					"left" : "50%",
					"top" : "0",
					"margin-left" : - (imgWidth / 2) + "px" 
				});
			}
/* 		$img.load(function(){
		}); */
	})
}


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

<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel">
		<!-- 내용영역 -->
		<div id="visualWrap" class="visualWrap">
			<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
			    <jsp:param name="position" value="001"/>
			    <jsp:param name="POS_END" value="10"/>
			</jsp:include>
		</div>
						
		<div class="section01">
			<div class="cont">
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
				<div class="promotionSlide">
					<div class="promotionImg">
						<span class="bg"></span>
						<p><a href="<%= url %>"><img src="<%= row.get("pc_banner") %>" alt=""></a></p>
					</div>
					<div class="txtArea promotion<%= row.get("cate") %>">
						<img src="/images/hotel/main/promotionTit.png" alt="PROMOTION">
						<p class="promotionTxt1"><%= row.get("title") %></p>
						<p class="promotionTxt2"><%= row.get("summary") %></p>
						<p class="date"><span><%= row.get("start_date").substring(0, 10) %> - <%= row.get("end_date").substring(0, 10) %></span></p>
					</div>
					<div class="btnArea">
						<a href="<%= url %>" class="more">READ MORE</a>	
					</div>
				</div>
<%
		i++;
	}
%>
			</div>
			<div class="controls">
				<button class="prev"></button>
				<button class="next"></button>
			</div>
		</div>
		
		<div class="section02">
			<h2><img src="/images/hotel/main/sectioni02Tit.png" alt="GALLERY"></h2>
			<ul class="tabArea">
				<li class="room"><a href="#room">ROOM</a></li>
				<li class="dinning"><a href="#dinning">DINNING</a></li>
				<li class="facility"><a href="#facility">FACILITY</a></li>
			</ul>
			<div class="galleryWrap">
				<div class="galleryCont galleryCont1" id="room">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum">02</span>
					</div>
					
					<ul>
						<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
						    <jsp:param name="position" value="002"/>
						    <jsp:param name="POS_END" value="5"/>		
						</jsp:include>
					</ul>				
				</div>
				
				<div class="galleryCont galleryCont2" id="dinning">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum"></span>
					</div>
					<ul>
						<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
						    <jsp:param name="position" value="003"/>
						    <jsp:param name="POS_END" value="5"/>		
						</jsp:include>
					</ul>			
				</div>
				
				<div class="galleryCont galleryCont3" id="facility">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum"></span>
					</div>
					<ul>
						<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
						    <jsp:param name="position" value="004"/>
						    <jsp:param name="POS_END" value="5"/>		
						</jsp:include>
					</ul>	
				</div>
			</div>
		</div>
		<div class="section03">
			<h2><img src="/images/hotel/main/section03_title.png" alt="자연과 함께하는 즐거움 상하농원"></h2>
			<ul>
				<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
				    <jsp:param name="position" value="005"/>
				    <jsp:param name="POS_END" value="1"/>		
				</jsp:include>
				<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
				    <jsp:param name="position" value="006"/>
				    <jsp:param name="POS_END" value="1"/>		
				</jsp:include>
				<jsp:include page="/hotel/include/hotel_main.jsp" flush="true"> 
				    <jsp:param name="position" value="007"/>
				    <jsp:param name="POS_END" value="1"/>		
				</jsp:include>
			</ul>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
