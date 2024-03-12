<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("Depth_4", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("시설소개"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
var mapJson;
$(function(){
	$.ajax({
		url:"/brand/introduce/getMapContent.json",
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
	})
	
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
	var $tit = $section.title; 
	var $desc = $section.desc; 
	var offset = $("#mapCont").offset();
	var temp = '<div class="txtArea">'
						+'<strong>'+ $tit +'</strong>'
						+'<p>'+ $desc +'</p>'
					+'</div>'
					+'<div class="imgArea">'
						+'<div class="slideCont">'
						+'<ul>'
						+'</ul>'
						+'</div>'
						//+'<a href="#" class="prev btnSlidePrev"><img src="/images/btn/btn_slide_prev.png" alt="이전"></a>'
						//+'<a href="#" class="next btnSlideNext"><img src="/images/btn/btn_slide_next.png" alt="다음"></a>'
					+'</div>';
	if($tit != "none"){
		$("#mapCont").html(temp);
		if($section.link){
			var linkTemp = '<a href="'+ $section.link.href +'" class="btn">'+ $section.link.txt +'</a>'
			$("#mapCont .txtArea").append(linkTemp);
		}
		
		
		if($section.imgs){
			var $url = $section.imgs.url;
			/* 
			if($url.length <= 2) {
				$("#mapCont .btnSlide").remove();
			} 
			*/
			var imgList = "";
			for(var i = 0; i < $url.length; i++){
				imgList = imgList + '<li><img src="' + $url[i] + '" alt=""></li>'; 		
			}
			$("#mapCont .imgArea ul").html(imgList);
		} else {
			$("#mapCont .imgArea").hide();
		}
		
		//efuSlider('.imgArea', 1, 150, '', 'once');	
		$("body, html").stop().animate({
			scrollTop : offset.top
		});
	} else {
		$("#mapCont").empty();
	}
	
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
		<div class="facilityWrap">
			<h2>
				<span>상하농원 안내지도</span>
				농원의 시설들을 미리 확인하세요
			</h2>
			<a href="/brand/structureInfo.pdf"  download class="btnTypeA sizeXL">건축물 소개 PDF다운로드</a>
			<div id="mapArea">
				<div class="mapListArea">
					<div class="tit">
						<strong>주변 시설</strong>
					</div>
					<ul class="list">
						<li><a href="#"><span>01</span>농원회관/매표소/파머스마켓</a></li>
						<li><a href="#"><span>02</span>과일공방</a></li>
						<li><a href="#"><span>03</span>빵공방</a></li>
						<li><a href="#"><span>04</span>발효공방</a></li>
						<li><a href="#"><span>05</span>농원상회</a></li>
						<li><a href="#"><span>06</span>파머스카페</a></li>
						<li><a href="#"><span>07</span>체험교실 A,B</a></li>
						<li><a href="#"><span>08</span>농원식당/유리온실</a></li>
						<li><a href="#"><span>09</span>햄공방</a></li>
						<li><a href="#"><span>10</span>상하키친</a></li>
						<li><a href="#"><span>11</span>농원사무소 </a></li>
						<li><a href="#"><span>12</span>동물농장</a></li>
						<li><a href="#"><span>13</span>육성목장</a></li>
						<li><a href="#"><span>14-1</span>파머스빌리지 호텔</a></li>
						<li><a href="#"><span>14-2</span>파머스테이블</a></li>
						<li><a href="#"><span>15</span>파머스빌리지 스파</a></li>
						<li><a href="#"><span>16</span>파머스빌리지 수영장</a></li>
						<li><a href="#"><span>17</span>파머스글램핑</a></li>
						<li><a href="#"><span>18</span>텃밭정원</a></li>
						<li><a href="#"><span>19</span>양떼목장</a></li>
						<li><a href="#"><span>20</span>강선달 저수지 수변데크</a></li>
						<li><a href="#"><span>21</span>상하베리굿팜</a></li>
						<li><a href="#"><span>22</span>고인돌</a></li>
					</ul>
				</div>
				<div class="mapPointer">
					<div class="section section1 line3">01<span>농원회관/<br>매표소/<br>파머스마켓</span></div>
					<div class="section section2">02<span>과일공방</span></div>
					<div class="section section3">03<span>빵공방</span></div>
					<div class="section section4">04<span>발효공방</span></div>
					<div class="section section5">05<span>농원상회</span></div>
					<div class="section section6">06<span>파머스카페</span></div>
					<div class="section section7 line2">07<span>체험교실<br>A,B	</span></div>
					<div class="section section8 line2">08<span>농원식당/<br>유리온실</span></div>
					<div class="section section9">09<span>햄공방</span></div>
					<div class="section section10">10<span>상하키친</span></div>
					<div class="section section11">11<span>농원사무소</span></div>
					<div class="section section12">12<span>동물농장</span></div>
					<div class="section section13">13<span>육성목장</span></div>
					<div class="section section14-1 line2">14-1<span>파머스빌리지<br>호텔</span></div>
					<div class="section section14-2">14-2<span>파머스테이블</span></div>
					<div class="section section15 line2">15<span>파머스빌리지<br>스파</span></div>
					<div class="section section16 line2">16<span>파머스빌리지<br>수영장</span></div>
					<div class="section section17">17<span>파머스글램핑</span></div>
					<div class="section section18">18<span>텃밭정원</span></div>
					<div class="section section19">19<span>양떼목장</span></div>
					<div class="section section20 line3">20<span>강선달<br>저수지<br>수변데크</span></div>
					<div class="section section21">21<span>상하베리굿팜</span></div>
					<div class="section section22">22<span>고인돌</span></div>

				</div><!-- //mapPointer -->
			</div><!-- //mapArea -->
			
			<div id="mapCont"> 
			</div><!-- //mapCont -->
		</div><!-- //facilityWrap -->
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					