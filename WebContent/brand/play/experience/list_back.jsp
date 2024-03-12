<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="com.sanghafarm.service.brand.ExpClassService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("체험교실"));
	
	Param param = new Param(request);
	ExpClassService svc = (new ExpClassService()).toProxyInstance();
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 3);
	final int BLOCK_SIZE = 5;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	//게시물 갯수
	int totalCount = svc.getListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
	$(function () {
		paging('<%= nPage%>');		
	});
	

	function paging(page) {
		var searchParam = {
				"page" : page
		}
		$.post('/ajax/programList.jsp', searchParam, function(html){
			$("#programList").html(html);
		});	
	}
</script> 
</head>  
<body class="fullpage">
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="expHead">
			<span>오감 먹거리 체험교실</span><br>자연의 먹거리를 그대로 보고,<br>만지는 오감 체험을 통해 바른 먹거리를 배우는 공간	
		</div>
		<div class="expArea">
			<h2><img src="/images/brand/play/tit_experience.png" alt="상하농원 체험교실"></h2>
			<p class="srmy"><span>상하농원 체험 교실의</span><br>다섯가지 긍정의 씨앗</p>
			<ul>
				<li class="no1">
					<p class="desc">슬기의 씨앗</p>
					<p class="cont">바른 음식을 구별할 수 있는 힘을<br> 길러줌으로써 먹거리를 제대로 알고 먹어요</p>
				</li>
				<li class="no2">
					<p class="desc">사랑의 씨앗</p>
					<p class="cont">가족/친구와 추억을 <br>공유함으로써 유대감과 사랑을 <br>키울 수 있어요</p>
				</li>
				<li class="no3">
					<p class="desc">참맛의 씨앗</p>
					<p class="cont">자극적인 맛에 길들여진 <br>미각을 일깨워 맛있는 <br>음식에 대한 기준을 재조명 해요 </p>
				</li>
				<li class="no4">
					<p class="desc">감사의 씨앗</p>
					<p class="cont">먹거리를 제공하는 모든 <br>자연, 동물과 생산자의 열정에<br> 감사하는 마음을 가져요</p>
				</li>
				<li class="no5">
					<p class="desc">행복의 씨앗</p>
					<p class="cont">먹거리가 주는 즐거움과<br> 함께 만드는 재미를 느껴요</p>
				</li>
			</ul>
		</div><!-- //expArea -->
		<div class="expProgram">
			<h2>체험 시간표</h2>
			<table class="bbsForm">
				<caption>체험 시간표</caption>
				<tr>
					<th scope="col" colspan="2">구분</th>
					<th scope="col">체험교실 - A동</th>
					<th scope="col">체험교실 - B동</th>
				</tr>
				<tr>
					<th scope="row" rowspan="3">평일</th>
					<td>1교시(10:30~)</td>
					<td>블루베리 크럼블 케이크</td>
					<td rowspan="3">동물쿠키<br>(상시체험)</td>
				</tr>
				<tr>
					<td>2교시(13:00~)</td>
					<td>소시지</td>
				</tr>
				<tr>
					<td>3교시(15:00~)</td>
					<td>찹쌀케이크</td>
				</tr>
				<tr>
					<th scope="col" colspan="2">구분</th>
					<th scope="col">체험교실 - A동</th>
					<th scope="col">체험교실 - B동</th>
				</tr>
				<tr>
					<th scope="row" rowspan="4">주말</th>
					<td>1교시(10:30~)</td>
					<td>블루베리 크럼블 케이크</td>
					<td>소시지</td>
				</tr>
				<tr>
					<td>2교시(13:00~)</td>
					<td>동물쿠키</td>
					<td>소시지</td>
				</tr>
				<tr>
					<td>3교시(15:00~)</td>
					<td>밀크빵</td>
					<td>소시지</td>
				</tr>
				<tr>
					<td>4교시(16:30~)</td>
					<td>-</td>
					<td>찹쌀케이크</td>
				</tr>
			</table>
			<ul class="caution">
				<li>체험교실은 예약제로 운영되며, 체험 진행 상황에 따라 일정이 변경 될 수 있습니다.</li>
				<li>평일 동물쿠키 상시체험은 예약에 따라 현장에서 접수/운영합니다.</li>
				<li>공휴일의 경우 주말 시간표로 운영합니다.</li>
				<li>11월 17, 18, 24, 25일 10:30 블루베리크럼블케이크 체험은 김장체험으로 대체되어 운영됩니다.</li>
			</ul>
			
			<h2>프로그램 상세</h2>
			<div id="programList">
			
			</div>
		</div><!-- //expProgram -->
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
