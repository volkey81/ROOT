<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.order.*" %>
<%
	Param param = new Param(request);
	OrderService svc = (new OrderService()).toProxyInstance();
	
	Enumeration _enum = request.getParameterNames();

// 	Param payReqMap = new Param();
	StringBuffer buf = new StringBuffer();

	while (_enum.hasMoreElements()) {
	
		String key = (String) _enum.nextElement();
	
		if(request.getParameterValues(key).length == 1){
// 			payReqMap.set(key, request.getParameter(key)); 
			buf.append("<input type='hidden' name='" + key + "' value='" + Utils.safeHTML(Utils.nvl(request.getParameter(key), "")) + "'>\n" );
		} else {
			if (request.getParameterValues(key) != null) {
				String[] pv = request.getParameterValues(key);
				for(int i=0; i<pv.length; i++){
					buf.append("<input type='hidden' name='" + key + "' value='" + Utils.safeHTML(pv[i]) + "'>\n" );	
				}
// 				payReqMap.set(key, pv);
			}
		}
	}

// 	session.setAttribute("PAYREQ_MAP", payReqMap);	

// 	FrontSession fs = FrontSession.getInstance(request, response);
// 	SanghafarmUtils.setCookie(response, "ORDERID", param.get("orderid"), fs.getDomain(), -1);
	
	Param info = svc.getOrderFormInfo(param.get("orderid"));
	if(info == null || "".equals(info.get("orderid"))) {
		svc.createOrderForm(new Param("orderid", param.get("orderid"), "form", buf.toString()));
	} else {
		svc.modifyOrderForm(new Param("orderid", param.get("orderid"), "form", buf.toString()));
	}
%>
<script>
	document.location.href="<%= param.get("paycoOrderUrl") %>";
</script>
