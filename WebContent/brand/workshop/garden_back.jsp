<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.brand.ImageBoardService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(5));
	request.setAttribute("MENU_TITLE", new String("텃밭정원"));
	
	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "006");
	List<Param> imageBoardList = imageBoard.getList(param);
	
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
$(function(){
	//주요 제품
	efuSlider('.gallerySlide', 1, 0, '', 'once');	
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
		<div class="workshopArea gardenArea">
			<div class="type02Cont01">
				<p class="brantTopTxt">푸른 자연의 힘을 느끼는 텃밭정원<span>무럭무럭 자라는 채소를<br>직접 관찰하고 체험하며, 자연을 느낄 수 있는 공간</span></p>
				<div class="gardenTxt">
					<p><span>시즌 별로 진행되는 다양한 심기체험,<br>수확체험을 통해 우리 아이들에게 먹거리가<br>어떻게 식탁에 오는 지 설명하는<br>교육의 공간입니다.</span></p>
				</div>
			</div>
			
			<!-- <div class="type02Cont02">
				<div class="gallerySlide">
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
				</div><!-- //productSlide-->
				 <ul class="txt">
					<li><span>-</span> 농사 체험 프로그램은 시즌 체험으로 현장 접수만 가능합니다.</li>
					<li><span>-</span> 자세한 체험 관련 내용은 농원 소식을 통해 공지 합니다.</li>
				</ul> 
			</div>
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					