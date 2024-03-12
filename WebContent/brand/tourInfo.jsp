<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("Depth_4", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("단체 견학 안내"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
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
});
</script>
<script>
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
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<div id="container">
		<!-- 내용영역 -->
		<div class="tourInfo">
			<div class="topTxt">
				<h2><span>함께하면 더 즐거운 상하농원</span>단체 견학 안내</h2>
				<p class="txt">사시사철 농촌의 아름다운 풍경과 신선한 먹거리가 만들어지는<br>상하농원에서 재미있는 체험이 기다리고 있어요
				<span>친구와, 선생님과, 동료와 함께 하면 더 즐거운 시간,<br>상하농원에서 만들어 보아요</span></p>
			</div>
			<div class="tourCourse">
				<p class="course01"><a href="/brand/play/experience/view.jsp?seq=6"><span>10:30</span>블루베리크럼블<br>케이크 체험</a></p>
				<p class="course02"><a href="/brand/food/store2.jsp"><span>12:00</span>농원식당/ 상하키친에서<br>맛있는 점심식사</a></p>
				<p class="course03"><a href="/brand/introduce/facility.jsp"><span>12:40~1:30</span>먹거리가 만들어지는<br>공방 견학 <span class="sTxt">(자유관람)</span></a></p>
				<p class="course04"><a href="/brand/workshop/factory.jsp"><span>14:00</span>매일유업<br>상하공장 견학</a></p>
				<p class="caption">* 만들기 체험은 월별로  체험내용이 달라질 수 있습니다.  체험교실 시간표 꼭 확인해주세요.</p>
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
				<div class="tourInfoCont" id="tourInfoCont01">
					<table class="bbsList">
						<colgroup>
							<col width="20%">
							<col width="20%">
							<col width="30%">
							<col width="30%">
						</colgroup>
						<thead>
							<tr>
								<th scope="col"></th>
								<th scope="col">입장권</th>
								<th scope="col">체험권</th>
								<th scope="col">패키지권</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>단체</td>	
								<td class="ticket">
									<p><span>소인</span>4,500원</p>
									<p><span>대인</span>7,200원</p>
								</td>	
								<td>
									<p><span>20인 이상(10%할인)</span>15,000원 → 13,500원</p>
									<p><span>40인 이상(20%할인)</span>15,000원 → 12,000원</p>
								</td>	
								<td>
									<p><span>20인 이상(10%할인)</span>18,000원 → 16,500원</p>
									<p><span>40인 이상(20%할인)</span>18,000원 → 15,000원</p>
								</td>	
							</tr>
						</tbody>
					</table>
				</div>
				<div class="tourInfoCont" id="tourInfoCont02">
					<div>
						<h3>체험프로그램 안내</h3>
						<table class="bbsList">
							<colgroup>							
								<col width="15%">
								<col width="48%">
								<col width="11%">
							</colgroup>
							<thead>
								<tr>									
									<th>체험구분</th>
									<th>운영시간</th>
									<th>운영내용</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>먹거리 만들기 체험</td>										
									<td>																		
										<p>오감 먹거리 체험교실<br>
										자연의 먹거리를 그대로 보고, 만지는 오감 체험을 통해 바른 먹거리를 배우는 공간</p>									
									</td>	
									<td>
										<a href="#layerPop1" onclick="etcPopOpen(1);" class="popOpen btnTypeB">프로그램 보기</a>										
									</td>	
								</tr>
								<tr>
									<td>동물먹이주기 체험</td>										
									<td>
										<p>미니돼지, 염소, 토끼, 산양, 면양, 젖소, 당나귀 등
										<span>*멍멍이운동장, 젖소운동장은 기후에 따라 운영</span></p>	
									</td>	
									<td>
										<a href="#layerPop2" onclick="etcPopOpen(2);" class="popOpen btnTypeB">프로그램 보기</a>										
									</td>	
								</tr>
							</tbody>
						</table>
					</div>					
					<div class="tableWrap">
						<h3>견학프로그램 안내</h3>
						<table class="bbsList">
							<colgroup>								
								<col width="8%">
								<col width="53%">
								<col width="11%">
							</colgroup>
							<thead>
								<tr>									
									<th>체험구분</th>
									<th>운영시간</th>
									<th>운영내용</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>상하공장</td>										
									<td>																	
										<p>유기농 우유와 자연 치즈는 어떻게 만들어질까요?우유와 치즈가 만들어지는 과정을 직접 견학 해보세요!</p>																				
									</td>	
									<td>
										<a href="#layerPop3" onclick="etcPopOpen(3);" class="popOpen btnTypeB">프로그램 보기</a>										
									</td>	
								</tr>
								<tr>
									<td>햄공방</td>										
									<td>
										<p>천연케이싱으로 육즙이 풍부한 소시지와 12시간 이상 염지하여 깊은 맛을 내는 베이컨으로<br/> 
										고기보다 더 맛있는 햄을 경험해보세요.
										</p>										
									</td>	
									<td rowspan="4">
										<p>연중무휴</p>
										<p>09:30~18:00</p>
									</td>	
								</tr>
								<tr>
									<td>과일공방</td>										
									<td>
										<p>황동솥에서 끓여 과일의 향미가 가득한 수제 잼. 따스한 햇살과 바람으로 숙성한 수제 과일 청.<br/>
										자연이 선사한 과일의 신선한 맛을 느껴보세요.
										</p>										
									</td>										
								</tr>
								<tr>
									<td>빵공방</td>										
									<td>
										<p>유기농 우유로 만든 고소한 식빵. 부드러운 천연 치즈 케이크.유정란으로 만든 깊은 맛의 카스텔라까지!
										</p>										
									</td>										
								</tr>
								<tr>
									<td>발효공방</td>										
									<td>
										<p>우리 땅에서 기른 재료에 공방장이 돌보는 정성을 더했습니다.<br/>								
									</td>										
								</tr>								
							</tbody>
						</table>
					</div>				
				</div>
				<div class="tourInfoCont" id="tourInfoCont03">					
					<table class="bbsList">
						<colgroup>													
							<col width="30%">
							<col width="30%">
							<col width="30%">
						</colgroup>
						<thead>
							<tr>																
								<th>식당</th>
								<th>메뉴</th>
								<th>가격</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<span class="iconBg icon1">농원식당</span>
								</td>
								<td>							
									<ul class="bltTypeA">
										<li>순백색 유정란 오므라이스</li>
										<li>간장 제육 덮밥</li>
										<li>카레 덮밥</li>
									</ul>							
								</td>
								<td rowspan="2">
									<p>예약 상담시 확정
									</p>									
								</td>		
							</tr> 
							<tr>
								<td>
									<span class="iconBg icon2">상하키친</span>									
								</td>
								<td>
									<ul class="bltTypeA">
										<li> 순백색 유정란 오므라이스</li>
									</ul>																									
								</td>									
							</tr>
						</tbody>
					</table>
					<ul class="caption bltTypeA">
						<li>도시락을 준비해오시는 경우, 농원 야외에서 돗자리를 이용 해 드실 수 있습니다. (식당은 영업공간으로 이용이 어려우며, 단체 방문자 취식을 위한 별도 실내공간이 준비되어 있지 않습니다)</li>
						<li>위 메뉴 외 다른 메뉴를 이용하고 싶으신 경우 상담 또는 문의 시 알려 주시기 바랍니다.</li>
					</ul>
				</div>	
				<div class="tourInfoCont" id="tourInfoCont04">
					<div class="groupCont">
						<div class="groupBg group1"></div>
						<div class="textArea">
							<h4>농원 사무실 회의실</h4>
							<span>최대 50명</span>
							<p>프로젝터, 마이크, 화이트보드,<br/>wifi 이용 가능</p>
						</div>
					</div>
					<div class="groupCont">
						<div class="groupBg group2"></div>
						<div class="textArea">
							<h4>파머스빌리지 강당</h4>
							<span>최대 150명</span>
							<p>연단, 프로젝터, 마이크,<br/>화이트보드, wifi 이용 가능</p>
							<a href="http://dev.sanghafarm.co.kr/hotel/wedding/seminar.jsp" class="btnTypeB" target="_blank">상세 보기</a>						
						</div>
					</div>
					<div class="groupCont">
						<div class="groupBg group3"></div>
						<div class="textArea">
							<h4>파머스테이블</h4>
							<span>최대 250명</span>
							<p>연단, 프로젝터, 마이크,<br/>화이트보드, wifi 이용 가능 
							</p>
							<a href="http://dev.sanghafarm.co.kr/hotel/wedding/seminar.jsp" class="btnTypeB" target="_blank">상세 보기</a>						
						</div>
					</div>					
				</div>
				<div class="tourInfoCont" id="tourInfoCont05">					
					<div class="groupCont">
						<div class="groupBg group4"></div>
						<div class="textArea">
							<h4>파머스빌리지 단체룸 A</h4>
							<strong>기준정원 8명/ 최대 8명</strong>
							<p>싱글베드X8,<br/>6인 책상, 복층구조
							</p>
							<a href="http://dev.sanghafarm.co.kr/hotel/room/group.jsp " class="btnTypeB" target="_blank">상세 보기</a>						
						</div>
					</div>
					<div class="groupCont">
						<div class="groupBg group5"></div>
						<div class="textArea">
							<h4>파머스빌리지 단체룸 B</h4>
							<strong>기준정원 24명/ 최대 24명</strong>
							<p>싱글베드X24 (2층침대),<br/>좌식탁자, 복층구조
							</p>
							<a href="http://dev.sanghafarm.co.kr/hotel/room/group.jsp " class="btnTypeB" target="_blank">상세 보기</a>						
						</div>
					</div>						
				</div>
				<div class="btnArea">
						<a href="/brand/play/reservation/group.jsp " class="btnTypeA">단체 견학 예약</a>
						<a href="/customer/counsel.jsp " class="btnTypeC">단체 견학 문의</a>
					</div>
					<ul class="caption">
						<li>※ 단체혜택은 방문자 20인 이상인 경우 받으실 수 있습니다</li>
						<li>※ 단체 견학 문의 또는 견학 예약 후 유선 상담이 이루어지며, 전체 일정 및 금액이 확정됩니다.</li>
					</ul>
			</div>
			
			
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
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
			<img src="../images/brand/introduce/guide/pop2_1.png" alt="">
		</div>
	</div>
	<div class="layerPop"  id="layerPop3">
		<div class="popCont">
			<img src="../images/brand/introduce/guide/pop3_1.png" alt="">
		</div>
	</div>	
</div><!-- //wrapper -->

</body>
</html>