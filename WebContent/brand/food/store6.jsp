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
	request.setAttribute("Depth_3", new Integer(6));
	request.setAttribute("MENU_TITLE", new String("브랜드샵"));
	
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
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=aac914a149713573a41e8d4cc725b63c "></script>
<script>
$(function(){
	//주요 제품
	efuSlider('.productSlide', 1, 0, '', 'once');	
	
	var mapArr = [[37.56504, 126.98184],[37.65512, 127.06108], [37.51229,127.09857], [36.81956,127.15671], [37.52937,126.91785]];
	
	var mapBox = $('.mapBox');
	$('.mapBox').each(function(index){
		var options = {
			center: new daum.maps.LatLng(mapArr[index][0], mapArr[index][1]),
			level: 3
		};
		var map = new daum.maps.Map(this, options);
		
		// 버튼을 클릭하면 아래 배열의 좌표들이 모두 보이게 지도 범위를 재설정합니다 
		var points = [
		    new daum.maps.LatLng(mapArr[index][0], mapArr[index][1])
		];

		// 지도를 재설정할 범위정보를 가지고 있을 LatLngBounds 객체를 생성합니다
		var bounds = new daum.maps.LatLngBounds();    

		var i, marker;
		for (i = 0; i < points.length; i++) {
		    marker =   new daum.maps.Marker({ position : points[i] });
		    marker.setMap(map);
		    
		    bounds.extend(points[i]);
		}

		function setBounds() {
		    // LatLngBounds 객체에 추가된 좌표들을 기준으로 지도의 범위를 재설정합니다
		    // 이때 지도의 중심좌표와 레벨이 변경될 수 있습니다
		    map.setBounds(bounds);
		}
	});
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
			<div class="foodArea foodArea3">
				<div class="foodHead">
					<p>도시에서 상하농원을 만나요
						<span>상하공방 제품과 자연의 먹거리를 가까이서 만나보세요</span>
					</p>
				</div>
				<h3>상하 브랜드샵</h3>
				<div class="timeType03">
					<div class="leftArea">
						<div class="location">롯데 본점 (B1)</div>
						<div class="imgBox">
							<img src="/images/brand/food/food0601.jpg" alt="">
						</div>
					</div>
					<div class="rightArea">
						<div class="mapBox mapBox_1"></div>
						<div class="time type03" >
							<strong class="timeTit">운영시간</strong>
							<div class="timeTxt">
								<ul class="line">
									<li><span>월요일</span>10:30~20:00 (연장시 20:30)</li>
									<li><span>화수목</span>10:30~20:00</li>
									<li><span>금토일</span>10:30~20:30</li>
								</ul>
							</div>
						</div>	
					</div>
				</div>	
				<div class="timeType03">
					<div class="leftArea">
						<div class="location">롯데 노원점 (B1)</div>
						<div class="imgBox mapBox_2">
							<img src="/images/brand/food/food0602.jpg" alt="">
						</div>
					</div>
					<div class="rightArea">
						<div class="mapBox"></div>
						<div class="time type03" >
							<strong class="timeTit">운영시간</strong>
							<div class="timeTxt">
								<ul class="line">
									<li><span>월요일</span>10:30~20:00 (연장시 20:30)</li>
									<li><span>화수목</span>10:30~20:00</li>
									<li><span>금토일</span>10:30~20:30</li>
								</ul>
							</div>
						</div>	
					</div>
				</div>	
				<div class="timeType03">
					<div class="leftArea">
						<div class="location">롯데 잠실점 (B1)</div>
						<div class="imgBox">
							<img src="/images/brand/food/food0603.jpg" alt="">
						</div>
					</div>
					<div class="rightArea">
						<div class="mapBox mapBox_3"></div>
						<div class="time type03" >
							<strong class="timeTit">운영시간</strong>
							<div class="timeTxt">
								<ul class="line">
									<li><span>월요일</span>10:30~20:00 (연장시 20:30)</li>
									<li><span>화수목</span>10:30~20:00</li>
									<li><span>금토일</span>10:30~20:30</li>
								</ul>
							</div>
						</div>	
					</div>
				</div>	
				<h3>상하목장 아이스크림 샵</h3>
				<div class="timeType03">
					<div class="leftArea">
						<div class="location">아우리 시네마점</div>
						<div class="imgBox">
							<img src="/images/brand/food/food0604.jpg" alt="">
						</div>
					</div>
					<div class="rightArea">
						<div class="mapBox mapBox_4"></div>
						<div class="time type03" >
							<strong class="timeTit">운영시간</strong>
							<div class="timeTxt">
								<ul class="line">
									<li><span style="width:124px;">월~일(공휴일)</span>10:30~21:30</li>
								</ul>
							</div>
						</div>	
					</div>
				</div>	
				<h3>로드샵</h3>
				<div class="timeType03">
					<div class="leftArea">
						<div class="location">현대카드 카페&amp;펍</div>
						<div class="imgBox">
							<img src="/images/brand/food/food0605.jpg" alt="">
						</div>
					</div>
					<div class="rightArea">
						<div class="mapBox mapBox_5"></div>
						<div class="time type03" >
							<strong class="timeTit">운영시간</strong>
							<div class="timeTxt">
								<ul class="line">
									<li><span style="width:108px;">주중</span>7:30~20:00</li>
									<li><span style="width:108px;">주말, 공휴일</span>미운영</li>
								</ul>
								<ul class="comments">
									<li>일반구매 가능합니다.</li>
									<li>신용카드는 현대카드만 결제 가능하며, 현대카드 포인트 사용 가능합니다.</li>
								</ul>
							</div>
						</div>	
					</div>
				</div>
			</div>
			
			<!-- //내용영역 -->
			</div><!-- //container -->
			<jsp:include page="/include/footer.jsp" /> 
		</div><!-- //wrapper -->
	</body>
</html>
					