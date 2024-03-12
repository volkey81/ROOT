<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.hotel.*,
			com.sanghafarm.service.code.*,
			com.sanghafarm.utils.*" %>
<% 
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(6));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("프로모션"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	HotelPromotionService svc = new HotelPromotionService();
	CodeService code = new CodeService();
	
	//검색파라미터 쿠키 저장
	param.keepQuery(response);
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 6);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	//게시물 리스트
	List<Param> list = svc.getList(param);
	//게시물 갯수
	int totalCount = svc.getListCount(param);
	
	List<Param> cateList = code.getList2("034");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp"/> 
<script>
$(function (){
	//tab
	/* $(".promotionTab ul li:first").addClass("on").show();
	$(".promotionTab ul li").click(function() {		
		$(".promotionTab ul li").removeClass("on");
		$(this).addClass("on");
	
	});	 */
	
	var pSwiper = new Swiper($(".promotionTab"), {
		slidesPerView: 'auto',
		onSlideChangeEnd: function(swiper){	
			var idx = swiper.activeIndex;
		}
	});
	$(".promotionTab").find(".swiper-slide").each(function(){
		if($(this).hasClass("on")){
			pSwiper.slideTo($(this).index(), 0);			
		}
	});
})
		
</script>
</head>  
<body>

<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="village styleA">
		<!-- 내용영역 -->
		<h2 class="animated fadeInUp delay02">프로모션</h2>
		<div class="promotionTab animated fadeInUp delay04">
			<ul class="swiper-wrapper">
				<li class="swiper-slide<%= "".equals(param.get("cate")) ? " on" : "" %>"><a href="list.jsp">전체보기</a></li>
<%
	for(Param row : cateList) {
%>
				<li class="swiper-slide<%= row.get("code2").equals(param.get("cate")) ? " on" : "" %>"><a href="list.jsp?cate=<%= row.get("code2") %>"><%= row.get("name2") %></a></li>
<%
	}
%>
			</ul>
		</div>
		<ul class="promotionList"> 

<%
	if(list.size() > 0){
		for(Param row : list) {
			String url = "1".equals(row.get("content_type")) ? "view.jsp?seq=" + row.get("seq") : row.get("mobile_url");
%>
			<li class="animated fadeInUp"><a href="<%= url %>">
				<img src="<%= row.get("mobile_list_img") %>">
				<div class="txtArea">
					<p class="tit"><%= row.get("title") %></p>
					<span class="date"><%= row.get("start_date").substring(0, 10) %> ~ <%= row.get("end_date").substring(0, 10) %></span>
					<p class="ico ico<%= Integer.parseInt(row.get("cate")) %>"><%= row.get("cate_name") %></p><!-- 객실 -ico1, 다이닝-ico2, 웨딩&이벤트-ico3, 세미나-ico4, 기타   -->
				</div>
			</a></li>
<%
		}
	} else {
%>
				<li class="animated fadeInUp none">** 현재 해당 프로모션이 없습니다. **</li>
<%
	}
%>
		</ul>
		<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
		</ul>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>