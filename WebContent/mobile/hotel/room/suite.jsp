<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.board.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("파머스빌리지"));
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
	<div id="container" class="room styleA btnFix">
	<!-- 내용영역 -->
		<h2 class="animated fadeInUp delay02">파머스빌리지</h2>
		<!-- roomTop -->
		<ul class="tabArea animated fadeInUp delay04 tblType">
			<li id="roomTypeA"><a href="#terraceCont">테라스 룸</a></li>
			<li id="roomTypeB"><a href="#ondolCont">온돌 룸</a></li>
			<li id="roomTypeC"><a href="#familyCont">패밀리 룸</a></li>
			<li id="roomTypeD"><a href="#suiteCont">스위트 룸</a></li>
			<li id="roomTypeE"><a href="#groupACont">단체룸 A</a></li>
			<li id="roomTypeF"><a href="#groupBCont">단체룸 B</a></li>
		</ul>
		<!-- //roomTop -->
		<!-- terrace -->
		<div class="roomCont" id="terraceCont">
			<div class="topArea">
				<div class="topTxtArea">
					<p class="tit"><img src="/mobile/images/hotel/room/roomContTit01.png" alt="TERRACE ROOM">테라스 룸</p>
					<p class="txt">툇마루를 연상시키는 테라스에서<br>나만의 자연을 즐길 수 있는 객실</p>
					<p class="floorTxt">VILLAGE, 2F</p>
					<div class="suiteRoom" id="terrace">
						<!-- slideWrap -->
						<div class="slideWrap2">
							<div class="slideNum">
								<span class="nowNum">01</span>
								<span class="allNum"></span>
							</div>
							<div class="slideArea"> 
								<div class="slide">
									<img src="/mobile/images/hotel/room/terrace01.jpg" alt="테라스룸1">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/terrace02.jpg" alt="테라스룸2">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/terrace03.jpg" alt="테라스룸3">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/terrace04.jpg" alt="테라스룸4">
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
					<span class="terrace">테라스</span>
					<span class="extent">10평</span>
					<span class="nosmoking">금연</span>
					<span class="shower">샤워실</span>
				</div>
				<h3>기준정원/최대정원</h3>
				<div class="type02">
					<span class="number">2명 / 3명</span>
				</div>
				<h3>레이아웃 및 가구</h3>
				<div class="type03">
					<span class="bed">2X싱글베드</span>
					<span class="desk">책상</span>
					<span class="floor">대리석</span>
				</div>
				<h3>편의용품</h3>
				<div class="type03">
					<span class="service0101">LCD TV</span>
					<span class="service0102">무선 WI-FI</span>
					<span class="service0103">냉장고</span>
					<span class="service0104">개인금고</span>
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
					<span class="service0304">피트니스존</span>
				</div>
				<p class="txt">체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
				<jsp:include page="/mobile/hotel/room/roomInfo.jsp" />
			</div>
		</div>
		<!-- //terrace -->
		
		<!-- ondol -->
		<div class="roomCont" id="ondolCont">
			<div class="topArea">
				<div class="topTxtArea">
					<p class="tit"><img src="/mobile/images/hotel/room/roomContTit02.png" alt="ONDOL ROOM">온돌 룸</p>
					<p class="txt">테라스까지 펼쳐져 있는 넓은 평상에 누워<br>농부의 휴식을 진정 만끽할 수 있는 객실</p>
					<p class="floorTxt">VILLAGE, 2F</p>
					<div class="suiteRoom" id="ondol">
						<!-- slideWrap -->
						<div class="slideWrap2">
							<div class="slideNum">
								<span class="nowNum">01</span>
								<span class="allNum"></span>
							</div>
							<div class="slideArea"> 
								<div class="slide">
									<img src="/mobile/images/hotel/room/ondol01.jpg" alt="온돌 룸1">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/ondol02.jpg" alt="온돌 룸2">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/ondol03.jpg" alt="온돌 룸3">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/ondol04.jpg" alt="온돌 룸4">
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
					<span class="terrace">테라스</span>
					<span class="extent">10평</span>
					<span class="nosmoking">금연</span>
					<span class="shower">샤워실</span>
				</div>
				<h3>기준정원/최대정원</h3>
				<div class="type02">
					<span class="number">2명 / 3명</span>
				</div>
				<h3>레이아웃 및 가구</h3>
				<div class="type03">
					<span class="bed">2X한실이불세트</span>
					<span class="desk">좌식탁자</span>
					<span class="floor">대리석 +마루</span>
				</div>
				<h3>편의용품</h3>
				<div class="type03">
					<span class="service0101">LCD TV</span>
					<span class="service0102">무선 WI-FI</span>
					<span class="service0103">냉장고</span>
					<span class="service0104">개인금고</span>
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
					<span class="service0304">피트니스존</span>
				</div>
				<p class="txt">체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
				<jsp:include page="/mobile/hotel/room/roomInfo.jsp" />
			</div>
		</div>
		<!-- //ondol -->
		
		<!-- family -->
		<div class="roomCont" id="familyCont">
			<div class="topArea">
				<div class="topTxtArea">
					<p class="tit"><img src="/mobile/images/hotel/room/roomContTit03.png" alt="FAMILY ROOM">패밀리 룸</p>
					<p class="txt">복층 타입의 가족형 공간에서<br>작은 하늘 창으로 별을 바라보는 객실</p>
					<p class="floorTxt">VILLAGE, 3F</p>
					<div class="suiteRoom" id="family">
						<!-- slideWrap -->
						<div class="slideWrap2">
							<div class="slideNum">
								<span class="nowNum">01</span>
								<span class="allNum"></span>
							</div>
							<div class="slideArea"> 
								<div class="slide">
									<img src="/mobile/images/hotel/room/family01.jpg" alt="패밀리 룸 1">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/family02.jpg" alt="패밀리 룸 2">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/family03.jpg" alt="패밀리 룸 3">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/family04.jpg" alt="패밀리 룸 4">
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
					<span class="terrace">복층형</span>
					<span class="extent">15평</span>
					<span class="nosmoking">금연</span>
					<span class="shower">샤워실</span>
				</div>
				<h3>기준정원/최대정원</h3>
				<div class="type02">
					<span class="number">3명 / 4명</span>
				</div>
				<h3>레이아웃 및 가구</h3>
				<div class="type03">
					<span class="bed">1X더블베드, 2X한실이불세트</span>
					<span class="desk">책상</span>
					<span class="floor">대리석+마루</span>
				</div>
				<h3>편의용품</h3>
				<div class="type03">
					<span class="service0101">LCD TV</span>
					<span class="service0102">무선 WI-FI</span>
					<span class="service0103">냉장고</span>
					<span class="service0104">개인금고</span>
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
					<span class="service0304">피트니스존</span>
				</div>
				<p class="txt">체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
				<jsp:include page="/mobile/hotel/room/roomInfo.jsp" />
			</div>
		</div>
		<!-- //family -->
		
		<!-- suite -->
		<div class="roomCont" id="suiteCont">
			<div class="topArea">
				<div class="topTxtArea">
					<p class="tit"><img src="/mobile/images/hotel/room/roomContTit04.png" alt="SUITE ROOM">스위트 룸</p>
					<p class="txt">농부가 정성껏 지은<br>신부를 위한 특별한 객실</p>
					<p class="floorTxt">VILLAGE, 2F</p>
					<div class="suiteRoom" id="suite">
						<!-- slideWrap -->
						<div class="slideWrap2">
							<div class="slideNum">
								<span class="nowNum">01</span>
								<span class="allNum"></span>
							</div>
							<div class="slideArea"> 
								<div class="slide">
									<img src="/mobile/images/hotel/room/suite01.jpg" alt="스위트 룸 1">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/suite02.jpg" alt="스위트 룸 2">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/suite03.jpg" alt="스위트 룸 3">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/suite04.jpg" alt="스위트 룸 4">
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
					<span class="terrace">테라스</span>
					<span class="extent">20평</span>
					<span class="nosmoking">금연</span>
					<span class="shower">샤워실</span>
				</div>
				<h3>기준정원/최대정원</h3>
				<div class="type02">
					<span class="number">4명 / 5명</span>
				</div>
				<h3>레이아웃 및 가구</h3>
				<div class="type03">
					<span class="bed">2X퀸베드<br>1X싱글베드</span>
					<span class="desk">책상</span>
					<span class="floor">대리석</span>
				</div>
				<h3>편의용품</h3>
				<div class="type03">
					<span class="service0101">LCD TV</span>
					<span class="service0102">무선 WI-FI</span>
					<span class="service0103">냉장고</span>
					<span class="service0104">개인금고</span>
					<span class="service0105">전기포트</span>
					<span class="service0107">프리미엄침구</span>
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
					<span class="service0304">피트니스존</span>
				</div>
				<p class="txt">체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
				<jsp:include page="/mobile/hotel/room/roomInfo.jsp" />
			</div>
		</div>
		<!-- //suite -->
		
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
					<span class="service0304">피트니스존</span>
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
					<span class="service0304">피트니스존</span>
				</div>
				<p class="txt">체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
				<jsp:include page="/mobile/hotel/room/roomInfo.jsp" />
			</div>
		</div>
		<!-- //groupBCont -->
		<div class="btnArea">
			<a href="/mobile/hotel/room/reservation/date.jsp" class="btnStyle05">예약하기</a><a href="/mobile/customer/hotelCounsel.jsp" class="btnStyle04">문의하기</a>
		</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>