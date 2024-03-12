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
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("즐길거리"));
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
$(function() {
	//슬라이드 갯수	
	var allLength = $(".slideArea .weddingSlide").length;
	$('.slideNum .allNum').html("0"+allLength);
	$('.weddingSlideWrap .slideArea').on('afterChange', function(event, slick, currentSlide){   
		$('.slideNum .nowNum').html("0"+ (currentSlide + 1));
	});
	
	//terrace room
	$('.weddingSlideWrap .slideArea').slick({
		slidesToShow: 1,
		slidesToScroll: 1,
		autoplay: true,
		dots: false,
		fade: false,
		arrows: true,
		pauseOnHover:false,
		asNavFor: '.slideAreaNav',
		cssEase : 'cubic-bezier(0.74, 0.01, 0.21, 0.99)'
	});
	$('.slideAreaNav').slick({
		slidesToShow: 1,
		slidesToScroll: 1,
		asNavFor: '.weddingSlideWrap .slideArea',
		dots: false,
		centerMode: false,
		focusOnSelect: false,
		cssEase : 'cubic-bezier(0.74, 0.01, 0.21, 0.99)'
	});
});	
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel hotelSlide enjoy">
		<!-- 내용영역 -->		
		<jsp:include page="/hotel/enjoy/enjoyTab.jsp" />
		<!-- diningSlide -->
		<div class="weddingSlideWrap animated fadeInUp delay04">
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea">
				<div class="weddingSlide">
					<img src="/images/hotel/enjoy/experiencSlide01.jpg" alt="">
				</div>
				<div class="weddingSlide">
					<img src="/images/hotel/enjoy/experiencSlide02.jpg" alt="">
				</div>
			</div>
			<div class="slideAreaNav">
				<div class="thum"><img src="/images/hotel/enjoy/experiencSlide01.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/enjoy/experiencSlide02.jpg" alt=""></div>
			</div>
			
			<div class="topTxt">
				<span class="sTxt">SANGHA FARM COOKING CLASS</span>
				<p class="contTit">
					자연과 함께하는 상하농원의<br>체험 교실을 경험해보세요
				</p>
			</div>
		</div>
		<!-- //diningSlide -->
		
		<div class="experienceCont">
			<h2>체험 시간표(유료)</h2>
			<table>
				<col width="15%">
				<col width="15%">
				<col width="15%">
				<col width="15%">
				<col width="*">
				<thead>
					<tr>
						<th scope="col" colspan="2">구분</th>
						<th scope="col">체험교실(A동)</th>
						<th scope="col">체험교실(B동)</th>
						<th scope="col">&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="week" rowspan="4">평일</td>
						<td>1교시(11:00~)</td>
						<td>소시지</td>
						<td>-</td>
						<td rowspan="8" class="last">
							<ul>
								<li>체험교실은 예약제로 운영되며, 체험 진행 상황에 따라 일정이<br>변경될 수 있습니다.</li>
								<li>평일 동물쿠키 상시체험은 예약에 따라 현장에서 접수/운영합니다.</li>
								<li>공휴일의 경우 주말 시간표로 운영합니다.</li>
								<li>단체 체험이용은 1522-3698로 문의 바랍니다. </li>
							</ul>
						</td>
					</tr>
					<tr>
						<td>2교시(13:30~)</td>
						<td>밀크빵</td>
						<td>-</td>
					</tr>
					<tr>
						<td>3교시(14:30~)</td>
						<td>쿠키</td>
						<td>-</td>
					</tr>
					<tr>
						<td class="last">4교시(16:00~)</td>
						<td class="last">유기농아이스크림</td>
						<td class="last">소시지</td>
					</tr>
					<tr>
						<td class="week" rowspan="4">주말</td>
						<td>1교시(11:00~)</td>
						<td>소시지</td>
						<td>밀크빵</td>
					</tr>
					<tr>
						<td>2교시(13:30~)</td>
						<td>유기농아이스크림</td>
						<td>블루베리 머핀</td>
					</tr>
					<tr>
						<td>3교시(14:30~)</td>
						<td>쿠키</td>
						<td>-</td>
					</tr>
					<tr>
						<td class="last">4교시(16:00~)</td>
						<td class="last">유기농아이스크림</td>
						<td class="last">소시지</td>
					</tr>
					<!-- <tr>
						<td class="week" rowspan="4">이벤트 기간<br>21~25일,<br>28일~31일</td>
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
						<td>크리스마스 케이크(40명)</td>
						<td>소시지</td>
					</tr>
					<tr>
						<td class="last">16:30</td>
						<td class="last">나무목도리</td>
						<td class="last"></td>
					</tr> -->
				</tbody>
			</table>
			<div class="btnArea">
				<a href="/brand/play/reservation/admission.jsp" class="btnStyle01">예약하기</a>
				<a href="/brand/play/experience/list.jsp" class="btnStyle02">자세히 보기</a>
			</div>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
