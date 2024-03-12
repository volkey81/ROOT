<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
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
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("상품평 관리"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);

	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
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
<jsp:include page="/mobile/include/head.jsp" /> 
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
	<%
	if(fs.isApp() && "android".equals(fs.getAppOS())){
	%>
	function sendFileData(orgName, image, division){
		var params = {
				"image": image,
				"orgName" : orgName,
				"board" : "01"
		}
		$.ajax({
		  type: "POST",
		  url: "/mobile/popup/appProc.jsp",
		  dataType:'json',
		  contentType: "application/x-www-form-urlencoded; charset=utf-8",
		  data: params,
		  success: function(data) {
			  if(data.isOk == "true"){
				  var ifra = document.getElementById("iframePopLayer113").contentWindow;
				  ifra.sendData(division, data.imagename);
			  } else {
				  alert(data.msg);  
			  }
			},
			error: function(data) {
				alert(data.msg);
			} 
		});
	}
	<%
	}
	%>
</script>
</head>  
<body>
<div id="wrapper">
	<form name="reviewForm" id="reviewForm" action="/popup/reviewProc.jsp" method="POST">
		<input type="hidden" name="mode" id="mode" value="REMOVE" />
		<input type="hidden" name="seq" id="seq" />
	</form>
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->
		<ol class="myReviewList">
<%
	if (CollectionUtils.isNotEmpty(list)){
		int i = 1;
		for(Param row : list) {
// 			Param productInfo = product.getInfo(new Param("grade_code", fs.getGradeCode(), "pid", row.get("pid")));
%>
				<li>
					<div class="head">
						<p class="thumb"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("THUMB") %>" alt="" width="39" height="43"></a></p>
						<p class="cate"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><%= row.get("pnm") %> <span class="fs fontTypeC">(<%= row.get("pid") %>)</span></a></p>
						<p class="tit"><a href="#reviewCont<%=i %>" onclick="showTab2(this, 'reviewCont'); return false"><%= Utils.safeHTML(row.get("title")) %></a></p>
						<p class="assess"><span class="assess<%= row.get("score") %>"><img src="/mobile/images/common/ico_assess.png" alt="평점<%= row.get("score") %>"></span></p>
					</div>
					<div class="reviewCont" id="reviewCont<%=i %>">
						<%= Utils.safeHTML(row.get("contents"), true) %>
						<div class="btn">
							<a href="#" onclick="showPopupLayer('/mobile/popup/review.jsp?seq=<%= row.get("seq") %>'); return false" class="btnTypeA sizeS">수정</a>
							<a href="#" onclick="removeReview('<%= row.get("seq") %>')" class="btnTypeC sizeS">삭제</a>
						</div>
						<%
						if (StringUtils.isNotEmpty(row.get("ANSWER"))) {
						%>
						<div class="answer">
							답변 : <%=row.get("ANSWER") %>
						</div>
						<%
						}
						%>
					</div>
				</li>
<%		
		i++;
		}
	} else { 
%>
			<li class="none">+++ 작성한 상품평이 없습니다. +++</li>
<% 
	}
%>
		</ol>
		<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("review.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
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