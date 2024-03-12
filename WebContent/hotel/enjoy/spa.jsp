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
	request.setAttribute("Depth_3", new Integer(6));
	request.setAttribute("MENU_TITLE", new String("즐길거리"));

	PopupService popup = (new PopupService()).toProxyInstance();
	List<Param> popupList = popup.getList(new Param("device", "P", "position", "B"));
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
					<img src="/images/hotel/enjoy/spaSlide01.jpg" alt="">
				</div>
				<div class="weddingSlide">
					<img src="/images/hotel/enjoy/spaSlide02.jpg" alt="">
				</div>
				<div class="weddingSlide">
					<img src="/images/hotel/enjoy/spaSlide03.jpg" alt="">
				</div>
				<div class="weddingSlide">
					<img src="/images/hotel/enjoy/spaSlide04.jpg" alt="">
				</div>
			</div>
			<div class="slideAreaNav">
				<div class="thum"><img src="/images/hotel/enjoy/spaSlide01.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/enjoy/spaSlide02.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/enjoy/spaSlide03.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/enjoy/spaSlide04.jpg" alt=""></div>
			</div>
			
			<div class="topTxt">
				<span class="sTxt">Spa</br>스파</span>
				<p class="contTit">자연과 하나되어 즐기는 숲 속에서의 재충전</p>
			</div>
		</div>
		<!-- //diningSlide -->
		
		<div class="experienceCont">
			<h3 style="padding-bottom: 24px; font-size: 26px; color: #080808;">
			농원에서 기른 허브 향 가득한 숲 속 노천탕에서</br>
			자연과 함께하는 휴식과 재충전의 시간을 즐겨보세요.
			</h3><br>
			<li  style="padding-bottom: 24px; font-size: 26px; color: #080808;"> * 운영일자 : 연중무휴<br><span style="padding-left:18px">청결한 스파 관리를 위해 욕장을 순환하여 청소합니다. 이에 일부 욕장이 운영되지 않을 수 있습니다.</span><br>
																				 * 운영시간 : 06시 ~ 21시 (호텔 프론트에서 발권 후 10분 내 입장)</li>
			</br></br>

			<h2> * 가격정보</h2>
			
			<table>
				<col width="20%">
				<col width="20%">
				<col width="">
				<col width="">
				<thead>
					<tr>
						<th colspan="2" scope="col">구분</th>
						<th scope="col">대인(14세이상)</th>
						<th scope="col">소인(36개월~13세)</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th colspan="2" class="tit">스파 이용권</th>
						<td>12,000원</td>
						<td>8,000원</td>
					</tr>
					<tr>
						<th class="tit last" rowspan="2"><img src="/images/hotel/enjoy/ico_best.png" alt="" class="vm">&nbsp;&nbsp;&nbsp;전용 바우처</th>
						<th class="tit">10매</th>
						<td colspan="2">20% 할인</td>
					</tr>
					<tr>
						<th class="tit">20매</th>
						<td colspan="2">30% 할인</td>
					</tr>
				</tbody>
			</table><br>
			<h3>* 전용 바우처 유의사항</h3>
			<ul class="caution typeB">
				<li>- 사용기간 : 구입일로부터 1년</li>
				<li>- 판매처 : 파머스빌리지 프론트(구매문의 063-563-6611)</li>
			</ul></br></br><br>

			<!-- <h2> * 우대정보</h2>
			<table>
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col width="25%">

				<thead>
					<tr>
						<th scope="col">구분</th>
						<th scope="col">상하농원유료이용고객</th>
						<th scope="col">파머스빌리지 투숙객</th>
						<th scope="col">고창군민</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="last">상시</td>
						<td class="last">10% 할인</td>
						<td class="last">50% 할인</td>
						<td class="last">25% 할인</td>
					</tr>


				</tbody>
			</table>
				<ul style="text-align: left; width:100%">
				* 모든 우대사항은 증빙서류가 없는 경우 적용이 불가합니다.</br>
				* 위 할인혜택은 2020년 12월 31일까지 적용되며, 이후 혜택이 변경 될 수 있습니다.
				</ul>				
			
			<br><br>

			<h2> * 전용바우처</h2>
			<table>
				<col width="100%">
				<thead>
					<tr>
						<th scope="col" style="text-align: left;">
						 - 사용기간 : 구입일로부터 1년</br>
						 - 포함사항 : 파머스빌리지 스파 이용권 20매 / 50매 (매수 별 할인율 상이)</br>
						 - 판매처 : 파머스빌리지 프론트(구매문의 063-563-6611)</br>
						</th>
					</tr>
				</thead>
			</table>
			</br></br> -->

			<h2> * 주의사항</h2>
<!--
				<div class="box">
					<p> - 음주 후 운동을 삼가하여 주시길 바랍니다.</p>
					<p> - 음식물 반입을 삼가하여 주시길 바랍니다.</br></p>
					<p> - 소음 등 타인에게 불쾌감을 주는 행동을 삼가하여 주시길 바랍니다.</br></p>
					<p> - 고객 안전을 위하여 만 16세 이하의 고객은 입장이 제한됨을 양지하여 주시기 바랍니다.</br></p>
					<p> - 고객 과실로 인한 사고는 상하농원에서 책임을 지지 않음을 양지하여 주시기 바랍니다.</br></p>
					<p> - 운동 중 불편,문의사항은 안내데스크로 문의하여 주시기 바랍니다.</br></p>
				</div>
-->	

			<table>
				<col width="100%">
				<thead>
					<tr>
						<th scope="col" style="text-align: left;">
						- 13세 이하의 어린이는 보호자 동반 하에 시설 이용이 가능합니다.</br>
						- 만 3세(36개월) 미만 어린이에 한하여 증빙서류 확인 후 혼욕이 가능합니다.</br>
						- 샴푸, 바스 외 목욕용품이 비치 되어 있지 않으므로 개별 지참이 필요합니다.</br>
						- 임산부, 심혈관계 질환자, 기타 약물 복용자, 장애우는 전문의와 상담 후 이용 부탁 드립니다.</br>
						- 고객의 안전을 위해 기준 인원 초과 시 입장이 제한될 수 있습니다.</br>
						- 음주, 고성방가 등 타인에게 불쾌감을 주는 행동을 삼가 하여 주시길 바랍니다.
						</th>
					</tr>
				</thead>
			</table>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
