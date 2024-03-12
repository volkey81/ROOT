<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.order.*,
			com.google.gson.*"%>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	CartService cart = (new CartService()).toProxyInstance();
	
	String userid = "";
	
	if(fs.isLogin()) userid = fs.getUserId();
	else userid = fs.getTempUserId();
	
	int count = cart.getListCount(userid);
// 	out.println(new Gson().toJson(info));
// 	System.out.println(new Gson().toJson(info));
%>
{ "count": <%= count %> }