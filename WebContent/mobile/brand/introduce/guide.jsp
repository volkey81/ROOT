<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("Depth_4", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("이용안내"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" /> 
	<div id="container">
	<!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="guideWrap">
			<h2>운영시간</h2>
			<table class="list">
				<colgroup>
					<col width=""><col width=""><col width="">
				</colgroup>
				<thead>
					<tr>
						<th class="typeA">구&nbsp;분</th>
						<th>개장시간</th>
						<th>폐장시간</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>연중무휴</td>
						<td>09:30</td>
						<td>21:00</td>
					</tr>
				</tbody>
			</table>
			<ul class="caution">
				<li>야간 이용 시 시설별 운영시간을 확인하시고, 이용하시기 바랍니다.</li>
				<li>상기 운영시간은 기상악화 및 현장 상황에 따라 변동될 수 있습니다.</li>
			</ul>
			
			<h2>시설별 이용시간</h2>
			<table class="list">
				<colgroup>
					<col width="33%"><col width=""><col width="">
				</colgroup>
				<thead>
					<tr>
						<th class="typeA">시설명</th>
						<th colspan="2">운영시간</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>파머스마켓</td>
						<td class="colorA">상시</td>
						<td>09:30 ~ 19:00</td>
					</tr>
					<tr>
						<td rowspan="2">상하키친</td>
						<td class="colorA">월요일</td>
						<td>11:00 ~ 21:00</td>
					</tr>
					<tr class="rowspan">
						<td class="colorA">화  - 일요일</td>
						<td>11:00 ~ 18:00</td>
					</tr>
					<tr>
						<td rowspan="2">농원식당</td>
						<td class="colorA">월요일</td>
						<td class="colorB">휴점</td>
					</tr>
					<tr class="rowspan">
						<td class="colorA">화 - 일요일</td>
						<td>11:00 ~ 21:00</td>
					</tr>
					<tr>
						<td>파머스카페 상하</td>
						<td class="colorA">상시</td>
						<td>09:30 ~ 18:00</td>
					</tr>
					<tr>
						<td>참기름공방</td>
						<td class="colorA">상시</td>
						<td>09:30 ~ 18:00</td>
					</tr>
					<tr>
						<td>체험교실</td>
						<td class="colorA">상시</td>
						<td>10:00 ~ 18:00</td>
					</tr>
					<tr>
						<td>체험목장</td>
						<td class="colorA">상시</td>
						<td>09:30 ~ 18:00</td>
					</tr>
				</tbody>
			</table>
			<ul class="caution">
				<li>체험교실의 프로그램은 지정된 시간에 따라 운영됩니다.</li>
			</ul>
			
			<h2>이용안내</h2>
			<div class="useWarning">
				<h3><strong>01.</strong> 쾌적한 환경을 위하여 아래 물품의 반입을 제한하고 있습니다.</h3>
				<p class="impor">※ 위반 시 즉시 퇴장 조치 될 수 있습니다.</p>
				<ul class="prohibite">
					<li>
						버너, 의자, 대형 돗자리 등<br><strong class="colorA">각종 취사도구</strong>
					</li>
					<li>
						도시락, 포장 음식, 주류 등<br><span class="colorA"><strong>외부음식</strong><br>[유아식 제외]</span>
					</li>
					<li>
						드론, 촬영기기, 음향 장비 등<br><span class="colorA">허가 받지 않은<br><strong>촬영/공연 장비</strong></span><br><span class="colorB">[촬영/공연 문의:1522-3698]</span>
					</li>
					<li>
						칼, 폭죽, 유해물질 등<br><span class="colorA">위협이 되는<br><strong>각종 위험물</strong></span>
					</li>
				</ul>
				<h3><strong>02.</strong> 안전하고 즐거운 이용을 위해 다음의 행위들은 금지하고 있습니다.</h3>
				<ul class="caution">
					<li>상하농원 내 전 구간은 금연구역입니다. 지정된 흡연장소에서 흡연 해 주세요. <span class="colorB">[흡연장소 : 외부주차장 공공화장실 뒤편]</span></li>
					<li>외부에서 가져온 음식을 동물에게 주거나 플래시를 켜고 촬영하지 말아주세요.</li>
					<li>고성방가, 과격한 행동, 음주 후 벤치에 눕는 행위 등은 삼가해주세요.</li>
					<li>식음 및 체험시설 반려동물 입장 불가합니다.</li>
					<li>웨딩 촬영의 경우, 상하농원에서 예식을 진행하는 고객에 한해 촬영 가능합니다. </li>
					<li>사전 협의가 없는 농원 내 무단 촬영을 금지합니다. <br><span class="colorB">※ 위반 시 즉시 퇴장조치 될 수 있습니다.</span><br>
						<p class="colorA">1) 방송/잡지사 촬영&nbsp;&nbsp;&nbsp;&nbsp;2) 웨딩 촬영&nbsp;&nbsp;&nbsp;&nbsp;3) 쇼핑몰 촬영&nbsp;&nbsp;&nbsp;&nbsp;4) 개인 인터넷 방송 촬영
						<span class="colorB">[촬영 문의 : <a href="tel:1522-3698">1522-3698</a>]</span></p>
					</li>
				</ul>
			</div>
			
			<h2>이용권</h2>
			<h3 class="bg1">[입장권]</h3>
			<table class="list">
				<colgroup>
					<col width=""><col width=""><col width="">
				</colgroup>
				<thead>
					<tr>
						<th class="typeA">구&nbsp;분</th>
						<th>소인 / 경로<br><span class="fs">(36개월 ~ 19세 / 70세 이상)</span></th>
						<th>대인</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>개인</td>
						<td>6,000원</td>
						<td>9,000원</td>
					</tr>
					<tr>
						<td>무료</td>
						<td colspan="2">고창군민, 36개월 미만 유아, 소인 장애인 (중증 1~3급), 제휴사(기관별 문의)</td>
					</tr>
				</tbody>
			</table>
			<ul class="caution">
				<li>경로(70세 이상), 장애인(중증 1~3급), 국가유공자, 현역군인(병사), 기초수급자 우대합니다.</li>
				<li>증명자료 원본 제시시에만 우대 가능합니다.</li>
				<li>외부 먹이 반입을 금지합니다.</li>
				<li>자연재해로 인한 입장권 환불 불가합니다.</li>
				<li>17시 이후 입장권 구매시 50% 할인이 적용됩니다.</li>
			</ul>
			
			<h3 class="bg2">[체험권]</h3>
			<table class="list">
				<colgroup>
					<col width=""><col width=""><col width=""><col width=""><col width="">
				</colgroup>
				<thead>
					<tr>
						<th class="typeA">구&nbsp;분</th>
						<th>소시지 만들기</th>
						<th>밀크빵 만들기</th>
						<th>동물쿠키 만들기</th>
						<th>시즌체험</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>2인 체험권</td>
						<td colspan="3">30,000원</td>
						<td>문의</td>
					</tr>
					<!-- 
					<tr>
						<td>패키지권<br><span class="fs">(입장 2인 + 체험 2인)</span></td>
						<td colspan="3">36,000원</td>
					</tr>
					 -->
				</tbody>
			</table>
			<ul class="caution">
				<li>정규체험은 2인 1세트가 최소 단위입니다. 체험프로그램에 따라 기준인원, 가격이 상이할 수 있습니다.</li>
				<li>단체 이용요금은 담당자에게 문의 부탁드립니다.</li>
				<li>영리 및 홍보를 목적으로 하는 상업적 무단 촬영을 금지합니다. <span class="colorA">단체요금 및 촬영문의 : <a href="tel:1522 - 3698">1522 - 3698</a></span></li>
			</ul>
		</div><!-- //guideWrap -->
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					