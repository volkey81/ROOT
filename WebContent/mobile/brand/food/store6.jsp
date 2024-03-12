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
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
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
<jsp:include page="/mobile/include/head.jsp" /> 
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=aac914a149713573a41e8d4cc725b63c "></script>
<script>
$(function(){
	//주요 제품
	var pSwiper = new Swiper($(".productSlide"), {
		slidesPerView: 'auto',
		slidesPerGroup: 2,
		onSlideChangeEnd: function(swiper){	
			var idx = swiper.activeIndex;
		}
	});
	
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
		<jsp:include page="/mobile/include/header.jsp" />
		<div id="container">
		<!-- 내용영역 -->
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<div class="foodArea store6">
				<div class="foodHead">
					<p>도시에서 상하농원을 만나요
						<span>상하공방 제품과 자연의 먹거리를<br>가까이서 만나보세요</span>
					</p>
				</div>
				<h2>상하 브랜드샵</h2>
				<div class="timeType03">
					<div class="imgBox">
						<div class="location">롯데 본점<br><span>롯데백화점 본점(B1)</span></div>
						<img src="/mobile/images/brand/food/food0601.jpg" alt="">
					</div>
					<div class="info">
						<div class="address">서울특별시 중구 을지로 30<br><span>지번</span> 서울특별시 중구 소공동 1</div>
						<div class="mapBox mapBox_1"></div>
						<div class="time type03" >
							<strong class="timeTit">운영시간</strong>
							<ul class="timeTxt">
								<li><span>월요일</span><span>10:30~20:00<br>(연장시 20:30)</span></li>
								<li><span>화수목</span><span>10:30~20:00</span></li>
								<li><span>금토일</span><span>10:30~20:30</span></li>
							</ul>
						</div>	
					</div>				
				</div>	
				<div class="timeType03">
					<div class="imgBox">
						<div class="location">롯데 노원점<br><span>롯데백화점 노원점(B1)</span></div>
						<img src="/mobile/images/brand/food/food0602.jpg" alt="">
					</div>
					<div class="info">
						<div class="address">서울특별시 노원구 동일로 1414<br><span>지번</span> 서울특별시 노원구 상계동 713</div>
						<div class="mapBox mapBox_2"></div>
						<div class="time type03" >
							<strong class="timeTit">운영시간</strong>
							<ul class="timeTxt">
								<li><span>월요일</span><span>10:30~20:00<br>(연장시 20:30)</span></li>
								<li><span>화수목</span><span>10:30~20:00</span></li>
								<li><span>금토일</span><span>10:30~20:30</span></li>
							</ul>
						</div>	
					</div>				
				</div>		
				<div class="timeType03">
					<div class="imgBox">
						<div class="location">롯데 잠실점<br><span>롯데백화점 잠실점(B1)</span></div>
						<img src="/mobile/images/brand/food/food0603.jpg" alt="">
					</div>
					<div class="info">
						<div class="address">서울특별시 송파구 올림픽로 240<br><span>지번</span> 서울특별시 송파구 잠실동 40-1</div>
						<div class="mapBox mapBox_3"></div>
						<div class="time type03" >
							<strong class="timeTit">운영시간</strong>
							<ul class="timeTxt">
								<li><span>월요일</span><span>10:30~20:00<br>(연장시 20:30)</span></li>
								<li><span>화수목</span><span>10:30~20:00</span></li>
								<li><span>금토일</span><span>10:30~20:30</span></li>
							</ul>
						</div>	
					</div>				
				</div>		
				<h2>상하목장 아이스크림샵</h2>
				<div class="timeType03">
					<div class="imgBox">
						<div class="location">야우리 시네마점<br><span>신세계백화점 충청점(4F)</span></div>
						<img src="/mobile/images/brand/food/food0604.jpg" alt="">
					</div>
					<div class="info">
						<div class="address">충청남도 천안시 동남구 만남로 43<br><span>지번</span> 충청남도 천안시 동남구 신부동 363-2 </div>
						<div class="mapBox mapBox_4"></div>
						<div class="time type03" >
							<strong class="timeTit">운영시간</strong>
							<ul class="timeTxt">
								<li><span style="width:90px;">월~일(공휴일)</span><span>10:30~21:30</span></li>
							</ul>
						</div>	
					</div>				
				</div>		
				<h2>로드샵</h2>
				<div class="timeType03">
					<div class="imgBox">
						<div class="location">현대카드 카페&amp;펍</div>
						<img src="/mobile/images/brand/food/food0605.jpg" alt="">
					</div>
					<div class="info">
						<div class="address">서울특별시 영등포구 의사당대로 3<br><span>지번</span> 서울특별시 영등포구 여의도동 15-21</div>
						<div class="mapBox mapBox_5"></div>
						<div class="time type03" >
							<strong class="timeTit">운영시간</strong>
							<ul class="timeTxt">
								<li><span>주중</span><span>7:30~20:00</span></li>
								<li>주말, 공휴일 미운영</li>
							</ul>
						</div>	
						<ul class="comments">
							<li>일반구매 가능합니다.</li>
							<li>신용카드는 현대카드만 결제 가능하며,<br>현대카드 포인트 사용 가능합니다.</li>
						</ul>
					</div>				
				</div>				
			</div>		
		<!-- //내용영역 -->
		</div><!-- //container -->
		<jsp:include page="/mobile/include/footer.jsp" /> 
	</div><!-- //wrapper -->
</body>
</html>
					