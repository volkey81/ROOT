<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.member.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("MENU_TITLE", new String("객실 검색"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	AddrBookService addr = (new AddrBookService()).toProxyInstance();
	
	//페이징 변수 설정
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("userid", fs.getUserId());
	
	//게시물 리스트
	List<Param> list = addr.getList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<div class="noRoom">
			<p class="txt">선택하신 날짜의<br>숙박 가능한 객실이 없습니다.</p>
			<div class="btnArea">
				<a href="#none" onclick="hidePopupLayer(); return false" class="btnStyle01">확인</a>
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