<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.hotel.*,
			com.sanghafarm.utils.*,
			org.apache.commons.lang.*" %>
<%
request.setAttribute("Depth_1", new Integer(5));
request.setAttribute("Depth_2", new Integer(6));
request.setAttribute("Depth_3", new Integer(3));
request.setAttribute("MENU_TITLE", new String("프로모션"));
String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");

	Param param = new Param(request);
	HotelPromotionService svc = new HotelPromotionService();
	
	if(StringUtils.isEmpty(param.get("seq"))) {
		Utils.sendMessage(out, "잘못된 접근입니다.");
		return;
	}
	
	Param info = svc.getInfo(param);
	svc.modifyHit(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp"/> 
<script>
$(function (){

})
</script>
</head>  
<body>

<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="village">
		<!-- 내용영역 -->
		<h2 class="animated fadeInUp delay02">프로모션</h2>
		<div class="viewArea">
			<p class="viewTop animated fadeIn delay04"><span class="tit promotionTit"><%= info.get("cate_name") %></span><span class="date"><%= info.get("start_date").substring(0, 10) %> ~ <%= info.get("end_date").substring(0, 10) %></span><br>
				<%= Utils.removeHtmlTag(info.get("title")) %>
			</p>
			<div class="viewTxt animated fadeIn delay06">
				<%= info.get("mobile_contents") %>
			</div>
		</div>
		<div class="btnArea">
			<a href="<%= "".equals(param.backQuery()) ? "list.jsp" : param.backQuery() %>" class="btnStyle01 sizeL">목록</a>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>