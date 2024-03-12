<%@page import="com.sanghafarm.service.brand.ImageBoardService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("농원식당"));
	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "008");
	List<Param> imageBoardList = imageBoard.getList(param);
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
$(function(){
	//주요 제품
	efuSlider('.productSlide', 1, 0, '', 'once');	
});	
</script>
</head>  
<body class="foodWrapper">
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="foodArea">
			<div class="foodHead bg02">
				<p>지리산이 키운 우리 흑돼지 '버크셔 K'로 즐기는 푸짐한 바비큐 구이
					<span>직접 구워먹는 고기구이부터 특제 간장게장까지! 제철 식재료로 신선하게!</span>
				</p>
			</div>
			<div class="timeType01">
				<div class="timeInfo">
					<span><img src="/images/brand/food/food0203.jpg" alt=""></span>
					<div class="time type02">
						<strong class="timeTit">운영시간</strong>
						<strong class="timeTxt timeTxt2">화 ~ 일요일 : 11:00 ~ 21:00<br>(월요일 휴점)</strong>
						<p style="top:107px;"><span>-</span> 개인 단체 예약은 최소 1주일 전 유선으로 문의 바랍니다.<br><span>-</span> 돌잔치 등 연회 단체 예약 가능</p>
						<a href="/images/brand/food/restaurant.pdf" target="_blank">메뉴판 다운로드 ▶</a>
						<!-- <a href="menuPop.html" target="_blank">메뉴판 보기 ▶</a> -->
						<!-- <a href="popMenu.jsp" onclick="window.open(this.href, 'menu', 'width=817px,height=600px,scrollbars=yes'); return false">메뉴판 다운로드 ▶</a> -->
					</div>	
				</div>			
			</div>	
			<div class="foodSlide">
				<div class="productSlide">
					<p>주요 메뉴<span>* 상기 메뉴는 상황에<br>따라 다를 수 있습니다.</span></p>
					<div class="slideCont">
						<ul>
<%
						if (CollectionUtils.isNotEmpty(imageBoardList)) {
							for (Param row : imageBoardList) {
%>
							<li><img src="<%=row.get("THUMB") %>" alt="">
								<span class="tit"><%=row.get("TITLE") %></span>
							</li>
<%
							}
						}							
%>
						</ul>
					</div><!-- //slideCont -->
<%
						if (CollectionUtils.isNotEmpty(imageBoardList)) {
							if (imageBoardList.size() > 3) {
%>
					<input type="image" src="/images/btn/btn_prev3.png" alt="이전달" class="prev">
					<input type="image" src="/images/btn/btn_next3.png" alt="다음달" class="next">
<%					
							}
						}
%>
				</div><!-- //productSlide -->	
				<!-- <div class="gallerySlide">
				<%
				if (CollectionUtils.isNotEmpty(imageBoardList)) {
				%>
					<div class="slideCont">
						<ul>
<%
						
							for (Param row : imageBoardList) {
%>
							<li><img src="<%=row.get("IMG") %>" alt="">
							</li>
<%
							}
													
%>
						</ul>
					</div><!-- //slideCont 
<%
				}
						if (CollectionUtils.isNotEmpty(imageBoardList)) {
							if (imageBoardList.size() > 3) {
%>
					<input type="image" src="/images/btn/btn_prev4.jpg" alt="이전달" class="prev">
					<input type="image" src="/images/btn/btn_next4.jpg" alt="다음달" class="next">
<%					
							}
						}
%>
				</div><!-- //gallerySlide -->	
			</div>		
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					