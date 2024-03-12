<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<ul id="location">
	<li><a href="/">홈</a></li>
</ul>
<script>
$(window).load(function(){
	var $lMenu = $("#snb .tit a");
	var $mMenu = $("#snb >ul >li.on p a");
	$("#location").append('<li class="curr"><%=MENU_TITLE%></li>');
<%
	if(Depth_2 != 0){
%>
	$("#location .curr").before('<li><a href="'+ $lMenu.attr("href") +'">'+ $lMenu.text() +'</a></li> ');
<%
	}
%>
<%
	if(Depth_3 != 0){
%>
	$("#location .curr").before('<li><a href="'+ $mMenu.attr("href") +'">'+ $mMenu.text() +'</a></li> ');
<%
	}
%>
});
</script>