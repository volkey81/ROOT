<%@page import="com.sanghafarm.service.board.FarmerMenuService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("농원소식"));
	
	Param param = new Param(request);
	FarmerMenuService menu = (new FarmerMenuService()).toProxyInstance();

	param.set("cate", "003");
	Param info = menu.getInfo(param);
	Param prev = menu.getPrevInfo(param);
	Param next = menu.getNextInfo(param);
	menu.modifyHit(param);
	List<Param> productList = menu.getProductList(param.get("seq"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<meta property="og:type" content="website">
<meta property="og:site_name" content="상하농원">
<meta property="og:title" content="상하농원 | 농부이야기 | <%= info.get("title") %>">
<meta name="og:url" content="">
<meta property="og:description" content="<%= info.get("summary") %>">
<meta name="twitter:site" content="상하농원"/>
<meta name="twitter:title" content="상하농원 | 농부이야기 | <%= info.get("title") %>"/>
<meta name="twitter:description" content="<%= info.get("summary") %>">
<script src="/js/kakao.min.js"></script>
<script>

	function sendSns(sns){
	    var _url = encodeURIComponent(location.href);
// 	    var _txt = encodeURIComponent(document.title);
	    var _txt = encodeURIComponent("상하농원 | 농부이야기 | <%= info.get("title") %>");
	 
	    switch(sns){
	        case 'facebook':
	           window.open('http://www.facebook.com/sharer/sharer.php?u=' + _url);
	        break;
	 
	        case 'twitter':
				window.open('http://twitter.com/intent/tweet?text=' + _txt + '&url=' + _url);
	            break;
	    }
	}
	
	function shareStory() {
	    var _url = location.href;
// 	    var _txt = document.title;
	    var _txt = "상하농원 | 농부이야기 | <%= info.get("title") %>";
		Kakao.Story.share({
			url: _url,
			text: _txt
		});
	}
	
</script>
</head>  
<body class="bgTypeA">
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="bbsView">
			<div class="head">
				<h2><%= info.get("title") %></h2>
				<p class="info"><%= info.get("summary") %><span class="date"><%= info.get("regist_date") %></span></p>
			</div>
			<div class="content">
				<%= info.get("contents") %>
			</div>
			<div class="foot">
				<ul class="sns">
					<li class="facebook"><a href="#" onclick="sendSns('facebook');return false;"></a></li>
					<li class="twitter"><a href="#" onclick="sendSns('twitter');return false;"></a></li>
					<li class="kakao"><a href="#" onclick="shareStory();return false;"></a></li>
				</ul>
				<a href="list.jsp" class="btnTypeB sizeL">목록</a>
			</div>
		</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					