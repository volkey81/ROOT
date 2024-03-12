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
	request.setAttribute("Depth_3", new Integer(5));
	request.setAttribute("MENU_TITLE", new String("젖소목장"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "013");
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
		<div class="playArea organic">
			<p class="brantTopTxt" style="padding-bottom:30.2%">행복한 소들의 보금자리,<br>상하농원 젖소 목장</p>
			<div class="txtArea">
				<img src="/mobile/images/brand/play/organic02.jpg" alt="">
				<p>젖소 초지, 2급수 이상의 마실 물.<br>행복한 소들이 함께하는 공간</p>	
			</div>
			<!-- <div class="playSlide">
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
				</div><!-- //gallerySlide
				<div class="slideTxt">
					<p><span>-</span> 농사 체험 프로그램은 시즌 체험으로 현장 접수만 가능합니다.</p>
					<p><span>-</span> 자세한 체험 관련 내용은 농원 소식을 통해 공지 합니다.</p>
				</div>	
			</div> -->
			
			<div class="playTime">
				<strong>동물교감체험-젖소목장</strong>
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
						<td>1교시(09:30)</td>
						<td>1교시(11:30)</td>
						<td>2교시(13:30)</td>
						<td>3교시(15:30)</td>
					</tr>
					<tr>
						<th scope="col"><strong>프로그램</strong></th>
						<td>송아지우유주기</td>
						<td>송아지우유주기</td>
						<td>송아지우유주기</td>
						<td>송아지우유주기</td>
					</tr>
				</table>
				<ul>
					<!--<li><span>-</span> 동물교감 체험은 입장 시 무료로 진행됩니다.</li>-->
					<li><span>-</span> 별도 예약은 불가하며, 현장에서 선착순으로 운영됩니다.</li>
				</ul>
			</div>
		</div>		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					