<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.board.EventService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("이벤트/기획전"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	EventService event = (new EventService()).toProxyInstance();

	//검색파라미터 쿠키 저장
	param.keepQuery(response);
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 6);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	//게시물 리스트
	List<Param> list = event.getList(param);

	//게시물 갯수
	int totalCount = event.getListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
</head>  
<body class="fullpage">
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<div id="container">
	<%-- <jsp:include page="/include/banner.jsp" flush="true">
	    <jsp:param name="position" value="024"/>
	    <jsp:param name="POS_END" value="5"/>
	</jsp:include> --%>
	<!-- 내용영역 -->
		
<% 
	int firstCnt = 0;
	String today = Utils.getTimeStampString("yyyy.MM.dd");
	if (CollectionUtils.isNotEmpty(list)) { 
%>		
		<ul class="eventList">
<%
			if (list.size() >= 3) {
				firstCnt = 3;
			} else {
				firstCnt = list.size();
			}
			
			for (int i = 0; i < firstCnt; i++) {
				String detail = "view.jsp?seq=" + list.get(i).get("seq") + "&type=view";
				if(list.get(i).get("end_date").compareTo(today) < 0) {
					detail = "javascript:alert('종료된 이벤트 입니다')";
				}
%>
			<li>
				<a href="<%= detail %>">
					<p class="thumb"><img src="<%=list.get(i).get("img") %>" alt=""></p>
<%
				if (StringUtils.equals("E", list.get(i).get("event_type"))) {
					if(list.get(i).get("start_date").compareTo(today) <= 0 && list.get(i).get("end_date").compareTo(today) >= 0) {
%>
								<p class="ico ico1"><img src="/images/common/ico_event.png" alt="이벤트진행중"></p>
<%
					} else if(list.get(i).get("end_date").compareTo(today) < 0) {
%>
								<p class="ico ico2"><img src="/images/common/ico_event.png" alt="이벤트진행종료"></p>
<%
					}
				} else {
%>
								<p class="ico ico3"><img src="/images/common/ico_event.png" alt="기획전">	</p>	
<% 				} %>
					<!-- class=ico1:이벤트진행증, ico2:이벤트종료, ico3:기획전 -->
					<p class="tit"><%= list.get(i).get("title") %></p>
					<p class="date"><%= list.get(i).get("start_date") %> ~ <%= list.get(i).get("end_date") %></p>
				</a>
<%
				if (StringUtils.equals("Y", list.get(i).get("announce_yn"))
						&& list.get(i).get("announce_date").compareTo(today) <= 0) {						
%>
					<p class="winner"><a href="view.jsp?seq=<%= list.get(i).get("seq") %>&type=result">당첨자<br>발표</a></p>
<% 				} %>
			</li>
<% 		}
	}
%>
		

		</ul><!-- //eventList -->
		
		<jsp:include page="/include/banner.jsp" flush="true">
		    <jsp:param name="position" value="025"/>
		    <jsp:param name="POS_END" value="1"/>
		</jsp:include>
<% if (CollectionUtils.isNotEmpty(list) && list.size() >= 4) { %>
		<ul class="eventList">
<%
			for (int i = firstCnt; i < list.size(); i++) {			
				String detail = "view.jsp?seq=" + list.get(i).get("seq") + "&type=view";
				if(list.get(i).get("end_date").compareTo(today) < 0) {
					detail = "javascript:alert('종료된 이벤트 입니다')";
				}
%>
			<li>
				<a href="<%= detail %>">
					<p class="thumb"><img src="<%=list.get(i).get("img") %>" alt=""></p>
<%
				if (StringUtils.equals("E", list.get(i).get("event_type"))) {
					if(list.get(i).get("start_date").compareTo(today) <= 0 && list.get(i).get("end_date").compareTo(today) >= 0) {
%>
								<p class="ico ico1"><img src="/images/common/ico_event.png" alt="이벤트진행중"></p>
<%
					} else if(list.get(i).get("end_date").compareTo(today) < 0) {
%>
								<p class="ico ico2"><img src="/images/common/ico_event.png" alt="이벤트진행종료"></p>
<%
					}
				} else {
%>
								<p class="ico ico3"><img src="/images/common/ico_event.png" alt="기획전">		
<% 				} %>
					<p class="tit"><%= list.get(i).get("title") %></p>
					<p class="date"><%= list.get(i).get("start_date") %> ~ <%= list.get(i).get("end_date") %></p>
				</a>
<%
				if (StringUtils.equals("Y", list.get(i).get("announce_yn"))
						&& list.get(i).get("announce_date").compareTo(today) <= 0) {						
%>
					<p class="winner"><a href="view.jsp?seq=<%= list.get(i).get("seq") %>&type=result">당첨자<br>발표</a></p>
<% 				} %>
			</li>
<%
			}
}
%>
		</ul><!-- //eventList -->
		<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeToShop(out);
	}
%>
		</ul>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
setCycle(".mainVisual", "fade", "visual", 5000, "", "");
$(".eventList li").each(function(){
	if($(this).find(".tit").height() > parseInt($(this).find(".tit").css("line-height"))){
		$(this).find(".tit").css("margin-top", "18px");
	}
});
</script>
</body>
</html>