<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.board.FarmerMenuService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("레시피"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FarmerMenuService menu = (new FarmerMenuService()).toProxyInstance();

	param.set("cate", "001");
	Param info = menu.getInfo(param);
	Param prev = menu.getPrevInfo(param);
	Param next = menu.getNextInfo(param);
	menu.modifyHit(param);
	List<Param> productList = menu.getProductList(param.get("seq"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script type="text/javascript" src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
	$(function(){
// 		Kakao.init('875eb70060bda09cc2d0a3dfc9998a05');    	
// 	 	Kakao.init("c707efb5a7e6b40706594364f10a5b18");
		Kakao.init('b0f34396ce9620b05e6814cac819e2d0');    	
	});

	function sendSns(sns){
	    var _url = encodeURIComponent(location.href);
// 	    var _txt = encodeURIComponent(document.title);
	    var _txt = encodeURIComponent("상하농원 | 레시피 | <%= info.get("title") %>");
	    var imgSrc = location.protocol + '//' + location.hostname  + '<%= info.get("list_img") %>';
	    switch(sns){
	        case 'facebook':
	           	window.open('http://www.facebook.com/sharer/sharer.php?u=' + _url + '&target=web');
		        break;
	        case 'twitter':
				window.open('http://twitter.com/intent/tweet?text=' + _txt + '&url=' + _url + '&target=web');
	            break;
	        case 'kakao' :
	        	/*
	        	Kakao.Link.sendTalkLink({
	     			label: "상하농원 | 레시피 | <%= info.get("title") %>",
	     			webLink : {
	     				text : "상하농원 | 레시피 | <%= info.get("title") %>",
	     				url  : location.href
	     			},
	      			image : {
	     				src : imgSrc,
	     				width : "353",
	     				height : "524"			
	     			}
     			});
	        	*/
	        	
	        	Kakao.Link.sendDefault({
// 	        		container: '#kakao-link-btn',
	        		objectType: 'feed',
	        		content: {
	        			title: '상하농원 | 레시피 | <%= info.get("title") %>',
	        			description: '상하농원 | 레시피 | <%= info.get("title") %>',
	        			imageUrl: location.protocol + '//' + location.hostname  + '<%= info.get("list_img") %>',
	        			link: {
	        				mobileWebUrl: location.href,
	        				webUrl: location.href
	        			}
	        		}
	        	});

	        	break;
	    }
	}
	
	function shareStory() {
	    var _url = location.href;
// 	    var _txt = document.title;
	    var _txt = "상하농원 | 레시피 | <%= info.get("title") %>";
	    
		Kakao.Story.share({
			url: _url,
			text: _txt
		});
	}

</script>
</head>  
<body class="fullpage">
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<div class="recipeView">
			<div class="head">
				<h1><%= info.get("title") %></h1>
				<p class="text"><%= info.get("summary") %></p>
			</div>
			<div class="content">
				<%= info.get("mcontents") %>
			</div>
		</div><!-- //recipeView -->
		<div class="btnArea">
			<span><a href="list.jsp" class="btnTypeB sizeL">레시피 목록</a></span>
			<span><a href="#" onclick="showSns(); return false" class="btnTypeA sizeL">레시피 공유하기</a></span>
		</div>
		<div class="relativeArea">
			<h2>본 레시피에 사용된 상하농원 제품입니다.</h2>
			<ul class="pdtList">
<%
					for(Param row : productList) {
%>
				<li><div class="wrap">
					<div class="thumb">
						<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("thumb") %>" alt="">
					</div>
					<a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
						<p class="tit"><%= row.get("pnm") %></p>
					</a>
				</div></li>
<%
					}
%>
			</ul>
		</div><!-- //relativeArea -->
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<div class="snsLayer">
	<div class="head">
		<h2>SNS공유</h2>
		<p class="close"><a href="#" onclick="hideSns(); return false"><img src="/mobile/images/btn/btn_close3.png" alt="닫기"></a></p>
	</div>
	<ul class="sns">
		<li class="kakao"><a href="#none" onclick="sendSns('kakao');return false;">카카오톡</a></li>
<!-- 		<li class="kakao"><a href="#none" id="kakao-link-btn">카카오톡</a></li> -->
		<li class="facebook"><a href="#none" onclick="sendSns('facebook');return false;">페이스북</a></li>
		<li class="twitter"><a href="#none" onclick="sendSns('twitter');return false;">트위터</a></li>
	</ul>
</div>
<script>
setListHeight($(".pdtList")); //제품리스트 행간 높이 통일
</script>
</body>
</html>