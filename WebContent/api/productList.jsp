<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.product.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	ProductService product = (new ProductService()).toProxyInstance();
	
	//페이징 변수 설정
	param.addPaging(1, Integer.MAX_VALUE);
	param.set("grade_code", fs.getGradeCode());
	
	List<Param> list = product.getList(param);
%>
<%= param.get("callback") %> ({
	"list" : [
<%	
	for(int i = 0 ; i < list.size(); i++) {
		Param row = list.get(i);
%>
		{
			"id" : "<%= row.get("pid") %>",
			"name" : "<%= row.get("pnm") %>",
			"api_link" : "http://<%= request.getServerName() %>/api/productDetail.jsp?pid=<%= row.get("pid") %>"
		}<%= i < list.size() - 1 ? "," : "" %>
<%
	}
%>
	]
})
