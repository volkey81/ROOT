<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("체험교실"));
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
					<img src="/mobile/images/hotel/enjoy/experiencSlide02.jpg" alt="체험교실1">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/experiencSlide03.jpg" alt="체험교실1">
				</div>
			</div>
		</div>
		<!-- //slideWrap -->
		
		<div class="hotelContTop animated fadeInUp delay04">
			<span class="sTxt">SANGHA FARM COOKING CLASS</span>
			<h2>체험교실<span>자연과 함께하는 상하농원의<br>체험 교실을 경험해보세요.</span></h2>
		</div>
			
		<div class="hotelCont animated fadeInUp delay06">
			<h3>체험 시간표 (유료)</h3>
			<table class="listStyleB">
				<colgroup>
					<col width="12%">
					<col width="18%">
					<col width="30%">
					<col width="30%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col" colspan="2">구분</th>
						<th scope="col">체험교실<br>(A동)</th>
						<th scope="col">체험교실<br>(B동)</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td rowspan="4" class="week">평일</td>
						<td>1교시</td>
						<td>(11:00~)<br>소시지</td>
						<td>-</td>
					</tr>
					<tr>
						<td>2교시</td>
						<td>(13:30~)<br>밀크빵</td>
						<td>-</td>
					</tr>
					<tr>
						<td>3교시</td>
						<td>(14:30~)<br>쿠키</td>
						<td>-</td>
					</tr>
					<tr>
						<td>4교시</td>
						<td>(16:00~)<br>유기농아이스크림</td>
						<td>(16:00~)<br>소시지</td>
					</tr>
					<tr>
						<td rowspan="4" class="week line">주말</td>
						<td class="line">1교시</td>
						<td class="line">(11:00~)<br>소시지</td>
						<td class="line">(11:00~)<br>밀크빵</td>
					</tr>
					<tr>
						<td>2교시</td>
						<td>(13:30~)<br>유기농아이스크림</td>
						<td>(13:30~)<br>블루베리 머핀</td>
					</tr>
					<tr>
						<td>3교시</td>
						<td>(14:30~)<br>쿠키</td>
						<td>-</td>
					</tr>
					<tr>
						<td>4교시</td>
						<td>(16:00~)<br>유기농아이스크림</td>
						<td>(16:00~)<br>소시지</td>
					</tr>
					<!-- <tr>
						<td rowspan="4" class="week line">이벤트<br>기간<br>21~<br>25일,<br>28일~<br>31일</td>
						<td class="line">10:30</td>
						<td class="line">쿠키</td>
						<td class="line">소시지</td>
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
						<td>16:30</td>
						<td>나무목도리</td>
						<td></td>
					</tr> -->
				</tbody>
			</table>
			<ul class="caption">
				<li>2020년 3~4월 체험시간표.</li>
				<li>체험교실은 예약제로 운영되며, 체험 진행 상황에 따라<br>일정이 변경될 수 있습니다.</li>
				<!--<li>평일 동물쿠키 상시체험은 예약에 따라 현장에서<br>접수 / 운영합니다.</li>-->
				<li>공휴일의 경우 주말 시간표로 운영합니다.</li>
				<li>단체 체험이용은 1522-3698로 문의 바랍니다.</li>
			</ul>
		</div>		
		<div class="btnArea">
			<a href="/mobile/brand/play/experience/list.jsp" class="btnStyle04">자세히보기</a><a href="/mobile/brand/play/reservation/admission.jsp" class="btnStyle05">예약하기</a>
		</div>	
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					