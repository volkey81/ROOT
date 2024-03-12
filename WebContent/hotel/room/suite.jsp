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
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("파머스빌리지"));
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script src="/js/jquery.event.scroll.js"></script>
<script>
$(function() {
	//슬라이드 갯수	
	var D_slide = ["#terrace .slideArea","#ondol .slideArea","#family .slideArea","#suite .slideArea","#groupA .slideArea","#groupB .slideArea"];
	var D_slideNav = [".nav01",".nav02",".nav03",".nav04"];

	$(".slideWrap").each(function(i){
		var tNum = $(this).find(".slideArea>.roomSlide").size();
		$(this).find(".slideNum .allNum").html("0"+tNum);
		
		$(D_slide[i]).slick({
			slidesToShow: 1,
			slidesToScroll: 1,
			dots: false,
			fade: true,
			arrows: true,
			pauseOnHover:false,
			autoplay: true,
			autoplaySpeed: 3000,
			asNavFor: D_slideNav[i]
		});
		
		$(D_slideNav[i]).slick({
			slidesToShow: 4,
			slidesToScroll: 1,
			asNavFor: D_slide[i],
			dots: false,
			arrows: false,
			autoplay: false,
			centerMode: false,
			focusOnSelect: true
		});
		
		$(D_slide[i])
		.on('afterChange', function(event, slick, currentSlide){
			$(this).parent().find('.slideNum .nowNum').html("0"+ (currentSlide + 1));
		});
	});
	
	//퀵
	$(window).scroll(function(){
		var terraceTop = $("#terrace").offset().top - 500;
		var ondolTop = $("#ondol").offset().top - 100;
		var familyTop = $("#family").offset().top - 100;
		var suiteTop = $("#suite").offset().top - 100;
		var groupATop = $("#groupA").offset().top - 100;
		var groupBTop = $("#groupB").offset().top -100;
		var value = $(this).scrollTop() ;
		var allLi = $("#suiteWQuick li");

		if (value >= terraceTop && value < ondolTop){
			$(allLi).removeClass("on");
			$(".terraceQuick").addClass("on");
		}else if (value >= ondolTop && value < familyTop){
			$(allLi).removeClass("on");
			$(".ondolQuick").addClass("on");
		}else if (value >= familyTop && value < suiteTop){
			$(allLi).removeClass("on");
			$(".familyQuick").addClass("on");
		}else if (value >= suiteTop && value < groupATop){
			$(allLi).removeClass("on");
			$(".suiteQuick").addClass("on");		
		}else if (value >= groupATop && value < groupBTop){
			$(allLi).removeClass("on");
			$(".groupAQuick").addClass("on");
		}else if (value >= groupBTop){
			$(allLi).removeClass("on");
			$(".groupBQuick").addClass("on");
		}
		
		
		if(value >= $("#terrace").offset().top) {
			if(!$("#suiteWQuick").hasClass("up")){
				$("#suiteWQuick").addClass("up");
			}
		} else {
			$("#suiteWQuick").removeClass("up");
		}
		
	});
	
	$(".btnMoreInfo").on("click", function(e){
		if(!$(this).hasClass("on")){
			$(this).addClass("on");
			$(this).parent().find(".bottom").slideDown();
		} else {
			$(this).removeClass("on");
			$(this).parent().find(".bottom").slideUp();
		}
		e.preventDefault();
	});
});	

