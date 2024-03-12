<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<div id="brandHead" style="background-image:url(/images/brand/bbs/top_img.png);">
	<ul id="locationBrand">
		<li class="home"><a href="/brand/index.jsp">홈</a></li>
	</ul>
</div>
<script>
$(window).load(function(){
	var $lMenu = $("#gnb .brand >ul >li.on p a");
	$("#locationBrand").append('<li class="curr"><%=MENU_TITLE%></li>');
<%
	if(Depth_2 != 0){
%>
	$("#locationBrand .curr").before('<li><a href="'+ $lMenu.attr("href") +'">'+ $lMenu.text() +'</a></li> ');
<%
	}
%>
});
</script>