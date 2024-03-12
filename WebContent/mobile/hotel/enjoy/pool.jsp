<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("수영장"));
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
		<div class="hotelContTop poolHead animated fadeInUp delay04">
			<img src="/mobile/images/hotel/enjoy/visual_pool.jpg" alt="">
			<span class="sTxt">SANGHAFARM</span>
			<h2>INTRODUCTION<span>자연 속에서 품격 있는 휴식을 즐길 수 있는 파머스빌리지 수영장에서 재충전의 시간을 가져보세요.<br>모자이크 타일 공법으로 더욱 견고하고, 은은하게 빛이 나는 풀장으로, 달팽이 모형의 독특한 유아풀에서 미끄럼틀과 적절한 온도의 온수풀로 운영하고 있어 가족들과 안전한 물놀이를 즐길 수 있으며,  50X24m의 넓은 규격의 대형 풀에서 선선히 불어오는 서해 바닷 바람을 느끼며 자연이 주는 이국적인 정취를 느껴보세요.</span></h2>
			<div class="info">
				<h3>LOCATION</h3>
				<p>전북 고창군 상하면 상하농원길 11-23</p>
				<h3>PERIOD</h3>
				<p>정식 오픈&nbsp;&nbsp;23.06.24 ~ 23.09.03</p>
				<h3>HOURS OF OPERATION</h3>
				<p>정식 오픈&nbsp;&nbsp;9:30 ~ 18:30 (50분 운영,  10분 휴게)</span><br>
				<span class="sub">수질정비시간에는 입수가 제한될 수 있습니다.</span></p>
			</div>
		</div>
		
		<div class="slideWrap animated fadeInUp delay06">
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea"> 
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/slide_pool1.jpg" alt="야외수영장1">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/slide_pool2.jpg" alt="야외수영장2">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/slide_pool3.jpg" alt="야외수영장3">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/slide_pool4.jpg" alt="야외수영장4">
				</div>
			</div>
		</div>
		<!-- //slideWrap -->
			
		<div class="hotelCont animated fadeInUp poolCont">
			<h2>시설안내</h2>
			<ul class="facility">
				<li>
					<img src="/mobile/images/hotel/enjoy/thumb_pool1.jpg" alt="">
					<p>야외 수영장</p>
					성인풀 길이 50m, 너비 24m, 깊이 1.1m~1.3m<br>
					유아풀 깊이 0.20m~0.90m<br>
					<%--<span class="sub">수영장 수질정비시간 12:00 – 13:00</span>--%>
				</li>
				<li>
					<img src="/mobile/images/hotel/enjoy/thumb_pool2.jpg" alt="">
					<p>파머스 카바나</p>
					선선히 불어오는 서해 바닷 바람을 느끼며<br>프라이빗한 시간을 누리는 독립형 휴식 공간
				</li>
				<li>
					<img src="/mobile/images/hotel/enjoy/thumb_pool3.jpg" alt="">
					<p>파머스 스낵바</p>
					상하농원 수제공방 레시피로 만든 건강한 먹거리와<br>음료를 즐길 수 있는 공간
				</li>
			</ul>
			
			<h2>가격정보</h2>
			<table class="listStyleB">
				<col width="15%"><col width=""><col width="25%">
				<thead>
					<tr>
						<th scope="col" colspan="2">구분</th>
						<th scope="col">요금</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td rowspan="2">종일</td>
						<td>대인 (14세 이상)</td>
						<td>24,000원</td>
					</tr>
					<tr>
						<td>소인 (37개월 ~ 13세)</td>
						<td>12,000원</td>
					</tr>
					<tr>
						<td class="bg" colspan="2">오후 4시 이후</td>
						<td class="bg">40% 할인</td>
					</tr>
				</tbody>
			</table>
			
			<h2>우대정보</h2>
			<table class="listStyleB">
				<col width="15%"><col width=""><col width=""><col width="">
				<thead>
					<tr>
						<th scope="col">구분</th>
						<th scope="col">파머스빌리지/<br>글램핑 투숙객</th>
						<th scope="col">고창군민</th>
						<th scope="col">정읍/광주/<br>영광/전주</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>주중</td>
						<td rowspan="3">25%<br>체크인 기준<br>23년 6월 23(금)~9월 3(일)<br>숙박시 무료</td>
						<td rowspan="3">25%</td>
						<td rowspan="2">25%</td>
					</tr>
					<tr>
						<td class="border">주말</td>
					</tr>
					<tr>
						<td>극성수기</td>
						<td>-</td>
					</tr>
				</tbody>
			</table>
			<ul class="caption">
				<li>민증 필참 인원만 해당 혜택 적용 가능</li> 
				<li>모든 할인은 본인에 한해 1인 1매 적용, 중복할인 불가</li>
				<li>23년 수영장 극성수기 기간 : 7월 21(금)~8월 27(일)</li> 
				<li>투숙객 무료 입장의 경우, 체크 아웃 전까지에 한해 무료입장 적용이 가능</li> 
				<li>숙박권 및 프로모션권 이용을 통한 숙박 시, 극성수기 요금 차액 발생 후 이용 가능</li>
			</ul>
			
			
			<div class="info2">
				<h3>주의사항</h3>
				<ul class="caption">
					<li>어린이 고객을 동반하신 고객께서는 안전한 수영을 위해 세심한 보호를 부탁드립니다.</li>
					<li>고객 여러분의 안전을 위하여 다음과 같이 풀 이용 규정을 준수해 주시기 바랍니다.<br>(수영복 및 관련 용품을 별도로 판매하고 있습니다.)</li>
				</ul>
				<h3>운영방침</h3>
				<ul class="caption">
					<li>수영모 착용은 필수 입니다.(썬캡 불가)</li>
					<li>수영장 이용 시 수건은 지급되지 않으며, 렌탈샵에서 구매 가능합니다.</li>
					<li>3세(36개월) 이상 어린이는 공중위생관리법에 따라 혼욕을 할 수 없습니다.</li>
					<li>쾌적하고 안전한 운영을 위해, 적정인원 초과 시 입장이 제한될 수 있습니다.</li>
					<li>수영장의 모든 지역은 금연 구역입니다.</li>
					<li>귀중품은 반드시 개인 락커에 보관해 주시고, 분실되지 않도록 유의 바랍니다.</li>
					<li>수영장 내 외부 음식 및 돗자리 반입이 불가합니다.</li>
					<li>락커키 분실 시 (제작비 5만원)이 발생하오니, 분실에 주의 바랍니다.</li>  
				</ul>  

				<h3>안전</h3>
				<ul class="caption">
					<li>신장 130cm 미만인 고객은 반드시 구명 조끼 착용과 보호자 동반 시 이용이 가능합니다.</li>
					<li>다이빙은 금지되어 있습니다.</li>
					<li>물에 들어가기 전 반드시 준비운동을 해주시기 바랍니다.</li>
					<li>금속, 플라스틱, 유리제품 등 날카롭거나 깨질 수 있는 물건의 반입을 금합니다.</li>
					<li>강우 및 강풍과 같은 기상 상황에 따라 이용이 제한될 수 있습니다.</li>
					<li>눈병, 피부병 및 기타 감염성 질환 등 공중 위생에 영향을 미치는 환자는 이용할 수 없습니다.</li>
					<li>수영장 소독물질이 알러지(Allergy)를 일으킬 수 있으니, 관련 알러지가 있는 고객은 이용을 삼가 주시기 바랍니다.</li>
					<li>안전한 이용을 위해 안전 요원 및 직원의 안내가 있을 경우 적극적으로 협조해 주시기 바랍니다.</li>
					<li>야외 수영장 특성 상 아쿠아슈즈 착용을 권장합니다.</li>
				</ul>
	
				<h3>촬영</h3>
				<ul class="caption">
					<li>상업적 목적의 촬영 시 이용이 제한될 수 있습니다.</li>
					<li>휴대전화를 포함한 촬영 장비로 풀장 내 수중 촬영 및 락커 내에서의 촬영은 불가합니다.</li>
					<li>다른 고객에게 불편을 주는 지나친 촬영은 제재될 수 있으니 이에 협조 바랍니다.</li>
					<li>수영장에서는 인터넷 방송을 진행할 수 없으며 초상권을 침해하는 행위로 간주되어 법적 제재를 받을 수 있습니다.</li>
				</ul>
				
				<table class="listStyleB">
					<thead>
						<tr>
							<th scope="col">입수 허용 품목</th>
							<th scope="col">입수 금지 품목</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>
								<ul class="caption">
									<li>수영복, 레시가드, 웨이크복 등 물놀이 복장</li>
									<li>구명조끼 및 튜브 (어린이용 보행튜브 및 지름 80cm 이하의 일반 튜브)</li>
									<li>수영모 필수(썬캡 불가), 물안경, 아쿠아 슈즈</li>
								</ul>
							</td>
							<td>
								<ul class="caption">
									<li>청/면 반바지 등 일상복</li>
									<li>안경, 귀걸이, 목걸이, 팔찌 등 악세서리 류 (락커보관)</li>
									<li>샌들, 슬리퍼 등 일반 신발류</li>
									<li>짙은 화장, 썬텐 오일 등 </li>
									<li>수영핀(오리발)</li>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>		
		<!-- <div class="btnArea">
			<a href="/mobile/hotel/village/location.jsp" class="btnStyle04">오시는길</a><a href="/mobile/hotel/village/promotion/list.jsp" class="btnStyle05">관련 프로모션</a>
		</div> -->	
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					