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
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("객실"));
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script src="/js/jquery.event.scroll.js"></script>
<script>
$(function() {
	//슬라이드 갯수	
	var D_slide = ["#groupA .slideArea","#groupB .slideArea"];
	var D_slideNav = [".nav01",".nav02",".nav03",".nav04"];

	$(".slideWrap").each(function(i){
		var tNum = $(this).find(".slideArea>.roomSlide").size();
		$(this).find(".slideNum .allNum").html("0"+tNum);
		
		$(D_slide[i]).slick({
			slidesToShow: 1,
			slidesToScroll: 1,
			dots: false,
			fade: true,
			pauseOnHover:false,
			arrows: true,
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
	
	//예약하기,문의하기버튼
	(function ($){
		var
			  ns		= (new Date).getTime()
			, special	= $.event.special
			, dispatch	= $.event.handle || $.event.dispatch

			, scroll		= 'scroll'
			, scrollStart	= scroll + 'start'
			, scrollEnd		= scroll + 'end'
			, nsScrollStart	= scroll +'.'+ scrollStart + ns
			, nsScrollEnd	= scroll +'.'+ scrollEnd + ns
		;

		special.scrollstart = {
			setup: function (){
				var pid, handler = function (evt/**$.Event*/){
					if( pid == null ){
						evt.type = scrollStart;
						dispatch.apply(this, arguments);
					}
					else {
						clearTimeout(pid);
					}
					pid = setTimeout(function(){
						pid = null;
					}, special.scrollend.delay);
				};
				$(this).bind(nsScrollStart, handler);
			},
			teardown: function (){
				$(this).unbind(nsScrollStart);
			}
		};

		special.scrollend = {
			delay: 300,
			setup: function (){
				var pid, handler = function (evt/**$.Event*/){
					var _this = this, args = arguments;

					clearTimeout(pid);
					pid = setTimeout(function(){
						evt.type = scrollEnd;
						dispatch.apply(_this, args);
					}, special.scrollend.delay);
				};
				$(this).bind(nsScrollEnd, handler);
			},
			teardown: function (){
				$(this).unbind(nsScrollEnd);
			}
		};

		$.isScrolled = false;
		$(window).bind(scrollStart+' '+scrollEnd, function (evt/**Event*/){
			$.isScrolled = (evt.type == scrollStart);
			$('body')[$.isScrolled ? 'addClass' : 'removeClass']('is-scrolled');
		});
	})(jQuery);
	
	//퀵
	$(window).scroll(function(){
		var groupATop = $("#groupA").offset().top - 500;
		var groupBTop = $("#groupB").offset().top -100;
		var value = $(this).scrollTop() ;

		if (value >= groupATop && value < groupBTop){
			$(".groupAQuick").addClass("on");
			$(".groupBQuick").removeClass("on");
		}else if (value >= groupBTop){
			$(".groupBQuick").addClass("on");
			$(".groupAQuick").removeClass("on");
		}
		
		if(value >= $("#groupA").offset().top) {
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
				<li class="groupAQuick on"><a href="#groupA">단체룸 A</a></li>
				<li class="groupBQuick"><a href="#groupB">단체룸 B</a></li>
			</ul>
			<div class="btnArea">
				<a href="/customer/hotelCounsel.jsp" class="btnStyle02">문의하기</a>
			</div>
		</div>
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
