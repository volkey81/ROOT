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
	request.setAttribute("Depth_3", new Integer(5));
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
					<img src="/images/hotel/enjoy/healthcare01.jpg" alt="">
				</div>
				<div class="weddingSlide">
					<img src="/images/hotel/enjoy/healthcare02.jpg" alt="">
				</div>
				<div class="weddingSlide">
					<img src="/images/hotel/enjoy/healthcare03.jpg" alt="">
				</div>
			</div>
			<div class="slideAreaNav">
				<div class="thum"><img src="/images/hotel/enjoy/healthcare01.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/enjoy/healthcare02.jpg" alt=""></div>
				<div class="thum"><img src="/images/hotel/enjoy/healthcare03.jpg" alt=""></div>
			</div>
			
			<div class="topTxt">
				<span class="sTxt">Fitness Zone</br>피트니스존</span>
				<p class="contTit">상하의 건강한 식단과 더불어 누리는 운동 밸런스</p>
			</div>
		</div>
		<!-- //diningSlide -->
		
		<div class="experienceCont">
			<h3 style="padding-bottom: 24px; font-size: 26px; color: #080808;">
			신체측정(Inbody), 근력운동(근력기구), 맨손운동(GX room)을 통해</br>
			일상의 지친 몸과 마음에 건강한 영양&운동 밸런스를 선사합니다.
			</h3>
			<div style="padding-bottom: 24px; font-size: 26px; color: #080808;"> * 운영일자 : 2020년 9월 11일(금) ~</br>* 운영시간 : 06시~23시</div>

<!--
			<h2> * 가격정보</h2>

			<table>
				<col width="20%">
				<col width="40%">
				<col width="40%">
				<thead>
					<tr>
						<th scope="col">구분</th>
						<th scope="col">대인(14세이상)</th>
						<th scope="col">소인(36개월~13세)</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td  class="week">가격</td>
						<td  class="last">22,000원</td>
						<td  class="last">12,000원</td>
					</tr>
				</tbody>
			</table><br><br>

			<h2> * 우대정보</h2>
			<table>
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col width="25%">

				<thead>
					<tr>
						<th scope="col"></th>
						<th scope="col">단체(20인 이상)</th>
						<th scope="col">파머스빌리지 투숙객</th>
						<th scope="col">고창군민</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>주중</td>
						<td>30% 할인</td>
						<td rowspan="2" class="last">25% 할인</td>
						<td rowspan="2" class="last">25% 할인</td>
					<tr>
						<td class="last">주말</td>
						<td class="last"></td>
					</tr>

				</tbody>
			</table><br><br>
-->

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
							- 음주 후 운동을 삼가하여 주시기 바랍니다.</br>
							- 음식물 반입을 삼가하여 주시기 바랍니다.</br>
							- 다른 이용자와 함께 이용하는 운동공간이므로, 타 이용자에게 불쾌감을 유발하는 행동을 자제해 주시기 바랍니다.</br>
							- 사전 예약제로 운영되며, 사전 예약을 하지 않은 방문객은 입장이 제한될 수 있으므로, 안내 데스크에 문의해 주시기 바랍니다.</br>
							- 운동기구를 본래의 용법에 따라 본인의 운동능력을 고려하여 사용하고, 이상 증상을 인지한 경우 즉시 이용을 중단하시기 바랍니다.</br>
							- 피트니스존은 충분한 운동능력을 보유한 건강한 성인을 대상으로 운영하는 공간입니다. 따라서 건강에 이상이 있거나 만 19세 미만의 미성년자, 노약자의 입장 및 시설이용은 금지되며, 금지사항 위반 시 발생하는 사고 등에 대하여는 이용자 본인 및 보호자에게 책임이 있습니다.</br>
							- 이용자의 부주의로 인하여 피트니스존 이용 과정 중 발생한 일체의 사고에 대한 책임은 본인에게 있으므로, 피트니스존 및 운동기구 사용법을 반드시 숙지하여 이용해 주시기 바랍니다.</br>
							- 운동 중 불편사항 또는 피트니스존 이용 관련 궁금한 사항은 안내 데스크에 문의해 주시기 바랍니다.</br>
						</th>
					</tr>
				</thead>
				<!--
				<tbody>
					<tr>
						<td style="text-align: left;">
								1) 수영복, 래시가드, 웨이크복 등 물놀이 복장<br>
								2) 구명조끼 및 튜브(어린이용 보행튜브 및 지름 80cm 이하의 일반 튜브<br>
								3) 수영모, 물안경
						</td>
						<td style="text-align: left;">
								1) 청/면 반바지 등 일상복<br>
								2) 안경, 귀걸이, 목걸이, 팔찌 등 악세서리 류(락커 보관 후 이용)<br>
								3) 샌들, 슬리퍼 등 일반 신발류<br>
								4) 짙은 화장, 썬텐 크림, 썬텐 오일
						</td>
					<tr>
						<td class="last" colspan="2">
							<ul>
								<li>만 5세(60개월)이상 어린이는 공중위생관리법에 따라 혼욕할 수 없습니다.</li>
								<li>수영장 내 외부 음식 및 돗자리 반입이 불가합니다.</li>
								<li>코로나 19로 인해 타올은 유료 대여 및 판매만 가능합니다.</li>
							</ul>					
						</td>
					</tr>
						

				</tbody>
				-->
			</table>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
