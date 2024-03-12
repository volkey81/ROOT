<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.board.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("객실 전체보기"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	PopupService popup = new PopupService();
	List<Param> popupList = popup.getList(new Param("device", "M", "position", "C"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp"/> 
<link rel="stylesheet" href="/mobile/css/swiper.min.css">
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-myeongjo.css" rel="stylesheet">
</head>  
<body>
<script>
$(function (){	
	setSwiper($(".roomTab")); //스위퍼 기능 유무 셋팅		
	if(!$(".roomTab").find(".swiper-wrapper").hasClass("noSwiper")){
		var pSwiper = new Swiper($(".roomTab"), {
			slidesPerView: 'auto',
			onSlideChangeEnd: function(swiper){	
				var idx = swiper.activeIndex;
			}
		});
	}

	//상단 텝 fix
	$(window).scroll(function(){
		var value = $(this).scrollTop();

		if (value >= 49){
			$(".roomTab").addClass("on");
		}else{
			$(".roomTab").removeClass("on");
		}
	}); 
		 
})

</script>
<div id="wrapper" >
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="room styleA">
	<!-- 내용영역 -->
		<h2 class="animated fadeInUp delay02">전체보기</h2>
				
		<!-- roomTop -->
		<div class="tabFix">
			<div class="roomTab animated fadeInUp delay04">
				<ul class="tabArea swiper-wrapper">
					<li class="swiper-slide"><a href="/mobile/hotel/room/suite.jsp?roomType=A">테라스 룸</a></li>
					<li class="swiper-slide"><a href="/mobile/hotel/room/suite.jsp?roomType=B">온돌 룸</a></li>
					<li class="swiper-slide"><a href="/mobile/hotel/room/suite.jsp?roomType=C">패밀리 룸</a></li>
					<li class="swiper-slide"><a href="/mobile/hotel/room/suite.jsp?roomType=D">스위트 룸</a></li>
					<li class="swiper-slide"><a href="/mobile/hotel/room/suite.jsp?roomType=E">단체룸 A</a></li>
					<li class="swiper-slide"><a href="/mobile/hotel/room/suite.jsp?roomType=F">단체룸 B</a></li>
					<li class="swiper-slide"><a href="/mobile/hotel/room/glamping.jsp?roomType=A">글램핑 A</a></li>
					<li class="swiper-slide"><a href="/mobile/hotel/room/glamping.jsp?roomType=B">글램핑 B</a></li>
				</ul>
			</div>
			<!-- //roomTop -->
			<div class="roomTop">
				<div class="sec">
					<img src="/images/hotel/room/index1.jpg">
					<div class="cont">
				<h2>파머스빌리지</h2>
				<p class="text">테라스에서 느끼는 작은 자연,<br>쏟아져 내리는 별빛을 간직한 천장,<br>상하의 바람까지 쉬어가는 파머스빌리지에서<br>편안하고 아늑한 팜스테이를 즐겨보세요.</p>
						<ul>
							<li><a href="#type1">테라스룸</a></li>
							<li><a href="#type2">온돌룸</a></li>
							<li><a href="#type3">패밀리룸</a></li>
							<li><a href="#type4">스위트룸</a></li>
							<li><a href="#type5">단체룸A,B</a></li>
						</ul>
						<a href="#roomPriceInfo1" class="btnStyle01">빌리지 객실 안내</a>
					</div>
				</div>
				<div class="sec">
					<img src="/images/hotel/room/index2.jpg">
					<div class="cont">
						<div class="box">
							<h2>파머스글램핑</h2>
							<p class="text">지친 일상의 움츠러든 몸과 마음을<br>자연 속 고즈넉한 농부의 쉼터에서 풀어보세요.<br>따뜻한 햇살이 아침을 밝히고, 사랑하는 반려견과 함께<br>특별하고 소중한 추억을 만들어 보세요.</p>
						</div>
						<ul>
							<li><a href="#type6">글램핑 A</a></li>
							<li><a href="#type6">글램핑 B</a></li>
						</ul>
						<a href="#roomPriceInfo2" class="btnStyle01">글램핑 객실 안내</a>
					</div>
				</div>	
			</div>
		</div>
		<div class="roomType">
			<div class="section" id="type1">
				<img src="/mobile/images/hotel/room/room01.jpg" alt="">
				<div class="txtArea"><a href="/mobile/hotel/room/suite.jsp?roomType=A">
					<img src="/mobile/images/hotel/room/room01Tit.png" alt="TERRACE ROOM">
					<p class="roomTit">테라스 룸</p>
					<p class="roomTxt">툇마루를 연상시키는 테라스에서<br>나만의 자연을 즐길 수 있는 객실</p>
				</a></div>
			</div>
			<div class="section ondol" id="type2">
				<img src="/mobile/images/hotel/room/room02.jpg" alt="">
				<div class="txtArea"><a href="/mobile/hotel/room/suite.jsp?roomType=B">
					<img src="/mobile/images/hotel/room/room02Tit.png" alt="ONDOL ROOM">
					<p class="roomTit">온돌 룸</p>
					<p class="roomTxt">테라스까지 펼쳐져 있는 넓은 평상에 누워<br>농부의 휴식을 진정 만끽할 수 있는 객실</p>
				</a></div>
			</div>
			<div class="section family" id="type3">
				<img src="/mobile/images/hotel/room/room03.jpg" alt="">
				<div class="txtArea"><a href="/mobile/hotel/room/suite.jsp?roomType=C">
					<img src="/mobile/images/hotel/room/room03Tit.png" alt="FAMILY ROOM">
					<p class="roomTit">패밀리 룸</p>
					<p class="roomTxt">복층 타입의 가족형 공간에서<br>작은 하늘 창으로 별을 바라보는 객실</p>
				</a></div>
			</div>
			<div class="section suite" id="type4">
				<img src="/mobile/images/hotel/room/room04.jpg" alt="">
				<div class="txtArea"><a href="/mobile/hotel/room/suite.jsp?roomType=D">
					<img src="/mobile/images/hotel/room/room04Tit.png" alt="SUITE ROOM">
					<p class="roomTit">스위트 룸</p>
					<p class="roomTxt">농부가 정성껏 지은<br>신부를 위한 특별한 객실</p>
				</a></div>
			</div>
			<div class="section groupA" id="type5">
				<img src="/mobile/images/hotel/room/room05.jpg" alt="">
				<div class="txtArea"><a href="/mobile/hotel/room/group.jsp?roomType=A">
					<img src="/mobile/images/hotel/room/room05Tit.png" alt="GROUP ROOM A">
					<p class="roomTit">단체룸 A</p>
					<p class="roomTxt">최대 8인까지 숙박할 수 있는<br>소규모 가족 / 친구 모임 등에 적합한 단체실</p>
				</a></div>
			</div>
			<div class="section groupB">
				<img src="/mobile/images/hotel/room/room06.jpg" alt="">
				<div class="txtArea"><a href="/mobile/hotel/room/group.jsp?roomType=B">
					<img src="/mobile/images/hotel/room/room06Tit.png" alt="GROUP ROOM B">
					<p class="roomTit">단체룸 B</p>
					<p class="roomTxt">최대 24인까지 숙박할 수 있는<br>체험 학습 / 캠프 행사 등에 적합한 단체실</p>
				</a></div>
			</div>
		</div>
	
		<div class="roomPriceInfo" id="roomPriceInfo1">
			<h3>빌리지 객실 안내</h3>
			<table class="listStyleB">
				<colgroup>
					<col width="">
					<col width="">
					<col width="">
					<col width="">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">객실</th>
						<th scope="col">기준정원<br>(최대정원)</th>
						<th scope="col">객실수</th>
						<th scope="col">침대타입</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>테라스<br>(33㎡)</td>
						<td>2<br>(3)</td>
						<td>14</td>
						<td>싱글+싱글</td>
					</tr>
					<tr>
						<td>온돌<br>(33㎡)</td>
						<td>2<br>(3)</td>
						<td>4</td>
						<td>한실침구</td>
					</tr>
					<tr>
						<td>패밀리<br>(39㎡)</td>
						<td>3<br>(4)</td>
						<td>20</td>
						<td>복층형<br>더블+한실침구</td>
					</tr>
					<tr>
						<td>스위트<br>(66㎡)</td>
						<td>4<br>(5)</td>
						<td>1</td>
						<td>퀸+퀸<br>싱글1</td>
					</tr>
					<tr>
						<td>단체A<br>(66㎡)</td>
						<td>8<br>(8)</td>
						<td>1</td>
						<td>복층형<br>싱글8</td>
					</tr>
					<tr>
						<td>단체B<br>(132㎡)</td>
						<td>24<br>(24)</td>
						<td>1</td>
						<td>2층침대형<br>싱글24</td>
					</tr>
				</tbody>
			</table>
			<p class="text"><strong>"<a href="/mobile/hotel/room/reservation/date.jsp">예약하기</a>"를 통하여 3개월 요금을 확인 하실 수 있습니다.</strong></p>
			<table class="listStyleB">
				<thead>
					<tr>
						<th scope="col">유의사항</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<ul class="caption">
								<li>매월 1일 3개월 예약상황을 확인 및 예약하실 수 있습니다.</li>
								<li>24년 성수기 : 봄(4/21~5/06), 가을(10/02~11/02), 겨울(12/24~12/31)</li>
								<li>24년 극성수기 : 6/21~9/01, 극극성수기(7/26~8/25)<br>*극성수기 및 성수기 일정은 변경 될 수 있습니다.</li>
								<li>입실기준 : 주말(금, 토, 공휴일 직전일), 주중(일~목요일)</li>
								<li>객실 VIEW는 지정하실수 없으며, 예약 순차적 배정됩니다.</li>
							</ul>
						</td>
					</tr>
				</tbody>
			</table>
			<table class="listStyleB typeB">
				<colgroup>
					<col width="10%">
					<col width="25%">
					<col width="">
					<col width="10%">
					<col width="25%">
					<col width="">
				</colgroup>
				<thead>
					<tr>
						<th colspan="6">제공사항(기준 정원기준)</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="6">웰빙조식뷔페(18,000원)+스파입장권(12,000원)+농원입장권(9,000원)<br>*극성수기 수영장입장권(24,000원)</td>
					</tr>
					<tr>
						<th colspan="3">시즌(성수기 포함)</th>
						<th colspan="3">극성수기(여름)</th>
					</tr>
					<tr>
						<th rowspan="2">추가<br>요금</th>
						<td>대인</td>
						<td>50,000원</td>
						<th rowspan="2">추가<br>요금</th>
						<td>대인</td>
						<td>65,000원</td>
					</tr>
					<tr>
						<td>소인<br>(36개월~만13세)</td>
						<td>35,000원</td>
						<td>소인<br>(36개월~만13세)</td>
						<td>40,000원</td>
					</tr>
				</tbody>
			</table>
			<p class="text">0개월~35개월 미취학도 인원수에 포함됩니다.(비용은 무료) </p>
			<table class="listStyleB typeB">
				<colgroup>
					<col width="">
					<col width="">
				</colgroup>
				<thead>
					<tr>
						<th colspan="2">취소 & 환불규정안내</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th>정규시즌</th>
						<th>성수기/극성수기(여름)/패키지</th>
					</tr>
					<tr>
						<td>8일전 전액 환불<br>7~4일 50% 환불<br>3일~당일 취소(No-show포함)환불불가</td>
						<td>15일전 전액 환불<br>14~8일전 90% 환불<br>	7~4일 50% 환불<br>3일~당일 취소(No-show포함)환불불가</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		
		<div class="roomType">
			<div class="section glampingA" id="type6">
				<img src="/mobile/images/hotel/room/room07.jpg?ver=1" alt="">
				<div class="txtArea"><a href="/mobile/hotel/room/glamping.jsp?roomType=A">
					<img src="/mobile/images/hotel/room/room07Tit.png" alt="GLAMPING A">
					<p class="roomTit">글램핑 A(반려견 입실불가)</p>
					<p class="roomTxt">더블침대 2개가 붙어있는 최대 4인까지 숙박가능한 농부의 쉼터</p>
				</a></div>
			</div>
			<div class="section glampingB">
				<img src="/mobile/images/hotel/room/room08.jpg?ver=1" alt="">
				<div class="txtArea"><a href="/mobile/hotel/room/glamping.jsp?roomType=B">
					<img src="/mobile/images/hotel/room/room07Tit.png" alt="GLAMPING B">
					<p class="roomTit">글램핑 B(반려견 입실가능)</p>
					<p class="roomTxt">소중한 반려동물과 편안하게 머무를 수 있는 온전한 쉼터</p>
				</a></div>
			</div>
		</div>
	
		<div class="roomPriceInfo" id="roomPriceInfo2">
			<h3>글램핑 객실 안내</h3>
			<table class="listStyleB">
				<colgroup>
					<col width="">
					<col width="">
					<col width="">
					<col width="">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">객실</th>
						<th scope="col">기준정원<br>(최대정원)</th>
						<th scope="col">객실수</th>
						<th scope="col">침대타입</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>글램A<br>(33㎡)</td>
						<td>3<br>(4)</td>
						<td>8</td>
						<td>더블+더블<br>(붙은타입)</td>
					</tr>
					<tr>
						<td>글램B<br>(33㎡)<br>(반려견 입실가능)</td>
						<td>3<br>(4)</td>
						<td>5</td>
						<td>더블+더블<br>(분리타입)</td>
					</tr>
				</tbody>
			</table>
			<p class="text"><strong>"<a href="/hotel/room/reservation/date.jsp">예약하기</a>"를 통하여 3개월 요금을 확인 하실 수 있습니다.</strong></p>
			<table class="listStyleB">
				<colgroup>
					<col width="">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">글램B 반려견 입실 유의사항</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<ul class="caption">
								<li>글램핑 B타입만 반려견 입실이 가능합니다.(글램핑 A와 B타입은 15m 거리를 두고 마주 보고 있습니다.)</li>
								<li>반려견 인식표, 중성화 수술완료 증명서, 접종증명서(5대접종/1년내 광견병예방접종)가 입실시 필요합니다.</li>
								<li>1실당 10kg미만 소형견 1마리만 입실 가능하며, 5만원의 추가금액과 클린보증금(30만원)이 필요합니다.</li>
								<li>클린보증금(30만원)은 침구등의 파손, 오염, 분실을 대비하여 카드를 오픈하여 운영하며, 해당 사유로 추가 객실 정비 필요시 별도의 추가 비용이 청구될 수 있습니다.</li>
								<li>전염병이 있거나 공격성이 강한 맹견, 5개월 이하 반려견은 입실이 불가 합니다.</li>
								<li>농원내 식음시설 및 카페, 스파 등 이용이 불가하여 켄넬을 이용할 수 있습니다.</li>
							</ul>
						</td>
					</tr>
				</tbody>
			</table>
			<table class="listStyleB">
				<thead>
					<tr>
						<th scope="col">유의사항</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<ul class="caption">
								<li>매월 1일 3개월 예약상황을 확인 및 예약하실 수 있습니다.</li>
								<li>24년 성수기 : 봄(4/21~5/06), 가을(10/02~11/02), 겨울(12/24~12/31)</li>
								<li>24년 극성수기 : 6/21~9/01, 극극성수기(7/26~8/25)<br>*극성수기 및 성수기 일정은 변경 될 수 있습니다.</li>
								<li>입실기준 : 주말(금, 토, 공휴일 직전일), 주중(일~목요일)</li>
								<li>객실 VIEW는 지정하실수 없으며, 예약 순차적 배정됩니다.</li>
							</ul>
						</td>
					</tr>
				</tbody>
			</table>
			<table class="listStyleB typeB">
				<colgroup>
					<col width="10%">
					<col width="25%">
					<col width="">
					<col width="10%">
					<col width="25%">
					<col width="">
				</colgroup>
				<thead>
					<tr>
						<th colspan="6">제공사항(기준 정원기준)</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="6">웰빙조식뷔페(18,000원)+스파입장권(12,000원)+농원입장권(9,000원)<br>*극성수기 수영장입장권(24,000원)</td>
					</tr>
					<tr>
						<th colspan="3">시즌(성수기 포함)</th>
						<th colspan="3">극성수기(여름)</th>
					</tr>
					<tr>
						<th rowspan="2">추가<br>요금</th>
						<td>대인</td>
						<td>38,000원</td>
						<th rowspan="2">추가<br>요금</th>
						<td>대인</td>
						<td>65,000원</td>
					</tr>
					<tr>
						<td>소인<br>(36개월~만13세)</td>
						<td>27,000원</td>
						<td>소인<br>(36개월~만13세)</td>
						<td>40,000원</td>
					</tr>
				</tbody>
			</table>
			<p class="text">0개월~35개월 미취학도 인원수에 포함됩니다.(비용은 무료) </p>
			<table class="listStyleB typeB">
				<colgroup>
					<col width="">
					<col width="">
				</colgroup>
				<thead>
					<tr>
						<th colspan="2">취소 & 환불규정안내</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th>정규시즌</th>
						<th>성수기/극성수기(여름)/패키지</th>
					</tr>
					<tr>
						<td>8일전 전액 환불<br>7~4일 50% 환불<br>3일~당일 취소(No-show포함)환불불가</td>
						<td>15일전 전액 환불<br>14~8일전 90% 환불<br>	7~4일 50% 환불<br>3일~당일 취소(No-show포함)환불불가</td>
					</tr>
				</tbody>
			</table>
		</div>
	
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>