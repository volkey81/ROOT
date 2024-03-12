<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.board.ReviewService"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("상품평 관리"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);

	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	ProductService product = (new ProductService()).toProxyInstance();
	ReviewService review = (new ReviewService()).toProxyInstance();
	param.set("userid", fs.getUserId());
	param.set("sort", "userid");
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	//게시물 리스트
	List<Param> list = review.getList(param);
	//게시물 갯수
	int totalCount = review.getListCount(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
	function removeReview(seq) {
		if(confirm("삭제하시겠습니까?")) {
			$("#seq").val(seq);
			ajaxSubmit($("#reviewForm"), function(json) {
				alert(json.msg);
				document.location.reload();
			});
		}
	}
</script>
</head>  
<body>
<div id="wrapper">
	<form name="reviewForm" id="reviewForm" action="/popup/reviewProc.jsp" method="POST">
		<input type="hidden" name="mode" id="mode" value="REMOVE" />
		<input type="hidden" name="seq" id="seq" />
	</form>
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/mypage/snb.jsp" />
		<div id="contArea">
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<!-- 내용영역 -->	
			<p class="caution">항상 최선을 다하는 상하농원이 되겠습니다.</p>		
			<table class="bbsList typeC">
				<caption>상품평 목록</caption>
				<colgroup>
					<col width="70"><col width="220"><col width="">
				</colgroup>
				<thead>
					<tr>
						<th scope="col" colspan="2">상품</th>
						<th scope="col">상품평</th>
					</tr>
				</thead>
				<tbody>
<%
	if (CollectionUtils.isNotEmpty(list)){
		for(Param row : list) {
// 			Param productInfo = product.getInfo(new Param("grade_code", fs.getGradeCode(), "pid", row.get("pid")));
%>
					<tr>
						<th scope="row" class="vt"><p class="thumb"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%=row.get("THUMB") %>" alt="" width="39" height="43"></a></p></th>
						<td class="vt al pName"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>"><%= row.get("pnm") %><br><span class="fs fontTypeC">(<%= row.get("pid") %>)</span></a></td>
						<td><div class="myReview">
							<div class="head">
								<p class="tit"><%= Utils.safeHTML(row.get("title")) %></p>
								<p class="assess"><span class="assess<%= row.get("score")%>"><img src="/images/common/ico_assess.png" alt="평점<%= row.get("score")%>"></span></p>
							</div>
							<div class="content">
								<%= Utils.safeHTML(row.get("contents"), true) %>
							</div>
							<div class="btn">
								<a href="#" onclick="showPopupLayer('/popup/review.jsp?seq=<%= row.get("seq") %>' ,'630'); return false" class="btnTypeA sizeS">수정</a>
								<a href="#" onclick="removeReview('<%= row.get("seq") %>')" class="btnTypeC sizeS">삭제</a>
							</div>
						</div></td>
					</tr>
<%		}
	} else { 
%>
					<tr><td colspan="3">+++ 작성한 상품평이 없습니다 +++</td></tr>
<% 
	}
%>
				</tbody>
			</table>
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("review.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
			</ul>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>