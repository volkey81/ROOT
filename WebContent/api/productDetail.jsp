<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.product.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	ProductService product = (new ProductService()).toProxyInstance();
	
	param.set("grade_code", fs.getGradeCode());
	Param info = product.getInfo(param);
%>
<%= param.get("callback") %> ({
	"id" : "<%= info.get("pid") %>",
	"name" : "<%= info.get("pnm") %>",
	"thumb" : "http://<%= request.getServerName() %><%= info.get("thumb") %>",
	"image" : [
		"<%= !"".equals(info.get("image1")) ? "http://" + request.getServerName() + info.get("image1") : "" %>",
		"<%= !"".equals(info.get("image2")) ? "http://" + request.getServerName() + info.get("image2") : "" %>",
		"<%= !"".equals(info.get("image3")) ? "http://" + request.getServerName() + info.get("image3") : "" %>",
		"<%= !"".equals(info.get("image4")) ? "http://" + request.getServerName() + info.get("image4") : "" %>",
		"<%= !"".equals(info.get("image5")) ? "http://" + request.getServerName() + info.get("image5") : "" %>",
		"<%= !"".equals(info.get("image6")) ? "http://" + request.getServerName() + info.get("image6") : "" %>"
	],
	"price" : "<%= info.get("sale_price") %>",
	"unit" : "<%= info.get("pack_unit") %>",
	"explain" : "<%= info.get("summary") %>",
	"link" : "http://<%= request.getServerName() %>/product/detail.jsp?pid=<%= info.get("pid") %>"
})
