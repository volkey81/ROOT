<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.board.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("체험교실"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	ExpContentService svc = new ExpContentService();

	if("".equals(param.get("seq"))) {
		Utils.sendMessage(out, "잘못된 경로로 접근하였습니다.");
		return;
	}
	
	Param info = svc.getInfo(param.get("seq"));
	List<Param> areaList = svc.getAreaList(param.get("seq"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="expView">
			<div class="intro">
				<div class="head">
					<div class="gallery">
						<div class="slideCont">
							<ul class="list">
								<li id="gallery1"><img src="<%= info.get("image") %>" alt=""></li>
							</ul>
						</div>
						<ul class="nav">
							<!-- cycle.js -->
						</ul>				
					</div><!-- //gallery -->
					<div class="cate"><img src="/images/brand/play/img_tag0<%= info.getInt("exp_gb") %>.jpg" alt="카테고리"></div>
					<h2><%= info.get("exp_type_nm") %></h2>
					<p><%= info.get("summary") %></p>
				</div>
				
				<div class="info">
					<ul class="cont">
						<li>
							<strong>체험 영역</strong>
							<p>
<%
	for(Param row : areaList) {
		if("".equals(row.get("area"))) {
%>
								<span><%= row.get("name2") %></span>
<%
		} else {
%>
								<b><%= row.get("name2") %></b>
<%
		}
	}
%>
							</p>
						</li>
						<li><strong>체험 계절</strong><%= Utils.safeHTML(info.get("season")) %></li>
						<li><strong>체험 시간</strong><%= Utils.safeHTML(info.get("time")) %></li>
						<li><strong>적정 연령</strong><%= Utils.safeHTML(info.get("age")) %></li>
						<li><strong>보호자 동반 여부</strong> 보호자 <%= "N".equals(info.get("protector_yn")) ? "미" : "" %>동반</li>
						<li><strong>알레르기 유발성분</strong><%= Utils.safeHTML(info.get("alergy")) %></li>
					</ul>
				</div>
				<div class="btnArea">
					<a class="btnTypeD sizeL" href="/brand/play/reservation/admission.jsp">예약하기</a>
				</div>
			</div>
			<div class="content">
				<%= info.get("contents")%>
			</div>
			<div class="btnArea">
				<a href="<%= param.backQuery() %>" class="btnTypeB sizeL">목록</a>
			</div>
		</div><!-- //expView -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
var pSwiper = new Swiper($(".gallery .slideCont"), {
	slidesPerView: 1,
	onSlideChangeEnd: function(swiper){	
		var idx = swiper.activeIndex;
		$(".gallery").find(".swiperNav").find("li:eq("+ idx +")").addClass("on").siblings().removeClass("on");
		
	}
});
</script>
</body>
</html>
