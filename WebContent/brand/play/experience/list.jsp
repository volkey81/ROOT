<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.board.*,
			com.sanghafarm.service.code.*,
			com.sanghafarm.utils.*" %>
<%	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("체험교실"));
	
	Param param = new Param(request);
	ExpContentService svc = new ExpContentService();
	CodeService code = new CodeService();	
	param.keepQuery(response);
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 9);
	final int BLOCK_SIZE = 5;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	
	List<Param> list = svc.getList(param);
	int totalCount = svc.getListCount(param);
	
	List<Param> gbList = code.getList2("037");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
	$(function () {
		$('.expArea .slideWrap').slick({
	         initialSlide:0,
	         slidesToShow:1,
	         slidesToScroll:1,
	         autoplay: true,
	         autoplaySpeed: 2000,
	         arrows:true,
	         adaptiveHeight: true,
	         infinite: true,
	         dots: true,
	         adaptiveHeight: true
	     });
		
		efuSlider('.calWrap', 1, 0, '', 'once');	
	});

</script> 
</head>  
<body class="fullpage">
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="expHead">
			<span>오감 먹거리 체험교실</span><br>자연의 먹거리를 그대로 보고,<br>만지는 오감 체험을 통해 바른 먹거리를 배우는 공간	
		</div>
		<div class="expArea">
			<h2><img src="/images/brand/play/tit_experience.png" alt="상하농원 체험교실"></h2>
			<p class="srmy"><span>상하농원 체험 교실의 다섯가지 긍정의 씨앗</span></p>
			<div class="slideWrap">
				<div>
					<p class="desc">사랑의 씨앗</p>
					<p class="cont">가족/친구와 추억을 <br>공유함으로써 유대감과 사랑을 키울 수 있어요</p>
				</div>
				<div>
					<p class="desc">참맛의 씨앗</p>
					<p class="cont">자극적인 맛에 길들여진 미각을 일깨워<br>맛있는 음식에 대한 기준을 재조명 해요 </p>
				</div>
				<div>
					<p class="desc">행복의 씨앗</p>
					<p class="cont">먹거리가 주는 즐거움과 함께<br>만드는 재미를 느껴요</p>
				</div>
				<div>
					<p class="desc">슬기의 씨앗</p>
					<p class="cont">바른 음식을 구별할 수 있는 힘을<br>길러줌으로써 먹거리를 제대로 알고 먹어요</p>
				</div>	
				<div>
					<p class="desc">감사의 씨앗</p>
					<p class="cont">먹거리를 제공하는 모든 자연, 동물과 생산자의 열정에<br> 감사하는 마음을 가져요</p>
				</div>	
			</div>
		</div><!-- //expArea -->
		<div class="expProgram">
			<div class="displayMode">
				<a href="list.jsp" class="on">유형으로 보기</a>
				<a href="list2.jsp">날짜로 보기</a>
			</div>
			<div id="programList">
				<div class="tabArea">
					<a href="list.jsp" <%= "".equals(param.get("exp_gb")) ? "class=\"on\"" : "" %>><div class="thum" style="background-image:url(/images/brand/play/experience_tab0.png);"></div>전체</a>
<%
	for(Param row : gbList) {
%>
					<a href="list.jsp?exp_gb=<%= row.get("code2") %>" <%= row.get("code2").equals(param.get("exp_gb")) ? "class=\"on\"" : "" %>><div class="thum" style="background-image:url(/images/brand/play/experience_tab<%= row.getInt("code2") %>.png);"></div><%= row.get("name2") %></a>
<%
	}
%>
				</div>
				<ul class="programList">
<%
	for(Param row : list) {
		String link = "Y".equals(row.get("link_yn")) ? "view.jsp?seq=" + row.get("seq") : "javascript:void(0)";
%>
					<li>
						<a href="<%= link %>">
							<div class="thum"><img src="<%= row.get("thumb") %>" alt=""></div>
							<div class="cont">
								<div class="cate"><img src="/images/brand/play/img_tag0<%= row.getInt("exp_gb") %>.jpg" alt="카테고리"></div>
								<strong><%= row.get("exp_type_nm") %></strong>
								<p><%= row.get("summary") %></p>
							</div>
						</a>
<%
		if("N".equals(row.get("link_yn"))) {
%>
						<div class="end">
							<p>
								<strong>마감</strong>
								다음에 또 만나요!
							</p>
						</div>
<%
		}
%>
					</li>
<%
	}
%>
				</ul>
				<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeToShop(out);
	}
%>
				</ul>
			</div>
		</div><!-- //expProgram -->
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" />
</div><!-- //wrapper -->
</body>
</html>
