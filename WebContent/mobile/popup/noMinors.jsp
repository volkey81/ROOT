<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("MENU_TITLE", new String(""));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont" class="noMinors">
	<!-- 내용영역 -->
		<div class="cont">
			<img src="/images/product/adultMark.png" alt="미성년자 제한">
			<p>주류 상품 구매 시 관계 법령에 따라<br><span>19세 이상 본인인증</span>을 거쳐야<br>구매하실 수 있습니다.</p>
			<ul class="caution">
				<li>비회원, SNS회원은 구매하실 수 없습니다.</li>
				<li>19세 이상 정회원만 구매 가능합니다</li>
			</ul>
		</div>
		<div class="btnArea">
			<span><a href="javascript:parent.fnt_login();"; class="btnTypeB sizeL"><span>회원로그인</span></a></span>
			<span><a href="javascript:hidePopupLayer();" class="btnTypeA sizeL"><span>닫기</span></a></span>
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