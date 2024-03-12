<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.code.CodeService"%>
<%@page import="com.sanghafarm.service.board.FaqService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(4));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("자주하는 질문"));

	String	 MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	Param param = new Param(request);
	FaqService faq = (new FaqService()).toProxyInstance();
	CodeService code = (new CodeService()).toProxyInstance();
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
	param.set("cate", param.get("cate", "001"));
	
	//게시물 리스트
	List<Param> list = faq.getList(param);
	//게시물 갯수
	int totalCount = faq.getListCount(param);
	
	List<Param> cateList = code.getList2("006");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/customer/snb.jsp" />
		<div id="contArea">
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<div class="faqTabArea">
<%
	for(Param row : cateList) {
%>
				<a href="faq.jsp?cate=<%= row.get("code2") %>" <%= row.get("code2").equals(param.get("cate", "001")) ? "class=\"on\"" : "" %>><%= row.get("name2") %></a>			
<%
	}
%>
			</div> 
			<table class="bbsList typeC">
				<caption>자주하는 질문 목록</caption>
				<colgroup>
					<col width="120"><col width="">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">유형</th>
						<th scope="col">질문</th>
					</tr>
				</thead>
				<tbody>
<%
	int i = 1;
	if (CollectionUtils.isNotEmpty(list)) {		
		for(Param row : list) {
%>
					<tr>
						<th scope="row"><%= row.get("cate_name") %></th>
						<td class="faqArea">
							<p class="question"><a href="#faq<%=i %>" onclick="showTab2(this, 'answer'); return false"><%= row.get("title") %></a></p>
							<div class="answer" id="faq<%=i %>">
								<%= row.get("contents") %>
								<p class="btn"><a href="#" onclick="hideFaq(this); return false">닫기</a></p>
							</div>
						</td>
					</tr>
<% 		
		i++;
		}
	} else {
%>
					<tr><td colspan="2">+++ 검색된 내용이 없습니다 +++</td></tr>
<%
	}	
%>
				</tbody>
			</table>
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("faq.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
			</ul>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
function hideFaq(obj){
	var target = $(obj).parents(".answer");
	target.slideUp(150);	
}
</script>
</body>
</html>