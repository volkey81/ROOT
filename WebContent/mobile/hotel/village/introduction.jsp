<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.board.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("소개"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	PopupService popup = new PopupService();
	List<Param> popupList = popup.getList(new Param("device", "M", "position", "C"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp"/>  
</head>  
<body>

<div id="wrapper" class="hotel">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="styleA introductionWrap">
		<!-- 내용영역 -->
		<div class="introduction">
			<h2 class="animated fadeInUp delay02">소개</h2>
			<div class="cont">
				<img src="/mobile/images/hotel/village/introduction.jpg" alt="">	
				<div class="txtArea">
					<p class="tit "><img src="/mobile/images/hotel/village/introductionTit.png" alt="농원에서 온 편지"></p>
					<p class="txt animated fadeInUp delay04">안녕하세요. 자연의 건강함을 전하는 상하농원입니다.</p>
					<p class="txt animated fadeInUp delay06">우리 아이들에게 농촌의 가치와 먹거리에 대한 소중함을<br>
					알려주고자 했던 저희는 농원을 찾아주시는 많은 손님들이 <br>
					편히 쉬어가실 수 있도록 자연에서 얻은 나무와 돌로 농원의<br>
					큰 헛간을 개조하여 작은 텃밭과 테라스가 있는 소박하지만<br>
					따뜻한 공간을 만들었습니다.</p>
					<p class="txt animated fadeInUp delay08">좋은 사람들과 자연속에서 즐기는 건강한 한 끼 식사, <br>
					밤하늘의 별을 볼 수 있는 작은 창이 있는 방.<br>
					푸르른 대지와 농촌의 풍경을 담아 잊지 못할 결혼식을 <br>
					할 수 있는 상하농원 농부들의 정성과 손길이 닿은 <br>
					파머스빌리지에서 청정한 자연 속의 팜스테이를 즐겨보세요.</p>
					<p class="txt animated fadeInUp delay10">바쁘고 지친 일상에서 벗어나 자연을 누릴 수 있는<br>
					파머스빌리지로 여러분을 초대합니다.</p>
				</div>
			</div>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>