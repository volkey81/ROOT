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

	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
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
<jsp:include page="/mobile/include/head.jsp"/> 
</head>  
<body>

<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="village">
		<!-- 내용영역 -->
		<h2 class="animated fadeInUp delay02"><%=MENU_TITLE %></h4>
		<div class="offerDetail">
			<h3 class="animated fadeInUp delay04"><%= info.get("pnm") %></h3>
			<div class="info animated fadeInUp delay06">
				<p class="thumb"><img src="<%= info.get("mo_img") %>" alt=""></p>
				<dl>
					<dt>객실구성</dt>
					<dd><%= info.get("room_comp") %>
<%
	if(!"".equals(info.get("mo_url"))) {
%>
						<br><a href="<%= info.get("mo_url") %>" target="_blank">상세보기</a>
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
					<dt class="long">제공사항</dt>
					<dd class="long"><%= info.get("provide") %></dd>
				</dl>
			</div><!-- //info -->
			<%--<h4><span>DETAIL</span></h4>--%>
			<div class="detail">
				<%= info.get("mcontents") %>
			</div>
			<h4><span>SPECIAL OFFER</span></h4>
			<div class="promotion">
				<div class="slideCont">
					<ul class="swiper-wrapper">
<%
	for(Param row : list) {
%>
						<li class="swiper-slide"><a href="detail.jsp?pid=<%= row.get("pid") %>&gubun=<%= gubun %>">
							<img src="<%= row.get("mo_list_img") %>" alt="">
							<div class="cont">
								<p class="tit"><%= row.get("pnm") %></p>
								<p class="price"><%= Utils.formatMoney(row.get("min_price")) %>원 ~</p>
							</div>
						</a></li>
<%
	}
%>
					</ul>
				</div>
			</div><!-- //promotion -->
			<div class="btnArea fixedBtn">
				<a href="#" onclick="showReserLayer(); return false" class="btnStyle01">예 약 하 기</a>
			</div>
		</div><!-- //offerDetail -->
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<div class="bgLayer"></div>
<div class="popReserLayer">
</div><!-- //예약하기 -->
<div class="loginLayer popLayer">
	<h2>로그인 안내</h2>
	<p class="text">상하농원 회원에게만 제공되는 스페셜오퍼 혜택, <br>지금 로그인하시고 예약을 완료하세요.</p>
	<p class="btn"><a href="#" onclick="goLogin(); return false" class="btnStyle03 sizeS">로그인 후 예약하기</a></p>
	<p class="text2">아직 회원이 아니세요? 지금 가입하시고 <br>스페셜오퍼를 포함한 다양한 혜택을 누려보세요.</p>
	<ul class="caution">
		<li>다양한 상품구매와 함께 쿠폰할인 혜택을 받으실 수 있습니다.</li>
		<li>회원전용의 다양한 서비스! 상품평, 이벤트 참여가 가능합니다.</li>
		<li>회원 가입을 하시면, 상하농원을 포함한 매일유업㈜의 매일 family 통합회원 온라인 서비스도 함께 이용하실 수 있습니다.</li>
	</ul>
	<p class="btn"><a href="#" onclick="goJoin(); return false" class="btnStyle03 sizeS">회원가입</a></p>
	<p class="close"><a href="#" onclick="hideLoginLayer(this); return false">닫기</a></p>
</div><!-- //로그인안내 -->
<script>
var promoSwiper = new Swiper ('.promotion .slideCont', {
	slidesPerView:'auto',
	spaceBetween: 5,
});

var hiddenScrollPoint;
function showReserLayer(){
	hiddenScrollPoint = $(window).scrollTop();
	$(".popReserLayer").append('<div class="layer">'
		+ ' <iframe src="/mobile/hotel/offer/reservation.jsp?pid=<%= pid %>" id="reserveFrame" width="100%" height="100%" frameborder="0" allowTransparency="true" scrolling="yes" id="popupLayer"></iframe>'
		+ '</div>'
		+ ' <p class="close"><a href="#" onclick="hideReserLayer(); return false"><img src="/mobile/images/btn/btn_close6.png" alt="닫기"></a></p>');     
	$("html, body").addClass("oh");
	$(".popReserLayer .layer iframe").height($(window).height());
	$(".popReserLayer").show();
}
function hideReserLayer(){
	$("html, body").removeClass("oh").scrollTop(hiddenScrollPoint)
	$(".popReserLayer .layer, .popReserLayer .close").remove();
	$(".popReserLayer").hide();
}
function hideLoginLayer(obj){
	$(obj).parents('.popLayer').hide().removeClass("on");
	$(".bgLayer").hide();
}
<%
	if("offerReserLayer".equals(request.getParameter("direct"))){ 
%>
	showReserLayer()
<%
	}
%>

function goLogin() {
	$('#reserveFrame').get(0).contentWindow.goLogin();
}

function goJoin() {
	$('#reserveFrame').get(0).contentWindow.goJoin();
}

</script>
</body>
</html>