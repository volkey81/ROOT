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
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("양떼목장"));
	
	Param param = new Param(request);

	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "012");
	List<Param> imageBoardList = imageBoard.getList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
</head>  
<body class="playWrapper">
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="playArea2">
			<div class="playHead bg02">
				<p>흰 털이 복스러운 양들의 양떼목장
					<span>상하농원 대표 운동선수 양들의 보금자리</span>
				</p>
			</div>
			<div class="playType bg02">
				<p>지금은 30마리의 양떼가<br>옹기종기 살고 있는데요,<span>상하농원에 가장 최근에 이사온 식구들입니다.<br>점점 식구를 늘려갈 저희 동물 가족들을 환영해 주실거죠?</span></p>
			</div>
			<div class="playTime">
				<strong>동물교감체험-양떼목장</strong>
				<table>
					<colgroup>
						<col width="20%">
						<col width="20%">
						<col width="20%">
					</colgroup>
					<tr>
						<th scope="col"><strong>시간 <span>(평일/주말)</span></strong></th>
						<td>1교시(11:30)</td>
						<td>2교시(14:00)</td>
					</tr>
					<tr>
						<th scope="col"><strong>프로그램</strong></th>
						<td>건초먹이주기</td>
						<td>건초먹이주기</td>
					</tr>
				</table>
				<ul>
					<li><span>-</span> 동물교감 체험은 입장 시 무료로 진행됩니다.</li>
					<li><span>-</span> 별도 예약은 불가하며, 현장에서 선착순으로 운영됩니다.</li>
				</ul>
			</div>
			
			<!-- <div class="playSlide">
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
					</div>
				</div> -->
				
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					