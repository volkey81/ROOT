<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.hotel.*,
			com.sanghafarm.service.code.*,
			com.sanghafarm.utils.*" %>
<%
	Param param = new Param(request);
	String gubun = param.get("gubun", "W");
	param.set("gubun", gubun);

	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(6));
	request.setAttribute("Depth_3", "W".equals(gubun) ? new Integer(1) : new Integer(2)); //패키지: Depth_3 = 2
	request.setAttribute("MENU_TITLE", "W".equals(gubun) ? new String("Weekly특가") : new String("패키지"));
	
	HotelOfferService svc = new HotelOfferService();

	String pid = param.get("pid");
	svc.increaseViewCnt(pid);
	Param info = svc.getInfo(pid);
	List<Param> list = svc.getList(param);

	if(info == null || "".equals(info.get("pid")) || !"S".equals(info.get("status"))) {
		Utils.sendMessage(out, "현재 판매중인 상품이 아닙니다.");
		return;
	}
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />

</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel">
		<!-- 내용영역 -->		
		<div class="offerDetail">
			<jsp:include page="/hotel/offer/tab.jsp" />
			<h1 class="animated fadeInUp delay04"><%= info.get("pnm") %></h1>
			<div class="info animated fadeInUp delay06">
				<p class="thumb"><img src="<%= info.get("pc_img") %>" alt=""></p>
				<dl>
					<dt>객실구성</dt>
					<dd><%= info.get("room_comp") %>
<%
	if(!"".equals(info.get("pc_url"))) {
%> 
						<br><a href="<%= info.get("pc_url") %>" class="btnTypeA sizeS" target="_blank">상세보기</a>
<%
	}
%>
					</dd>
					<dt>객실크기</dt>
					<dd><%= info.get("room_size") %></dd>
					<dt>침대타입</dt>
					<dd><%= info.get("bed_type") %></dd>
					<dt>기준정원/최대정원</dt>
					<dd><%= info.get("capa") %>/<%= info.get("max_capa") %></dd>
					<dt>제공사항</dt>
					<dd><%= info.get("provide") %></dd>
				</dl>
				<p class="btn"><a href="#" onclick="showReserLayer(); return false" class="btnTypeB">예약하기</a></p>
			</div><!-- //info -->
			<div class="popReserLayer">
			</div>
			<div class="detail">
				<%= info.get("contents") %>
			</div>
			<!-- <h2><span>DETAIL</span></h2>
			<div class="detail">
				<ul>
					<li><img src="/images/upload/offer3.jpg" alt=""></li>
					<li><img src="/images/upload/offer3.jpg" alt=""></li>
					<li><img src="/images/upload/offer3.jpg" alt=""></li>
				</ul>
				<p class="text">체크인/체크아웃 <span>15:00/11:00</span></p>	
				<p class="text2">툇마루를 연상시키는 테라스에서 나만의 자연을 즐길 수 있는 객실은 청정지역 고창에서 따뜻한 자연 채광을 만끽하며 편안한 휴식을 즐길 수 있습니다.</p>
			</div>//detail
			<h2><span>BENEFIT</span></h2>
			<div class="benefit">
				<ul>
					<li>
						<img src="/images/upload/offer3.jpg" alt="">
						<p class="tit">스파</p>
						<p class="text">자연과 하나되어 즐기는<br>숲 속에서의 재충전</p>
						<p class="more"><a href="">MORE DETAILS</a></p>
					</li>
					<li>
						<img src="/images/upload/offer3.jpg" alt="">
						<p class="tit">헬스케어존</p>
						<p class="text">상하의 건강한 식단과 더불어 누리는<br>운동 밸런스</p>
						<p class="more"><a href="">MORE DETAILS</a></p>
					</li>
					<li>
						<img src="/images/upload/offer3.jpg" alt="">
						<p class="tit">조식뷔페</p>
						<p class="text">상하에서 자란 식재료를 활용한<br>건강한 농부의 밥상</p>
						<p class="more"><a href="">MORE DETAILS</a></p>
					</li>
				</ul>
			</div>//benefit
			<div class="offerDetail offerInfoDetail">
				<h2><span>INFORMATION</span></h2>
				<dl>
					<dt>편의시설</dt>
					<dd>평면LCD TV<br>상하샘물 (2개)<br>파머스빌리지 조식 뷔페<br>상하농원 무료 입장권</dd>
					<dt>어메니티</dt>
					<dd>100% 순면 오리털 이불<br>엑스트라 베드 (유료)</dd>
					<dt>피트니스</dt>
					<dd>
					</dd>
					<dt>추가정보</dt>
					<dd>
					</dd>
				</dl>
			</div> -->
			<h2><span>SPECIAL OFFER</span></h2>
			<div class="promotion">
				<div class="slideCont">
					<ul class="swiper-wrapper">
