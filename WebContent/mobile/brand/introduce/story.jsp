<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("Depth_4", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("상하농원은"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
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
		<div class="storyWrap">
			<img src="/mobile/images/brand/introduce/story/visual.jpg" alt="" style="width:100%;">
			<div class="handTxt">
				<strong><img src="/mobile/images/brand/introduce/story/stamp.png" alt="상하농원" height="86"></strong>
				<img src="/mobile/images/brand/introduce/story/letter.gif" alt="도시에 살고있는 우리에게 거리마다 가득찬 식다으이 화려한 음식과 슈퍼마켓에 진열되어 잇는 수많은 인스턴트 식품은 어머니가 해주신 한 그릇의 따뜻한 된장찌개 보다 익숙합니다. 넘쳐나는 먹거리 속에 담긴 우리의 불안은 이 잃어 버린 멀건 된장찌개에서 비롯된 것은 아닐까요? 쌀이 슈퍼마켓에서 나온다는 우리 아이들에게 먹거리에 대한 소중함과 어머니의 맛을 알려주기 위해 저희는 상하를 찾았고, 마을을 꾸렸습니다. 사계절, 이십사절기 풍요로운 자연에 순응하고 안심할 수 있는 건강한 먹거리를 생산하며 된장찌개 한 그릇의 소박한 즐거움을 누리며 살아가는 상하온원 젊은 농부 한사람, 한사람의 마음을 그대로 담아 여러분들께 전달하는 그 날까지."  style="width:100%;">
			</div>
			
			<div class="keywordArea">
				<div class="section">
					<strong><img src="/mobile/images/brand/introduce/story/tit_keyword1.png" alt="짓다"></strong>
					<p class="copy">비옥한 우리의 땅에서<br>미래의 농업을 만듭니다.</p>
					<p class="txt">사계절을 거스르지 않는 농촌의 가치가<br>
						더 건강한 우리 먹거리를 만든다고 믿기에 <br>
						농민과 함게 새로운 농업을 만들고, 더 많은<br>
						아이들이 우리의 땅을 체험하도록 합니다.</p>
				</div><!-- //section -->
				<div class="section">
					<strong><img src="/mobile/images/brand/introduce/story/tit_keyword2.png" alt="놀다"></strong>
					<p class="copy">자연과 사람이 함께하는<br>즐거움을 전합니다.</p>
					<p class="txt">지친 일상에 소중한 사람과 함께하는<br> 
						즐거움을 잊진 않았나요.<br>
						건강하고 맛있는 한끼, 동물 친구들과의 교감,<br> 
						따뜻한 온기를 나누는 상하농원에서는 <br>
						사람냄새 나는 소박한 즐거움의 가치를 <br>
						전합니다.</p>
				</div><!-- //section -->
				<div class="section">
					<strong><img src="/mobile/images/brand/introduce/story/tit_keyword3.png" alt="먹다"></strong>
					<p class="copy">건강한 생산을 통해<br>먹거리의 가치를 높입니다.</p>
					<p class="txt">신선한 원재료, 가공과정을 최소화하는<br> 
						바른 생산 원칙을 준수하여 제품을 생산합니다.<br>
						공방 견학과 먹거리 가공 체험을 통해 <br>
						올바른 먹거리의 가치를 소비자와 공유합니다.</p>
				</div><!-- //section -->
			</div>
		</div>	
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					