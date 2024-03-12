<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.board.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("포토리뷰"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");

	Param param = new Param(request);
	ReviewService review = (new ReviewService()).toProxyInstance();
	Integer count = review.getImageCount(param.get("pid"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<link rel="stylesheet" href="/mobile/css/swiper.min.css" type="text/css">
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont" class="photoReviewList">
	<!-- 내용영역 -->
		<p class="total">TOTAL <%= Utils.formatMoney(count) %></p>
		<ul class="photoList">
		</ul>
		<div class="btnArea">
			<a href="#" onclick="getImage(); return false" class="btnTypeA sizeA"><span class="icoFold">더보기</span></a>
		</div>
	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->
<div class="photoSrmyLayer layer">
	<p class="close"><a href="#" onclick="hideContent(this); return false"><img src="/mobile/images/btn/btn_back.png" alt="이전"></a></p>
	<div class="slideCont">
		<ul class="swiper-wrapper">
			<li class="swiper-slide">
			</li>
		</ul>
	</div>
</div><!-- //photoSrmyLayer -->
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
<script>
var page = 1;
var totalPage = <%= count %> % 15 == 0 ? <%= count %> / 15 : <%= count %> / (15 + 1);

$(function() {
	getImage();
});

function getImage() {
	console.log("-------getImage");
	$.ajax({
		method : "POST",
		url : "photoReviewAjax.jsp",
		data : { pid : "<%= param.get("pid") %>", page : page },
		dataType : "html"
	})
	.done(function(html) {
		$(".photoList").append(html);
		setPopup(<%=layerId%>);
		if(page >= totalPage) {
			$(".btnArea").hide();
		}
		page++;
	});
	
}

$("body").imagesLoaded(function(){
	$(".photoList li").each(function(){
		if($(this).find("img").height() < $(this).find("img").width()){
			$(this).addClass("vertical")
		}
	});
});
var swiperPhoto, swiperZoomPhoto, swiperZoomList

//팝업높이조절
setPopup(<%=layerId%>);

function showMore(){
	//더보기 맨 마지막에
	$("body").imagesLoaded(function(){
		$(".photoList li").each(function(){
			if($(this).find("img").height() < $(this).find("img").width()){
				$(this).addClass("vertical")
			}
		});
	});
	
}

function showContent(obj, seq, imgno) {
	$.ajax({
		method : "POST",
		url : "photoReviewAjax2.jsp",
		data : { seq : seq, imgno : imgno },
		dataType : "html"
	})
	.done(function(html) {
		$(".swiper-slide").html(html);
		parent.$(".popLayer .close").hide();
		$(".photoSrmyLayer").show();
		swiperPhoto = new Swiper ('.photoSrmyLayer .slideCont', {
			slideActiveClass: 'on',
			slidesPerView: 1,
			initialSlide: 1 //시작 index
		})
		$(".photoSrmyLayer").imagesLoaded(function(){
			$(".photoSrmyLayer li").each(function(){
				if($(this).find("img").height() < $(this).find("img").width()){
					$(this).addClass("vertical")
				}
			});
			//$(".photoSrmyLayer .slideCont").css("margin-top", "-" + ($(".photoSrmyLayer .slideCont").height()/2) + "px")
			$(".photoSrmyLayer").addClass("on");
		});
	});
}

function hideContent(obj){
	if($(obj).parents('.photoSrmyLayer').length > 0){
		parent.$(".popLayer .close").show();
	}
	$(obj).parents('.layer').hide();
}
</script>
</body>
</html>