<%
	for(Param row : list) {
%>
						<li class="swiper-slide"><a href="detail.jsp?pid=<%= row.get("pid") %>&gubun=<%= gubun %>">
							<img src="<%= row.get("pc_list_img") %>" alt="">
							<div class="cont">
								<p class="tit"><%= row.get("pnm") %></p>
								<p class="text"><%= row.get("summary") %></p>
								<p class="price"><%= Utils.formatMoney(row.get("min_price")) %>원 ~</p>
							</div>
						</a></li>
<%
	}
%>
					</ul>
					<input type="image" src="/images/btn/btn_prev11.png" class="prev" alt="이전">
					<input type="image" src="/images/btn/btn_next11.png" class="next" alt="다음">
				</div>
			</div><!-- //promotion -->
			<div class="btnArea">
				<a href="list.jsp" class="btnStyle01">목록</a>
			</div>
		</div><!-- //offerDetail -->
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
<div class="loginLayer popLayer">
	<h2>로그인 안내</h2>
	<p class="text">상하농원 회원에게만 제공되는 스페셜오퍼 혜택, <br>지금 로그인하시고 예약을 완료하세요.</p>
	<p class="btn"><a href="#" onclick="goLogin(); return false" class="btnStyle03">로그인 후 예약하기</a></p>
	<p class="text2">아직 회원이 아니세요? 지금 가입하시고 <br>스페셜오퍼를 포함한 다양한 혜택을 누려보세요.</p>
	<ul class="caution">
		<li>다양한 상품구매와 함께 쿠폰할인 혜택을 받으실 수 있습니다.</li>
		<li>회원전용의 다양한 서비스! 상품평, 이벤트 참여가 가능합니다.</li>
		<li>회원 가입을 하시면, 상하농원을 포함한 매일유업㈜의 매일 family 통합회원 온라인 서비스도 함께 이용하실 수 있습니다.</li>
	</ul>
	<p class="btn"><a href="#" onclick="goJoin(); return false" class="btnStyle03">회원가입</a></p>
	<p class="close"><a href="#" onclick="hideLoginLayer(this); return false">닫기</a></p>
</div>
<script src="/js/swiper.min.4.5.1.js"></script>
<script>
var promoSwiper = new Swiper ('.promotion .slideCont', {
	slidesPerView: 3,
	slidesPerGroup: 3,
	spaceBetween: 45,
	loop: true,
	navigation: {
		nextEl: '.promotion .next',
		prevEl: '.promotion .prev',
	}
});

$(".promotion li").on("mouseenter", function(){
	$(this).find(".text, .price").stop().slideDown(200)
	$(this).addClass("on")
}).on("mouseleave", function(){
	$(this).find(".text, .price").stop().slideUp(100)
	$(this).removeClass("on")
})

function showReserLayer(){
	$(".popReserLayer").append('<div class="layer">'
		+ ' <iframe src="/hotel/offer/reservation.jsp?pid=<%= pid %>" id="reserveFrame" width="100%" height="100%" frameborder="0" allowTransparency="true" scrolling="no"></iframe>'
		+ '</div>'
		+ ' <p class="close"><a href="#" onclick="hideReserLayer(); return false"><img src="/images/btn/btn_close10.png?ver=1" alt="닫기"></a></p>'
	);     
	$(".bgLayer").css("height", $(document).height() + "px").show();	
	$(".popReserLayer").show();
}
function hideReserLayer(){
	$(".popReserLayer .layer").remove();
	$(".popReserLayer, .bgLayer").hide();
}
function hideLoginLayer(obj){
	$(obj).parents('.popLayer').hide().removeClass("on");
	$('#reserveFrame')[0].contentWindow.$(".bgLayer").hide();
}

function goLogin() {
	$('#reserveFrame').get(0).contentWindow.goLogin();
}

function goJoin() {
	$('#reserveFrame').get(0).contentWindow.goJoin();
}
</script>
</body>
</html>
