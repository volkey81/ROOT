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
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("발효공방"));
	
	Param param = new Param(request);

	CraftSchService svc = (new CraftSchService()).toProxyInstance();
	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	Param info = svc.getInfo("003");
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "003");
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

/* 	//금주 생산일정
	$(".schedule ul li a").click(function() {		
		if(!$(this).hasClass("on")) {
			$(this).addClass("on");
		} else {
			$(this).removeClass("on");
		}
		return false;
	});	 */
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
			<p class="brantTopTxt">기다림과 정성으로 만드는 발효공방<span>무농약 콩 & 고창 지역 천일염을 재래방식 그대로 숙성</span></p>
			<div class="type01Cont01">
				<div class="txtArea">
					<img src="/images/brand/workshop/workshop0401.jpg?ver=1" alt="">
					<p>
						<img src="/images/brand/workshop/workshop0403.png" alt="">
						<span>우리 땅에서 기른 재료에 <br>공방장이 돌보는 정성을 더했습니다.<br>시간이 주는 진한 전통 장 맛으로<br>요리를 바꿔보세요!</span>
					</p>
				</div>
				<div class="scheduleArea">
					<div class="schedule">
						<p>금주 생산일정</p>
						<ul>
							<li><span>일</span><a <%=StringUtils.equals("Y", info.get("SUN")) ? "class='on'" : "" %>></a></li>
							<li><span>월</span><a <%=StringUtils.equals("Y", info.get("MON")) ? "class='on'" : "" %>></a></li>
							<li><span>화</span><a <%=StringUtils.equals("Y", info.get("TUE")) ? "class='on'" : "" %>></a></li>
							<li><span>수</span><a <%=StringUtils.equals("Y", info.get("WED")) ? "class='on'" : "" %>></a></li>
							<li><span>목</span><a <%=StringUtils.equals("Y", info.get("THU")) ? "class='on'" : "" %>></a></li>
							<li><span>금</span><a <%=StringUtils.equals("Y", info.get("FRI")) ? "class='on'" : "" %>></a></li>
							<li><span>토</span><a <%=StringUtils.equals("Y", info.get("SAT")) ? "class='on'" : "" %>></a></li>
						</ul>
						<span>시설 견학은 농원운영 시간 내 상시 가능하고 <br>시즌 및 공휴일의 경우 시설이 운휴될 수 있습니다.</span>
					</div>
					<img src="/images/brand/workshop/workshop0402.jpg" alt="">
				</div>
			</div>
			
			<div class="type01Cont02">
				<div class="productSlide">
					<p>주요 제품</p>
					<div class="slideCont">
						<ul>
<%
						if (CollectionUtils.isNotEmpty(imageBoardList)) {
							for (Param row : imageBoardList) {
%>
							<li><a href="<%= "".equals(row.get("url")) ? "#none" : row.get("url") %>"><img src="<%=row.get("THUMB") %>" alt=""></a>
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
				<div class="movieArea">
					<p>공방영상<span>상하농원 발효공방</span></p>
					<iframe width="910" height="512" src="https://www.youtube.com/embed/H5YvbVoLjbc" frameborder="0" allowfullscreen></iframe>
				</div>
			</div>
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					