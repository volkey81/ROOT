<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.board.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("단체룸"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	String	 roomType	=	request.getParameter("roomType");
	if(roomType == null){
		roomType = "A";
	}
	
	Param param = new Param(request);

	PopupService popup = new PopupService();
	List<Param> popupList = popup.getList(new Param("device", "M", "position", "C"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp"/> 
</head>  
<body>
<script>
$(function(){	
	//텝
	//$(".roomCont").hide();
	//$(".tabArea li:first").addClass("on").show();
	//$(".roomCont:first").show();
	$(".tabArea li a").click(function() {
		if(!$(this).parent().hasClass("on")){
			if($(".tabArea li.on").size() > 0){
				var beforeTab = $(".tabArea li.on a").attr("href"); 
				var beforeSlide =  $(beforeTab).find(".slideArea");
				$(".tabArea li").removeClass("on");	
				//beforeSlide.unslick();
				beforeSlide.slick('unslick');
				$(beforeTab).find('.slideNum .nowNum').html("01");
			}
			$(this).parent().addClass("on");	
			$(".roomCont").hide();
			
			var activeTab = $(this).attr("href");
			$(activeTab).show();
			
			$('html, body').animate({scrollTop : 0}, 400);
			
			var D_slide =  $(activeTab).find(".slideArea");
			
			var tNum = $(activeTab).find(".slideArea .slide").size();
			$(activeTab).find(".slideNum .allNum").html("0"+tNum); 
			
			D_slide.slick({
				slidesToShow: 1,
				slidesToScroll: 1,
				dots: false,
				fade: true,
				arrows: true,
				autoplay: false     
			});
			
			$(activeTab).find(".slideArea")
			.on('afterChange', function(event, slick, currentSlide){
				$(this).parent().find('.slideNum .nowNum').html("0"+ (currentSlide + 1));
			});
		}
	
		return false;
		
	});

	$("#roomType<%= roomType%> a").trigger("click");
	
	//상단 텝 fix
	$(window).scroll(function(){
		var value = $(this).scrollTop();

		if (value >= 49){
			$(".tabArea").addClass("on");
		}else{
			$(".tabArea").removeClass("on");
		}
	});
});
</script>
<div id="wrapper" >
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="room styleA groupRoom">
	<!-- 내용영역 -->
		<h2 class="animated fadeInUp delay02">단체룸</h2>
		<!-- roomTop -->
		<ul class="tabArea animated fadeInUp delay04 tblType">
			<li id="roomTypeA"><a href="#groupACont">단체룸 A</a></li>
			<li id="roomTypeB"><a href="#groupBCont">단체룸 B</a></li>
		</ul>
		<!-- //roomTop -->
		<!-- groupACont -->
		<div class="roomCont" id="groupACont">
			<div class="topArea">
				<div class="topTxtArea">
					<p class="tit"><img src="/mobile/images/hotel/room/roomContTit05.png" alt="GROUP ROOM A">단체 룸 A</p>
					<p class="txt">최대 8인까지 숙박할 수 있는<br>소규모 가족 / 친구 모임 등에 적합한 단체실</p>
					<p class="floorTxt">VILLAGE, 3F</p>
					<div class="suiteRoom" id="groupA">
						<!-- slideWrap -->
						<div class="slideWrap2">
							<div class="slideNum">
								<span class="nowNum">01</span>
								<span class="allNum"></span>
							</div>
							<div class="slideArea"> 
								<div class="slide">
									<img src="/mobile/images/hotel/room/groupA01.jpg" alt="단체룸A1">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/groupA02.jpg" alt="단체룸A2">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/groupA03.jpg" alt="단체룸A3">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/groupA04.jpg" alt="단체룸A4">
								</div>
							</div>
						</div>
						<!-- //slideWrap -->
					</div>
				</div>
			</div>
			<div  class="roomInfo">
				<h3>객실 구성</h3>
				<div class="type01">
					<span class="extent">20평</span>
					<span class="nosmoking">금연</span>
					<span class="shower">샤워실</span>
				</div>
				<h3>기준정원/최대정원</h3>
				<div class="type02">
					<span class="number">8명 / 8명</span>
				</div>
				<h3>레이아웃 및 가구</h3>
				<div class="type03">
					<span class="bed">8X싱글베드</span>
					<span class="desk">6인책상</span>
					<span class="floor">대리석+복층마루</span>
				</div>
				<h3>편의용품</h3>
				<div class="type03">
					<span class="service0101">LCD TV</span>
					<span class="service0102">무선 WI-FI</span>
					<span class="service0103">8X개인락카</span>
					<!-- <span class="service0104">개인금고</span> -->
					<span class="service0105">전기포트</span>
				</div>
				<p class="txt">객실 냉난방은 중앙시스템으로 운영됩니다.</p>
				<h3>욕실용품</h3>
				<div class="type03">
					<span class="service0201">헤어드라이기</span>
					<span class="service0202">타월</span>
					<span class="service0203">샴푸(린스겸용)</span>
					<span class="service0204">바디워스</span>
					<span class="service0205">페이스워시</span>
				</div>
				<p class="txt">상하농원 친환경 캠페인 일환으로 일회용품 및 어메니티는 제공되지 않습니다. 필요 시 벤딩머신에서 구매가능합니다.</p>
				<h3>포함서비스</h3>
				<div class="type03">
					<span class="service0301">상하농원 무료입장권</span>
					<span class="service0302">조식 무료</span>
					<span class="service0303">무료생수(1박 2병)</span>
				</div>
				<p class="txt">체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
				<jsp:include page="/mobile/hotel/room/roomInfo.jsp" />
			</div>
		</div>
		<!-- //groupACont -->
		
		<!-- groupBCont -->
		<div class="roomCont" id="groupBCont">
			<div class="topArea">
				<div class="topTxtArea">
					<p class="tit"><img src="/mobile/images/hotel/room/roomContTit06.png" alt="GROUP ROOM B">단체 룸 B</p>
					<p class="txt">최대 24인까지 숙박할 수 있는<br>체험 학습 / 캠프 행사 등에 적합한 단체실</p>
					<p class="floorTxt">VILLAGE, 3F</p>
					<div class="suiteRoom" id="groupB">
						<!-- slideWrap -->
						<div class="slideWrap2">
							<div class="slideNum">
								<span class="nowNum">01</span>
								<span class="allNum"></span>
							</div>
							<div class="slideArea"> 
								<div class="slide">
									<img src="/mobile/images/hotel/room/groupB01.jpg" alt="단체룸B1">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/groupB02.jpg" alt="단체룸B2">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/groupB03.jpg" alt="단체룸B3">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/groupB04.jpg" alt="단체룸B4">
								</div>
							</div>
						</div>
						<!-- //slideWrap -->
					</div>
				</div>
			</div>
			<div  class="roomInfo">
				<h3>객실 구성</h3>
				<div class="type01">
					<span class="extent">40평</span>
					<span class="nosmoking">금연</span>
					<span class="shower">샤워실</span>
				</div>
				<h3>기준정원/최대정원</h3>
				<div class="type02">
					<span class="number">24명 / 24명</span>
				</div>
				<h3>레이아웃 및 가구</h3>
				<div class="type03">
					<span class="bed">24X싱글베드(2층침대)</span>
					<span class="desk">좌식탁자</span>
					<span class="floor">대리석 +복층마루</span>
				</div>
				<h3>편의용품</h3>
				<div class="type03">
					<span class="service0101">LCD TV</span>
					<span class="service0102">무선 WI-FI</span>
					<span class="service0103">24X개인락카</span>
					<!-- <span class="service0104">개인금고</span> -->
					<span class="service0105">전기포트</span>
				</div>
				<p class="txt">객실 냉난방은 중앙시스템으로 운영됩니다.</p>
				<h3>욕실용품</h3>
				<div class="type03">
					<span class="service0201">헤어드라이기</span>
					<span class="service0202">타월</span>
					<span class="service0203">샴푸(린스겸용)</span>
					<span class="service0204">바디워스</span>
					<span class="service0205">페이스워시</span>
				</div>
				<p class="txt">상하농원 친환경 캠페인 일환으로 일회용품 및 어메니티는 제공되지 않습니다. 필요 시 벤딩머신에서 구매가능합니다.</p>
				<h3>포함서비스</h3>
				<div class="type03">
					<span class="service0301">상하농원 무료입장권</span>
					<span class="service0302">조식 무료</span>
					<span class="service0303">무료생수(1박 2병)</span>
				</div>
				<p class="txt">체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
				<jsp:include page="/mobile/hotel/room/roomInfo.jsp" />
			</div>
		</div>
		<!-- //groupBCont -->
		<div class="btnArea inquiryBtn">
			<!-- <a href="" class="btnStyle05">예약하기</a> -->
			<a href="/mobile/customer/hotelCounsel.jsp" class="btnStyle05">문의하기</a>
		</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>