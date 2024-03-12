<%@page import="com.sanghafarm.service.board.FarmerMenuService"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
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
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(0));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("체험교실"));
	Param param = new Param(request);
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	// 주문/배송 현황
	BannerService banner = (new BannerService()).toProxyInstance();
	
	PopupService popup = (new PopupService()).toProxyInstance();
	List<Param> popupList = popup.getList(new Param("device", "M", "position", "B"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<link rel="stylesheet" href="/mobile/css/swiper.min.css?t=<%=System.currentTimeMillis()%>">
<script>
$(function(){
	$(".tourInfoCont").hide();
	$(".tourTab li:first").addClass("on").show();
	$(".tourInfoCont:first").show();
	$(".tourTab li").click(function() {		
		$(".tourTab li").removeClass("on");
		$(this).addClass("on");
		$(".tourInfoCont").hide();
	
		var activeTab = $(this).find("a").attr("href");
		$(activeTab).show();
		return false;
	});	
	
	$('.slideWrap .slideCont').slick({
        initialSlide:0,
        slidesToShow:2,
        slidesToScroll:1,
        autoplay: false,
        autoplaySpeed: 2000,
        arrows:true,
        adaptiveHeight: true,
        infinite: true,
        dots: false,
        adaptiveHeight: true
    });
});

var num = 1;
function etcPopClose(){
	$('.layerPop .closeBtn').remove();
	$('.layerPop').hide();
	$(window).off('mousewheel scroll');
	$('#layerPop'+num).off('click');
}
function etcPopOpen(num){
	$('#layerPop'+num).show();			
	$('#layerPop'+num).find('.popCont').prepend('<div class="closeBtn"></div>');
	$('#layerPop'+num).find('.popCont').css({top:($(window).height()-$('#layerPop'+num).find('.popCont').height())/2});
	
	$(window).on('mousewheel scroll', function(e) {
        e.preventDefault();
        e.stopPropagation();
        return false;
    });			
	$('#layerPop'+num).on('click', function(e) {
		if($(e.target).parents(".popCont").size() == 0) etcPopClose();
    });			
	$('#layerPop'+num).find('.closeBtn').on('click', function(){
		etcPopClose();
	});	
}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="tourInfoWrap"><!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="tourInfo">
			<div class="tourTop">
				<p>함께하면 더 즐거운 상하농원<br>단체 견학 안내
					<span>사시사철 농촌의 아름다운 풍경과<br>신선한 먹거리가 만들어지는 상하농원에서 <br>재미있는 체험이 기다리고 있어요</span>
				</p>
			</div>		
			<div class="slideWrap">
				<p class="tit"><img src="/mobile/images/brand/tour/slideTit.png" alt="단체 견학 추천코스"></p>
				<div class="slideCont">
					<div>
						<img src="/mobile/images/brand/tour/slide01.png" alt="10:30">
						<span class="txt">블루베리크럼블<br>케이크 체험</span>
					</div>
					<div>
						<img src="/mobile/images/brand/tour/slide02.png" alt="12:00">
						<span class="txt">농원식당/ 상하키친에서<br>맛있는 점심식사</span>
					</div>
					<div>
						<img src="/mobile/images/brand/tour/slide03.png" alt="12:40~1:30">
						<span class="txt">먹거리가 만들어지는<br>공방 견학 <span>(자유관람)</span></span>
					</div>
					<div>
						<img src="/mobile/images/brand/tour/slide04.png" alt="14:00">
						<span class="txt">매일유업<br>상하공장 견학</span>
					</div>
				</div>
				<div class="caption">※ 만들기 체험은 월별로  체험내용이 달라질 수 있습니다.<br>체험교실 시간표 꼭 확인해주세요.</div>
			</div>
			
			<div class="infoArea">
				<h2>이용안내</h2>
				<ul class="tourTab">
					<li><a href="#tourInfoCont01"><span>요금</span></a></li>
					<li><a href="#tourInfoCont02"><span>프로그램</span></a></li>
					<li><a href="#tourInfoCont03"><span>단체식사</span></a></li>
					<li><a href="#tourInfoCont04"><span>단체모임</span></a></li>
					<li><a href="#tourInfoCont05"><span>숙소</span></a></li>
				</ul>
				<div class="tourInfoCont" id="tourInfoCont01" style="display:none;">
					<table class="bbsList">
						<colgroup>
							<col width="45%">
							<col width="*">
						</colgroup>
						<thead>
							<tr>
								<th scope="col" colspan="2">단체</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="tit">입장권</td>	
								<td class="ticket">
									<div><span>소인</span> 4,500원</div>
									<div><span>대인</span> 7,200원</div>
								</td>	
							</tr>
							<tr>
								<td class="tit">체험권</td>	
								<td>
									<div><span>20인 이상(10% 할인)</span>15,000원 → 13,500원</div>
									<div><span>40인 이상(20% 할인)</span>15,000원 → 12,000원</div>
								</td>	
							</tr>
							<tr>
								<td class="tit">패키지권</td>	
								<td>
									<div><span>20인 이상(10% 할인)</span>18,000원 → 16,500원</div>
									<div><span>40인 이상(20% 할인)</span>18,000원 → 15,000원</div>
								</td>	
							</tr>
						</tbody>
					</table>
				</div>
				<div class="tourInfoCont" id="tourInfoCont02" style="display:none;">
					<div class="cont">
						<h3>체험프로그램 안내</h3>
						<dl>
							<dt>먹거리 만들기 체험</dt>
							<dd><strong>오감 먹거리 체험교실</strong> 자연의 먹거리를 그대로 보고,<br>만지는 오감 체험을 통해 바른 먹거리를 배우는 공간
								<a href="#layerPop1"  onclick="etcPopOpen(1);">프로그램 보기</a>
							</dd>
							<dt>동물먹이주기 체험</dt>
							<dd>미니돼지, 염소, 토끼, 산양, 면양, 젖소, 당나귀 등<br>* 멍멍이운동장, 젖소운동장은 기후에 따라 운영
								<a href="#layerPop2" onclick="etcPopOpen(2);">프로그램 보기</a>
							</dd>
						</dl>
					</div>
					<div class="cont">
						<h3>견학프로그램 안내</h3>
						<dl>
							<dt>상하공장</dt>
							<dd>유기농 우유와 자연 치즈는 어떻게 만들어질까요?<br>우유와 치즈가 만들어지는 과정을 직접 견학 해보세요!
								<a href="#layerPop3" onclick="etcPopOpen(3);">프로그램 보기</a>
							</dd>
							<dt>햄공방</dt>
							<dd>천연케이싱으로 육즙이 풍부한 소시지와 12시간 이상 염지하여 깊은 맛을 내는 베이컨으로 고기보다 더 맛있는 햄을 경험해보세요<br>
								<strong>· 운영시간</strong> : 연중무휴 09:30~18:00
							</dd>
							<dt>과일공방</dt>
							<dd>황동솥에서 끓여 과일의 향미가 가득한 수제 잼.<br>따스한 햇살과 바람으로 숙성한 수제 과일 청.<br>자연이 선사한 과일의 신선한 맛을 느껴보세요.<br>
								<strong>· 운영시간</strong> : 연중무휴 09:30~18:00
							</dd>
							<dt>빵공방</dt>
							<dd>유기농 우유로 만든 고소한 식빵. 부드러운 천연 치즈 케이크.<br>유정란으로 만든 깊은 맛의 카스텔라까지!<br>
								<strong>· 운영시간</strong> : 연중무휴 09:30~18:00
							</dd>
							<dt>발효공방</dt>
							<dd>우리 땅에서 기른 재료에 공방장이 돌보는 정성을 더했습니다.<br>시간이 주는 진한 전통 장 맛으로 요리를 바꿔보세요!<br>
								<strong>· 운영시간</strong> : 연중무휴 09:30~18:00
							</dd>
						</dl>
					</div>
				</div>
				
				<div class="tourInfoCont" id="tourInfoCont03" style="display:none;">
					<div class="cont">
						<dl>
							<dt>농원식당</dt>
							<dd>
								<div class="txtArea">
									<strong>메뉴</strong>
									<ul>
										<li>순백색 유정란 오므라이스</li>
										<li>간장 제육 덮밥 </li>
										<li>카레 덮밥</li>
									</ul>
									<strong>가격</strong>
									<ul>
										<li>예약 상담시 확정</li>
									</ul>
								</div>
							</dd>
							<dt>상하키친</dt>
							<dd class="second">
								<div class="txtArea">
									<strong>메뉴</strong>
									<ul>
										<li>순백색 유정란 오므라이스</li>
									</ul>
									<strong>가격</strong>
									<ul>
										<li>예약 상담시 확정</li>
									</ul>
								</div>
							</dd>
						</dl>
						<ul>
							<li>- 도시락을 준비해오시는 경우, 농원 야외에서 돗자리를 이용 해 드실 수 있습니다. (식당은 영업공간으로 이용이 어려우며, 단체 방문자 취식을 위한 별도 실내공간이 준비되어 있지 않습니다)</li>
							<li>- 위 메뉴 외 다른 메뉴를 이용하고 싶으신 경우 상담 또는 문의 시 알려 주시기 바랍니다.</li>
						</ul>
					</div>
				</div>

				<div class="tourInfoCont" id="tourInfoCont04" style="display:none;">
					<ul class="list">
						<li>
							<dl>
								<dt>농원 사무실 회의실</dt>
								<dd class="num">최대 50명</dd>
								<dd class="txt">프로젝터, 마이크, 화이트보드, wifi 이용 가능</dd>
							</dl>		
						</li>
						<li>
							<dl>
								<dt>파머스빌리지 강당</dt>
								<dd class="num">최대 150명</dd>
								<dd class="txt">연단, 프로젝터, 마이크, 화이트보드, wifi 이용 가능</dd>
							</dl>	
							<a href="/hotel/wedding/seminar.jsp">상세 보기</a>
						</li>
						<li>
							<dl>
								<dt>파머스테이블</dt>
								<dd class="num">최대 250명</dd>
								<dd class="txt">연단, 프로젝터, 마이크,화이트보드, wifi 이용 가능</dd>
							</dl>			
							<a href="/hotel/wedding/seminar.jsp">상세 보기</a>
						</li>
					</ul>
				</div>
		
				<div class="tourInfoCont" id="tourInfoCont05" style="display:block;">
					<ul class="list">
						<li>
							<dl>
								<dt>파머스빌리지 단체룸 A</dt>
								<dd class="num">기준정원 8명/ 최대 8명</dd>
								<dd class="txt">싱글베드X8 , 6인 책상, 복층구조 </dd>
							</dl>	
							<a href="/hotel/room/group.jsp">상세 보기</a>	
						</li>
						<li>
							<dl>
								<dt>파머스빌리지 단체룸 B</dt>
								<dd class="num">기준정원 24명/ 최대 24명</dd>
								<dd class="txt">싱글베드X24 (2층침대) , 좌식탁자, 복층구조</dd>
							</dl>	
							<a href="/hotel/room/group.jsp">상세 보기</a>
						</li>
					</ul>
				</div>
				<div class="btnArea">
					<a href="/mobile/brand/play/reservation/group.jsp " class="btnTypeA">단체 견학 예약</a>
					<a href="/mobile/customer/counsel.jsp " class="btnTypeC">단체 견학 문의</a>
				</div>
				<ul class="caption">
					<li>※ 단체혜택은 방문자 20인 이상인 경우 받으실 수 있습니다</li>
					<li>※ 단체 견학 문의 또는 견학 예약 후 유선 상담이 이루어지며,<br>전체 일정 및 금액이 확정됩니다.</li>
				</ul>
			</div>			
		</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
	<div class="layerPop" id="layerPop1">
		<div class="popCont">
			<!-- <img src="../../images/brand/introduce/guide/pop1_3.jpg" alt=""> -->
			<div class="popTxt">
				<h3>먹거리 만들기 체험</h3>
				<h4>먹거리 만들기 프로그램</h4>
				<div class="cont">
					<p class="tit">주중</p>
					<table class="popProgram">
						<colgroup>
							<col width="*">
							<col width="34%">
							<col width="34%">
						</colgroup>
						<thead>
							<tr>
								<th scope="col" class="time">시간</th>
								<th scope="col">체험교실 A동</th>
								<th scope="col">체험교실 B동</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>13:00</td>
								<td>크럼블 케이크</td>
								<td rowspan="3">소시지</td>
							</tr>
							<tr>
								<td>15:00</td>
								<td>동물쿠키</td>
							</tr>
							<tr>
								<td>16:30</td>
								<td>곡물 손난로</td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- <ul class="caption">
					<li>※ 상시 쿠키는 단체 예약에 따라 운영시간이 달라질 수 있습니다.</li>
				</ul> -->
				<div class="cont">
					<p class="tit">주말/공휴일</p>
					<table class="popProgram">
						<colgroup>
							<col width="*">
							<col width="34%">
							<col width="34%">
						</colgroup>
						<thead>
							<tr>
								<th scope="col" class="time">시간</th>
								<th scope="col">체험교실 A동</th>
								<th scope="col">체험교실 B동</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>10:30</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>13:00</td>
								<td>크럼블 케이크</td>
								<td rowspan="3">동물쿠키<br>(13:00~16:30, 상시)</td>
							</tr>
							<tr>
								<td>15:00</td>
								<td>소시지</td>
							</tr>
							<tr>
								<td>16:30</td>
								<td>손난로</td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- <div class="cont">
					<p class="tit">이벤트기간 21~25일, 28일~31일</p>
					<table class="popProgram">
						<colgroup>
							<col width="*">
							<col width="34%">
							<col width="34%">
						</colgroup>
						<thead>
							<tr>
								<th scope="col" class="time">시간</th>
								<th scope="col">체험교실 A동</th>
								<th scope="col">체험교실 B동</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>10:30</td>
								<td>쿠키</td>
								<td>소시지</td>
							</tr>
							<tr>
								<td>13:00</td>
								<td>크리스마스 케이크(40명)</td>
								<td>소시지</td>
							</tr>
							<tr>
								<td>15:00</td>
								<td>크리스마스  케이크(40명)</td>
								<td>소시지</td>
							</tr>
							<tr>
								<td>16:30</td>
								<td>나무목도리</td>
								<td></td>
							</tr>
						</tbody>
					</table>
				</div> -->
				<ul class="caption">
					<li>※ 체험교실은 예약제로 운영되며, 체험 진행 상황에 따라 일정이 변경될 수 있습니다.</li>
					<li>※ 평일 동물쿠키 상시체험은 예약에 따라 현장에서 접수/운영합니다.</li>
					<li>※ 공휴일의 경우 주말 시간표로 운영합니다.</li>
				</ul>
			</div>
		</div>
	</div>
	<div class="layerPop"  id="layerPop2">
		<div class="popCont">
			<img src="/mobile/images/brand/introduce/guide/pop2.jpg" alt="">
		</div>
	</div>
	<div class="layerPop"  id="layerPop3">
		<div class="popCont">
			<img src="/mobile/images/brand/introduce/guide/pop3.jpg" alt="">
		</div>
	</div>
</div><!-- //wrapper -->

</body>
</html>
