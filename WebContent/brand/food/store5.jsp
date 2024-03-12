<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.brand.ImageBoardService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(5));
	request.setAttribute("MENU_TITLE", new String("파머스마켓"));
	
	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "011");
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
		<div class="foodArea foodArea2">
			<div class="foodHead foodHead2 bg05">
				<p>도시와 농촌의 만남, 파머스 마켓
					<span>지역 농민들이 직접 농사지은 채소와 과일, 고창 특산물까지</span>
				</p>
			</div>
			<div class="timeType01">
				<div class="timeInfo">
					<span><img src="/images/brand/food/food0502.jpg" alt=""></span>
					<div class="time type05" >
						<strong class="timeTit">운영시간</strong>
						<strong class="timeTxt">연중무휴 09:30 ~ 18:00</strong>
						<p><span>-</span> 온라인을 통해 더욱 편리하게 구매할 수 있습니다.</p>
						<a href="http://www.sanghafarm.co.kr/main.jsp">온라인 쇼핑몰 가기 ▶</a>
					</div>	
				</div>			
			</div>	
			<!--<div class="foodSlide2">
				 <div class="productSlide">
					<p>주요 제품</p>
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
					</div><!-- //slideCont 
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
				</div><!-- //productSlide 
			</div>	-->	
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					