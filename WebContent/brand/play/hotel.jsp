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
	request.setAttribute("Depth_3", new Integer(7));
	request.setAttribute("MENU_TITLE", new String("파머스빌리지"));

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
			<div class="playHead bg01">
				<p>건강한 휴식이 있는 농부의 쉼터, 파머스 빌리지 
					<span>농부의 정성까지 담은 객실과 부대시설로 편안하게!</span>
				</p>
			</div>
			<div class="playType bg04">
				<p>작은 창과 테라스가 있는 객실<br>양떼목장이 내려다보이는 레스토랑<br>250명까지 수용할 수 있는 강당<span>소박한 휴식의 공간에서 여유를 찾아가세요!</span></p>
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
						<td>1교시(11:30)</td>
						<td>2교시(12:30)</td>
						<td>3교시(14:00)</td>
						<td>4교시(15:00)</td>
					</tr>
					<tr>
						<th scope="col"><strong>프로그램 <span>(동물농장)</span></strong></th>
						<td>건초먹이주기</td>
						<td>송아지 우유주기</td>
						<td>건초먹이주기</td>
						<td>송아지 우유주기</td>
					</tr>
				</table>
				<ul>
					<li><span>-</span> 동물농장 체험은 입장 시 무료로 진행됩니다.</li>
					<li><span>-</span> 별도 예약은 불가하며, 현장에서 선착순으로 운영됩니다.</li>
				</ul>
			</div> -->
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
					