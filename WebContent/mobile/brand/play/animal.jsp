<%@page import="com.sanghafarm.service.brand.ImageBoardService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("동물농장"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");

	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "004");
	List<Param> imageBoardList = imageBoard.getList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
$(function(){
	//주요 제품
	var fSwiper = new Swiper($(".playSlide .slideCont"), {
		slidesPerView: 1,
        spaceBetween: 15,		
		prevButton: $(".playSlide .prev"),
		nextButton: $(".playSlide .next")
	});
});	
</script>
</head>  
<body class="playWrapper">
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="playArea animal">
			<p class="brantTopTxt">동물들과 직접 교감하는 동물농장<span>상하농원의 귀염둥이들을 한 곳에서!</span></p>
			<div class="txtArea">
				<img src="/mobile/images/brand/play/animal02.jpg" alt="">
				<p>직접 먹이도 주고,<br>만져 볼 수 있는 인기 만점 동물농장<br>매일 산책을 즐기는 미니돼지 '봉자'와<br>태양을 피하고 싶은 면양 '양군'이 인기스타</p>	
			</div>
			<div class="playSlide">
				<div class="gallerySlide">
<%
	if (CollectionUtils.isNotEmpty(imageBoardList)) {
%>
					<div class="slideCont">
						<ul class="swiper-wrapper">
<%
						
		for (Param row : imageBoardList) {
%>
							<li class="swiper-slide"><img src="<%=row.get("IMG") %>" alt=""></li>
<%
		}
													
%>
						</ul>
					</div>
<%
	}
	if (CollectionUtils.isNotEmpty(imageBoardList)) {
		if (imageBoardList.size() > 2) {
%>
					<div class="control">
						<input type="image" src="/mobile/images/btn/btn_prev4.gif" alt="이전" class="prev">
						<input type="image" src="/mobile/images/btn/btn_next4.gif" alt="다음" class="next">
					</div>		
<%					
		}
	}
%>
				</div><!-- //gallerySlide -->
				<div class="slideTxt">
					<p><span>-</span> 농사 체험 프로그램은 시즌 체험으로 현장 접수만 가능합니다.</p>
					<p><span>-</span> 자세한 체험 관련 내용은 농원 소식을 통해 공지 합니다.</p>
				</div>	
			</div>

			<!-- <div class="playTime">
				<strong>체험 시간표</strong>
				<table>
					<colgroup>
						<col width="20%">
						<col width="20%">
						<col width="20%">
						<col width="20%">
						<col width="20%">
					</colgroup>
					<tr>
						<th scope="col"><strong>시간 <span>(평일/주말)</span></strong></th>
						<td>1교시<br>(11:30)</td>
						<td>2교시<br>(12:30)</td>
						<td>3교시<br>(14:00)</td>
						<td>4교시<br>(15:00)</td>
					</tr>
					<tr>
						<th scope="col"><strong>프로그램 <span>(동물농장)</span></strong></th>
						<td>건초<br>먹이주기</td>
						<td>송아지<br>우유주기</td>
						<td>건초<br>먹이주기</td>
						<td>송아지<br>우유주기</td>
					</tr>
				</table>
				<ul>
					<li><span>-</span> 동물농장 체험은 입장 시 무료로 진행됩니다.</li>
					<li><span>-</span> 별도 예약은 불가하며, 현장에서 선착순으로 운영됩니다.</li>
				</ul>
			</div> -->
			
				
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					