</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel room">
		<!-- 내용영역 -->		
		<jsp:include page="/hotel/room/roomTab.jsp" />
		<div class="suiteWrap">
			<!-- terrace -->
			<div class="suiteRoom" id="terrace">
				<div class="slideWrap">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum"></span>
					</div>
					<div class="slideArea">
						<div class="roomSlide">
							<img src="/images/hotel/room/terrace01.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/terrace02.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/terrace03.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/terrace04.jpg" alt="">
						</div>
					</div>
					<div class="slideAreaNav nav01">
						<div class="thum"><img src="/images/hotel/room/terrace01Nav.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/terrace02Nav.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/terrace03Nav.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/terrace04Nav.jpg" alt=""></div>
					</div>
				</div>
				

				<div class="suiteRoomInfo">
					<div class="roomTxt">
						<h2 class="contTit"><img src="/images/hotel/room/terraceTit.png" alt="TERRACE ROOM">
							테라스 룸
							<span>툇마루를 연상시키는 테라스에서 나만의 자연을 <br>즐길 수 있는 객실</span>
						</h2>
						<span class="sTxt">VILLAGE, 2F</span>
					</div>
					<div class="roomInfo">
						<ul class="top">
							<li><strong>객실구성</strong>
								<div>
									<span class="terrace">테라스</span>
									<span class="extent">10평</span>
									<span class="nosmoking">금연</span>
									<span class="shower">샤워실</span>
								</div>
							</li>
							<li class="big bigStyle01"><strong>기준정원/최대정원</strong>
								<div>
									<span class="number">2명 / 3명</span>
								</div>
							</li>
							<li class="big bigStyle02"><strong>레이아웃 및 가구</strong>
								<div>
									<span class="bed">2X싱글베드</span>
									<span class="desk">책상</span>
									<span class="floor">대리석</span>
								</div>
							</li>
						</ul>
						<ul class="bottom">
							<li><strong>편의용품</strong>
								<span class="service0101">LCD TV</span>
								<span class="service0102">무료 WI-FI</span>
								<span class="service0103">냉장고</span>
								<span class="service0104">개인금고</span>
								<span class="service0105">전기포트</span>
								<p>* 객실 냉난방은 중앙시스템으로 운영됩니다.</p>
							</li>
							<li><strong>욕실용품</strong>
								<span class="service0201">헤어드라이기</span>
								<span class="service0202">타월</span>
								<span class="service0203">샴푸(린스겸용)</span>
								<span class="service0204">바디워시</span>
								<span class="service0205">페이스워시</span>
								<p>* 상하농원 친환경 캠페인 일환으로 일회용품 및 어메니티는 제공되지 않습니다.<br>필요 시 벤딩머신에서 구매가능합니다.</p>
							</li>
							<li><strong>포함서비스</strong>
								<span class="service0301">상하농원 무료입장권</span>
								<span class="service0302">조식 무료</span>
								<span class="service0303">무료생수(1일 2병)</span>
								<span class="service0304">피트니스존</span>
								<p>* 체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
							</li>
							<jsp:include page="/hotel/room/policy.jsp" /> 
						</ul>
						<a href="#" class="btnMoreInfo"><span>더보기</span></a>
					</div>		
				</div>
			</div>
			<!-- //terrace -->
			
			<!-- ondol -->
			<div class="suiteRoom" id="ondol">
				<div class="slideWrap">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum"></span>
					</div>
					<div class="slideArea">
						<div class="roomSlide">
							<img src="/images/hotel/room/ondol01.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/ondol02.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/ondol03.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/ondol04.jpg" alt="">
						</div>
					</div>
					<div class="slideAreaNav nav02">
						<div class="thum"><img src="/images/hotel/room/ondol01Nav.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/ondol02Nav.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/ondol03Nav.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/ondol04Nav.jpg" alt=""></div>
					</div>
				</div>

				<div class="suiteRoomInfo">
					<div class="roomTxt">
						<h2 class="contTit"><img src="/images/hotel/room/ondolTit.png" alt="ONDOL ROOM">
							온돌 룸
							<span>테라스까지 펼쳐져 있는 넓은 평상에 누워<br>농부의 휴식을 진정 만끽할 수 있는 객실</span>
						</h2>
						<span class="sTxt">VILLAGE, 2F</span>
					</div>
					<div class="roomInfo">
						<ul class="top">
							<li><strong>객실구성</strong>
								<div>
									<span class="terrace">테라스</span>
									<span class="extent">10평</span>
									<span class="nosmoking">금연</span>
									<span class="shower">샤워실</span>
								</div>
							</li>
							<li class="big bigStyle01"><strong>기준정원/최대정원</strong>
								<div>
									<span class="number">2명 / 3명</span>
								</div>
							</li>
							<li class="big bigStyle02"><strong>레이아웃 및 가구</strong>
								<div>
									<span class="bed">2x한실이불세트</span>
									<span class="desk">좌식탁자</span>
									<span class="floor">대리석+마루</span>
								</div>
							</li>
						</ul>
						<ul class="bottom">
							<li><strong>편의용품</strong>
								<span class="service0101">LCD TV</span>
								<span class="service0102">무료 WI-FI</span>
								<span class="service0103">냉장고</span>
								<span class="service0104">개인금고</span>
								<span class="service0105">전기포트</span>
								<p>* 객실 냉난방은 중앙시스템으로 운영됩니다.</p>
							</li>
							<li><strong>욕실용품</strong>
								<span class="service0201">헤어드라이기</span>
								<span class="service0202">타월</span>
								<span class="service0203">샴푸(린스겸용)</span>
								<span class="service0204">바디워시</span>
								<span class="service0205">페이스워시</span>
								<p>* 상하농원 친환경 캠페인 일환으로 일회용품 및 어메니티는 제공되지 않습니다.<br>필요 시 벤딩머신에서 구매가능합니다.</p>
							</li>
							<li><strong>포함서비스</strong>
								<span class="service0301">상하농원 무료입장권</span>
								<span class="service0302">조식 무료</span>
								<span class="service0303">무료생수(1일 2병)</span>
								<span class="service0304">피트니스존</span>
								<p>* 체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
							</li>
							<jsp:include page="/hotel/room/policy.jsp" /> 
						</ul>
						<a href="#" class="btnMoreInfo"><span>더보기</span></a>
					</div>		
				</div>
			</div>
			<!-- //ondol -->
			
			<!-- family -->
			<div class="suiteRoom" id="family">
				<div class="slideWrap">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum"></span>
					</div>
					<div class="slideArea">
						<div class="roomSlide">
							<img src="/images/hotel/room/family01.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/family02.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/family03.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/family04.jpg" alt="">
						</div>
					</div>
					<div class="slideAreaNav nav03">
						<div class="thum"><img src="/images/hotel/room/family01Nav.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/family02Nav.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/family03Nav.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/family04Nav.jpg" alt=""></div>
					</div>
				</div>

				<div class="suiteRoomInfo">
					<div class="roomTxt">
						<h2 class="contTit"><img src="/images/hotel/room/familyTit.png" alt="FAMILY ROOM">
							패밀리 룸
							<span>복층 타입의 가족형 공간에서<br>작은 하늘 창으로 별을 바라보는 객실</span>
						</h2>
						<span class="sTxt">VILLAGE, 3F</span>
					</div>
					<div class="roomInfo">
						<ul class="top">
							<li><strong>객실구성</strong>
								<div>
									<span class="terrace">복층형</span>
									<span class="extent">15평</span>
									<span class="nosmoking">금연</span>
									<span class="shower">샤워실</span>
								</div>
							</li>
							<li class="big bigStyle01"><strong>기준정원/최대정원</strong>
								<div>
									<span class="number">3명 / 4명</span>
								</div>
							</li>
							<li class="big bigStyle02"><strong>레이아웃 및 가구</strong>
								<div>
									<span class="bed">1x더블베드, 2x한실이불세트</span>
									<span class="desk">책상</span>
									<span class="floor">대리석+마루</span>
								</div>
							</li>
						</ul>
						<ul class="bottom">
							<li><strong>편의용품</strong>
								<span class="service0101">LCD TV</span>
								<span class="service0102">무료 WI-FI</span>
								<span class="service0103">냉장고</span>
								<span class="service0104">개인금고</span>
								<span class="service0105">전기포트</span>
								<p>* 객실 냉난방은 중앙시스템으로 운영됩니다.</p>
							</li>
							<li><strong>욕실용품</strong>
								<span class="service0201">헤어드라이기</span>
								<span class="service0202">타월</span>
								<span class="service0203">샴푸(린스겸용)</span>
								<span class="service0204">바디워시</span>
								<span class="service0205">페이스워시</span>
								<p>* 상하농원 친환경 캠페인 일환으로 일회용품 및 어메니티는 제공되지 않습니다.<br>필요 시 벤딩머신에서 구매가능합니다.</p>
							</li>
							<li><strong>포함서비스</strong>
								<span class="service0301">상하농원 무료입장권</span>
								<span class="service0302">조식 무료</span>
								<span class="service0303">무료생수(1일 2병)</span>
								<span class="service0304">피트니스존</span>
								<p>* 체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
							</li>
							<jsp:include page="/hotel/room/policy.jsp" /> 
						</ul>
						<a href="#" class="btnMoreInfo"><span>더보기</span></a>
					</div>		
				</div>
			</div>
			<!-- //family -->
			
			<!-- suite -->
			<div class="suiteRoom" id="suite">
				<div class="slideWrap">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum"></span>
					</div>
					<div class="slideArea">
						<div class="roomSlide">
							<img src="/images/hotel/room/suite01.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/suite02.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/suite03.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/suite04.jpg" alt="">
						</div>
					</div>
					<div class="slideAreaNav nav04">
						<div class="thum"><img src="/images/hotel/room/suite01Nav.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/suite02Nav.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/suite03Nav.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/suite04Nav.jpg" alt=""></div>
					</div>
				</div>

				<div class="suiteRoomInfo">
					<div class="roomTxt">
						<h2 class="contTit"><img src="/images/hotel/room/suiteTit.png" alt="SUITE ROOM">
							스위트 룸
							<span>농부가 정성껏 지은<br>신부를 위한 특별한 객실</span>
						</h2>
						<span class="sTxt">VILLAGE, 2F</span>
					</div>
					<div class="roomInfo">
						<ul class="top">
							<li><strong>객실구성</strong>
								<div>
									<span class="terrace">테라스</span>
									<span class="extent">20평</span>
									<span class="nosmoking">금연</span>
									<span class="shower">샤워실</span>
								</div>
							</li>
							<li class="big bigStyle01"><strong>기준정원/최대정원</strong>
								<div>
									<span class="number number4-5">4명 / 5명</span>
								</div>
							</li>
							<li class="big bigStyle02"><strong>레이아웃 및 가구</strong>
								<div>
									<span class="bed">2X퀸베드<br>1X싱글베드</span>
									<span class="desk">책상</span>
									<span class="floor">대리석</span>
								</div>
							</li>
						</ul>
						<ul class="bottom">
							<li><strong>편의용품</strong>
								<span class="service0101">LCD TV</span>
								<span class="service0102">무료 WI-FI</span>
								<span class="service0103">냉장고</span>
								<span class="service0104">개인금고</span>
								<span class="service0105">전기포트</span>
								<span class="service0107">프리미엄침구</span>
								<p>* 객실 냉난방은 중앙시스템으로 운영됩니다.</p>
							</li>
							<li><strong>욕실용품</strong>
								<span class="service0201">헤어드라이기</span>
								<span class="service0202">타월</span>
								<span class="service0203">샴푸(린스겸용)</span>
								<span class="service0204">바디워시</span>
								<span class="service0205">페이스워시</span>
								<p>* 상하농원 친환경 캠페인 일환으로 일회용품 및 어메니티는 제공되지 않습니다. 필요 시 벤딩머신에서 구매가능합니다.</p>
							</li>
							<li><strong>포함서비스</strong>
								<span class="service0301">상하농원 무료입장권</span>
								<span class="service0302">조식 무료</span>
								<span class="service0303">무료생수(1일 2병)</span>
								<span class="service0304">피트니스존</span>
								<p>* 체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
							</li>
							<jsp:include page="/hotel/room/policy.jsp" /> 
						</ul>
						<a href="#" class="btnMoreInfo"><span>더보기</span></a>
					</div>		
				</div>
			</div>
			<!-- //suite -->
			
			<!-- groupA -->
			<div class="suiteRoom" id="groupA">
				<div class="slideWrap">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum"></span>
					</div>
					<div class="slideArea">
						<div class="roomSlide">
							<img src="/images/hotel/room/groupA01.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/groupA02.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/groupA03.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/groupA04.jpg" alt="">
						</div>
					</div>
				</div>
				<div class="slideAreaNav nav01">
					<div class="thum"><img src="/images/hotel/room/groupA01.jpg" alt=""></div>
					<div class="thum"><img src="/images/hotel/room/groupA02.jpg" alt=""></div>
					<div class="thum"><img src="/images/hotel/room/groupA03.jpg" alt=""></div>
					<div class="thum"><img src="/images/hotel/room/groupA04.jpg" alt=""></div>
				</div>
		
				<div class="suiteRoomInfo">
					<div class="roomTxt">
						<h2 class="contTit"><img src="/images/hotel/room/groupATit.png" alt="GROUP ROOM A">
							단체룸 A
							<span>최대 8인까지 숙박할 수 있는<br>소규모 가족 / 친구 모임 등에 적합한 단체실</span>
						</h2>
						<span class="sTxt">VILLAGE, 3F</span>
					</div>
					<div class="roomInfo">
						<ul class="top">
							<li><strong>객실구성</strong>
								<div>
									<span class="extent">20평</span><br>
									<span class="nosmoking">금연</span>
									<span class="shower">샤워실</span>
								</div>
							</li>
							<li class="big bigStyle01"><strong>기준정원/최대정원</strong>
								<div>
									<span class="number">8명 / 8명</span>
								</div>
							</li>
							<li class="big bigStyle02"><strong>레이아웃 및 가구</strong>
								<div>
									<span class="bed">8X싱글베드</span>
									<span class="desk">6인책상</span>
									<span class="floor">대리석+복층마루</span>
								</div>
							</li>
						</ul>
						<ul class="bottom">
							<li><strong>편의용품</strong>
								<span class="service0101">LCD TV</span>
								<span class="service0102">무료 WI-FI</span>
								<span class="service0106">8X개인락카</span>
								<span class="service0105">전기포트</span>
								<p>* 객실 냉난방은 중앙시스템으로 운영됩니다.</p>
							</li>
							<li><strong>욕실용품</strong>
								<span class="service0201">헤어드라이기</span>
								<span class="service0202">타월</span>
								<span class="service0203">샴푸(린스겸용)</span>
								<span class="service0204">바디워시</span>
								<span class="service0205">페이스워시</span>
								<p>* 상하농원 친환경 캠페인 일환으로 일회용품 및 어메니티는 제공되지 않습니다.<br>필요 시 벤딩머신에서 구매가능합니다.</p>
							</li>
							<li><strong>포함서비스</strong>
								<span class="service0301">상하농원 무료입장권</span>
								<span class="service0302">조식 무료</span>
								<span class="service0303">무료생수(1일 2병)</span>
								<span class="service0304">피트니스존</span>
								<p>* 체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
							</li>
							<jsp:include page="/hotel/room/policy.jsp" /> 
						</ul>
						<a href="#" class="btnMoreInfo"><span>더보기</span></a>
					</div>		
				</div>
			</div>
			<!-- //groupA -->
			
			<!-- groupB -->
			<div class="suiteRoom" id="groupB">
				<div class="slideWrap">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum"></span>
					</div>
					<div class="slideArea">
						<div class="roomSlide">
							<img src="/images/hotel/room/groupB01.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/groupB02.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/groupB03.jpg" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/groupB04.jpg" alt="">
						</div>
					</div>
					<div class="slideAreaNav nav02">
						<div class="thum"><img src="/images/hotel/room/groupB01.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/groupB02.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/groupB03.jpg" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/groupB04.jpg" alt=""></div>
					</div>
				</div>

				<div class="suiteRoomInfo">
					<div class="roomTxt">
						<h2 class="contTit"><img src="/images/hotel/room/groupBTit.png" alt="GROUP ROOM B">
							단체룸 B
							<span>최대 24인까지 숙박할 수 있는<br>체험학습 / 캠프 행사 등에 적합한 단체실</span>
						</h2>
						<span class="sTxt">VILLAGE, 3F</span>
					</div>
					<div class="roomInfo">
						<ul class="top">
							<li><strong>객실구성</strong>
								<div>
									<span class="extent">40평</span><br>
									<span class="nosmoking">금연</span>
									<span class="shower">샤워실</span>
								</div>
							</li>
							<li class="big bigStyle01"><strong>기준정원/최대정원</strong>
								<div>
									<span class="number">24명 / 24명</span>
								</div>
							</li>
							<li class="big bigStyle02"><strong>레이아웃 및 가구</strong>
								<div>
									<span class="bed">24x싱글베드(2층 침대)</span>
									<span class="desk">좌식탁자</span>
									<span class="floor">대리석+복층마루</span>
								</div>
							</li>
						</ul>
						<ul class="bottom">
							<li><strong>편의용품</strong>
								<span class="service0101">LCD TV</span>
								<span class="service0102">무료 WI-FI</span>
								<span class="service0106">24X개인락카</span>
								<span class="service0105">전기포트</span>
								<p>* 객실 냉난방은 중앙시스템으로 운영됩니다.</p>
							</li>
							<li><strong>욕실용품</strong>
								<span class="service0201">헤어드라이기</span>
								<span class="service0202">타월</span>
								<span class="service0203">샴푸(린스겸용)</span>
								<span class="service0204">바디워시</span>
								<span class="service0205">페이스워시</span>
								<p>* 상하농원 친환경 캠페인 일환으로 일회용품 및 어메니티는 제공되지 않습니다.<br>필요 시 벤딩머신에서 구매가능합니다.</p>
							</li>
							<li><strong>포함서비스</strong>
								<span class="service0301">상하농원 무료입장권</span>
								<span class="service0302">조식 무료</span>
								<span class="service0303">무료생수(1일 2병)</span>
								<span class="service0304">피트니스존</span>
								<p>* 체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
							</li>
							<jsp:include page="/hotel/room/policy.jsp" /> 
						</ul>
						<a href="#" class="btnMoreInfo"><span>더보기</span></a>
					</div>		
				</div>
			</div>
			<!-- //groupB -->
		</div>
		<!-- //내용영역 -->
		<div id="suiteWQuick">
			<ul>
				<li class="terraceQuick on"><a href="#terrace">테라스 룸</a></li>
				<li class="ondolQuick"><a href="#ondol">온돌 룸</a></li>
				<li class="familyQuick"><a href="#family">패밀리 룸</a></li>
				<li class="suiteQuick"><a href="#suite">스위트 룸</a></li>
				<li class="groupAQuick"><a href="#groupA">단체룸 A</a></li>
				<li class="groupBQuick"><a href="#groupB">단체룸 B</a></li>
			</ul>
			<div class="btnArea">
				<a href="/hotel/room/reservation/date.jsp" class="btnStyle01">예약하기</a>
				<a href="/customer/hotelCounsel.jsp" class="btnStyle02">문의하기</a>
			</div>
		</div>
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
