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
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("파머스카페 상하"));

	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "009");
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
			<div class="foodHead bg03">
				<p>신선한 우유와 엄선한 원두의 파머스카페 상하<span>목장을 바라보며 즐기는 자연속의 여유</span></p>
			</div>
			<div class="timeType01">
				<div class="timeInfo">
					<span><img src="/images/brand/food/food0303.jpg" alt=""></span>
					<div class="time type03">
						<strong class="timeTit">운영시간</strong>
						<strong class="timeTxt">연중무휴 09:30 ~ 18:00</strong>
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
					