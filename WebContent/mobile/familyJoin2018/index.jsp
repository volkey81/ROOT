<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*" %>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("상하가족 가입안내"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
	if(!"".equals(param.get("r"))) {	// 추천인이 있는 경우
		SanghafarmUtils.setCookie(response, "RECOMMENDER2", param.get("r"), fs.getDomain(), 60*60*24*300);
	}
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	function showGift() {
<%
	if(fs.isLogin()) {
%>
		showPopupLayer('/mobile/popup/gift.jsp', '580');
<%
	} else {
%>
		alert("<%= FrontSession.LOGIN_MSG %>");
		fnt_login();
<%
	}
%>
	}
	
	
	$(function(){
		$(".downCont .openBtn").click(function(){
			if(!$(this).parent().hasClass("on")) {
				$(this).parent().addClass("on");
				$(this).parent().next(".cont").slideDown();
			} else {
				$(this).parent().removeClass("on");
				$(this).parent().next(".cont").slideUp();
			}
			return false;
		});
	});

</script>
</head>  
<body>
<div id="wrapper" class="familyJoinWrap">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<!-- <div class="familyJoin">
			<div class="bannerArea">
				<img src="/mobile/images/familyJoin/banner.jpg" alt="프리미엄 서비스 상하가족 가입안내.상하와 가족이 되다">
				<div class="txt">
					<p>상하가족 혜택 리뉴얼로 인해<br>웹사이트/방문현장가입은 일시 중단 됩니다.<br>기존 상하가족 회원은 마이페이지를 통하여<br>혜택 및 사용내역 확인하실 수 있습니다.</p>
					<a href="/mobile/mypage/index.jsp" class="btnTypeA sizeL">마이페이지 이동</a>
				</div>
			</div>
		</div> -->
	<div class="familyJoin familyJoinIndex">
		<img src="/mobile/images/familyJoin/familyJoin01.jpg" alt="프리미엄 서비스 상하가족 가입안내.상하와 가족이 되다">
		<img src="/mobile/images/familyJoin/familyJoin02.jpg" alt="상하가족이란? 01.가입하기, 02.선물선택, 03.사입비 결제, 04혜택누려~">
		<div class="downCont">
			<div class="tit">
				<img src="/mobile/images/familyJoin/familyJoin03_1.jpg" alt="상하가족의 다양한 혜택. 상하 가족이 된다면 즐길 수 있는 다양한 혜택! 이 모든 것을 가입 즉시 바로 누릴 수 있습니다!">
				<a href="#" class="openBtn"></a>
			</div>
			<p class="cont"><img src="/mobile/images/familyJoin/familyJoin03_2.jpg" alt="상하가족의 다양한 혜택. 상하 가족이 된다면 즐길 수 있는 다양한 혜택! 이 모든 것을 가입 즉시 바로 누릴 수 있습니다!"></p>
		</div>
		<div class="downCont">
			<div class="tit">
				<img src="/mobile/images/familyJoin/familyJoin04_1.jpg" alt="상하가족의 다양한 혜택. 상하 가족이 된다면 즐길 수 있는 다양한 혜택! 이 모든 것을 가입 즉시 바로 누릴 수 있습니다!">
				<a href="#" class="openBtn"></a>
			</div>
			<p class="cont"><img src="/mobile/images/familyJoin/familyJoin04_2.jpg" alt="상하가족의 다양한 혜택. 상하 가족이 된다면 즐길 수 있는 다양한 혜택! 이 모든 것을 가입 즉시 바로 누릴 수 있습니다!"></p>
		</div>
		<div class="downCont">
			<div class="tit">
				<img src="/mobile/images/familyJoin/familyJoin05_1.jpg" alt="상하가족의 다양한 혜택. 상하 가족이 된다면 즐길 수 있는 다양한 혜택! 이 모든 것을 가입 즉시 바로 누릴 수 있습니다!">
				<a href="#" class="openBtn"></a>
			</div>
			<p class="cont"><img src="/mobile/images/familyJoin/familyJoin05_2.jpg" alt="상하가족의 다양한 혜택. 상하 가족이 된다면 즐길 수 있는 다양한 혜택! 이 모든 것을 가입 즉시 바로 누릴 수 있습니다!"></p>
		</div>
		
		<div class="btnArea">
			<a href="/mobile/familyJoin2018/agree.jsp" class="joinBtn"><img src="/mobile/images/familyJoin/btn_familyJoin01.png" alt="상하가족 가입하기"></a><br><br>
			<!-- <a href="#p"onclick="showGift(); return false" class="joinBtn"><img src="/mobile/images/familyJoin/btn_familyJoin02.png" alt="상하가족 선물하기"></a> -->
		</div>
	
	</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>