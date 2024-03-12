<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.service.board.BrandNoticeService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("Depth_4", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("입사지원하기"));



	Param param = new Param(request);
	BrandNoticeService notice = (new BrandNoticeService()).toProxyInstance();
	
	if(StringUtils.isEmpty(param.get("seq"))) {
		Utils.sendMessage(out, "잘못된 접근입니다.");
		return;
	}
	
	param.set("cate", "003");
	Param info = notice.getInfo(param);
	Param prev = notice.getPrevInfo(param);
	Param next = notice.getNextInfo(param);
	notice.modifyHit(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script src="/js/kakao.min.js"></script>
<script>

</script>
</head>  
<body class="bgTypeA">
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location_job.jsp" />
	

<div id="snbBrand">

	<ul class="menu01">
		<!--<li><a href="/brand/introduce/story.jsp">채용공고</a></li>-->
		<li><a href="/brand/bbs/jobnotice/story1.jsp">핵심가치</a></li>
		<li><a href="/brand/bbs/jobnotice/story2.jsp">인재상</a></li>
		<li><a href="/brand/bbs/jobnotice/story3.jsp">복리후생</a></li>
		<li class="on"><a href="/brand/bbs/jobnotice/story4_list.jsp">입사지원하기</a></li>
	</ul>
</div>
	<div id="container" class="bbsNotice">
		<!-- 내용영역 -->
		<div id="contArea">
			<h1 class="typeA">입사지원하기</h1>
			<div class="bbsView">
				<div class="head">
					<h2><%= info.get("title") %></h2>
					<p class="date"><%= info.get("wdate").substring(0, 10) %></p>
				</div>
				<div class="content">
					<%= info.get("contents") %>
				</div>
			</div>
			<dl class="pvnt">
				<dt>이전</dt>
<%
	if(prev != null && !"".equals(prev.get("seq"))) {
%>					
				<dd><a href="story4_view.jsp?seq=<%= prev.get("seq") %>"><%= prev.get("title") %></a><span class="date"><%= prev.get("wdate").substring(0, 10) %></span></dd>
<%
	} else {
%>
				<dd>이전글이 없습니다.</dd>
<%	} %>
				<dt>다음</dt>
<%
	if(next != null && !"".equals(next.get("seq"))) {
%>
				<dd><a href="story4_view.jsp?seq=<%= next.get("seq") %>"><%= next.get("title") %></a><span class="date"><%= next.get("wdate").substring(0, 10) %></span></dd>
<%
	} else {
%>
				<dd>다음글이 없습니다.</dd>
<%	} %>
			</dl>
			<div class="btnArea ac">
				<a href="<%= param.backQuery() %>" class="btnTypeB">목록</a>
			</div> 
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					