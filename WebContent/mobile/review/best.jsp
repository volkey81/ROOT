<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.board.*" %>			 
<%
	request.setAttribute("Depth_1", new Integer(7));
	request.setAttribute("Depth_2", new Integer(0));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("베스트 후기"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	ReviewService review = (new ReviewService()).toProxyInstance();

	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("best", "2");
	
	NoticeService notice = (new NoticeService()).toProxyInstance();
	
	List<Param> noticeList = notice.getList(new Param("status", "S", "cate", "003", "POS_STA", 0, "POS_END", Integer.MAX_VALUE));
		
	//게시물 리스트
	List<Param> list = review.getList(param);
	//게시물 갯수
	int totalCount = review.getListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	function search() {
		$("#reviewForm").submit();
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<style>
		.bestReview .search {padding-left:0;}
		</style>
		<!-- 내용영역 -->	
		<div class="bestReview">
			<form name="reviewForm" id="reviewForm">
			<div class="search">
				<input type="text" name="pnm" value="<%= Utils.safeHTML(param.get("pnm")) %>" placeholder="상품명입력" >
				<a href="javascript:search();" class="btnTypeB sizeS">검색</a>				
			</div>
			</form>
			<ol class="reviewList">
<%
	int i = 1;
	for(Param row : noticeList) {
%>
				<li>
					<div class="head">
						<a href="#reviewAdminCont<%= i %>" onclick="showTab2(this, 'reviewAdminCont'); return false">
							<p class="tit"><%= Utils.safeHTML(row.get("title")) %></p>
							<p class="user"><%= Utils.maskString(row.get("regist_user")) %><span class="date"><%= row.get("regist_date") %></span></p>
						</a>
					</div>
					<div class="reviewAdminCont" id="reviewAdminCont<%= i %>" style="display:none;">
						<%= row.get("contents") %>
					</div>
				</li>				
<%
		i++;
	}

	i = 1;
	int cnt = totalCount - ((nPage - 1) * PAGE_SIZE);
	for(Param row : list) {
%>
				<li>
					<div class="head"><a href="#reviewCont<%= i %>" onclick="showTab2(this, 'reviewCont'); return false">
						<p class="num"><%= cnt-- %></p>
						<img src="<%= row.get("thumb") %>" alt="" class="thum">
						<div class="productTxt">
							<p class="tit"><%= Utils.safeHTML(row.get("title")) %></p>
							<p class="assess"><span class="assess<%= row.get("score") %>"><img src="/mobile/images/common/ico_assess.png" alt="평점<%= row.get("score") %>"></span></p>
							<p class="user"><%= Utils.maskString(row.get("userid")) %><span class="date"><%= row.get("regist_date") %></span></p>
						</div>	
					</a></div>
					<div class="reviewCont" id="reviewCont<%= i %>">
						<p class="tit"><%= row.get("pnm") %><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>" class="btnTypeB">상품보기</a></p>
							<%= Utils.safeHTML(row.get("contents"), true) %><br/>
<%
		if (StringUtils.isNotEmpty(row.get("img1"))) {
%>
						<img alt="" src="<%= row.get("img1") %>"><br/>
<%
		}
		if (StringUtils.isNotEmpty(row.get("img2"))) {
%>
						<img alt="" src="<%= row.get("img2") %>"> <br/>
<%
		}

		if (StringUtils.isNotEmpty(row.get("answer"))) {
%>
						<div class="answer">
							답변 : <%= Utils.safeHTML(row.get("answer"), true) %>
						</div>				
<%
		}
%>
					</div>
				</li>				
<%
		i++;
	}
%>					
			</ol>
			
		<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("best.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
		</ul>
		</div>
		
		
	
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>