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
	request.setAttribute("MENU_TITLE", new String("파머스글램핑"));
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script src="/js/jquery.event.scroll.js"></script>
<script>
$(function() {
	//슬라이드 갯수	
	var D_slide = ["#glampingA .slideArea","#glampingB .slideArea"];
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
		var terraceTop = $("#glampingA").offset().top - 500;
		var ondolTop = $("#glampingB").offset().top - 100;
		var value = $(this).scrollTop() ;
		var allLi = $("#suiteWQuick li");

		if (value >= glampingATop && value < glampingBTop){
			$(allLi).removeClass("on");
			$(".glampingAQuick").addClass("on");
		}else if (value >= suiteTop ){
			$(allLi).removeClass("on");
			$(".glampingBQuick").addClass("on");		
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
		<div class="suiteWrap glampingWrap">
			<!-- terrace -->
			<div class="suiteRoom" id="glampingA">
				<div class="slideWrap">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum"></span>
					</div>
					<div class="slideArea">
						<div class="roomSlide">
							<img src="/images/hotel/room/glampingA_1.jpg?t=<%=System.currentTimeMillis()%>" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/glampingA_2.jpg?t=<%=System.currentTimeMillis()%>" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/glampingA_3.jpg?t=<%=System.currentTimeMillis()%>" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/glampingA_4.jpg?t=<%=System.currentTimeMillis()%>" alt="">
						</div>
					</div>
					<div class="slideAreaNav nav01">
						<div class="thum"><img src="/images/hotel/room/glampingA_1.jpg?t=<%=System.currentTimeMillis()%>" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/glampingA_2.jpg?t=<%=System.currentTimeMillis()%>" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/glampingA_3.jpg?t=<%=System.currentTimeMillis()%>" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/glampingA_4.jpg?t=<%=System.currentTimeMillis()%>" alt=""></div>
					</div>
				</div>
				

				<div class="suiteRoomInfo">
					<div class="roomTxt">
						<h2 class="contTit"><img src="/images/hotel/room/tit_glampingA.png" alt="GLAMPING A">
							글램핑 A <em>(반려견 입실불가)</em>
							<span>더블침대 2개가 붙어있는 <br>최대 4인까지 숙박가능한 농부의 쉼터 </span>
						</h2>
					</div>
					<div class="roomInfo">
						<ul class="top">
							<li><strong>객실구성</strong>
								<div>
									<span class="extent double">12평<br>(데크포함)</span>
									<span class="nosmoking">금연</span>
								</div>
							</li>
							<li class="big bigStyle01"><strong>기준정원/최대정원</strong>
								<div>
									<span class="number number3-4">3명 / 4명</span>
								</div>
							</li>
							<li class="big bigStyle02"><strong>레이아웃 및 가구</strong>
								<div>
									<span class="bed">2X더블베드</span>
									<span class="desk">테이블/의자</span>
									<span class="floor">덱의자</span>
									<span class="desk">야외테이블</span>
								</div>
							</li>
						</ul>
						<ul class="bottom">
							<li><strong>편의용품</strong>
								<span class="service0">냉장고</span>
								<span class="service0">냉난방기</span>
								<span class="service0">공기청정기</span>
								<span class="service0">인덕션(렌탈요청)</span>
								<span class="service0">BBQ그릴신청(2인 20,000원) <br><em>그릴 또는 숯추가 5,000원</em></span>
								<span class="service0">불멍세트(1동 25,000원)<br><em>대형화로대&장작, 오로라가루</em></span>
							</li>
							<li><strong>공용용품</strong>
								<span class="service0">공용샤워장(50M)</span>
								<span class="service0">공용화장실(20M)</span>
								<span class="service0">개수대(샘터)</span>
							</li>
							<li><strong>포함서비스</strong>
								<span class="service0301">상하농원 무료입장권</span>
								<span class="service0302">조식 무료</span>
								<span class="service0303">무료생수(1일 2병)</span>
								<span class="service0304">피트니스존</span>
								<p>* 체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
							</li>
							<li class="last"><strong>숙소정책</strong>
								<span>체크인 : 오후3시 / 체크아웃: 오전 11시</span>		
								<span>밤 22시 이후 매너타임이 적용되며 위반 시 1차 경고 후 강제퇴실 조치됩니다.(환불불가)</span>
								<span>최대 인원을 초과하여 투숙할 수 없으며, 투숙인원은 연령과 상관없이 1인으로 산정합니다.</span>
								<span>요금은 기준정원 기준이며, 초과인원은 최대정원 내에서 대인(만 14세 이상) 3만8천원, 소인(36개월~만 13세) 2만7천원 추가됩니다.</span>
								<span>2박 이상 투숙 시 객실청소는 요청 고객에 한하여 제공됩니다.</span>
								<span>코로나19 확산 방지를 위하여 식기용품은 제공되지 않습니다.</span>
								<span>개인 세면도구는 제공되지 않습니다.</span>
								<span>본 시설은 부모의 과실/부주의로 인해 발생하는 모든 안전사고 또는 분쟁에 대한 책임이 없습니다.</span>
								<span>본 시설물 또는 제품 등 파손 시 그에 해당하는 금액을 변상 해야 합니다.</span>
								<span>본 시설은 애완동물(반려견) 동반할 수 없습니다.</span>
								<span>본 시설 내에서 절대금연이며 화기 사용을 엄격히 금합니다.</span>
							</li>
						</ul>
						<a href="#" class="btnMoreInfo"><span>더보기</span></a>
					</div>		
				</div>
			</div>
			<!-- //terrace -->
			
			<!-- ondol -->
			<div class="suiteRoom" id="glampingB">
				<div class="slideWrap">
					<div class="slideNum">
						<span class="nowNum">01</span>
						<span class="allNum"></span>
					</div>
					<div class="slideArea">
						<div class="roomSlide">
							<img src="/images/hotel/room/glampingB_1.jpg?t=<%=System.currentTimeMillis()%>" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/glampingB_2.jpg?t=<%=System.currentTimeMillis()%>" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/glampingB_3.jpg?t=<%=System.currentTimeMillis()%>" alt="">
						</div>
						<div class="roomSlide">
							<img src="/images/hotel/room/glampingB_4.jpg?t=<%=System.currentTimeMillis()%>" alt="">
						</div>
					</div>
					<div class="slideAreaNav nav02">
						<div class="thum"><img src="/images/hotel/room/glampingB_1.jpg?t=<%=System.currentTimeMillis()%>" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/glampingB_2.jpg?t=<%=System.currentTimeMillis()%>" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/glampingB_3.jpg?t=<%=System.currentTimeMillis()%>" alt=""></div>
						<div class="thum"><img src="/images/hotel/room/glampingB_4.jpg?t=<%=System.currentTimeMillis()%>" alt=""></div>
					</div>
				</div>

				<div class="suiteRoomInfo">
					<div class="roomTxt">
						<h2 class="contTit"><img src="/images/hotel/room/tit_glampingB.png" alt="GLAMPING B">
							<p class="pr">글램핑 B <em>(반려견 입실가능)<br><span>※추가금액발생</span></em></p>
							<span>소중한 반려견과 편안하게<br>머무를 수 있는 온전한 쉼터</span>
						</h2>
					</div>
					<div class="roomInfo">
						<ul class="top">
							<li><strong>객실구성</strong>
								<div>
									<span class="extent double">12평<br>(데크포함)</span>
									<span class="nosmoking">금연</span>
								</div>
							</li>
							<li class="big bigStyle01"><strong>기준정원/최대정원</strong>
								<div>
									<span class="number number3-4">3명 / 4명</span>
								</div>
							</li>
							<li class="big bigStyle02"><strong>레이아웃 및 가구</strong>
								<div>
									<span class="bed">2X더블베드</span>
									<span class="desk">테이블/의자</span>
									<span class="floor">덱의자</span>
									<span class="desk">야외테이블</span>
								</div>
							</li>
						</ul>
						<ul class="bottom">
							<li><strong>편의용품</strong>
								<span class="service0">냉장고</span>
								<span class="service0">냉난방기</span>
								<span class="service0">공기청정기</span>
								<span class="service0">인덕션(렌탈요청)</span>
								<span class="service0">BBQ그릴신청(2인 20,000원) <br><em>그릴 또는 숯추가 5,000원</em></span>
								<span class="service0">불멍세트(1동 25,000원)<br><em>대형화로대&장작, 오로라가루</em></span>
								<span class="service0">반려견 전용 : 애견 원목침대(중), 원목식기</span>
							</li>
							<li><strong>공용용품</strong>
								<span class="service0">공용샤워장(50M)</span>
								<span class="service0">공용화장실(20M)</span>
								<span class="service0">개수대(샘터)</span>
							</li>
							<li><strong>포함서비스</strong>
								<span class="service0301">상하농원 무료입장권</span>
								<span class="service0302">조식 무료</span>
								<span class="service0303">무료생수(1일 2병)</span>
								<span class="service0304">피트니스존</span>
								<p>* 반려견 전용 : 탈취제(비치품목), 배변시트(중) 2장, 배변봉투, LED펜던트, 웰컴키트 1개</p>
								<p>* 체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</p>
							</li>
							<li class="last"><strong>숙소정책</strong>
								<span>체크인 : 오후3시 / 체크아웃: 오전 11시</span>	
								<span>반려견은 1실당 10kg 미만 소형견 1마리만 가능 하며 중성화수술 및 접종증명서 필수 (5대 및 1년내 광견변예방 접종)</span>	
								<span>밤 22시 이후 매너타임이 적용되며 위반 시 1차 경고 후 강제퇴실 조치됩니다.(환불불가)</span>
								<span>최대 인원을 초과하여 투숙할 수 없으며, 투숙인원은 연령과 상관없이 1인으로 산정합니다.</span>
								<span>요금은 기준정원 기준이며, 초과인원은 최대정원 내에서 대인(만 14세 이상) 3만8천원, 소인(36개월~만 13세) 2만7천원 추가됩니다.</span>
								<span>2박 이상 투숙 시 객실청소는 요청 고객에 한하여 제공됩니다.</span>
								<span>코로나19 확산 방지를 위하여 식기용품은 제공되지 않습니다.</span>
								<span>개인 세면도구는 제공되지 않습니다.</span>
								<span>본 시설은 부모의 과실/부주의로 인해 발생하는 모든 안전사고 또는 분쟁에 대한 책임이 없습니다.</span>
								<span>본 시설물 또는 제품 등 파손 시 그에 해당하는 금액을 변상 해야 합니다.</span>
								<span>본 시설은 반려견 유의사항을 준수할 경우 반려견 입실이 가능 합니다.</span>
								<span>본 시설 내에서 절대금연이며 화기 사용을 엄격히 금합니다.</span>
							</li> 
						</ul>
						<a href="#" class="btnMoreInfo"><span>더보기</span></a>
					</div>		
				</div>
			</div>
			<!-- //ondol -->
			
			
		</div>
		<!-- //내용영역 -->
		<div id="suiteWQuick">
			<ul>
				<li class="glampingAQuick on"><a href="#glampingA">글램핑 A</a></li>
				<li class="glampingBQuick"><a href="#glampingB">글램핑 B</a></li>
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
