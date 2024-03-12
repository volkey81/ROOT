<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.board.*" %>			 
<%
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
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("베스트 후기"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
	function search() {
		$("#reviewForm").submit();
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<ul id="location"> 
		<li><a href="/">홈</a>
		<li>베스트 후기</li>
	</ul>

	<div id="container">
	<!-- 내용영역 -->
		<div class="bestReview">
			<form name="reviewForm" id="reviewForm">
			<div class="head">
				<p class="tit">베스트 후기</p>
				<p class="txt">상하농원을 사랑해주시는 고객 여러분의 솔직한 후기입니다. </p>
				<div class="search">
					<input type="text" name="pnm" value="<%= Utils.safeHTML2(param.get("pnm")) %>" title="검색어" placeholder="상품평 입력" style="width:290px">
					<a href="javascript:search();" class="btnTypeB sizeL">검색</a>
				</div>
			</div>
			</form>
			<div class="content pdtDetail">
				<table class="bbsList typeC">
					<caption>베스트 후기 목록</caption>
					<colgroup>
						<col width="80"><col width="200"><col width=""><col width="90"><col width="120">
					</colgroup>
					<thead>
						<tr>
							<th scope="col">no</th>
							<th scope="col">상품</th>
							<th scope="col">제목</th>
							<th scope="col">작성자</th>
							<th scope="col">등록일</th>
						</tr>
					</thead>
					<tbody>
<%
	int i = 1;
	for(Param row : noticeList) {
%>
						<tr>
							<th scope="row">-</th>
							<td class="productTit">&nbsp;</td>
							<td class="tit"><a href="#reviewAdminCont<%= i %>" onclick="showTab2(this, 'reviewAdminCont'); return false">
								<%= Utils.safeHTML(row.get("title")) %></a></td>
							<td><%= Utils.maskString(row.get("regist_user")) %></td>
							<td><%= row.get("regist_date") %></td>
						</tr>
						<tr class="reviewAdminCont" id="reviewAdminCont<%=i %>" style="display: none;">
							<td colspan="5" style="display: none;">
								<%= row.get("contents") %>
							</td>
						</tr>
<%
		i++;
	}

	i = 1;
	int cnt = totalCount - ((nPage - 1) * PAGE_SIZE);
	for(Param row : list) {
%>
						<tr>
							<th scope="row"><%= cnt-- %></th>
							<td class="productTit"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("thumb") %>" alt=""><span><%= row.get("pnm") %></span></a></td>
							<td class="tit"><a href="#reviewCont<%= i %>" onclick="showTab2(this, 'reviewCont'); return false">
								<p class="assess"><span class="assess<%= row.get("score") %>"><img src="/images/common/ico_assess.png" alt="평점<%= row.get("score") %>"></span></p><br>		
								<%= Utils.safeHTML(row.get("title")) %></a></td>
							<td><%= Utils.maskString(row.get("userid")) %></td>
							<td><%= row.get("regist_date") %></td>
						</tr>
						<tr class="reviewCont" id="reviewCont<%= i %>" style="display:none">
							<td colspan="5" style="display: none">
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
							</td>
						</tr>	
<%
		i++;
	}
%>					
					</tbody>
				</table>
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(Utils.safeHTML2(param.toQueryString("best.jsp")), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
			</ul>
			</div>
		</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
