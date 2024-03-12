<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
	if(!"".equals(param.get("r"))) {	// 추천인이 있는 경우
		SanghafarmUtils.setCookie(response, "RECOMMENDER", param.get("r"), fs.getDomain(), 60*60*24*300);
	}
%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("상하가족 가입안내"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
	function showGift() {
<%
	if(fs.isLogin()) {
%>
		showPopupLayer('/popup/gift.jsp', '580');
<%
	} else {
%>
		alert("<%= FrontSession.LOGIN_MSG %>");
		fnt_login();
<%
	}
%>
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<ul id="location">
		<li><a href="/">홈</a></li>
		<li>상하가족</li>
	</ul>
	<div id="container">
	<!-- 내용영역 -->
	<div class="familyJoin">
		<div class="bannerArea">
			<img src="/images/familyJoin/banner.jpg" alt="프리미엄 서비스 상하가족 가입안내.상하와 가족이 되다">
			<div class="txt">
				<p>"상하가족 혜택 리뉴얼로 혜택이 변경됐습니다.<br>신규로 상하가족을 가입하실 회원은 상하가족 가입하기 페이지로 이동하여 혜택을 꼼꼼히 확인하셔서 가입바랍니다."</p>
				<a href="/familyJoin2018/index.jsp" class="btnTypeA sizeL">상하가족 가입하기 이동</a>
			</div>
		</div>
	</div> 
	

	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>

</html>