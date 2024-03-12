<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(6));
	request.setAttribute("MENU_TITLE", new String("스파"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="styleA experience btnFix">
		<!-- 내용영역 -->
		<!-- slideWrap -->
		<div class="slideWrap animated fadeInUp delay02">
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea"> 
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/spaSlide01.jpg" alt="스파1">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/spaSlide02.jpg" alt="스파2">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/spaSlide03.jpg" alt="스파3">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/spaSlide04.jpg" alt="스파4">
				</div>
			</div>
		</div>
		<!-- //slideWrap -->
		
		<div class="hotelContTop animated fadeInUp delay04">
			<span class="sTxt">SANGHA FARMERS VILLAGE Spa</span>
			<h2>스파
				<span>농원에서 기른 허브 향 가득한<br> 숲 속 노천탕에서 자연과 함께하는
				<br>휴식과 재충전의 시간을 즐겨보세요.


				<br>
				</span>
			</h2><br>
			
				<span>
					운영일자 : 연중무휴<br>청결한 스파 관리를 위해 욕장을 순환하여 청소합니다. 이에 일부 욕장이 운영되지 않을 수 있습니다.<br>
					운영시간 : 06시 ~ 21시 <br> 
					(호텔 프론트에서 발권 후 10분 내 입장)
	
				</span>
		</div>
			
		<div class="hotelCont animated fadeInUp delay06">
			<h3>가격정보</h3>
			
			<table class="listStyleB">
				<col width="20%">
				<col width="20%">
				<col width="30%">
				<col width="30%">
				<thead>
					<tr>
						<th colspan="2" scope="col">구분</th>
						<th scope="col">대인<br>(14세이상)</th>
						<th scope="col">소인<br>(36개월~13세)</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th colspan="2" class="tit">스파 이용권</th>
						<td>12,000원</td>
						<td>8,000원</td>
					</tr>
					<tr>
						<th class="tit last pr" rowspan="2"><img src="/images/hotel/enjoy/ico_best.png" alt="" class="bestIcon">전용<br>바우처</th>
						<th class="tit">10매</th>
						<td colspan="2">20% 할인</td>
					</tr>
					<tr>
						<th class="tit">20매</th>
						<td colspan="2">30% 할인</td>
					</tr>
				</tbody>
			</table><br>
			
			<h4>* 전용 바우처 유의사항</h4>
			<ul class="caption">
				<li>사용기간 : 구입일로부터 1년</li>
				<li>판매처 : 파머스빌리지 프론트(구매문의 063-563-6611)</li>
			</ul>

			<!-- <h3>우대정보</h3>
			<table class="listStyleB">
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col width="25%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">구분</th>
						<th scope="col">상하농원<br>유료이용객</th>
						<th scope="col">파머스빌리지<br>투숙객</th>
						<th scope="col">고창군민</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="line">상시</td>
						<td class="line">10%할인</td>
						<td class="line">50%할인</td>
						<td class="line">25%할인</td>
					</tr>
					
					<tr>
						<td class="week line">주말</td>
						<td class="line"></td>
					</tr>
					
				</tbody>
			</table>
			<ul class="caption">
				<li> 모든 우대사항은 증빙서류가 없는 경우 적용이 불가합니다.</li>
				<li> 위 할인혜택은 2020년 12월 31일까지 적용되며, 이후 혜택이 변경 될 수 있습니다</li>
			</ul>

			<h3>전용바우처</h3>
			<ul class="caption">
				<li> 사용기간 : 구입일로부터 1년</li>
				<li> 포함사항 : 파머스빌리지 스파 이용권 20매 / 50매<br>(매수 별 할인율 상이)</li>
				<li> 판매처 : 파머스빌리지 프론트(구매문의 063-563-6611)</li>
			</ul> -->

			<h3>*주의사항</h3>
			<ul class="caption">
				<li> 13세 이하의 어린이는 보호자 동반 하에 시설 이용이 가능합니다.</li>
				<li> 만 3세(36개월) 미만 어린이에 한하여 증빙서류 확인 후 혼욕이 가능합니다.</li>
				<li> 샴푸, 바스 외 목욕용품이 비치 되어 있지 않으므로 개별 지참이 필요합니다.</li>
				<li> 임산부, 심혈관계 질환자, 기타 약물 복용자, 장애우는 전문의와 상담 후 이용 부탁 드립니다.</li>
				<li> 고객의 안전을 위해 기준 인원 초과 시 입장이 제한될 수 있습니다.</li>
				<li> 음주, 고성방가 등 타인에게 불쾌감을 주는 행동을 삼가 하여 주시길 바랍니다.</li>

			</ul>
		</div>		
		<div class="btnArea">
			<a href="/mobile/hotel/village/location.jsp" class="btnStyle04">오시는길</a><a href="/mobile/hotel/village/promotion/list.jsp" class="btnStyle05">관련 프로모션</a>
		</div>	
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					