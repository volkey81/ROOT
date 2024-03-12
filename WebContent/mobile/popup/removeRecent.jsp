<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
		 	com.efusioni.stone.utils.*,
		 	com.sanghafarm.common.*,
		 	com.sanghafarm.service.product.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	ProductService product = (new ProductService()).toProxyInstance();

	if (fs.isLogin()) {
		product.removeRecentProduct(new Param("userid", fs.getUserId(), "pid", param.get("pid")));
	} else {
		List<Param> recentList = (ArrayList<Param>)session.getAttribute("recentList");
		
		for(Param row : recentList) {
			if(param.get("pid").equals(row.get("pid"))) {
				recentList.remove(row);
				break;
			}
		}
		session.setAttribute("recentList", recentList);
	}
%>
