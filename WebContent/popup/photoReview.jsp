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
<jsp:include page="/include/head.jsp" />
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
<script>
var page = 1;
var totalPage = <%= count %> % 15 == 0 ? <%= count %> / 15 : <%= count %> / (15 + 1);

$(function() {
	getImage();
});

function getImage() {
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
	$(".photoList li:not(.reviewContent)").each(function(){
		if($(this).find("img").height() < $(this).find("img").width()){
			$(this).addClass("vertical")
		}
	});
});
//팝업높이조절

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
		/*
		var cont = '<p class="user"><strong>dps*****</strong> 2012.12.12</p>'
			+ '<p class="close"><a href="#" onclick="hideContent(this); return false"><img src="/images/btn/btn_close2.png" alt="닫기"></a></p>'
			+ '<div class="thumbArea">'
			+ '	<p class="thumb"><img src="http://www.sanghafarm.co.kr/sanghafarm_Data/upload/shop/review/202103/img1_1616373896335.jpeg" alt=""></p>'
			+ '	<p class="prev"><a href=""><img src="/images/btn/btn_prev.png" alt=""></a></p>'
			+ '	<p class="next"><a href=""><img src="/images/btn/btn_next.png" alt=""></a></p>'
			+ '</div>'
			+ '<ul class="list">'
			+ '	<li class="on"><a href=""><img src="http://dev.sanghafarm.co.kr/sanghafarm_Data/upload/shop/product/201704/C0000392_image1.jpg" alt=""></a></li>'
			+ '	<li><a href=""><img src="http://www.sanghafarm.co.kr/sanghafarm_Data/upload/shop/product/201912/C0004904_2019120614293064412.jpg" alt=""></a></li>'
			+ '</ul>'
			+ '<p class="tit">산란일자로부터 14일</p>'
			+ '<div class="cont">스키야키,베이킹용으로 날계란을 써야할때마다 컬리와 파머스마켓에서 주문해왔는데 지난 몇년동안 산란일로 부터 14일이나 된 계란을 받은것은 이번 3.19일이 처음입니다.</div>'
		*/
		
		var cont = html;
		$(obj).parents("li").addClass("on").siblings().removeClass("on")
		var line = parseInt($(obj).parents("li").index() / 6)
		$(".reviewContent").remove()
		if($(".photoList li:nth-child("+ ((line+1)*6) +")").length < 1){
			$(".photoList li:last-child").after("<li class='reviewContent'></li>")
		} else {
			$(".photoList li:nth-child("+ ((line+1)*6) +")").after("<li class='reviewContent'></li>")
		}
		$(".reviewContent").append(cont).slideDown(100, function(){
			$(".reviewContent .thumb").each(function(){
				if($(this).find("img").height() > $(this).find("img").width()){
					$(this).addClass("vertical")
				}
			});
			$(".reviewContent .list li").each(function(){
				if($(this).find("img").height() < $(this).find("img").width()){
					$(this).addClass("vertical")
				}
			});
			$(".reviewContent").addClass("show")
			setPopup(<%=layerId%>);
			$("#popCont").scrollTop($(obj).parents("li").position().top - 50);
		})
		
	});
	
}
function hideContent(obj){
	$(obj).parents(".reviewContent").slideUp(50, function(){
		$(obj).parents(".reviewContent").remove();
	})
}
</script>
</body>
</html>