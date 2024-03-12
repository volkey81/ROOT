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
	request.setAttribute("MENU_TITLE", new String("파머스글램핑"));
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
		<h2 class="animated fadeInUp delay02">파머스글램핑</h2>
		<!-- roomTop -->
		<ul class="tabArea group animated fadeInUp delay04">
			<li id="roomTypeA"><a href="#glampingACont">글램핑 A</a></li>
			<li id="roomTypeB"><a href="#glampingBCont">글램핑 B</a></li>
		</ul>
		<!-- //roomTop -->
		<!-- glampingACont -->
		<div class="roomCont" id="glampingACont">
			<div class="topArea">
				<div class="topTxtArea">
					<p class="tit"><img src="/mobile/images/hotel/room/roomContTit07.png" alt="GLAMPING A">글램핑 A <em>(반려견 입실불가)</em></p>
					<p class="txt">더블침대 2개가 붙어있는 <br>최대 4인까지 숙박가능한 농부의 쉼터</p>
					<div class="suiteRoom" id="groupA">
						<!-- slideWrap -->
						<div class="slideWrap2">
							<div class="slideNum">
								<span class="nowNum">01</span>
								<span class="allNum"></span>
							</div>
							<div class="slideArea"> 
								<div class="slide">
									<img src="/mobile/images/hotel/room/glampingA_1.jpg?t=<%=System.currentTimeMillis()%>" alt="">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/glampingA_2.jpg?t=<%=System.currentTimeMillis()%>" alt="">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/glampingA_3.jpg?t=<%=System.currentTimeMillis()%>" alt="">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/glampingA_4.jpg?t=<%=System.currentTimeMillis()%>" alt="">
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
					<span class="extent">12평 (데크포함)</span>
					<span class="nosmoking">금연</span>
				</div>
				<h3>기준정원/최대정원</h3>
				<div class="type02">
					<span class="number number3-4">3명 / 4명</span>
				</div>
				<h3>레이아웃 및 가구</h3>
				<div class="type03">
					<span class="bed">2X더블베드</span>
					<span class="desk">테이블/의자</span>
					<span class="floor">덱의자</span>
					<span class="desk">야외 테이블</span>
				</div>
				<h3>편의용품</h3>
				<div class="type03">
					<span class="service0">냉장고</span>
					<span class="service0">냉난방기</span>
					<span class="service0">공기청정기</span>
					<span class="service0">인덕션(렌탈요청)</span>
					<span class="service0">BBQ그릴신청(2인 20,000원) <em>그릴 또는 숯추가 5,000원</em></span>
					<span class="service0">불멍세트(1동 25,000원) <em>대형화로대&장작, 오로라가루</em></span>
				</div>
				<h3>공용용품</h3>
				<div class="type03">
					<span class="service0">공용샤워장(50M)</span>
					<span class="service0">공용화장실(20M)</span>
					<span class="service0">개수대(샘터)</span>
				</div>
				<h3>포함서비스</h3>
				<div class="type03">
					<span class="service0301">상하농원 무료입장권</span>
					<span class="service0302">조식 무료</span>
					<span class="service0303">무료생수(1일 2병)</span>
					<span class="service0304">피트니스존</span>
					<span class="service0">체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</span>
				</div>
				<h3>숙소정책</h3>
				<ul>
					<li>체크인 : 오후3시 / 체크아웃: 오전 11시</li>		
					<li>밤 22시 이후 매너타임이 적용되며 위반 시 1차 경고 후 강제퇴실 조치됩니다.(환불불가)</li>
					<li>최대 인원을 초과하여 투숙할 수 없으며, 투숙인원은 연령과 상관없이 1인으로 산정합니다.</li>
					<li>요금은 기준정원 기준이며, 초과인원은 최대정원 내에서 대인(만 14세 이상) 3만8천원, 소인(36개월~만 13세) 2만7천원 추가됩니다.</li>
					<li>2박 이상 투숙 시 객실청소는 요청 고객에 한하여 제공됩니다.</li>
					<li>코로나19 확산 방지를 위하여 식기용품은 제공되지 않습니다.</li>
					<li>개인 세면도구는 제공되지 않습니다.</li>
					<li>본 시설은 부모의 과실/부주의로 인해 발생하는 모든 안전사고 또는 분쟁에 대한 책임이 없습니다.</li>
					<li>본 시설물 또는 제품 등 파손 시 그에 해당하는 금액을 변상 해야 합니다.</li>
					<li>본 시설은 애완동물(반려견) 동반할 수 없습니다.</li>
					<li>본 시설 내에서 절대금연이며 화기 사용을 엄격히 금합니다.</li>
				</ul>
			</div>
		</div>
		<!-- //glampingACont -->
		
		<!-- glampingBCont -->
		<div class="roomCont" id="glampingBCont">
			<div class="topArea">
				<div class="topTxtArea">
					<div class="tit"><img src="/mobile/images/hotel/room/roomContTit08.png" alt="GLAMPING B"><p class="pr">글램핑 B <em>(반려견 입실가능)<br><span>※추가금액발생</span></em></p></div>
					<p class="txt">소중한 반려견과 편안하게<br>머무를 수 있는 온전한 쉼터</p>
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
									<img src="/mobile/images/hotel/room/glampingB_1.jpg?t=<%=System.currentTimeMillis()%>" alt="">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/glampingB_2.jpg?t=<%=System.currentTimeMillis()%>" alt="">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/glampingB_3.jpg?t=<%=System.currentTimeMillis()%>" alt="">
								</div>
								<div class="slide">
									<img src="/mobile/images/hotel/room/glampingB_4.jpg?t=<%=System.currentTimeMillis()%>" alt="">
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
					<span class="extent">12평 (데크포함)</span>
					<span class="nosmoking">금연</span>
				</div>
				<h3>기준정원/최대정원</h3>
				<div class="type02">
					<span class="number number3-4">3명 / 4명</span>
				</div>
				<h3>레이아웃 및 가구</h3>
				<div class="type03">
					<span class="bed">2X더블베드</span>
					<span class="desk">테이블/의자</span>
					<span class="floor">덱의자</span>
					<span class="desk">야외 테이블</span>
				</div>
				<h3>편의용품</h3>
				<div class="type03">
					<span class="service0">냉장고</span>
					<span class="service0">냉난방기</span>
					<span class="service0">공기청정기</span>
					<span class="service0">인덕션(렌탈요청)</span>
					<span class="service0">BBQ그릴신청(2인 20,000원) <em>그릴 또는 숯추가 5,000원</em></span>
					<span class="service0">불멍세트(1동 25,000원) <em>대형화로대&장작, 오로라가루</em></span>
					<span class="service0">반려견 전용 : 애견 원목침대(중), 원목식기</span>
				</div>
				<h3>공용용품</h3>
				<div class="type03">
					<span class="service0">공용샤워장(50M)</span>
					<span class="service0">공용화장실(20M)</span>
					<span class="service0">개수대(샘터)</span>
				</div>
				<h3>포함서비스</h3>
				<div class="type03">
					<span class="service0301">상하농원 무료입장권</span>
					<span class="service0302">조식 무료</span>
					<span class="service0303">무료생수(1일 2병)</span>
					<span class="service0304">피트니스존</span>
					<span class="service0">반려견 전용 : 탈취제(비치품목), 배변시트(중) 2장, 배변봉투, LED펜던트, 웰컴키트 1개</span>
					<span class="service0">체크인 시 확인된 투숙인원에 한하여 제공되는 서비스입니다.</span>
				</div>
				<h3>숙소정책</h3>
				<ul>
					<li>체크인 : 오후3시 / 체크아웃: 오전 11시</li>		
					<li>반려견은 1실당 10kg 미만 소형견 1마리만 가능 하며 중성화수술 및 접종증명서 필수 (5대 및 1년내 광견변예방 접종)</li>	
					<li>밤 22시 이후 매너타임이 적용되며 위반 시 1차 경고 후 강제퇴실 조치됩니다.(환불불가)</li>
					<li>최대 인원을 초과하여 투숙할 수 없으며, 투숙인원은 연령과 상관없이 1인으로 산정합니다.</li>
					<li>요금은 기준정원 기준이며, 초과인원은 최대정원 내에서 대인(만 14세 이상) 3만8천원, 소인(36개월~만 13세) 2만7천원 추가됩니다.</li>
					<li>2박 이상 투숙 시 객실청소는 요청 고객에 한하여 제공됩니다.</li>
					<li>코로나19 확산 방지를 위하여 식기용품은 제공되지 않습니다.</li>
					<li>개인 세면도구는 제공되지 않습니다.</li>
					<li>본 시설은 부모의 과실/부주의로 인해 발생하는 모든 안전사고 또는 분쟁에 대한 책임이 없습니다.</li>
					<li>본 시설물 또는 제품 등 파손 시 그에 해당하는 금액을 변상 해야 합니다.</li>
					<li>본 시설은 반려견 유의사항을 준수할 경우 반려견 입실이 가능 합니다.</li>
					<li>본 시설 내에서 절대금연이며 화기 사용을 엄격히 금합니다.</li>
				</ul>

			</div>
		</div>
		<!-- //glampingBCont -->
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