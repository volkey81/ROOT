<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<li id="option_<%= info.get("pid") %>">
	<p class="tit"><%= info.get("opt_pnm") %></p>
	<p class="countNum typeB">
		<input type="hidden" name="sub_pid" id="sub_pid_<%= info.get("pid") %>" value="<%= info.get("pid") %>" />
		<input type="hidden" name="sub_pnm" id="sub_pnm_<%= info.get("pid") %>" value="<%= info.get("opt_pnm") %>" />
		<input type="hidden" name="default_price" id="default_price_<%= info.get("pid") %>" value="<%= info.get("default_price") %>" />
		<input type="hidden" name="sale_price" id="sale_price_<%= info.get("pid") %>" value="<%= info.get("sale_price") %>" />
		<a href="#none" onclick="setQty('down', '<%= info.get("pid") %>'); return false;"><img src="/mobile/images/btn/btn_minus2.png" alt="-"></a>
		<input type="text" name="qty_<%= info.get("pid") %>" id="qty_<%= info.get("pid") %>" value="1">
		<a href="#none" onclick="setQty('up', '<%= info.get("pid") %>'); return false;"><img src="/mobile/images/btn/btn_plus2.png" alt="+"></a>
	</p>
	<p class="btn"><input type="image" src="/mobile/images/btn/btn_close.png" alt="" onclick="removeOption('<%= info.get("pid") %>'); return false;"></p>
</li>
