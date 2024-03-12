<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(5));
	request.setAttribute("Depth_4", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("주변관광"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
var mapJson;
$(function(){
	$.ajax({
		url:"/brand/introduce/getTourContent.json",
        type:"POST",
        dataType:"text", 
        success:function(data) {
        	mapJson = $.parseJSON(data);  // json 파싱
        	//$("#mapArea .mapListArea ul li:first-child a").trigger("click");
        }
    });
	$("#mapArea .mapListArea ul li a")
	.on("mouseenter", function(){
		var idx = $(this).parent().index();
		$("#mapArea .mapPointer .section").eq(idx).addClass("on");
	})
	.on("mouseleave", function(){
		var idx = $(this).parent().index();
		$("#mapArea .mapPointer .section").eq(idx).removeClass("on");
	})
	.on("click", function(e){
		var idx = $(this).parent().index();
		$("#mapArea .mapPointer .section.active").removeClass("active");
		$("#mapArea .mapPointer .section").eq(idx).addClass("active");
		$("#mapArea .mapListArea ul li.on").removeClass("on");
		$(this).parent().addClass("on");
		setMapContent(idx);
		e.preventDefault();
	});
	
	$("#mapArea .mapPointer .section")
	.on("mouseenter", function(){
		var idx = $(this).index();
		$("#mapArea .mapListArea ul li:eq("+ idx +")").addClass("on");
		$("#mapArea .mapListArea ul li:eq("+ idx +") a").trigger("mouseenter");
	})
	.on("mouseleave", function(){
		var idx = $(this).index();
		$("#mapArea .mapListArea ul li:eq("+ idx +")").removeClass("on"); 
		$("#mapArea .mapListArea ul li:eq("+ idx +") a").trigger("mouseleave");
	})
	.on("click", function(e){
		var idx = $(this).index();
		$("#mapArea .mapListArea ul li:eq("+ idx +") a").trigger("click");
		e.preventDefault();
	});
	
});

function setMapContent(num){
	var $section = mapJson.mapContents.section[num]; 
	var $copy= $section.copy;
	var $acticle = $section.acticle;
	
	$("#mapCont").html("<h3>"+ $copy +"</h3>");
	var offset = $("#mapCont").offset();
	for(var j = 0; j < $acticle.length; j++ ) {
		var $tit = $acticle[j].title; 
		var $desc = $acticle[j].desc; 
		var temp = '<div id="section'+ j +'" class="section"><div class="txtArea">'
							+'<strong>'+ $tit +'</strong>'
							+'<p>'+ $desc +'</p>'
						+'</div>'
						+'<div class="imgArea">'
							+'<div class="slideCont">'
							+'<ul>'
							+'</ul>'
							+'</div>'
						+'</div></div>';
		$("#mapCont").append(temp);
		if($acticle[j].link){
			var linkTemp = '<a href="'+ $acticle[j].link.href +'" target="'+ $acticle[j].link.target +'" class="btn">'+ $acticle[j].link.txt +'</a>'
			$("#section"+ j +" .txtArea").append(linkTemp);
		}
		if($acticle[j].imgs){
			var $url = $acticle[j].imgs.url;
			var imgList = "";
			for(var i = 0; i < $url.length; i++){
				imgList = imgList + '<li><img src="' + $url[i] + '" alt=""></li>'; 		
			}
			$("#section"+ j +" .imgArea ul").html(imgList);
		} else {
			$("#section"+ j +" .imgArea").hide();
		}
	}
	$("body, html").stop().animate({
		scrollTop : offset.top
	});
}
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="tourWrap">
			<h2>
				<span>상하농원 주변 고창 주요 관광지</span>
				상하농원을 백 배 즐기는 법
			</h2>
			<div id="mapArea">
				<div class="mapListArea">
					<div class="tit">
						<strong>주변관광</strong>
					</div>
					<ul class="list">
						<li><a href="#"><span>01</span>학원농장</a></li>
						<li><a href="#"><span>02</span>골프장</a></li>
						<li><a href="#"><span>03</span>장호 어촌 체험마을</a></li>
						<li><a href="#"><span>04</span>문수사</a></li>
						<li><a href="#"><span>05</span>고인돌</a></li>
						<li><a href="#"><span>06</span>구시포/동호</a></li>
						<li><a href="#"><span>07</span>선운산</a></li>
						<li><a href="#"><span>08</span>고창읍성</a></li>
					</ul>
				</div>
				<div class="mapPointer">
					<div class="section section1">01<span>학원농장</span></div>
					<div class="section section2">02<span>골프장</span></div>
					<div class="section section3 line2">03<span>장호 어촌<br>체험마을</span></div>
					<div class="section section4">04<span>문수사</span></div>
					<div class="section section5">05<span>고인돌</span></div>
					<div class="section section6 line2">06<span>구시포<br>/동호</span></div>
					<div class="section section7">07<span>선운산</span></div>
					<div class="section section8">08<span>고창읍성</span></div>
				</div><!-- //mapPointer -->
			</div><!-- //mapArea -->
			<div id="mapCont">
			</div><!-- //mapCont -->
		</div><!-- //tourWrap -->
	
	
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					