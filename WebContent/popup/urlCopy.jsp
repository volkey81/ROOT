<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.product.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("상하가족 추천하기"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script type="text/javascript" src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
	$(function() {
// 		Kakao.init('875eb70060bda09cc2d0a3dfc9998a05');    	
		Kakao.init('b0f34396ce9620b05e6814cac819e2d0');    	
	});

	function sendInvitation() {
    	Kakao.Link.sendDefault({
    		objectType: 'feed',
    		content: {
    			title: "회원가입 시 <%= fs.getUserNm() %>(<%= fs.getUserId() %>) 추천하고 다양한 혜택받아보세요!",
    			description: "무료배송, 온/오프 할인쿠폰, 최대 3% 포인트 적립",
    			imageUrl: 'https://www.sanghafarm.co.kr/images/invitaion.jpg',
    			link: {
    				mobileWebUrl: 'https://www.sanghafarm.co.kr/mobile/event/view.jsp?seq=181&type=view',
    				webUrl: 'https://www.sanghafarm.co.kr/event/view.jsp?seq=181&type=view'
    			}
    		}
    	});
	}
	
</script>
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<div class="urlAddressCopy">
			<p>초대한 친구가 나를 추천인으로 등록하면,<br>다양한 혜택이 제공됩니다.</p>
			<div class="btnArea">
				<button class="btnTypeB sizeL" onclick="sendInvitation()">친구 초대하기</button>
			</div>
		</div>
	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->
<script>
//팝업높이조절
setPopup(<%=layerId%>);
</script>
</body>
</html>

