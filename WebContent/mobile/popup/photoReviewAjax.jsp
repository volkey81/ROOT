<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.board.*" %>
<%
	Param param = new Param(request);
	ReviewService review = (new ReviewService()).toProxyInstance();

	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 15);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	List<Param> list = review.getImageList(param);
	
	for(Param row : list) {
%>
			<li><a href="#" onclick="showContent(this, <%= row.get("seq") %>, '<%= row.get("imgno") %>'); return false"><img src="<%= row.get("img") %>" alt=""></a></li>
<%
	}
%>