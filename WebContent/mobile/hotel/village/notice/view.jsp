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
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("문의사항"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");

	Param param = new Param(request);
	HotelNoticeService notice = (new HotelNoticeService()).toProxyInstance();
	
	if(StringUtils.isEmpty(param.get("seq"))) {
		Utils.sendMessage(out, "잘못된 접근입니다.");
		return;
	}
	
	Param info = notice.getInfo(param);
	Param prev = notice.getPrevInfo(param);
	Param next = notice.getNextInfo(param);
	notice.modifyHit(param);
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
		<h2 class="animated fadeInUp delay02">문의사항</h2>
		<div class="viewArea">
			<p class="viewTop animated fadeIn delay04"><span class="tit <%= "001".equals(info.get("cate")) ? "norice" : "pr" %>Icon"><%= info.get("cate_name") %></span><span class="date"><%= info.get("wdate").substring(0, 10) %></span><br>
				<%= info.get("title") %>
			</p>
			<div class="viewTxt animated fadeIn delay06">
				<%= info.get("contents") %>
			</div>
		</div>
		<ul class="viewPaging  animated fadeIn delay08">
<%
	if(prev != null && !"".equals(prev.get("seq"))) {
%>					
				<li class="prevView"><a href="view.jsp?seq=<%= prev.get("seq") %>"><span>이전</span><%= prev.get("title") %></a><span class="date"><%= info.get("wdate").substring(0, 10) %></span></li>
<%
	} else {
%>
				<li class="prevView viewNone"><a href="javascript:void(0);"><span>이전</span>이전글이 없습니다.</a></li>
<%
	}
	if(next != null && !"".equals(next.get("seq"))) {	
%>
				<li class="nextView"><a href="view.jsp?seq=<%= next.get("seq") %>"><span>다음</span><%= next.get("title") %></a><span class="date"><%= info.get("wdate").substring(0, 10) %></span></li>
<%
	} else {
%>
				<li class="nextView viewNone"><a href="javascript:void(0);"><span>다음</span>다음글이 없습니다.</a></li>
<%
	}
%>
			</ul>
		<div class="btnArea">
			<a href="/mobile/hotel/village/notice/list.jsp" class="btnStyle01 sizeL">목록</a>
		</div>
		
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>