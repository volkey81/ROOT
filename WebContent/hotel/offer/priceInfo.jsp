<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.hotel.*" %>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%
	Param param = new Param(request);
	HotelOfferService svc = new HotelOfferService();

	Param info = svc.getPriceInfo(param);
%>
{
	"price": <%= info.getInt("price") %>,
	"adult_price": <%= info.getInt("adult_price") %>,
	"child_price": <%= info.getInt("child_price") %>,
	"qty": <%= info.getInt("qty") %>,
	"default_price": <%= info.getInt("default_price") %>,
	"default_adult_price": <%= info.getInt("default_adult_price") %>,
	"default_child_price": <%= info.getInt("default_child_price") %>
}
