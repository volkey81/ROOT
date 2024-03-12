<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.service.brand.ImageBoardService"%>
<%@page import="com.sanghafarm.service.brand.CraftSchService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(8));
	request.setAttribute("MENU_TITLE", new String("치즈공방"));
	
	Param param = new Param(request);

	CraftSchService svc = (new CraftSchService()).toProxyInstance();
	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	Param info = svc.getInfo("016");
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "016");
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

 	//금주 생산일정
	$(".schedule ul li a").click(function() {		
		if(!$(this).hasClass("on")) {
			$(this).addClass("on");
		} else {
			$(this).removeClass("on");
		}
		return false;
	});
});	
</script>
</head>  
<body class="workshopWrapper">
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="workshopArea">
			<p class="brantTopTxt">자연 그대로, 건강하고 풍부한 맛을 선사하는 치즈 공방<span>1989년부터 쌓아온 장인의 노하우를 담은 최고급 치즈</span></p>
			<div class="type01Cont01">
				<div class="txtArea">
					<img src="/images/brand/workshop/workshop0801.jpg" alt="">
					<p>
						<img src="/images/brand/workshop/workshop0803.png" alt="">
						<span>보존료와 인공첨가물 없이<br>깨끗하게 선별된<br>국내산 1A등급 원유만을 사용해<br>더 건강한 치즈를 맛보세요!</span>
					</p>
				</div>
				<div class="scheduleArea">
					<div class="schedule">
						<p>매일유업 상하공장 견학 가능일정</p>
						<ul>
							<li><span>일</span><a <%=StringUtils.equals("Y", info.get("SUN")) ? "class='on'" : "" %>></a></li>
							<li><span>월</span><a <%=StringUtils.equals("Y", info.get("MON")) ? "class='on'" : "" %>></a></li>
							<li><span>화</span><a <%=StringUtils.equals("Y", info.get("TUE")) ? "class='on'" : "" %>></a></li>
							<li><span>수</span><a <%=StringUtils.equals("Y", info.get("WED")) ? "class='on'" : "" %>></a></li>
							<li><span>목</span><a <%=StringUtils.equals("Y", info.get("THU")) ? "class='on'" : "" %>></a></li>
							<li><span>금</span><a <%=StringUtils.equals("Y", info.get("FRI")) ? "class='on'" : "" %>></a></li>
							<li><span>토</span><a <%=StringUtils.equals("Y", info.get("SAT")) ? "class='on'" : "" %>></a></li>
						</ul>
						<span>상하농원의 자연 치즈가 만들어지는 과정을 직접 견학 해보세요!</span>
						<a href="/brand/play/reservation/admission.jsp" class="btn">견학 예약하기</a>
					</div>
					<img src="/images/brand/workshop/workshop0802.jpg" alt="">
				</div>
			</div>
			
			<div class="type01Cont02">
				<div class="productSlide">
					<p>주요 제품</p>
<%
						if (CollectionUtils.isNotEmpty(imageBoardList)) {
%>					
					<div class="slideCont">
						<ul>
<%
							for (Param row : imageBoardList) {
%>
							<li><a href="<%= "".equals(row.get("url")) ? "#none" : row.get("url") %>"><img src="<%=row.get("THUMB") %>" alt=""></a>
								<span class="tit"><%=row.get("TITLE") %></span>
							</li>
<%
							}
%>
						</ul>
					</div><!-- //slideCont -->
<%
						} else {
%>
					<div class="noData"><img src="/images/brand/workshop/workshop0704.jpg" alt=""></div>
<%
						}
%>					
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
				<!-- <div class="movieArea">
					<p>공방영상<span>상하농원 발효공방</span></p>
					<iframe width="910" height="512" src="https://www.youtube.com/embed/H5YvbVoLjbc" frameborder="0" allowfullscreen></iframe>
				</div> -->
			</div>
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					