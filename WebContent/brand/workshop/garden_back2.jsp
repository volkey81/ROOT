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
	request.setAttribute("Depth_3", new Integer(5));
	request.setAttribute("MENU_TITLE", new String("농부체험"));
	
	Param param = new Param(request);

	CraftSchService svc = (new CraftSchService()).toProxyInstance();
	ImageBoardService imageBoard = (new ImageBoardService()).toProxyInstance();
	
	Param info = svc.getInfo("014");
	
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("status", "S");
	param.set("cate", "014");
	List<Param> imageBoardList = imageBoard.getList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
</head>  
<body class="workshopWrapper">
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="workshopArea gardenArea">
			<div class="type03Cont01">
				<p class="brantTopTxt">매일 먹는 식재료는 어디서 왔을까요?<span>식탁에서 만나는 채소 친구들은 어떻게 자라는지 관찰하고, <br />흙을 만질 수 있는 공간</span></p>
				<div class="gardenTxt">
					<p><span>마늘은<br>어디서 자랄까요?</span></p>
				</div>
			</div>
			<div class="type01Txt01">
				<strong>
					가족농부체험<br />(3~4인)<br />
					<span>94,000 원</span>
				</strong>
				<ul>
					<li><span>ㆍ</span>상하농원 입장료는 체험비와는 별도입니다.</li>
					<li><span>ㆍ</span>농부체험은 농부 체험 및 식사가 포함 된 가격입니다.</li>
					<li><span>ㆍ</span>체험 입장 30분전까지는 농원에 도착하셔야 예약 확인 후, 체험이 가능합니다.</li>
					<li><span>ㆍ</span>체험 3일전까지 취소한 경우에 한해 100% 환불이 가능합니다. (이후 취소수수료 발생)</li>																				
				</ul>
			</div>
			
			<div class="type03Cont02">
				<div class="gardenTxt">
					<p>
						<span>
							<strong>농부체험 1편, 마늘</strong>
							<i>ㆍ일시 : 6월 9일 (토) 11시</i>
							<i>ㆍ준비물 : 어두운 색의 운동화</i>
							<i class="infoTxt">[안내사항]</i>
							<i>ㆍ1가족(3~4인) 기준, 마늘 1접 수확</i>	
						</span>
					</p>
				</div>				
			</div>
			
			<div class="orderInfo" style="background:#dcd5b3;">
				<strong>체험과정 소개</strong>
				<ul>
					<li class="list01">
						<span>STEP 1</span>
						<p>마늘이야기</p>
					</li>
					<li class="list02">
						<span>STEP 2</span>
						<p>트니트니 체조</p>
					</li>
					<li class="list03">
						<span>STEP 3</span>
						<p>마늘을 관찰해요!</p>
					</li>
					<li class="list04">
						<span>STEP 4</span>
						<p>맛있는 식사 시간!</p>
					</li>															
				</ul>
			</div>
			
			<div class="orderBtn">
				<a href="/brand/play/reservation/experience.jsp"><img src="/images/brand/workshop/btn_orderInfo.jpg" alt="" /></a>
			</div>
			</div>
		</div>
		
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					